
local Levels = import("..data.Levels")
local Board = import("..views.Board")
local AdBar = import("..views.AdBar")
local TextButton = import("..ui.TextButton")
local Footbar = import("..views.Footbar")

local PlayLevelScene = class("PlayLevelScene", function()
    return display.newScene("PlayLevelScene")
end)

-- levelIndex 主要是传递给 Board 的参数，可数字或表格类型
function PlayLevelScene:ctor(levelIndex)
    if type(levelIndex == "number") then
	self.levelIndex_ = levelIndex
    else
	self.levelIndex_ = 0
    end

    local bg = display.newSprite("#PlayLevelSceneBg.png")
    -- make background sprite always align top
    bg:setPosition(display.cx, display.top - bg:getContentSize().height / 2)
    self:addChild(bg)
    bg:setOpacity(168)

    local title = display.newSprite("#Title.png", display.left + 150, display.top - 50)
    title:setScale(0.5)
    self:addChild(title)

    -- 步数计数器
    self.flipsCount_  = 0
    self.flips_ = cc.ui.UILabel.new({
	UILabelType = 1,
	text  = string.format("flips: %d", self.flipsCount_),
	font  = "UIFont.fnt",
	x     = display.left + 10,
	y     = display.top - 150,
	align = cc.ui.TEXT_ALIGN_LEFT,
    }) :addTo(self)

    self:createLevelLabel()

    -- 创建棋盘，设定监听
    self.board = Board.new(levelIndex)
    self.board:addEventListener("LEVEL_COMPLETED", handler(self, self.onLevelCompleted))
    self:addChild(self.board)
    self.board:addEventListener("FLIP_ONCE", handler(self, self.onFlipOnce))

    -- cc.ui.UIPushButton.new({normal = "#BackButton.png", pressed = "#BackButtonSelected.png"})
    TextButton.new("Back")
        :align(display.CENTER, display.right - 100, display.bottom + 120)
        :onButtonClicked(function() self:onBack() end)
        :addTo(self)

    -- retry 文字标签
    TextButton.new("Retry")
	:align(display.CENTER, display.right - 100, display.top - 150)
	:onButtonClicked(function() self:onRetry() end)
	:addTo(self)

    -- 监听手机硬件返回按键
    display.newLayer()
	:addTo(self, -10)
	:setKeypadEnabled(true)
	:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
	    if event.key == "back" then self:onBack() end
	end)

    Footbar.new("playsc", "common") :addTo(self)
end

function PlayLevelScene:createLevelLabel()
    local levelIndex = self.levelIndex_
    if type(levelIndex) ~= "number" then return end
    local label = cc.ui.UILabel.new({
	UILabelType = 1,
	font  = "UIFont.fnt",
	text  = string.format("Level: %s", tostring(levelIndex)),
	x     = display.left + 10,
	y     = display.bottom + 120,
	align = cc.ui.TEXT_ALIGN_LEFT,
    })
    self:addChild(label)
end

function PlayLevelScene:onLevelCompleted()
    audio.playSound(GAME_SFX.levelCompleted)

    local dialog = display.newSprite("#LevelCompletedDialogBg.png")
    dialog:setPosition(display.cx, display.top + dialog:getContentSize().height / 2 + 40)
    self:addChild(dialog)

    -- transition.moveTo(dialog, {time = 0.7, y = display.top - dialog:getContentSize().height / 2 - 40, easing = "BOUNCEOUT"})
    transition.moveTo(dialog, {time = 0.7, y = display.cy, easing = "BOUNCEOUT"})

    -- 保存关卡进度
    if GameData.currentLevel == self.levelIndex_ then
	GameData.currentLevel = GameData.currentLevel + 1
	GameState.save(GameData)
    end

    -- 点击成功对话框，进入下一关
    dialog:setTouchEnabled(true)
        :setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
        :addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
            if event.name == "began" then
                -- print("succeed dialog touch began")
                return true
            elseif event.name == "moved" then
                print("succeed dialog touch moved")
                return false
            elseif event.name == "ended" then
                -- print("succeed dialog touch end")
                if self.levelIndex_ < Levels.numLevels() then
                    app:playLevel(self.levelIndex_ + 1)
                end
            end
        end)
end

-- 更新步数计时器
function PlayLevelScene:onFlipOnce()
    self.flipsCount_  = self.flipsCount_ + 1
    self.flips_:setString(string.format("flips: %d", self.flipsCount_))
end

function PlayLevelScene:onRetry()
    if self.flipsCount_ == 0 then return end
    db.print("retry button clicked")
    self.board:replaceCoins()
    self.flipsCount_  = 0
    self.flips_:setString(string.format("flips: %d", self.flipsCount_))
end

function PlayLevelScene:onBack()
    app:enterChooseLevelScene(self.levelIndex_)
end

function PlayLevelScene:onEnter()
end

return PlayLevelScene
