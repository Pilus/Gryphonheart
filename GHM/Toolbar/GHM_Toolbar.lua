--===================================================
--
--				GHM_Toolbar
--  			GHM_Toolbar.lua
--
--	     Creates toolbar with buttons
--		API:
--
--			profile[n] = a GHM object profile. n is any number
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;
function GHM_ToolbarObj(parent, main, profile)
	local frame = CreateFrame("Frame", "GHM_ToolbarObj" .. count, parent);
	count = count + 1;

	local height,width = 0,0;

	for i=1,#(profile) do
		local _height = GHM_CreateObject(i,profile[i],frame,main);
		height = math.max(height,_height);
		local obj = frame.lastLeft;
		width = width + obj:GetWidth();
	end

	frame:SetHeight(height);
	frame:SetWidth(width);

	GHM_FramePositioning(frame,profile,parent);

	return frame;
end

