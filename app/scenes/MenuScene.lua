
local AdBar = import("..views.AdBar")
local BubbleButton = import("..views.BubbleButton")
local Footbar = import("..views.Footbar")
local TextButton = import("..ui.TextButton")

local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

function MenuScene:ctor()
    self.bg = display.newSprite("#MenuSceneBg.png", display.cx, display.cy)
    self:addChild(self.bg)

    self.adBar = AdBar.new()
    self:addChild(self.adBar)

    self.moreGamesButton = BubbleButton.new({
            image = "#MenuSceneMoreGamesButton.png",
            sound = GAME_SFX.tapButton,
            prepare = function()
                audio.playSound(GAME_SFX.tapButton)
                -- self.moreGamesButton:setButtonEnabled(false)
            end,
            listener = function()
                app:enterMoreGamesScene()
            end,
        })
        :align(display.CENTER, display.left + 150, display.bottom + 300)
        :addTo(self)

    self.startButton = BubbleButton.new({
            image = "#MenuSceneStartButton.png",
            sound = GAME_SFX.tapButton,
            prepare = function()
                audio.playSound(GAME_SFX.tapButton)
                -- self.startButton:setButtonEnabled(false)
            end,
            listener = function()
                app:enterChooseLevelScene()
            end,
        })
        :align(display.CENTER, display.right - 150, display.bottom + 300)
        :addTo(self)

    -- [[ 监听手机硬件返回按键
    display.newLayer()
	:addTo(self, -10)
	:setKeypadEnabled(true)
	:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
	    if event.key == "back" then 
		-- self:onBack()
		CCDirector:sharedDirector():endToLua()  
		--[[ 这段代码在自己的华为手机上测试有 bug
		device.showAlert("Confirm Exit", "Are you sure exit game ?", {"YES", "NO"}, function (event)  
		    if event.buttonIndex == 1 then  
			CCDirector:sharedDirector():endToLua()  
		    else  
			device.cancelAlert()   
		    end  
		end)  
		--]]
	    end
	end)
    --]]

    -- db.print("ctor MenuScene")
    self.footbar = Footbar.new("mainsc", "common") :addTo(self)

    -- language 文字标签
    self.setLang = TextButton.new("Language")
	:align(display.CENTER_LEFT, display.left + 90, display.bottom + 100)
	:onButtonClicked(function() self:onLang() end)
	:addTo(self)

    if app.tiplang == "en" then
	self.setLang:setString("Chinese")
    else
	self.setLang:setString("English")
    end
end

function MenuScene:onEnter()
    -- db.print("enter MenuScene")
end

function MenuScene:onLang()
    if app.tiplang == "en" then
	app.tiplang = "zh"
	self.setLang:setString("English")
    else
	app.tiplang = "en"
	self.setLang:setString("Chinese")
    end
    self.footbar:setTip()
end

return MenuScene
