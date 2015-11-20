-- ���̱༭������

local Levels = import("..data.Levels")
local Coin   = import("..views.Coin")

local BoardSet = class("BoardSet", function()
    return display.newNode()
end)

local NODE_PADDING   = 100
local NODE_ZORDER    = 0

local COIN_ZORDER    = 1000
local BOARD_OUTSIDE  = "XX"

-- ���̶���ṹ
-- .rows, .cols
-- .holes, �������� holes[i].x holes[i].y
function BoardSet:ctor(preset)
    cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    preset = preset or {}
    self.rows_ = preset.rows or 6
    self.cols_ = preset.cols or 6
    self.holes_ = preset.holes or {}
    self.grid_ = {}
    self.bgrid_ = {}  -- ȫ��Χ�װ�6*6
    self.bholes_ = {} -- Ԥ�����صı�ʾ�οյľ���

    self.HOLE_MODE_ = false

    local rowMax, colMax = 6, 6
    local offsetX = -math.floor(NODE_PADDING * colMax / 2) - NODE_PADDING / 2
    local offsetY = -math.floor(NODE_PADDING * rowMax / 2) - NODE_PADDING / 2
    local batch = display.newBatchNode(GAME_TEXTURE_IMAGE_FILENAME)
	:pos(display.cx, display.cy)
	:addTo(self)

    self.batch_ = batch

    -- local textLable = display.newLayer() :pos(display.cx, display.cy) :addTo(self)

    -- �̸���
    -- �ײ㣺BoarddNode
    -- �в㣺��Χ�� #BroadNodeLocked.png����������������������
    -- �ϲ㣺���ص��οձ��
    for row = 1, rowMax do
	local y = row * NODE_PADDING + offsetY
	self.grid_[row] = {}
	self.bgrid_[row] = {}
	self.bholes_[row] = {}

	for col = 1, colMax do
	    local x = col * NODE_PADDING + offsetX
	    local boardNode = display.newSprite("#BoardNode.png", x, y) :addTo(batch)
	    self.bgrid_[row][col] = boardNode

	    if row > self.rows_ or col > self.cols_ then
		local lockNode = display.newSprite("#BoardNodeLocked.png", x, y) :addTo(batch)
		self.grid_[row][col] = lockNode
	    else
		local coin = Coin.new(Levels.NODE_IS_BLACK) :pos(x, y) :addTo(batch)
		self.grid_[row][col] = coin
	    end

	    local holeNode = display.newSprite("#CloseButton.png", x, y) :addTo(batch)
	    self.bholes_[row][col] = holeNode
	    holeNode:setVisible(false)

	    --[[
	    cc.ui.UILabel.new({text = string.format("(%d,%d)", row, col)})
	    :pos(x,y)
	    :addTo(textLable)
	    --]]
	end
    end

    -- ���ԽǷ�����ҳ��ϣ��οմ�����Ӳ��
    self:markCorner_()
    self:markHoles_()

    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	return self:onTouch(event.name, event.x, event.y)
    end)

end

function BoardSet:markCorner_()
    self.grid_[1][1]:flip()
    self.grid_[self.rows_][self.cols_]:flip()
end

function BoardSet:markHoles_()
    for i, hole in ipairs(self.holes_) do
	if hole.y <= self.rows_ and hole.x <= self.cols_ then
	    self.grid_[hole.y][hole.x]:setVisible(false)
	end
    end
end

function BoardSet:redraw_()
    local rowMax, colMax = 6, 6
    local offsetX = -math.floor(NODE_PADDING * colMax / 2) - NODE_PADDING / 2
    local offsetY = -math.floor(NODE_PADDING * rowMax / 2) - NODE_PADDING / 2
    local batch = self.batch_

    for row = 1, rowMax do
	local y = row * NODE_PADDING + offsetY

	for col = 1, colMax do
	    local x = col * NODE_PADDING + offsetX
	    local node = self.grid_[row][col]
	    if node then node:removeSelf() end

	    if row > self.rows_ or col > self.cols_ then
		local lockNode = display.newSprite("#BoardNodeLocked.png", x, y) :addTo(batch)
		self.grid_[row][col] = lockNode
	    else
		local coin = Coin.new(Levels.NODE_IS_BLACK) :pos(x, y) :addTo(batch)
		self.grid_[row][col] = coin
	    end

	end
    end
    self:markCorner_()
    self:markHoles_()
