--===================================================
--
--				GH_DebugMenu
--  			GH_DebugMenu.lua
--
--	Menu showing a code field for copying of debug output.
--  Usage:  GHI_MenuList("GH_DebugMenu").New("debug text");
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local menuIndex = 0;
function GH_DebugMenu()
	local class = GHClass("GH_DebugMenu");
	menuIndex = menuIndex + 1;

	local menuFrame,inUse,editField;

	class.New = function(text)
		inUse = true;
		menuFrame.ForceLabel("code", text);
		menuFrame:AnimatedShow();
	end

	class.IsInUse = function()
		return inUse;
	end

	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				{
					type = "CodeField",
					height = 430,
					text = "",
					width = 780,
					label = "code",
					align = "c",
				},
			},
		},
		title = "Debug",
		name = "DebugMenu" .. menuIndex,
		theme = "BlankTheme",
		width = 800,
		useWindow = true,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	});
	editField = menuFrame.GetLabelFrame("code").field;

	return class;

end

