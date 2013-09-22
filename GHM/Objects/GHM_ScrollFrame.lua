--===================================================
--
--				GHM_ScrollFrame
--  			GHM_ScrollFrame.lua
--
--	A scroll frame with both vertical and horizontal scroll
--			Based on blizzard code
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================


function GHM_ScrollFrame_OnLoad(self)
	_G[self:GetName() .. "ScrollBarScrollDownButton"]:Disable();
	_G[self:GetName() .. "ScrollBarScrollUpButton"]:Disable();

	local scrollbar = _G[self:GetName() .. "ScrollBar"];
	scrollbar:SetMinMaxValues(0, 0);
	scrollbar:SetValue(0);
	self.offset = 0;
	scrollbar:Hide();

	local scrollbar2 = _G[self:GetName() .. "ScrollBar2"];
	scrollbar2:SetMinMaxValues(0, 0);
	scrollbar2:SetValue(0);
	self.offset2 = 0;
	scrollbar2:Hide();

	self.origAnchors = {};
	for i = 1, self:GetNumPoints() do
		local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(i);
		self.origAnchors[point] = {
			relativeTo = relativeTo,
			relativePoint = relativePoint,
			xOfs = xOfs,
			yOfs = yOfs,
		}
	end
	--GHM_TempBG(self);
	GHM_ScrollFrame_OnScrollRangeChanged(self);
end

local function AdjustScrollFrameArea(self, vBarShown, hBarShown)
	local anchors = self.origAnchors;
	if anchors.BOTTOM and anchors.RIGHT then
		local b = anchors.BOTTOM;
		self:SetPoint("BOTTOM", b.relativeTo, b.relativePoint, b.xOfs, b.yOfs + ((hBarShown and 16) or 0));

		local r = anchors.RIGHT;
		self:SetPoint("RIGHT", r.relativeTo, r.relativePoint, r.xOfs - ((vBarShown and 16) or 0), r.yOfs);
	end
	if anchors.BOTTOMRIGHT then
	end
	if anchors.TOPRIGHT then
	end
	if anchors.BOTTOMLEFT then
	end
	if anchors.TOPLEFT then
	end
	if anchors.CENTER then
	end
end

function GHM_ScrollFrame_OnScrollRangeChanged(self, xrange, yrange)
	local scrollbarV = _G[self:GetName() .. "ScrollBar"];
	local scrollbarH = _G[self:GetName() .. "ScrollBar2"];
	if (not yrange) then
		yrange = self:GetVerticalScrollRange();
	end
	if (not xrange) then
		xrange = self:GetHorizontalScrollRange();
	end
	local yvalue = scrollbarV:GetValue();
	if (yvalue > yrange) then
		yvalue = yrange;
	end
	local xvalue = scrollbarH:GetValue();
	if (xvalue > xrange) then
		xvalue = xrange;
	end

	scrollbarV:SetMinMaxValues(0, yrange);
	scrollbarV:SetValue(yvalue);

	scrollbarH:SetMinMaxValues(0, xrange);
	scrollbarH:SetValue(xvalue);

	local VScrollBarShown, HScrollBarShown = false, false;

	if (floor(yrange) > 0) and (yrange - yvalue > 0.005) then
		VScrollBarShown = true;
	end
	if (floor(xrange) > 0) and (xrange - xvalue > 0.005) then
		HScrollBarShown = true;
	end

	-- adjust accordingly
	AdjustScrollFrameArea(self, VScrollBarShown, HScrollBarShown);

	-- show the bars
	if VScrollBarShown then
		scrollbarV:Show();
	else
		scrollbarV:Hide();
	end
	if HScrollBarShown then
		scrollbarH:Show();
	else
		scrollbarH:Hide();
	end
end