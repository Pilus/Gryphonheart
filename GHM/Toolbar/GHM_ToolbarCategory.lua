--===================================================
--
--				GHM_ToolbarCategory
--  			GHM_ToolbarCategory.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;
function GHM_ToolbarCategory(parent, main, profile)
	local frame = CreateFrame("Frame", "GHM_ToolbarCategory" .. count, parent);
	count = count + 1;

	local height,width = 0,0;

	for i=1,#(profile) do
		local row = GHM_ToolbarObjectRow(frame, main, profile[i]);

		row:SetPoint("TOP","TOP", 0, height)

		width = math.max(width, row:GetWidth());
		height = height + row:GetHeight();
	end

	local h, text = GHM_Text(frame, main, {
		text = profile.name,
		align = "c",
	})
	text:ClearAllPoints();
	text:SetPoint("BOTTOM","BOTTOM");

	frame:SetHeight(height);
	frame:SetWidth(width);

	GHM_FramePositioning(frame,profile,parent);

	return frame;
end
