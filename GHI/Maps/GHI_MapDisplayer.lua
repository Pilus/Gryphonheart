--===================================================
--
--				GHI_MapDisplayer
--  			GHI_MapDisplayer.lua
--
--	 Frame for displaying maps at a given coordinate,
--   with given extra map elements.
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local AZEROTH_WIDTH = 14545.7650;
local AZEROTH_HEIGHT = 9697.1767;

function GHI_MapDisplayer(width, height)
	local scrollFrame = CreateFrame("ScrollFrame");

	scrollFrame:SetWidth(width);
	scrollFrame:SetHeight(height);

	local scaleLimit = math.max(width / AZEROTH_WIDTH, height / AZEROTH_HEIGHT);

	local scrollFrameButtonOverlay = CreateFrame("Button");
	scrollFrameButtonOverlay:SetParent(scrollFrame);
	scrollFrameButtonOverlay:SetAllPoints(scrollFrame);

	local GenerateTexture = function(frame,width,height,x,y,texCoord,path)
		local texture = frame:CreateTexture(nil,"BACKGROUND")
		texture:SetWidth(width);
		texture:SetHeight(height);
		texture:SetTexCoord(unpack(texCoord));
		texture:SetPoint("TOPLEFT", x,y);
		texture:SetTexture(path);
		texture:Show();
	end

	local mapFrame = CreateFrame("Frame","$parentMap",scrollFrame);
	scrollFrame:SetScrollChild(mapFrame);

	local mapH,mapW = 0,0;
	local mapData = Linq(GHI_MapData).OrderBy(function(p1, p2) return p1.order < p2.order; end);

	for index,t in pairs(mapData) do
		GenerateTexture(mapFrame, t.width, t.height, t.x, t.y, t.texCoord, t.path);
		mapW = math.max(mapW, t.x + t.width);
		mapH = math.max(mapH, -t.y + t.height);
	end

	mapFrame:SetHeight(AZEROTH_HEIGHT);
	mapFrame:SetWidth(AZEROTH_WIDTH);

	local SetMapCoordinatesForPosition = function(posX, posY, mapX, mapY)
		local scale = mapFrame:GetScale();
		scrollFrame:SetHorizontalScroll(math.max(0, math.min(AZEROTH_WIDTH - width/scale, mapX - posX/scale)));
		scrollFrame:SetVerticalScroll(math.max(0, math.min(AZEROTH_HEIGHT - height/scale, mapY - posY/scale)));
	end

	local SetCenter = function(x, y)
		SetMapCoordinatesForPosition(width / 2, height / 2, x, y);
	end

	local GetMapCoordinatesForPosition = function(posX, posY)
		local scale = mapFrame:GetScale();
		local x = scrollFrame:GetHorizontalScroll() + posX / scale;
		local y = scrollFrame:GetVerticalScroll() + posY / scale;
		return x, y;
	end

	local GetCenter = function()
		return GetMapCoordinatesForPosition(width / 2, height / 2);
	end

	local GetMousePositionOnMap = function()
		local x, y = GetCursorPosition();
		local s = scrollFrameButtonOverlay:GetEffectiveScale();
		local yTop = (UIParent:GetHeight() - scrollFrameButtonOverlay:GetTop()) - y;
		return (x / s) - scrollFrameButtonOverlay:GetLeft(), -((y / s) - scrollFrameButtonOverlay:GetTop());
	end

	local SetScale = function(scale)
		local cx, cy = GetCenter();
		mapFrame:SetScale(scale);
		SetCenter(cx, cy);
	end

	scrollFrame:SetScript("OnMouseWheel",function(self, dir)
		local cursorX, cursorY = GetMousePositionOnMap();
		local mapX, mapY = GetMapCoordinatesForPosition(cursorX, cursorY);
		local scale = mapFrame:GetScale();
		local newScale = scale + scale*0.1*dir;
		mapFrame:SetScale(math.max(scaleLimit, newScale));
		SetMapCoordinatesForPosition(cursorX, cursorY, mapX, mapY);
	end)

	scrollFrameButtonOverlay:RegisterForDrag("LeftButton")
	scrollFrameButtonOverlay:SetScript("OnDragStart", function(b) b.drag = true end)
	scrollFrameButtonOverlay:SetScript("OnDragStop", function(b) b.drag = false; b.prev = nil; end)
	scrollFrameButtonOverlay:SetScript("OnUpdate", function(b)
		if b.drag then
			local x, y = GetMousePositionOnMap();

			if b.prev then
				local prevX, prevY = unpack(b.prev);
				local dX, dY = x - prevX, y - prevY;

				local scale = mapFrame:GetScale();
				scrollFrame:SetHorizontalScroll(math.max(0, math.min(AZEROTH_WIDTH - width/scale, scrollFrame:GetHorizontalScroll() - dX/scale)));
				scrollFrame:SetVerticalScroll(math.max(0, math.min(AZEROTH_HEIGHT - height/scale, scrollFrame:GetVerticalScroll() - dY/scale)));
			end

			b.prev = {x, y};
		end
	end)

	mapFrame:SetScale(0.1);
	scrollFrame:SetVerticalScroll(1000)
	scrollFrame:SetHorizontalScroll(1000)

	return scrollFrame;
end

-- /script