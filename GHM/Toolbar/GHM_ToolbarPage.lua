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
function GHM_ToolbarPage(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_ToolbarPage" .. count, parent);
	count = count + 1;

	local height,width = 0,0;

	local cats = Linq();
	for i=1,#(profile) do
		local cat = GHM_ToolbarCategory(profile[i], frame, settings);
		cat:SetPoint("LEFT", cats[i-1] or frame, (cats[i-1] == nil) and "LEFT" or "RIGHT")
		height = math.max(height, cat:GetHeight());
		width = width + cat:GetWidth();
		cats[i] = cat;
	end
	for i=1,#(profile) do
		cats[i]:SetHeight(height);
	end

	frame.GetLabelFrame = function(label)
		local frame;
		cats.Foreach(function(cat)
			frame = frame or cat.GetLabelFrame(label);
		end);
		return frame;
	end

	frame:SetHeight(height);
	frame:SetWidth(width);

	return frame;
end

