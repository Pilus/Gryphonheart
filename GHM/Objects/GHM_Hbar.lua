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

	return obj;
end

