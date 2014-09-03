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

function GHI_MapDisplayer(width, height)
	local scrollFrame = CreateFrame("ScrollFrame");

	scrollFrame:SetWidth(width);
	scrollFrame:SetHeight(height);

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

	mapFrame:SetHeight(mapH);
	mapFrame:SetWidth(mapW);

	local SetCenter = function(x, y)
		local scale = mapFrame:GetScale();
		--print("Set", scale)
		scrollFrame:SetVerticalScroll(x - (width / 2) );
		scrollFrame:SetHorizontalScroll(y - (width / 2) );
	end
	--AA = SetCenter;

	local GetCenter = function()
		local scale = mapFrame:GetScale();
		--print("Get",scale)
		local x = scrollFrame:GetVerticalScroll() + (width / 2);
		local y = scrollFrame:GetHorizontalScroll() + (width / 2) ;
		return x, y;
	end

	local SetScale = function(scale)
		--local cx, cy = GetCenter();
		mapFrame:SetScale(scale);
		--SetCenter(cx, cy);
	end

	scrollFrame:SetScript("OnMouseWheel",function(self, dir)
		local scale = mapFrame:GetScale();
		local newScale = scale + scale*0.1*dir;
		SetScale(newScale);
	end)

	scrollFrameButtonOverlay:RegisterForDrag("LeftButton")
	scrollFrameButtonOverlay:SetScript("OnDragStart", function(b) b.drag = true end)
	scrollFrameButtonOverlay:SetScript("OnDragStop", function(b) b.drag = false; b.prev = nil; end)
	scrollFrameButtonOverlay:SetScript("OnUpdate", function(b)
		if b.drag then
			local _x, _y = GetCursorPosition();
			local s = b:GetEffectiveScale();

			local x, y = _x / s, _y / s;

			if b.prev then
				local prevX, prevY = unpack(b.prev);
				local dX, dY = x - prevX, y - prevY;

				local scale = mapFrame:GetScale();
				scrollFrame:SetHorizontalScroll(scrollFrame:GetHorizontalScroll() - dX/scale);
				scrollFrame:SetVerticalScroll(scrollFrame:GetVerticalScroll() + dY/scale);

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