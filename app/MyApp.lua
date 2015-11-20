
require("cocos.init")
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

local uTipManager = import("app.models.uTipManager")

-- 保存用户数据，当前关卡进度
GameState = require("framework.cc.utils.GameState")
GameData = {}
GameData.currentLevel = 1
-- currentLevel 是当前要玩但未完成的关，小于的已完成，大于的未解锁

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    self.objects_ = {}

    GameState.init(function(param)
	local returnValue = nil
	if param.errorCode then
	    CCLuaLog("error")
	else
	    if param.name == "save" then
		returnValue = param.values
	    elseif param.name == "load" then
		returnValue = param.values
	    end
	end
	return returnValue
    end, "state.json", nil)

    if io.exists(GameState.getGameStatePath()) then
	GameData=GameState.load()
    end

    self.tips = uTipManager.getInstance()
    self.tiplang = "en"
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    display.addSpriteFrames(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)

    -- preload all sounds
    for k, v in pairs(GAME_SFX) do
        audio.preloadSound(v)
    end

    db.print("app:run() called")
    math.newrandomseed()
    self:enterMenuScene()
end

function MyApp:enterMenuScene()
    self:enterScene("MenuScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:enterMoreGamesScene()
    self:enterScene("MoreGamesScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:enterCreateLevelScene()
    self:enterScene("CreateLevelScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:enterChooseLevelScene(levelIndex)
    self:enterScene("ChooseLevelScene", {levelIndex}, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:playLevel(levelIndex)
    self:enterScene("PlayLevelScene", {levelIndex}, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:playCustom(levelIndex)
    self:enterScene("PlayCustomScene", {levelIndex}, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:SetCreate()
    self:enterScene("SetCreateScene", nil, "fade", 0.6, display.COLOR_WHITE)
end
-- appInstance = MyApp
return MyApp
