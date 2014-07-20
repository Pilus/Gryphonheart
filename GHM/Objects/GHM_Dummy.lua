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
	local class = CreateFrame("Frame", "GHM_Dummy"..num, parent);



	return class;
end