end

function BoardSet:onTouch(name, x, y)
    db.print("event pos:", x, y)
    local pos = self:gridPos(x, y)
    if not pos then return false end
    db.print("grid pos:", pos.x, pos.y)

    if self.HOLE_MODE_ then
	self:switchOneHole_(pos)
	self:switchHoleMode(false)
    else
	self:resize_(pos.y, pos.x)
    end

    db.print("BoardSet onTouch called")
    -- ֻ��Ӧ�����ʼ began
    return false
end

function BoardSet:resize_(rows, cols)
    if rows == self.rows_ and cols == self.cols_ then
	return false, "the size not changed"
    elseif rows == 1 and cols == 1 then
	return false, "the board is tow small"
    end

    self.rows_ = rows
    self.cols_ = cols
    self:redraw_()
end

-- ͨ����Ļ���������ȡ��������1-6���ṹ���Ƶ�����{x,y}
function BoardSet:gridPos(x, y)
    local pos = cc.p(x, y)
    local rowMax, colMax = 6, 6
    for row = 1, rowMax do
	for col = 1, colMax do
	    local bgrid = self.bgrid_[row][col]
	    local box = bgrid:getBoundingBox()
	    -- for k, v in pairs(box) do db.print(k, v) end
	    box.x = box.x + display.cx
	    box.y = box.y + display.cy
	    if cc.rectContainsPoint(box, pos) then
		return {x = col, y = row}
	    end
	end
    end
    return nil
end

-- HoleMode: �û�������ӱ༭�Ƿ�Ϊ�ն����л���ʽ��һ��һ��
function BoardSet:switchHoleMode(flag)
    if type(flag) == "boolean" then
	self.HOLE_MODE_ = flag
    else
	self.HOLE_MODE_ = not self.HOLE_MODE_
    end

    if self.HOLE_MODE_ then
	self:showHoleMode_()
    else
	self:showNormalMode_()
    end
end

-- ������ң���ԭ�ǿն������Ƴ�֮���������ն��б�
function BoardSet:switchOneHole_(pos)
    local ishole = false

    if pos.x > self.cols_ or pos.y > self.rows_ then
	db.print("Can't set hole outside the vild board")
	return
    end

    for i = #self.holes_, 1, -1  do
	local hole = self.holes_[i]
	if hole.x == pos.x and hole.y == pos.y then
	    table.remove(self.holes_, i)
	    self.bholes_[hole.y][hole.x]:setVisible(false)
	    ishole = true
	end
    end

    if not ishole then
	table.insert(self.holes_, pos)
    end
end

-- �� HoleMode �£�������ʾ�ն���������Ӳ��
function BoardSet:showHoleMode_()
    for row = 1, self.rows_ do
	for col = 1, self.cols_ do
	    self.grid_[row][col]:setVisible(false)
	end
    end

    for i = 1, #self.holes_ do
	local hole = self.holes_[i]
	if hole.y <= self.rows_ and hole.x <= self.cols_ then
	    self.bholes_[hole.y][hole.x]:setVisible(true)
	end
    end
end

-- ���س���ģʽ��������ʾӲ�ң��ն�����Ӳ��
function BoardSet:showNormalMode_()
    for row = 1, self.rows_ do
	for col = 1, self.cols_ do
	    self.grid_[row][col]:setVisible(true)
	end
    end
    for i = 1, #self.holes_ do
	local hole = self.holes_[i]
	if hole.y <= self.rows_ and hole.x <= self.cols_ then
	    self.bholes_[hole.y][hole.x]:setVisible(false)
	    self.grid_[hole.y][hole.x]:setVisible(false)
	end
    end
end

-- �������ã�����һ�� preset �Ľṹ
function BoardSet:exportSet()
    local preset = {}
    preset.rows = self.rows_
    preset.cols = self.cols_
    preset.holes = self.holes_

    for i = #preset.holes, 1, -1 do
	local hole = preset.holes[i]
	if hole.y > preset.rows or hole.x > preset.cols then
	    table.remove(preset.holes, i)
	end
    end

    return preset
end

return BoardSet
