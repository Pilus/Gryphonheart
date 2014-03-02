--===================================================
--
--				GHM_ToolbarPage
--  			GHM_ToolbarPage.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;
function GHM_ToolbarPage(parent, main, profile)
	local frame = CreateFrame("Frame", "GHM_ToolbarPage" .. count, parent);
	count = count + 1;

	local height,width = 0,0;

	local prevRow;
	for i=1,#(profile) do
		local row = GHM_ToolbarCategory(frame, main, profile[i]);
		row:SetPoint("TOP", prevRow or frame, (prevRow == nil) and "TOP" or "BOTTOM")
		width = math.max(width, row:GetWidth());
		height = height + row:GetHeight();
		prevRow = row;
	end

	local h, text = GHM_Text(frame, main, {
		text = profile.name,
		align = "c",
	})
	text:ClearAllPoints();
	text:SetPoint("BOTTOM","BOTTOM");
	height = height + text:GetHeight();

	frame:SetHeight(height);
	frame:SetWidth(width);

	GHM_FramePositioning(frame,profile,parent);

	return frame;
end

