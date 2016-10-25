--
--
--				GHM_ToolbarPage
--  			GHM_ToolbarPage.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local count = 1;
function GHM_ToolbarPage(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_ToolbarPage" .. count, parent);
	count = count + 1;

	local height,width = 0,0;

	local cats = Linq();

	local i = profile[0] and 0 or 1;
	while type(profile[i]) == "table" do
		local cat = GHM_ToolbarCategory(profile[i], frame, settings);
		cat:SetPoint("TOPLEFT", cats[i-1] or frame, (cats[i-1] == nil) and "TOPLEFT" or "TOPRIGHT");

		if i == #(profile) then
			cat:SetPoint("TOPRIGHT", frame, "TOPRIGHT");
		end

		height = math.max(height, cat:GetHeight());
		width = width + cat:GetWidth();
		cats[i] = cat;

		cats[i]:SetHeight(height);
		i = i + 1;
	end

	frame.GetLabelFrame = function(label)
		local frame;
		cats.Foreach(function(cat)
			frame = frame or cat.GetLabelFrame(label);
		end);
		return frame;
	end

	frame.SetPosition = function(xOff, yOff, width, height)
		frame:SetWidth(width);
		frame:SetHeight(height);
		frame:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, -yOff);
		for i=1,#(profile) do
			cats[i]:SetHeight(height);
		end
	end

	frame:SetHeight(height);
	frame:SetWidth(width);

	return frame;
end

