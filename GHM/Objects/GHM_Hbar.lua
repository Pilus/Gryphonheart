--===================================================
--
--				GHM_Hbar
--  			GHM_Hbar.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local num = 0;
function GHM_HBar(profile, parent, settings)
	num = num + 1;
	local obj = CreateFrame("Frame", "GHM_HBar"..num, parent, "GHM_HBar_Template");

	obj:SetWidth(profile.width or 40);

	obj.GetPreferredDimensions = function()
		return profile.width, profile.height or obj:GetHeight();
	end

	obj:Show();
	return obj;
end

