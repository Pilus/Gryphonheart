--===================================================
--
--				GHI_DebugMenu
--  			GHI_DebugMenu.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_DebugMenu(parentName)
	if class then
		return class;
	end
	class = GHClass("GHI_DebugMenu");
	local parentWidth = InterfaceOptionsFramePanelContainer:GetWidth() - 20;
	local parentHeight = InterfaceOptionsFramePanelContainer:GetHeight() - 20;
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
					height = parentHeight - 30,
					width = parentWidth - 50,
					label = "log",
				},
			},
		},
		OnShow = function()
			menuFrame.ForceLabel("log", log.ToText());
		end,
		title = loc.DEBUG_EVENT_LOG,
		height = 400,
		name = "GHI_OptionsDebugFrame",
		theme = "BlankTheme",
		width = parentWidth,
	});

	_G[menuFrame.GetLabelFrame("log"):GetName() .. "AreaScrollText"]:SetMaxLetters(50000);

	menuFrame.name = loc.DEBUG_EVENT_LOG;
	menuFrame.okay = function() end;
	menuFrame.parent = parentName;

	InterfaceOptions_AddCategory(menuFrame);

	class.Show = function(cat)
		InterfaceOptionsFrame_OpenToCategory(menuFrame);
	end

	--[[GHI_Timer(function()
		if menuFrame:IsShown() then
			menuFrame.ForceLabel("log", log.ToText());
		end
	end,1,false,"debug log update") --]]

	return class;
end

