
local Footbar = class("Footbar", function()
    return display.newNode()
end)

function Footbar:ctor(maingroup, randgroup)
    self.maingroup_ = maingroup
    self.randgroup_ = randgroup
    self.timeInterval_ = 5
    self.randTimes_ = 3

    self.font_ = "Arial"
    self.size_ = 20
    self.color_ = cc.c3b(255, 255, 0)

    local defaultText = "Coin Flip"
    local yshift = 50
    local xshift = 20

    self.label_ = cc.ui.UILabel.new({
	UILabelType = 2,
	-- font = self.font_,
	text = defaultText,
	size = self.size_,
	color = self.color_,
	align = cc.ui.TEXT_ALIGN_CENTER,
    }) 
    :addTo(self)
    :pos(display.left + xshift, display.bottom + yshift)

    -- self:pos(display.cx, display.bottom + yshift)

    -- self:start()
    self.mainTips_ = app.tips:getTipsbyTag(self.maingroup_) or {}
    self.randTips_ = app.tips:getTipsbyTag(self.randgroup_) or {}
    -- self:viewTips()
    self.mainIndex_ = 0
    self.randCount_ = 0
    self.currentTip_ = nil
    self:nextTip()

    self:onPlay()
end

-- 下一条提示，先从主group中顺序循环，再从随机组中循环一定次数
function Footbar:nextTip()
    if self.mainIndex_ < #self.mainTips_ then
	self.mainIndex_ = self.mainIndex_ + 1
	self:setTip(self.mainTips_[self.mainIndex_])
    else
	if #self.randTips_ > 0 then
	    self:setTip(self.randTips_[math.random(#self.randTips_)])
	    self.randCount_ = self.randCount_ + 1
	    if self.randCount_ >= self.randTimes_ then
		self.mainIndex_ = 0
		self.randCount_ = 0
	    end
	else
	    self.mainIndex_ = 0
	end
    end
    return self
end

function Footbar:setTip(tip)
    if tip then
	self.label_:setString(tip[app.tiplang])
	self.currentTip_ = tip
    else
	self.label_:setString(self.currentTip_[app.tiplang])
    end
end

function Footbar:onPlay()
    self:schedule(function()
	self:nextTip()
    end, self.timeInterval_)

    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	if event.name == "began" then
	    self:nextTip()
	    return false
	end
    end)
    db.print("Began play Footbar")
end
function Footbar:onEnter()
    db.print("enter Footbar")
end

function Footbar:onExit()
    self:removeAllEventListeners()
end

function Footbar:viewTips()
    for i, tip in ipairs(self.mainTips_) do
	db.print(i, tip.id)
    end
    for i, tip in ipairs(self.randTips_) do
	db.print(i, tip.id)
    end
end
return Footbar
