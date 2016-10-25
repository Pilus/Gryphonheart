--
--
--		GHI_MenuAppearanceOptionsMenu
--		GHI_MenuAppearanceOptionsMenu.lua
--
--	Options menu for the appearance of GHM menus
--
--	(c)2013 The Gryphonheart Team
--			All rights reserved
--
local loc = GHI_Loc();

local PREDEFINED_THEMES = {
	{
		guid = "001",
		name = loc.THEME_2_0,
		background = "Interface\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains.blp",
		titleBar = { 0.5, 0.1, 0.1, 1 },
		titleBarTextColor = { 1, 1, 1, 1 },
		backgroundColor = { 1, 1, 1, 0.5 },
		buttonColor = { 0.5, 0.1, 0.1, 1 },
		mainTextColor = { 1.0, 0.82, 0.0, 1 },
		detailsTextColor = { 1.0, 1.0, 1.0, 1 },
	},
	{
		guid = "002",
		name = loc.CLASSIC_THEME,
		background = "Interface\\DialogFrame\\UI-DialogBox-Background.blp",
		titleBar = { 0.5, 0.1, 0.1, 1 },
		titleBarTextColor = { 1, 1, 1, 1 },
		backgroundColor = { 0.3, 0.3, 0.3, 0.5 },
		buttonColor = { 0.5, 0.1, 0.1, 1 },
		mainTextColor = { 1.0, 0.82, 0.0, 1 },
		detailsTextColor = { 1.0, 1.0, 1.0, 1 },
	},
}

