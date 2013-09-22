--===================================================
--
--				GHI_DOC_CursorMarker
--  			GHI_DOC_CursorMarker.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_DOC_CursorMarker()
	if class then
		return class;
	end
	class = GHClass("GHI_DOC_CursorMarker");
	local lastUpdate = time();
	local blinkSpeed = 1;
	local frame = CreateFrame("Frame");
	frame.bg = frame:CreateTexture();
	frame.bg:SetAllPoints(frame);
	frame.bg:SetTexture(1,1,1);
	frame:SetWidth(2);
	frame:SetHeight(10);

	class.SetHeight = function(h)
		frame:SetHeight(h);
	end

	class.SetColor = function(...)
		frame.bg:SetTexture(...);
	end

	class.SetAnchor = function(parent,x,y)
		frame:SetParent(parent);
		frame:ClearAllPoints();
		frame:SetPoint("BOTTOMLEFT",x,y);
		frame:Show();
		lastUpdate = GetTime();
		frame.bg:Show();
	end

	class.Hide = function()
		frame:Hide();
	end


	frame:SetScript("OnUpdate",function()
		if (GetTime()-lastUpdate) >= (blinkSpeed/2) then
			if frame.bg:IsShown() then
				frame.bg:Hide();
			else
			   	frame.bg:Show();
			end
			lastUpdate = GetTime();
		end
	end)

	return class;
end

