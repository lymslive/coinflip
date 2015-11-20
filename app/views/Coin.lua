
local Levels = import("..data.Levels")

local Coin = class("Coin", function(nodeType)
    local index = 1
    if nodeType == Levels.NODE_IS_BLACK then
        index = 8
    end
    -- newSprite 从缓存中加载中要用 # 字符表示
    local sprite = display.newSprite(string.format("#Coin%04d.png", index))
    sprite.isWhite = index == 1
    return sprite
end)

function Coin:flip(onComplete)
    -- newFrames 动画帧，名字前无 #，但需要预加载缓存
    -- %d, 1, 8 模板序列，加载1-8张图片，%04d 表示名称模板是4位数字，补前导0 
    local frames = display.newFrames("Coin%04d.png", 1, 8, not self.isWhite)
    local animation = display.newAnimation(frames, 0.3 / 8)
    self:playAnimationOnce(animation, false, onComplete)

    self:runAction(transition.sequence({
        cc.ScaleTo:create(0.15, 1.5),
        cc.ScaleTo:create(0.1, 1.0),
        cc.CallFunc:create(function()
            local actions = {}
            local scale = 1.1
            local time = 0.04
            for i = 1, 5 do
                actions[#actions + 1] = cc.ScaleTo:create(time, scale, 1.0)
                actions[#actions + 1] = cc.ScaleTo:create(time, 1.0, scale)
                scale = scale * 0.95
                time = time * 0.8
            end
            actions[#actions + 1] = cc.ScaleTo:create(0, 1.0, 1.0)
            self:runAction(transition.sequence(actions))
        end)
    }))

    self.isWhite = not self.isWhite
end

return Coin