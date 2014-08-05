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

	local area = CreateFrame("Frame", frame:GetName().."Area", frame)
	for i=1,#(profile) do
		local row = GHM_ToolbarObjectRow(area, main, profile[i]);

		row:SetPoint("TOP", area, "TOP", 0, -height)

		width = math.max(width, row:GetWidth());
		height = height + row:GetHeight();
	end

	area:SetHeight(height);
	area:SetWidth(width);

	-- Top spacing
	height = height + 5;

	local text = GHM_Text(frame, main, {
		text = profile.name,
		color = "yellow",
		fontSize = 11,
		align = "c",
	})
	text:ClearAllPoints();
	text:SetPoint("BOTTOM", frame, "BOTTOM", 0, 5);

	width = math.max(width + 10, text:GetWidth() + 10)

	frame:SetHeight(height + text:GetHeight() + 5);
	frame:SetWidth(width);

	area:SetPoint("CENTER", frame, "CENTER", 0, text:GetHeight()/2);

	frame:SetBackdrop({bgFile = "",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }});

	return frame;
end
