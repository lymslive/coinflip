local Footbar = import("..views.Footbar")
local TextButton = import("..ui.TextButton")

local MoreGamesScene = class("MoreGamesScene", function()
    return display.newScene("MoreGamesScene")
end)

function MoreGamesScene:ctor()
    local bg = display.newSprite("#OtherSceneBg.png"):addTo(self)
    bg:setPosition(display.cx, display.top - bg:getContentSize().height / 2)
    bg:setOpacity(192)

    local title = display.newSprite("#Title.png", display.cx, display.top - 100)
    self:addChild(title)

    self:staticPanel()

    -- 底部文本按钮
    TextButton.new("Back")
        :align(display.CENTER, display.right - 100, display.bottom + 120)
        :onButtonClicked(function() self:onBack() end)
        :addTo(self)
	
    TextButton.new("Create")
        :align(display.CENTER, display.cx, display.bottom + 120)
        :onButtonClicked(function() app:enterCreateLevelScene() end)
        :addTo(self)
	
    -- add highlight level icon
    self.highlightButton = display.newSprite("#HighlightLevelIcon.png")
    self.highlightButton:setVisible(false)
    self:addChild(self.highlightButton)

    -- 为背景层添加触屏响应
    bg:setTouchEnabled(true)
	:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
	    self:onTouch(event.name, event.x, event.y)
	    return true
	end)

    -- 监听手机硬件返回按键
    display.newLayer()
	:addTo(self, -10)
	:setKeypadEnabled(true)
	:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
	    if event.key == "back" then self:onBack() end
	end)

    Footbar.new("moresc", "common") :addTo(self)
end

function MoreGamesScene:onBack()
    app:enterMenuScene()
end

-- 不用翻页，固定显示16个自定义关卡
function MoreGamesScene:staticPanel()
    local rows = 4
    local cols = 4
    local rowHeight = math.floor((display.height - 340) / rows)
    local colWidth = math.floor(display.width * 0.9 / cols)

    local batch = display.newBatchNode(GAME_TEXTURE_IMAGE_FILENAME)
    self:addChild(batch)
    self.buttons = {}

    local levelCount = 0
    if GameData.CustomLevel and #GameData.CustomLevel >= 1 then
	levelCount = #GameData.CustomLevel
	-- db.print("levelCount:", levelCount)
    end

    local startX = (display.width - colWidth * (cols - 1)) / 2
    local y = display.top - 220
    local levelIndex = 1

    for row = 1, rows do
	local x = startX
	for column = 1, cols do
	    local png = "#UnlockedLevelIcon.png"
	    local icon = display.newSprite(png, x, y)

	    batch:addChild(icon)
	    icon.levelIndex = levelIndex
	    self.buttons[#self.buttons + 1] = icon

	    -- 未定义的自创关卡位，levelIndex 修为 0
	    local str = tostring(levelIndex)
	    if levelIndex > levelCount then
		-- str = tostring(0)
		str = ""
		icon.levelIndex = 0
	    end
	    -- db.print("levelIndex:", levelIndex)

	    local label = cc.ui.UILabel.new({
		UILabelType = 1,
		text  = str,
		font  = "UIFont.fnt",
	    })
		:align(cc.ui.TEXT_ALIGN_CENTER, x, y - 4)
		:addTo(self)

	    x = x + colWidth
	    levelIndex = levelIndex + 1
	end

	y = y - rowHeight
    end

end

function MoreGamesScene:onTouch(event, x, y)
    local button = self:checkButton(x, y)
    if not button then
	db.print("no button touched in MoreGameScene")
	return
    end

    if event == "began" then
	self.highlightButton:setVisible(true)
	self.highlightButton:setPosition(button:getPosition())
    else
	self.highlightButton:setVisible(false)
	local levelIndex = button.levelIndex
	if levelIndex > 0 then
	    app:playCustom(levelIndex)
	end
    end
end

function MoreGamesScene:checkButton(x, y)
    local pos = cc.p(x, y)
    for i = 1, #self.buttons do
	local button = self.buttons[i]
	if cc.rectContainsPoint(button:getBoundingBox(), pos) then
	    return button
	end
    end
    return nil
end

return MoreGamesScene
