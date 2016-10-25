--
--
--				GHM_NewFrame
--  			GHM_NewFrame.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHM_NewFrame(owner, profile)
	local theme = profile.theme or "StdTheme";

	if theme == "WizardTheme" or theme == "BlankWizardTheme" then
		return GHM_WizardMenu(owner, profile);
	elseif theme == "BlankTheme" and not(profile.useWindow) then
		return GHM_BaseMenu(owner, profile);
	elseif theme == "TabTheme" then
		return GHM_TabMenu(owner, profile);
	elseif theme == "StdTheme" or not(theme) or profile.useWindow then
		return GHM_WindowedMenu(owner, profile);
	else
		error("GHM Menu theme "..theme.." is not supported.");
	end
end

