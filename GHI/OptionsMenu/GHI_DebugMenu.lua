--===================================================
--
--				GHI_DebugMenu
--  			GHI_DebugMenu.lua
--
--	Options menu showing the debug log
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_DebugMenu(parentName)
	if class then
		return class;
	end
	class = GHClass("GHI_DebugMenu");
	local loc = GHI_Loc();
	local log = GHI_Log();

	local menuFrame;
	menuFrame = GHM_NewFrame(CreateFrame("frame"), {
		onOk = function(self) end,
		{
			{
				{
					align = "c",
					type = "Text",
					text = loc.DEBUG_EVENT_LOG,
					fontSize = 11,
				},
			},
			{
				{
					type = "EditField",
					align = "c",
					label = "log",
				},
			},
		},
		OnShow = function()
			menuFrame.ForceLabel("log", log.ToText());
		end,
		title = loc.DEBUG_EVENT_LOG,
		lineSpacing = 10,
		name = "GHI_OptionsDebugFrame",
		theme = "BlankTheme",
		width = InterfaceOptionsFramePanelContainer:GetWidth(),
		height = InterfaceOptionsFramePanelContainer:GetHeight(),
	});

	_G[menuFrame.GetLabelFrame("log"):GetName() .. "AreaScrollText"]:SetMaxLetters(50000);

	menuFrame.name = loc.DEBUG_EVENT_LOG;
	menuFrame.okay = function() end;
	menuFrame.parent = parentName;

	InterfaceOptions_AddCategory(menuFrame);

	class.Show = function(cat)
		InterfaceOptionsFrame_OpenToCategory(menuFrame);
	end

	return class;
end

