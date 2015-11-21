local PlayLevelScene = import(".PlayLevelScene")

local PlayCustomScene = class("PlayCustomScene", PlayLevelScene)

function PlayCustomScene:ctor(levelIndex)
    self.customLevel_ = levelIndex
    local levelData = GameData.CustomLevel[levelIndex]
    PlayCustomScene.super.ctor(self, levelData)
end

function PlayCustomScene:onLevelCompleted()
    audio.playSound(GAME_SFX.levelCompleted)

    local dialog = display.newSprite("#LevelCompletedDialogBg.png")
    dialog:setPosition(display.cx, display.top + dialog:getContentSize().height / 2 + 40)
    self:addChild(dialog)

    transition.moveTo(dialog, {time = 0.7, y = display.cy, easing = "BOUNCEOUT"})

    -- 点击成功对话框，返回 MoreGame
    dialog:setTouchEnabled(true)
    :setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    :addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
	if event.name == "began" then
	    app:enterMoreGamesScene()
	    return true
	end
    end)
end

function PlayCustomScene:createLevelLabel()
    local levelIndex = self.customLevel_
    local label = cc.ui.UILabel.new({
	UILabelType = 1,
	font  = "UIFont.fnt",
	text  = string.format("Custom: %s", tostring(levelIndex)),
	x     = display.left + 10,
	y     = display.bottom + 120,
	align = cc.ui.TEXT_ALIGN_LEFT,
    })
    self:addChild(label)
end

function PlayCustomScene:addAnswerLabel()
    return
end

function PlayCustomScene:onBack()
    app:enterMoreGamesScene()
end

return PlayCustomScene
