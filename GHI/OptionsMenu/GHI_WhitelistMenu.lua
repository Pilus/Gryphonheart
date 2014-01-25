--===================================================
--
--				GHI_WhitelistMenu
--				GHI_WhitelistMenu.lua
--
--	Options menu containing the whitelist for scripting
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_WhitelistMenu(parentName)
	if class then
		return class;
	end
	class = GHClass("GHI_WhitelistMenu");
	local loc = GHI_Loc()
	local parentWidth = InterfaceOptionsFramePanelContainer:GetWidth() - 20;
	local parentHeight = InterfaceOptionsFramePanelContainer:GetHeight() - 20;

	local menuFrame;
	menuFrame = GHM_NewFrame(CreateFrame("frame"), {
		onOk = function(self) end,
		{
			{
				{
					align = "c",
					type = "Text",
					text = loc.PERSONAL_SCRIPT_WHITELIST,
					fontSize = 13,
				},
			},
			{
				{
					align = "l",
					type = "Text",
					color = "white",
					text = loc.PERSONAL_WHITELIST_INFO,
					fontSize = 11,
					width = parentWidth - 20,
				},
			},
			{
				{
					align = "l",
					type = "Text",
					color = "white",
					text = loc.WHITELIST_RELOAD_WARN,
					fontSize = 11,
					width = parentWidth - 20,
				},
			},
			{
				{
					type = "EditField",
					align = "c",
					height = parentHeight - 200,
					width = parentWidth - 50,
					label = "list",
				},
			},
		},
		OnShow = function()
		end,
		title = loc.WHITELIST_TITLE,
		height = 400,
		name = "GHI_OptionsWhiteListFrame",
		theme = "BlankTheme",
		width = parentWidth,
	});

	menuFrame.name = loc.WHITELIST_TITLE;
	menuFrame.refresh = function()
		menuFrame.ForceLabel("list", strjoin("\n", unpack(GHI_MiscData["WhiteList"] or {})));
	end;
	menuFrame.okay = function()
		GHI_MiscData["WhiteList"] = { strsplit("\n", gsub(menuFrame.GetLabel("list") .. "\n", " ", "")) };
	end;
	menuFrame.parent = parentName;

	InterfaceOptions_AddCategory(menuFrame);

	class.Show = function(cat)
		InterfaceOptionsFrame_OpenToCategory(menuFrame);
	end

	return class;
end

