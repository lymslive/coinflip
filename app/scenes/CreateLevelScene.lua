-- 创建自定义关卡的场景
local Levels = import("..data.Levels")
local Board = import("..views.Board")
local AdBar = import("..views.AdBar")
local TextButton = import("..ui.TextButton")
local Footbar = import("..views.Footbar")

local CreateLevelScene = class("CreateLevelScene", function()
    return display.newScene("CreateLevelScene")
end)

CreateLevelScene.MaxCustom = 16

function CreateLevelScene:ctor()
    -- self.rows_ = rows or self.rows_ = 6
    -- self.cols_ = cols or slef.cols_ = 6

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

    -- resume 文字标签
    TextButton.new("Resume")
	:align(display.CENTER_RIGHT, display.right - 100, display.top - 150)
	:onButtonClicked(function() self:onResume() end)
	:addTo(self)

    -- random 文字标签
    TextButton.new("Random")
	:align(display.CENTER, display.cx, display.top - 150)
	:onButtonClicked(function() self:onRandomFlip() end)
	:addTo(self)

    -- Back 文字标签
    TextButton.new("Back")
	:align(display.CENTER_RIGHT, display.right - 100, display.bottom + 120)
	:onButtonClicked(function() self:onBack() end)
	:addTo(self)
	
    -- Export 文字标签
    TextButton.new("Export")
	:align(display.CENTER_LEFT, display.left + 90, display.bottom + 120)
	:onButtonClicked(function() self:onExport() end)
	:addTo(self)

    -- Set 文字标签
    TextButton.new("Set")
	:align(display.CENTER, display.cx, display.bottom + 120)
	:onButtonClicked(function() app:SetCreate() end)
	:addTo(self)


    -- 创建棋盘
    self.board = Board.new(self:getPreset()) :addTo(self)
    self.board:addEventListener("FLIP_ONCE", handler(self, self.onFlipOnce))
    self.board.playForever = true

    -- 监听手机硬件返回按键
    display.newLayer()
	:addTo(self, -10)
	:setKeypadEnabled(true)
	:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
	    if event.key == "back" then self:onBack() end
	end)

    Footbar.new("createsc", "common") :addTo(self)
end

-- 导出并返回
function CreateLevelScene:onExport()
    db.print("Export Clicked")
    if self.flipsCount_  == 0 then
	return
    end
    local levelData = self.board:exportGrid()
    if self:pushLevel(levelData) then
	GameState.save(GameData)
	db.print("Level exported")
	self:onBack()
    end
end

-- 存入自定义关卡，如果超过最大数量，则按队列方式挤出最早的关卡
-- 新关卡始终在最后一个
function CreateLevelScene:pushLevel(levelData)
    if not GameData.CustomLevel then
	GameData.CustomLevel = {}
    end

    if #GameData.CustomLevel < self.MaxCustom then
	table.insert(GameData.CustomLevel, levelData)
    else
	for i = 1, self.MaxCustom-1 do
	    GameData.CustomLevel[i] = GameData.CustomLevel[i+1]
	end
	GameData.CustomLevel[self.MaxCustom] = levelData
    end
    return true
end

-- 更新步数计时器
function CreateLevelScene:onFlipOnce()
    self.flipsCount_  = self.flipsCount_ + 1
    self.flips_:setString(string.format("flips: %d", self.flipsCount_))
end

function CreateLevelScene:onResume()
    if self.flipsCount_ == 0 then return end
    db.print("Resume button clicked")
    self.board:resumeWhite()
    self.flipsCount_  = 0
    self.flips_:setString(string.format("flips: %d", self.flipsCount_))
end

function CreateLevelScene:onRandomFlip()
    self.board:randomFlip(true)
    self:onFlipOnce()
end

-- 从设置数据中创建模板棋盘 
-- 先根据范围大小铺上金币，再根据空洞位置挖空
function CreateLevelScene:getPreset()
    local levelData = {}
    local preset = GameData.CustomSet

    if not preset then
	preset = {rows = 6, cols = 6, holes = {},}
    end
    levelData.rows = preset.rows
    levelData.cols = preset.cols

    local grid = {}
    for row = 1, preset.rows do
	grid[row] = {}
	for col = 1, preset.cols do
	    grid[row][col] = Levels.NODE_IS_WHITE
	end
    end

    for i = 1, #preset.holes do
	local hole = preset.holes[i]
	if hole.y <= preset.rows and hole.x <= preset.cols then
	    grid[hole.y][hole.x] = Levels.NODE_IS_EMPTY
	else
	    db.print("the saved data has error")
	end
    end

    levelData.grid = grid
    return levelData
end

function CreateLevelScene:onBack()
    app:enterMoreGamesScene()
end

function CreateLevelScene:onEnter()
end

return CreateLevelScene
