
local AdBar = import("..views.AdBar")
local LevelsList = import("..views.LevelsList")
local TextButton = import("..ui.TextButton")
local Footbar = import("..views.Footbar")

local ChooseLevelScene = class("ChooseLevelScene", function()
    return display.newScene("ChooseLevelScene")
end)

-- 额外构造参数 levelIndex 用于定位页面
function ChooseLevelScene:ctor(levelIndex)
    local bg = display.newSprite("#OtherSceneBg.png")
    -- make background sprite always align top
    bg:setPosition(display.cx, display.top - bg:getContentSize().height / 2)
    self:addChild(bg)
    bg:setOpacity(192)

    local title = display.newSprite("#Title.png", display.cx, display.top - 100)
    self:addChild(title)

    local adBar = AdBar.new()
    self:addChild(adBar)

    -- create levels list
    local rect = cc.rect(display.left, display.bottom + 180, display.width, display.height - 280)
    self.levelsList = LevelsList.new(rect)
    self.levelsList:addEventListener("onTapLevelIcon", handler(self, self.onTapLevelIcon))
    self:addChild(self.levelsList)

    -- ME: 滚动到指定页
    levelIndex = levelIndex or GameData.currentLevel
    local pageIndex = self.levelsList:getPageIndex(levelIndex)
    self.levelsList:scrollToCell(pageIndex)

    -- cc.ui.UIPushButton.new({normal = "#BackButton.png", pressed = "#BackButtonSelected.png"})
    TextButton.new("Back")
        :align(display.CENTER, display.right - 100, display.bottom + 120)
        :onButtonClicked(function() self:onBack() end)
        :addTo(self)

    -- 监听手机硬件返回按键
    display.newLayer()
	:addTo(self, -10)
	:setKeypadEnabled(true)
	:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
	    if event.key == "back" then self:onBack() end
	end)

    Footbar.new("choosesc", "common") :addTo(self)
end

function ChooseLevelScene:onTapLevelIcon(event)
    audio.playSound(GAME_SFX.tapButton)
    -- 只可能进入小于等于当前关卡
    if event.levelIndex <= GameData.currentLevel then
	app:playLevel(event.levelIndex)
    end
end

function ChooseLevelScene:onBack()
    app:enterMenuScene()
end

function ChooseLevelScene:onEnter()
    self.levelsList:setTouchEnabled(true)
end

return ChooseLevelScene
