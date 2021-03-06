
local Levels = import("..data.Levels")
local Coin   = import("..views.Coin")

local Board = class("Board", function()
    return display.newNode()
end)

local NODE_PADDING   = 100
local NODE_ZORDER    = 0

local COIN_ZORDER    = 1000

Board.AnswerDelay = 2

-- Board 的构造函数支持两种参数
-- levelIndex，数字类型，表示关卡数
-- levelData,  表格类型，表示关卡结构
function Board:ctor(levelIndex)
    cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    local levelData = {}
    if type(levelIndex) == "table" then
	levelData = levelIndex
    else
	levelData = Levels.get(levelIndex)
    end
    self.levelData = levelData

    self.playForever = false

    self.batch = display.newBatchNode(GAME_TEXTURE_IMAGE_FILENAME)
    self.batch:setPosition(display.cx, display.cy)
    self:addChild(self.batch)

    self.grid = clone(levelData.grid)
    self.rows = levelData.rows
    self.cols = levelData.cols
    self.coins = {}
    self.flipAnimationCount = 0

    local offsetX = -math.floor(NODE_PADDING * self.cols / 2) - NODE_PADDING / 2
    local offsetY = -math.floor(NODE_PADDING * self.rows / 2) - NODE_PADDING / 2
    -- create board, place all coins
    for row = 1, self.rows do
        local y = row * NODE_PADDING + offsetY
        for col = 1, self.cols do
            local x = col * NODE_PADDING + offsetX
            local nodeSprite = display.newSprite("#BoardNode.png", x, y)
            self.batch:addChild(nodeSprite, NODE_ZORDER)

            local node = self.grid[row][col]
            if node ~= Levels.NODE_IS_EMPTY then
                local coin = Coin.new(node)
                coin:setPosition(x, y)
                coin.row = row
                coin.col = col
                self.grid[row][col] = coin
                self.coins[#self.coins + 1] = coin
                self.batch:addChild(coin, COIN_ZORDER)
	    else
		self.grid[row][col] = nil
            end
        end
    end

    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y)
    end)

end

-- 重置硬币
function Board:replaceCoins()
    local row = 1
    local col = 1
    for row = 1 , self.rows do
	for col = 1, self.cols do
	    local oldFace = self.levelData.grid[row][col]
	    if oldFace ~= Levels.NODE_IS_EMPTY then
		local oldWhite = (oldFace == Levels.NODE_IS_WHITE)
		local curWhite = self.grid[row][col].isWhite
		if oldWhite ~= curWhite then
		    self.grid[row][col]:flip()
		end
	    end
	end
    end
end

-- 将所有硬币翻正面
function Board:resumeWhite()
    for row = 1 , self.rows do
	for col = 1, self.cols do
	    local coin = self.grid[row][col]
	    if coin and (not coin.isWhite) then
		coin:flip()
	    end
	end
    end
end

-- 导出当前棋盘布局
function Board:exportGrid()
    local levelData = {}
    levelData.rows = self.rows
    levelData.cols = self.cols

    local grid = clone(self.grid)
    for row = 1, self.rows do
	for col = 1, self.cols do
	    local coin = self.grid[row][col]
	    if coin then
		if coin.isWhite then
		    grid[row][col] = Levels.NODE_IS_WHITE
		else
		    grid[row][col] = Levels.NODE_IS_BLACK
		end
	    else
		grid[row][col] = Levels.NODE_IS_EMPTY
	    end
	end
    end

    levelData.grid = grid
    return levelData
end

function Board:checkLevelCompleted()
    if self.playForever then return end
    local count = 0
    for _, coin in ipairs(self.coins) do
        if coin.isWhite then count = count + 1 end
    end
    if count == #self.coins then
        -- completed
        self:setTouchEnabled(false)
        self:dispatchEvent({name = "LEVEL_COMPLETED"})
    end
end

function Board:getCoin(row, col)
    if self.grid[row] then
        return self.grid[row][col]
    end
end

function Board:flipCoin(coin, includeNeighbour)
    if not coin or coin == Levels.NODE_IS_EMPTY then return end

    self.flipAnimationCount = self.flipAnimationCount + 1
    coin:flip(function()
        self.flipAnimationCount = self.flipAnimationCount - 1
        self.batch:reorderChild(coin, COIN_ZORDER)
        if self.flipAnimationCount == 0 then
            self:checkLevelCompleted()
        end
    end)
    if includeNeighbour then
        audio.playSound(GAME_SFX.flipCoin)
        self.batch:reorderChild(coin, COIN_ZORDER + 1)
        self:performWithDelay(function()
            self:flipCoin(self:getCoin(coin.row - 1, coin.col))
            self:flipCoin(self:getCoin(coin.row + 1, coin.col))
            self:flipCoin(self:getCoin(coin.row, coin.col - 1))
            self:flipCoin(self:getCoin(coin.row, coin.col + 1))
        end, 0.25)
    end
end

function Board:onTouch(event, x, y)
    if event ~= "began" or self.flipAnimationCount > 0 then return end

    local padding = NODE_PADDING / 2
    for _, coin in ipairs(self.coins) do
        local cx, cy = coin:getPosition()
        cx = cx + display.cx
        cy = cy + display.cy
        if x >= cx - padding
            and x <= cx + padding
            and y >= cy - padding
            and y <= cy + padding then
            self:flipCoin(coin, true)
	    self:dispatchEvent({name = "FLIP_ONCE"})
            break
        end
    end
end

-- 随机翻一个
function Board:randomFlip(includeNeighbour)
    local index = math.random(#self.coins)
    self:flipCoin(self.coins[index], includeNeighbour)
end

-- 插入答案
function Board:playAnswer(solve)
    self:setTouchEnabled(false)
    self.playForever = true

    local aseq = {}
    local delay = cc.DelayTime:create(Board.AnswerDelay)
    for i, pos in ipairs(solve) do
	local coin = self:getCoin(pos.row, pos.col)
	local callFlip = cc.CallFunc:create(function()
	    self:flipCoin(coin, true)
	    self:dispatchEvent({name = "FLIP_ONCE"})
	end)
	table.insert(aseq, delay)
	table.insert(aseq, callFlip)
    end
    -- table.insert(aseq, delay)

    local finish = cc.CallFunc:create(function()
	-- self:setTouchEnabled(true)
	self:dispatchEvent({name = "ANSWER_FINISH"})
	-- self.playForever = false
    end)
    table.insert(aseq, finish)

    local action = transition.sequence(aseq)
    self:runAction(action)

end

function Board:onEnter()
    self:setTouchEnabled(true)
end

function Board:onExit()
    self:removeAllEventListeners()
end

return Board
