-- ÎÄ±¾°´Å¥
local TextButton = class("TextButton", cc.ui.UIPushButton)

function TextButton:ctor(str)
    TextButton.super.ctor(self)
    local label = cc.ui.UILabel.new({
	UILabelType = 1,
	font  = "UIFont.fnt",
	text  = str,
	align = cc.ui.TEXT_ALIGN_LEFT,
    })
    self:setButtonLabel(label)
end

function TextButton:setString(str)
    self:setButtonLabelString(str)
end

return TextButton
