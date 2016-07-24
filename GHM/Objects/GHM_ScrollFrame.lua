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

	GHM_ScrollFrame_OnScrollRangeChanged(self);

	--Create textures
	local bg1 = CreateFrame("Frame", nil, self);
	self.bg1 = bg1;
	bg1:SetPoint("TOPLEFT", self, "TOPRIGHT", -2, 0);
	bg1:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", scrollbar:GetWidth()-2, -scrollbar:GetWidth()-2);
	local t = bg1:CreateTexture(nil,"BACKGROUND");
	t:SetColorTexture(0, 0, 0, 1);
	t:SetAllPoints(bg1);

	local bg2 = CreateFrame("Frame", nil, self);
	self.bg2 = bg2;
	bg2:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 0);
	bg2:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", scrollbar:GetWidth()-2, -scrollbar:GetWidth()-2);
	local t = bg2:CreateTexture(nil,"BACKGROUND");
	t:SetColorTexture(0, 0, 0, 1);
	t:SetAllPoints(bg2);

	bg1:Hide();
	bg2:Hide();
	self.ShowScrollBarBackgrounds = function()
		bg1:Show();
		bg2:Show();
	end
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

function GHM_ScrollFrame_OnScrollRangeChanged(self) --, xrange, yrange)
	local scrollbarV = _G[self:GetName() .. "ScrollBar"];
	local scrollbarH = _G[self:GetName() .. "ScrollBar2"];
	local child = self:GetScrollChild();

	local xrange, yrange = 0, 0;

	if (child) then
		yrange = child:GetHeight() - self:GetHeight();
		xrange = child:GetWidth() - self:GetWidth();
	end

	local yvalue = scrollbarV:GetValue();
	if (yvalue > yrange) then
		yvalue = yrange;
	end
	local xvalue = scrollbarH:GetValue();
	if (xvalue > xrange) then
		xvalue = xrange;
	end

	local VScrollBarShown, HScrollBarShown = false, false;

	if (floor(yrange) > 0) and (yrange - yvalue > 0.005) then
		VScrollBarShown = true;
		scrollbarV:SetMinMaxValues(0, yrange);
		scrollbarV:SetValue(yvalue);
	end
	if (floor(xrange) > 0) and (xrange - xvalue > 0.005) then
		HScrollBarShown = true;
		scrollbarH:SetMinMaxValues(0, xrange);
		scrollbarH:SetValue(xvalue);
	end

	-- adjust accordingly
	AdjustScrollFrameArea(self, VScrollBarShown, HScrollBarShown);

	-- show the bars
	scrollbarV:Show();
	if VScrollBarShown then
		scrollbarV:Enable();
	else
		scrollbarV:Disable();
	end

	scrollbarH:Show();
	if HScrollBarShown then
		scrollbarH:Enable();
	else
		scrollbarH:Disable();
	end
end