
-- local Levels = import("..data.Levels")
-- local Board = import("..views.Board")
-- local AdBar = import("..views.AdBar")
local BoardSet = import("..views.BoardSet")
local TextButton = import("..ui.TextButton")
local Footbar = import("..views.Footbar")

local SetCreateScene = class("SetCreateScene", function()
    return display.newScene("SetCreateScene")
end)

function SetCreateScene:ctor()
    -- self.rows_ = rows or self.rows_ = 6
    -- self.cols_ = cols or slef.cols_ = 6

    local bg = display.newSprite("#PlayLevelSceneBg.png")
	:pos(display.cx, display.cy)
	:addTo(self)
	:setOpacity(168)

    local title = display.newSprite("#Title.png", display.left + 150, display.top - 50)
	:setScale(0.5)
	:addTo(self)


    -- 创建棋盘
    local preset = GameData.CustomSet or {}
    self.board = BoardSet.new(preset)
	-- :pos(display.cx, display.cy)
	:addTo(self)
    self.board:addEventListener("FLIP_ONCE", handler(self, self.onFlipOnce))

    -- Back 文字标签
    TextButton.new("Back")
	:align(display.CENTER_RIGHT, display.right - 100, display.bottom + 120)
	:onButtonClicked(function() self:onBack() end)
	:addTo(self)

    -- OK 文字标签
    TextButton.new("OK")
	:align(display.CENTER_LEFT, display.left + 90, display.bottom + 120)
	:onButtonClicked(function() self:onOK() end)
	:addTo(self)

    -- Hole 文字标签
    TextButton.new("Hole")
	:align(display.CENTER, display.cx, display.bottom + 120)
	:onButtonClicked(function() self:onHole() end)
	:addTo(self)

    -- 监听手机硬件返回按键
    display.newLayer()
	:addTo(self, -10)
	:setKeypadEnabled(true)
	:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
	    if event.key == "back" then self:onBack() end
	end)

    Footbar.new("setsc", "common") :addTo(self)
end

function SetCreateScene:onBack()
    app:enterCreateLevelScene()
end

function SetCreateScene:onOK()
    db.print("OK Clicked")
    local preset = self.board:exportSet()
    GameData.CustomSet = preset
    GameState.save(GameData)
    self:onBack()
end

-- 点击 Hole 临时进入编辑空洞模式，一次点一个空洞
function SetCreateScene:onHole()
    db.print("Hole Clicked")
    self.board:switchHoleMode()
end

function SetCreateScene:onCancel()
    db.print("Cancel Clicked")
end

function SetCreateScene:onEnter()
end

return SetCreateScene
