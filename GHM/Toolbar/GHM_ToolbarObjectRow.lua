--
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
--

local count = 1;
function GHM_ToolbarObjectRow(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_ToolbarObjectRow" .. count, parent);
	count = count + 1;

	local height,width = 0,0;
	local objects = Linq();
	local i = profile[0] and 0 or 1;
	while type(profile[i]) == "table" do
		local obj = GHM_BaseObject(profile[i], frame, settings);
		local objWidth, objHeight = obj.GetPreferredDimensions();

		obj.SetPosition(width, 0, objWidth, objHeight);

		height = math.max(height, objHeight);
		width = width + objWidth;


		table.insert(objects, obj);
		i = i + 1;
	end

	frame.GetLabelFrame = function(label)
		return objects.Where(function(obj) return obj.GetLabel() == label; end).First();
	end

	frame:SetHeight(height);
	frame:SetWidth(width);

	return frame;
end

