--
--
--				GHM_ToolbarCategory
--  			GHM_ToolbarCategory.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local count = 1;
function GHM_ToolbarCategory(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_ToolbarCategory" .. count, parent);
	count = count + 1;

	local height,width = 0,0;
	local rows = Linq();

	local area = CreateFrame("Frame", frame:GetName().."Area", frame)
	local i = profile[0] and 0 or 1;
	while type(profile[i]) == "table" do
		local row = GHM_ToolbarObjectRow(profile[i], area, settings);

		row:SetPoint("TOP", area, "TOP", 0, -height)

		width = math.max(width, row:GetWidth());
		height = height + row:GetHeight();
		table.insert(rows, row);
		i = i + 1;
	end

	area:SetHeight(height);
	area:SetWidth(width);

	-- Top spacing
	height = height + 5;

	local text = GHM_Text({
		text = profile.name,
		color = "yellow",
		fontSize = 11,
		align = "c",
	}, frame, {})
	text:ClearAllPoints();
	text:SetPoint("BOTTOM", frame, "BOTTOM", 0, 5);

	local frameWidth = math.max(width + 10, text:GetWidth() + 10)

	frame:SetHeight(height + text:GetHeight() + 5);
	frame:SetWidth(frameWidth);

	area:SetPoint("LEFT", frame, "LEFT", (frameWidth - width) / 2, text:GetHeight()/2);

	frame:SetBackdrop({bgFile = "",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }});

	frame.GetLabelFrame = function(label)
		local frame;
		rows.Foreach(function(row)
			frame = frame or row.GetLabelFrame(label);
		end);
		return frame;
	end

	return frame;
end