local BACKGROUNDS = {
	{ p = "", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains.blp", x = 256, y = 256, },
	{ p = "Interface\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_matte.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_BLOODELF\\rg_jlo_BloodElf_DoorTrim_01.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_BLOODELF\\RG_MM_CLOUDS_03.blp", x = 256, y = 256 },
	{ p = "Interface\\DressUpFrame\\DressUpBackground-BloodElf1.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_CharacterSelect\\UI_CharactersClouds.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_DeathKnight\\IceCrown_Clouds_Unholy01.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_DeathKnight\\deathknight_floorskulls.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_DRAENEI\\draenei_platform_crystal.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Draenei\\rg_jlo_Draenei_window_03.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Dwarf\\dwarfsky.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Dwarf\\snow.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Human\\caustic02.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Human\\MM_clouds_03.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Human\\MM_sky_02.blp", x = 256, y = 256, blend = "DISABLE", },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\DarkPortal_platform_01.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\DarkPortal_stone_01.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\DarkPortal_trim_01.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\DurotarRock03.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\MM_clouds_01.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\MM_sky_01.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\mm_thorns_01.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\swordgradient.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\SWORDGRADIENT2.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MainMenu_BurningCrusade\\dp_Lightning2.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MainMenu_BurningCrusade\\dp_Lightning2b.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MainMenu_BurningCrusade\\dp_nebula.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\aa_moonwell_glow.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\aa_NE_clouds.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\aa_NE_ground.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\aa_NE_sky.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\caustic01.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\causticblend.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\KalidarMidTree_purple01.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Tauren\\sky1.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Goblin\\UI_Goblin_sky.blp", x = 256, y = 256 },
	{ p = "Interface\\DialogFrame\\UI-DialogBox-Background.blp", x = 64, y = 64 },
	{ p = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background.blp", x = 64, y = 64 },
	{ p = "Interface\\AchievementFrame\\UI-Achievement-AchievementBackground.blp", x = 512, y = 512 },
	{ p = "Interface\\AchievementFrame\\UI-Achievement-StatsBackground.blp", x = 512, y = 512 },
	{ p = "Interface\\FullScreenTextures\\LowHealth.blp", x = 256, y = 256 },
	{ p = "Interface\\FullScreenTextures\\OutOfControl.blp", x = 256, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU_CATACLYSM\\UI_strmwnd_lavawall01_nite.blp", x = 256, y = 256 },
	{ p = "Interface\\Lfgframe\\ui-lfg-background-brew.blp", x = 256, y = 256 },
}

local class;
function GHI_MenuAppearanceOptionsMenu(parentName)

	if class then
		return class;
	end
	
	class = GHClass("GHI_MenuAppearanceOptionsMenu");
	GHI_MiscData = GHI_MiscData or {};

	local themes = GHI_MiscData.UI_Themes or {};

	local GetNumPredefinedThemes = function()
		return #(PREDEFINED_THEMES);
	end

	local GetNumThemes = function()
		themes = GHI_MiscData.UI_Themes or {};
		return #(PREDEFINED_THEMES) + #(themes) + 1;
	end
	
	local GetThemeInfo = function(i)
		if i > #(PREDEFINED_THEMES) + #(themes) then
			return "<"..loc.NEW_THEME..">";
		elseif i > #(PREDEFINED_THEMES) then
			local theme = themes[i - #(PREDEFINED_THEMES)];
			return theme.name, theme.guid, theme;
		else
			local theme = PREDEFINED_THEMES[i];
			return theme.name, theme.guid, theme;
		end
	end

	local menuFrame;
	local colorsFrame;
	local SaveTheme;
	local DeleteTheme;

	local LoadTheme = function(themeI)
		local theme;
		local isThemeUnsaved = false;
		if themeI > #(PREDEFINED_THEMES) + #(themes) then
			return;
		elseif themeI > #(PREDEFINED_THEMES) then
			theme = themes[themeI - #(PREDEFINED_THEMES)];
		elseif themeI > 0 then
			theme = PREDEFINED_THEMES[themeI];
		elseif type(themes.Current) == "table" then
			theme = themes.Current;
			isThemeUnsaved = true;
			themeI = GetNumThemes();
		elseif type(themes.Current) == "string" then
			for i = 1, GetNumThemes() do
				local _, guid, loadedTheme = GetThemeInfo(i);
				if guid == themes.Current then
					theme = loadedTheme;
					themeI = i;
				end
			end
		end
		
		if not (theme) then
			theme = PREDEFINED_THEMES[1];
			themeI = 1;
		end

		if isThemeUnsaved then
			menuFrame.ForceLabel("preset", GetNumThemes())
		else
			menuFrame.ForceLabel("preset", themeI);
		end

		local _, lastLoaded = GetThemeInfo(themeI);
		menuFrame.lastLoaded = lastLoaded;
		menuFrame.ForceLabel("background", theme.background or "");
		menuFrame.ForceLabel("titleBar" , theme.titleBar)
		menuFrame.ForceLabel("titleBarTextColor" , theme.titleBarTextColor)
		menuFrame.ForceLabel("backgroundColor" , theme.backgroundColor)
		menuFrame.ForceLabel("buttonColor" , theme.buttonColor)
		menuFrame.ForceLabel("mainTextColor" , theme.mainTextColor)
		menuFrame.ForceLabel("detailsTextColor" , theme.detailsTextColor)
	end	
				
	local t = {
		onOk = function(self) end,
		{
			{
				{
					align = "c",
					type = "Text",
					text = loc.MENU_APPEARANCE,
					fontSize = 13,
				},
			},
			{
				{
					align = "l",
					type = "Text",
					color = "white",
					text = loc.MENU_APPEARANCE_TEXT,
					fontSize = 11,
				},
			},
			{
				{
					type = "DropDown",
					text = loc.PRESET_THEME,
					align = "l",
					label = "preset",
					width = 130,
					returnIndex = true,
					dataFunc = function()
						local t = {};
						for i = 1, GetNumThemes() do
							local name = GetThemeInfo(i);
							t[i] = name;
						end
						return t;
					end,
					OnSelect = function(i)
						if menuFrame then
							local save = menuFrame.GetLabelFrame("save")
							local delete = menuFrame.GetLabelFrame("delete")
							local load = menuFrame.GetLabelFrame("load")
							if i <= GetNumPredefinedThemes() then
								save:Disable();
								delete:Disable();
								load:Enable()
							elseif i < GetNumThemes() then
								save:Enable();
								delete:Enable();
								load:Enable()
							else
								save:Enable();
								delete:Disable();
								load:Enable()
							end
						end
					end,
				},
				{
					type = "Button",
					text = loc.LOAD_THEME,
					align = "l",
					compact = false,
					yOff = 0,
					OnClick = function(obj)
						local i = menuFrame.GetLabel("preset");
						LoadTheme(i);
					end,
					label = "load",
				},
				{
					height = 10,
					type = "Dummy",
					align = "l",
					width = 10,
				},
				{
					type = "Button",
					text = loc.SAVE_THEME,
					align = "l",
					compact = false,
					OnClick = function(obj)
						local i = menuFrame.GetLabel("preset");
						SaveTheme(i);
					end,
					label = "save",
				},
				{
					height = 10,
					type = "Dummy",
					align = "l",
					width = 10,
				},
				{
					type = "Button",
					text = loc.DELETE_THEME,
					align = "l",
					compact = false,
					OnClick = function(obj)
						local i = menuFrame.GetLabel("preset");
						DeleteTheme(i);
					end,
					label = "delete",
				},
			},
			{
				{
					align = "l",
					type = "CheckBox",
					text = loc.ANIMATION,
					label = "useAnimation",
					width = 200,
				},
			},
			{
				{
					align = "r",
					type = "Text",
					text = loc.MENU_WINDOW_COLORS,
					fontSize = 10,
				},
				{
					type = "Button",
					text = loc.MENU_UNIFY_TEXT,
					align = "r",
					compact = true,
					tooltip = loc.MENU_UNIFY_TEXT_TT,
					OnClick = function(obj)
						local unifiedColors = menuFrame.GetLabel("mainTextColor")
						menuFrame.ForceLabel("titleBarTextColor",unifiedColors)
						menuFrame.ForceLabel("detailsTextColor",unifiedColors)
					end,
				},
				{
					type = "Button",
					text = loc.MENU_UNIFY_WINDOW,
					align = "r",
					compact = true,
					tooltip = loc.MENU_UNIFY_WINDOW_TT,
					xOff = -10,
					OnClick = function(obj)
						local unifiedColors = menuFrame.GetLabel("titleBar")
						menuFrame.ForceLabel("backgroundColor",unifiedColors)
						menuFrame.ForceLabel("buttonColor",unifiedColors)
					end,
				},
			},
			{
				{
					type = "HBar",
					align = "c",
				},
			},
			{
				{
					alight = "l",
					type = "Color",
					text = loc.TITLE_BAR_COLOR,
					label = "titleBar",
					tooltip = loc.TITLE_BAR_COLOR_TT,
					returnIndexTable = true,
					OnChanged = function()
						OnColor()
					end
				},
				{
					alight = "l",
					type = "Color",
					text = loc.TITLE_BAR_TEXT_COLOR,
					label = "titleBarTextColor",
					tooltip = loc.TITLE_BAR_TEXT_COLOR_TT,
					returnIndexTable = true,
					OnChanged = function()
						OnColor()
					end
				},
				{
					alight = "l",
					type = "Color",
					text = loc.BACKGROUND_COLOR,
					label = "backgroundColor",
					tooltip = loc.BACKGROUND_COLOR_TT,
					returnIndexTable = true,
					OnChanged = function()
						OnColor()
					end
				},
			},
			{
				{
					alight = "l",
					type = "Color",
					text = loc.BUTTON_COLOR,
					label = "buttonColor",
					tooltip = loc.BUTTON_COLOR_TT,
					returnIndexTable = true,
					OnChanged = function()
						OnColor()
					end
				},
				{
					alight = "l",
					type = "Color",
					text = loc.MAIN_TEXT_COLOR,
					label = "mainTextColor",
					tooltip = loc.MAIN_TEXT_COLOR_TT,
					returnIndexTable = true,
					OnChanged = function()
						OnColor()
					end
				},
				{
					alight = "l",
					type = "Color",
					text = loc.DETAILS_TEXT_COLOR,
					label = "detailsTextColor",
					tooltip = loc.DETAILS_TEXT_COLOR_TT,
					returnIndexTable = true,
					OnChanged = function()
						OnColor()
					end
				},
			},
			{
				{
					type = "HBar",
					align = "c",
				},
			},
			{
				{
					type = "ImageList",
					align = "l",
					label = "background",
					text = loc.BACKGROUND,
					data = BACKGROUNDS,
					sizeX = 70,
					OnSelect = function(self, path)
						local i = menuFrame.GetLabel("preset");
						if i <= GetNumPredefinedThemes() then
							menuFrame.ForceLabel("preset", GetNumThemes())
						end
					end
				}
			},
			{
				{
					align = "l",
					type = "Text",
					color = "white",
					text = loc.MENU_WARN_RELOG,
					fontSize = 11,
				},
			},
		},
		OnShow = function()
		end,
		title = loc.MENU_APPEARANCE,
		width = InterfaceOptionsFramePanelContainer:GetWidth(),
		height = InterfaceOptionsFramePanelContainer:GetHeight(),
		lineSpacing = 10,
		name = "GHI_OptionsMenuAppearanceFrame",
		theme = "BlankTheme",
	}

	menuFrame = GHM_NewFrame(CreateFrame("frame"), t)

	local OnColor = function()
		local i = menuFrame.GetLabel("preset");
		if i <= GetNumPredefinedThemes() then
			menuFrame.ForceLabel("preset", GetNumThemes())
		end
	end;

	menuFrame.GetLabelFrame("background").SetImages(BACKGROUNDS);

	local AreTablesIdentical;
	AreTablesIdentical = function(t1, t2)
		if not (type(t1) == "table") or not (type(t2) == "table") then
			return false;
		end
		for i, value in pairs(t1) do
			if type(value) == "table" then
				if not (AreTablesIdentical(value, t2[i] or {})) then
					return false;
				end
			else
				if not (value == t2[i]) then
					return false;
				end
			end
		end
		for i, value in pairs(t2) do
			if not (t1[i]) then
				if type(value) == "table" then
					if not (AreTablesIdentical(value, t1[i] or {})) then
						return false;
					end
				else
					if not (value == t1[i]) then
						return false;
					end
				end
			end
		end
		return true;
	end

	DeleteTheme = function(index)
		if index and index < GetNumThemes() and index > GetNumPredefinedThemes() then
			table.remove(GHI_MiscData.UI_Themes, index - GetNumPredefinedThemes());
			menuFrame.ForceLabel("preset", index)
		end
	end

	SaveTheme = function(index)
			
		local newCurrent = {
			background = menuFrame.GetLabel("background"),
			titleBar = menuFrame.GetLabel("titleBar"),
			titleBarTextColor = menuFrame.GetLabel("titleBarText"),
			backgroundColor = menuFrame.GetLabel("backgroundColor");
			buttonColor = menuFrame.GetLabel("buttonColor"),
			mainTextColor = menuFrame.GetLabel("mainTextColor"),
			detailsTextColor = menuFrame.GetLabel("detailsTextColor"),
		}
		
		if index and index < GetNumThemes() and index > GetNumPredefinedThemes() then
			local name, guid = GetThemeInfo(index);
			newCurrent.name = name;
			newCurrent.guid = guid;
			GHI_MiscData.UI_Themes[index - GetNumPredefinedThemes()] = newCurrent;
			return
		end
		
		StaticPopupDialogs["GHI_NAME_THEME"] = {
			text = loc.THEME_NAME,
			button1 = OKAY,
			button2 = CANCEL,
			OnAccept = function(self)
				newCurrent.name = self.editBox:GetText();
				newCurrent.guid = GHI_GUID().MakeGUID();
				GHI_MiscData.UI_Themes[index - GetNumPredefinedThemes()] = newCurrent;
				menuFrame.ForceLabel("preset", index)
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			hasEditBox = true,
		}
		StaticPopup_Show("GHI_NAME_THEME");
	end

	local ApplyTheme = function()
		local background = menuFrame.GetLabel("background");
		local titleBarColor = menuFrame.GetLabel("titleBar");
		local titleBarTextColor = menuFrame.GetLabel("titleBarTextColor");
		local backgroundColor = menuFrame.GetLabel("backgroundColor");
		--local alpha = menuFrame.GetLabel("bg_alpha")
		--table.insert(backgroundColor,alpha)
		local buttonColor = menuFrame.GetLabel("buttonColor")
		local mainTextColor = menuFrame.GetLabel("mainTextColor")
		local detailsTextColor = menuFrame.GetLabel("detailsTextColor")
		

		local presetGuid = menuFrame.lastLoaded;
	
		GHM_SetBackground(background);
		GHM_SetTitleBarColor(unpack(titleBarColor));
		GHM_SetTitleBarTextColor(unpack(titleBarTextColor));
		GHM_SetBackgroundColor(unpack(backgroundColor));
		GHM_SetButtonColor(unpack(buttonColor));
		GHM_SetHeadTextColor(unpack(mainTextColor));
		GHM_SetDetailsTextColor(unpack(detailsTextColor));

		local newCurrent = {
			background = background,
			titleBar = titleBarColor,
			titleBarTextColor = titleBarTextColor,
			backgroundColor = backgroundColor,
			buttonColor = buttonColor,
			mainTextColor = mainTextColor,
			detailsTextColor = detailsTextColor,
		}

		for i = 1, GetNumThemes() do
			local name, guid, loadedTheme = GetThemeInfo(i);
			if guid == presetGuid then
				newCurrent.guid = guid;
				newCurrent.name = name;
				if AreTablesIdentical(newCurrent, loadedTheme) == true then
					newCurrent = guid;
				end
			end
		end

		themes.Current = newCurrent;

		GHI_MiscData.UI_Themes = themes;
        GHI_Timer(GHM_UpdateThemedObject,0,true); -- run this in another thread to allow errors
	end
	LoadTheme(0);
	ApplyTheme();

	menuFrame.refresh = function()
		if GHI_MiscData["UseMenuAnimation"] == false then
			menuFrame.ForceLabel("useAnimation", false)
		else
			menuFrame.ForceLabel("useAnimation",  true)
		end
	end
	menuFrame.name = loc.MENU_APPEARANCE;
	menuFrame.okay = function()
		ApplyTheme();
		GHI_MiscData["UseMenuAnimation"] = menuFrame.GetLabel("useAnimation");
		GHM_SetUseAnimation(GHI_MiscData["UseMenuAnimation"]);
	end;
	menuFrame.parent = parentName
	InterfaceOptions_AddCategory(menuFrame)

	class.Show = function(cat)
		InterfaceOptionsFrame_OpenToCategory(scrollMenuFrame);
	end

	GHM_SetUseAnimation(GHI_MiscData["UseMenuAnimation"]);

	return class;
end

