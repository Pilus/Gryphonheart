--===================================================
--
--				GHM_PlayButton
--  			GHM_PlayButton.lua
--
--	          (description)
--
-- 	  (c)2014 The Gryphonheart Team
--			All rights reserved
--===================================================
local num = 0;
function GHM_PlayButton(profile, parent, settings)
	num = num + 1;
	local obj = CreateFrame("Button", "GHM_PlayButton"..num, parent, "GHM_PlayButton_Template");

	if type(profile.onclick) == "function" then
		obj:SetScript("OnClick", profile.onclick);
	end

	return obj;
end

