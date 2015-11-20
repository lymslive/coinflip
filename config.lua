
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1

VERSION = 1.001
AUTHOR = "lymslive"

-- display FPS stats on screen
DEBUG_FPS = false

-- dump memory info every 10 seconds
DEBUG_MEM = false

-- load deprecated API
LOAD_DEPRECATED_API = false

-- load shortcodes API
LOAD_SHORTCODES_API = true

-- screen orientation
CONFIG_SCREEN_ORIENTATION = "portrait"

-- design resolution
CONFIG_SCREEN_WIDTH  = 640
CONFIG_SCREEN_HEIGHT = 960

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"

-- sounds
GAME_SFX = {
    tapButton      = "sfx/TapButtonSound.mp3",
    backButton     = "sfx/BackButtonSound.mp3",
    flipCoin       = "sfx/ConFlipSound.mp3",
    levelCompleted = "sfx/LevelWinSound.mp3",
}

GAME_TEXTURE_DATA_FILENAME  = "AllSprites.plist"
GAME_TEXTURE_IMAGE_FILENAME = "AllSprites.png"

-- 打印调试信息
-- [[ 删除 -- 后面的空格可注释下面的函数定义
db={}
db.print = function(...)
    if DEBUG > 0 then
	print(...)
	-- print(unpack(arg))
    end
end
--]]
