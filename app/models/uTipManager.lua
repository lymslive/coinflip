-- uTipManager: 帮助提示管理类
-- dataCfg_
local tipConfig = import("..data.HelpTips")

local uTipManager = class("uTipManager")

-- uTipManager.dataCfg_ = tipConfig
uTipManager.instance = nil

function uTipManager:ctor(tipConfig)
    self.dataCfg_ = tipConfig
    uTipManager.instance = self
end

function uTipManager:getInstance()
    if not uTipManager.instance then
	uTipManager.instance = uTipManager.new(tipConfig)
    end
    return uTipManager.instance
end

-- 按 tag 查找一组 tips
function uTipManager:getTipsbyTag(tag)
    local group = {}
    for i = 1, #self.dataCfg_ do
	local tip = self.dataCfg_[i]
	if tip.tag == tag then
	    table.insert(group, tip)
	end
    end
    return group
end

-- 按 id 查找一个 tip
function uTipManager:getTipsbyId(id)
    local found = nil
    for i = 1, #self.dataCfg_ do
	local tip = self.dataCfg_[i]
	if tip.id == id then
	    found = tip
	end
    end
    return found
end

return uTipManager
