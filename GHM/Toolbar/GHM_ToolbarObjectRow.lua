--===================================================
--
--				GHM_ToolbarObjectRow
--  			GHM_ToolbarObjectRow.lua
--
--		Creates toolbar with buttons
--		API:
--
--			profile[n] = a GHM object profile. n is any number
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;
function GHM_ToolbarObjectRow(parent, main, profile)
	local frame = CreateFrame("Frame", "GHM_ToolbarObjectRow" .. count, parent);
	count = count + 1;

	local height,width = 0,0;
	for i=1,#(profile) do
		local _height, obj = GHM_CreateObject(i, profile[i], frame, main);
		height = math.max(height,_height);
		width = width + obj:GetWidth();
	end

	frame:SetHeight(height);
	frame:SetWidth(width);

	return frame;
end

