
local AdBar = {}

function AdBar.new()
    -- local sprite = display.newSprite("#AdBar.png")
    local sprite = display.newSprite()
    sprite:align(display.BOTTOM_CENTER, display.cx, display.bottom)
    return sprite
end

return AdBar
