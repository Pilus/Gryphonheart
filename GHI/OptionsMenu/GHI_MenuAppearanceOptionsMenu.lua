--===================================================
--
--		GHI_MenuAppearanceOptionsMenu
--		GHI_MenuAppearanceOptionsMenu.lua
--
--	Options menu for the appearance of GHM menus
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local loc = GHI_Loc();

local PREDEFINED_THEMES = {
	{
		guid = "001",
		name = loc.THEME_2_0,
		background = "Interface\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains.blp",
		titleBar = { 0.5, 0.1, 0.1, 1 },
		titleBarTextColor = { 1, 1, 1, 1 },
		backgroundColor = { 1, 1, 1, 1 },
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
		backgroundColor = { 0.3, 0.3, 0.3, 1 },
		buttonColor = { 0.5, 0.1, 0.1, 1 },
		mainTextColor = { 1.0, 0.82, 0.0, 1 },
		detailsTextColor = { 1.0, 1.0, 1.0, 1 },
	},
}

local colorAreas = {
	titleBar = loc.TITLE_BAR_COLOR,
	titleBarTextColor = loc.TITLE_BAR_TEXT_COLOR,
	backgroundColor = loc.BACKGROUND_COLOR,
	buttonColor = loc.BUTTON_COLOR,
	mainTextColor = loc.MAIN_TEXT_COLOR,
	detailsTextColor = loc.DETAILS_TEXT_COLOR,
}
local alphaValues = {0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.85,0.9,0.95,1}

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

	local parentWidth = InterfaceOptionsFramePanelContainer:GetWidth() - 20;

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
		
		for i,v in pairs(colorAreas) do
			if tostring(i) == "backgroundColor" then
				local r, g, b, a = unpack(theme.backgroundColor)
				menuFrame.ForceLabel("backgroundColor",theme.backgroundColor)
				menuFrame.ForceLabel("bg_alpha",a)	
			else
			menuFrame.ForceLabel(i,theme[i])
			end
		end
		
	end
	
	local row1 = {}
	local row2 = {}
	
	local rowCount = 1	
	for cata,title in pairs(colorAreas) do
		if rowCount <= 3 then
		table.insert(row1,
		{
			alight = "l",
			type = "Color2",
			text = title or cata,
			label = cata,
			tooltip = "Sets the "..title,
			xOff = 20,
			scale = 0.9,
			iTable = true,
		}
		)
		rowCount = rowCount + 1
		else
		table.insert(row2,
		{
			alight = "l",
			type = "Color2",
			xOff = 20,
			text = title or cata,
			label = cata,
			tooltip = "Sets the "..title,
			scale = 0.9,
			iTable = true,
		}
		)
		rowCount = rowCount + 1
		end
	end
	row1[1].xOff = 0
	row2[1].xOff = 0
	row2[1].yOff = -10
	
	local st = {
		onOk = function(self) end,
		{
			{
				{
					align = "l",
					type = "Text",
					color = "white",
					width = parentWidth - 100,
					text = loc.MENU_APPEARANCE_TEXT,
					fontSize = 11,
				},
				{
					height = 30,
					type = "Dummy",
					align = "r",
					width = 20,
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
							if i <= GetNumPredefinedThemes() then
								menuFrame.GetLabelFrame("save"):Disable();
								menuFrame.GetLabelFrame("load"):Enable();
								menuFrame.GetLabelFrame("delete"):Disable();
							elseif i < GetNumThemes() then
								menuFrame.GetLabelFrame("save"):Enable();
								menuFrame.GetLabelFrame("load"):Enable();
								menuFrame.GetLabelFrame("delete"):Enable();
							else
								menuFrame.GetLabelFrame("save"):Enable();
								menuFrame.GetLabelFrame("load"):Disable();
								menuFrame.GetLabelFrame("delete"):Disable();
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
                              --UpdateTheme()
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
					yOff = 0,
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
					yOff = 0,
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
					height = 30,
					type = "Dummy",
					align = "l",
					width = 20,
				},
				{
					type = "HBar",
					align = "l",
					width = parentWidth-100,
				},
			},
			{
				{
					align = "l",
					type = "Text",
					text = loc.MENU_WINDOW_COLORS,
					fontSize = 10,
				},
			},
			row1,
			row2,
			{
				{
					type = "Button",
					text = loc.MENU_UNIFY_TEXT,
					align = "l",
					compact = false,
					tooltip = loc.MENU_UNIFY_TEXT_TT,
					yOff = -10,
					OnClick = function(obj)
						local unifiedColors = menuFrame.GetLabel("mainTextColor")
						menuFrame.ForceLabel("titleBarTextColor",unifiedColors)
						menuFrame.ForceLabel("detailsTextColor",unifiedColors)
					end,
				},
				{
					type = "Button",
					text = loc.MENU_UNIFY_WINDOW,
					align = "l",
					compact = false,
					tooltip = loc.MENU_UNIFY_WINDOW_TT,
					xOff = 10,
					OnClick = function(obj)
						local unifiedColors = menuFrame.GetLabel("titleBar")
						menuFrame.ForceLabel("backgroundColor",unifiedColors)
						menuFrame.ForceLabel("buttonColor",unifiedColors)
					end,
				},
				{
				   type = "Slider",
				   align = "l",
				   values = alphaValues,
				   xOff = 10,
				   yOff = -8,
				   label = "bg_alpha",
				   text = loc.MENU_BG_ALPHA,
				   width = 150,
				},
			},
			{
				{
					height = 30,
					type = "Dummy",
					align = "l",
					width = 20,
				},
				{
					type = "HBar",
					align = "l",
					width = parentWidth-100,
				},
			},
			{
				{
					align = "l",
					type = "Text",
					text = loc.BACKGROUND,
					fontSize = 10,
					width = parentWidth -100,
				},
			},
			{
				{
					type = "ImageList",
					align = "l",
					height = 200,
					width = parentWidth-100,
					scaleX = 1.4,
					scaleY = 1.4,
					label = "background",
					xOff = 5,
					data = BACKGROUNDS,
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
					width = parentWidth / 2,
					text = loc.MENU_WARN_RELOG,
					fontSize = 11,
				},
			},
		},
		OnShow = function()
		end,
		title = loc.MENU_APPEARANCE,
		height = 800,
		name = "GHI_OptionsMenuAppearanceFrame",
		theme = "BlankTheme",
		width = parentWidth,
	}
	local t = {
		{
			{
				{
					align = "c",
					type = "Text",
					text = loc.MENU_APPEARANCE,
					fontSize = 13,
				},
				{
					height = 20,
					type = "Dummy",
					align = "r",
					width = 20,
				},
			},
			{
				{
					height = 515,
					type = "Dummy",
					align = "l",
					width = parentWidth-10,
					label = "colorAnchor"
				},
			},			
		},
		OnShow = function()	end,
		height = 600,
		name = "GHI_OptionsMenuAppearanceFrame",
		theme = "BlankTheme",
		width = parentWidth,	
	}

	rowCount = 1
	
	scrollMenuFrame = GHM_NewFrame(CreateFrame("frame"), t);
	menuFrame = GHM_NewFrame(CreateFrame("frame"), st)
	
	scrollMenuFrame.scroll = CreateFrame("ScrollFrame","$parentScroll",scrollMenuFrame,"GHM_ScrollFrameTemplate")
	scrollMenuFrame.scroll:SetAllPoints(scrollMenuFrame.GetLabelFrame("colorAnchor"))
	scrollMenuFrame.scroll:SetScrollChild(menuFrame)
	menuFrame:SetParent(scrollMenuFrame.scroll)
	menuFrame:Show()
	
	local OnColor = function()
		local i = menuFrame.GetLabel("preset");
		if i <= GetNumPredefinedThemes() then
			menuFrame.ForceLabel("preset", GetNumThemes())
		end
	end;
	
	for label,_ in pairs(colorAreas) do
		local f = menuFrame.GetLabelFrame(label)
		local _, mf = f:GetChildren()
		local _, colorPick = mf:GetChildren()
		
		colorPick:HookScript("OnColorSelect",function()
			OnColor()
		end)
	
	end

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
		local alpha = menuFrame.GetLabel("bg_alpha")
			
		local newCurrent = {
			background = menuFrame.GetLabel("background"),
			titleBar = menuFrame.GetLabel("titleBar"),
			titleBarTextColor = menuFrame.GetLabel("titleBarText"),
			backgroundColor = menuFrame.GetLabel("backgroundColor");
			buttonColor = menuFrame.GetLabel("buttonColor"),
			mainTextColor = menuFrame.GetLabel("mainTextColor"),
			detailsTextColor = menuFrame.GetLabel("detailsTextColor"),
		}
		
		table.insert(newCurrent.backgroundColor,alpha)
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
		local alpha = menuFrame.GetLabel("bg_alpha")
		table.insert(backgroundColor,alpha)
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
	scrollMenuFrame.name = loc.MENU_APPEARANCE;
	scrollMenuFrame.okay = function()
		ApplyTheme();
		GHI_MiscData["UseMenuAnimation"] = menuFrame.GetLabel("useAnimation");
		GHM_SetUseAnimation(GHI_MiscData["UseMenuAnimation"]);
	end;
	scrollMenuFrame.parent = parentName;

	InterfaceOptions_AddCategory(scrollMenuFrame);

	class.Show = function(cat)
		InterfaceOptionsFrame_OpenToCategory(scrollMenuFrame);
	end

	GHM_SetUseAnimation(GHI_MiscData["UseMenuAnimation"]);

	return class;
end

