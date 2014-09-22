--===================================================
--
--				GHM_Dummy
--  			GHM_Dummy.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local num = 0;
function GHM_Dummy(profile, parent, settings)
	num = num + 1;
	local obj = CreateFrame("Frame", "GHM_Dummy"..num, parent);

	obj.GetPreferredDimensions = profile.GetPreferredDimensions or function()
		return profile.width, profile.height;
	end

	--GHM_TempBG(obj);
	return obj;
end

