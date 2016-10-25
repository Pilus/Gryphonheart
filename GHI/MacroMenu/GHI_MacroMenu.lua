--
--
--				GHI_MacroMenu
--  			GHI_MacroMenu.lua
--
--		Menu for creation of GHI macros
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--
local count = 1;

function GHI_MacroMenu()
	local api = GHI_ContainerAPI().GetAPI()
	local loc = GHI_Loc()

	local class = GHClass("GHI_MacroMenu");
	local menuFrame
	local macroIcon, itemGUID, itemName
	local inUse = false;
	
	local OnOkay = function()
	  
		local macroBody = menuFrame.GetLabel("macro")
		local name = menuFrame.GetLabel("macroName")

		if string.find(macroIcon,[[Interface\Icons\]]) then
			local iconPath = string.gsub(macroIcon,[[Interface\Icons\]],[[]]);
			macroIcon = string.format([["%s"]],iconPath);
			CreateMacro(name, iconPath, macroBody, true)
			menuFrame:Hide()
			inUse = false
		else
			print(loc.MACRO_MENU_ERROR)
		end
	end
	
	local SetupWithNewMacro = function()
		inUse = true;
		edit = false;
		menuFrame.ForceLabel("item",nil)
		menuFrame.ForceLabel("icon",nil)
		menuFrame.ForceLabel("macroName",nil)
		menuFrame.ForceLabel("macro",nil)
	end
	
	menuFrame = GHM_NewFrame("ItemMacroWindow",{
		{
			{
				{
					type = "Text",
					fontSize = 14,
					text = loc.MACRO_MENU_TEXT,
					align = "l",
					width = 400,
				},
			},
			{
				{
					type = "Item",
					text = loc.ATTYPE_ITEM,
					align = "l",
					label = "item",
					texture = "Tooltip",
					OnSetItem = function(guid)
						itemGUID = guid
						local originalText = menuFrame.GetLabel("macro")
						local newText = originalText.."/script GHI_UseItem(\""..guid.."\")"
						menuFrame.ForceLabel("macro",newText)
						local itemName = api.GHI_GetItemInfo(guid)
						menuFrame.ForceLabel("macroName",itemName)
					end,
				},
				{
					type = "Icon",
					text = loc.ICON,
					align = "r",
					xOff = -15,
					label = "icon",
					framealign = "r",
					CloseOnChoosen = true,
					OnChanged = function(icon)
						macroIcon = icon
					end
				},
			},
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.NAME;
					label = "macroName",
					texture = "Tooltip",
					width = 200,
				},
			},
			{
				{
					align = "l",
					type = "EditField",
					text = loc.MACRO_MENU_MACRO,
					width = 440,
					height = 150,
					label = "macro",
					texture = "Tooltip",
				},
			},
			{
				{
					type = "Dummy",
					height = 10,
					width = 100,
					align = "l",
				},
				{
					type = "Button",
					text = OKAY,
					align = "l",
					label = "ok",
					compact = false,
					OnClick = OnOkay,
				},
				{
					type = "Dummy",
					height = 10,
					width = 100,
					align = "r",
				},
				{
					type = "Button",
					text = CANCEL,
					align = "r",
					label = "cancel",
					compact = false,
					OnClick = function(obj)
					menuFrame:Hide();
					end,
				},
			},
		},
		title = loc.MACRO_CREATE_MACRO,
		name = "GHI_MacroFrame"..count,
		theme = "BlankTheme",
		width = 450,
		height = 375,
		useWindow = true,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	  }
	);
	menuFrame:Hide()
	count = count + 1
	
	class.IsInUse = function()
		return inUse and menuFrame.window:IsShown()
	end

	class.New = function()
		menuFrame:AnimatedShow();
		SetupWithNewMacro();
	end
	
	return class
end