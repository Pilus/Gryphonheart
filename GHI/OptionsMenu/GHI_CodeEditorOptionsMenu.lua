--===================================================
--
--			GHI_CodeEditorOptionsMenu
--  			GHI_CodeEditorOptionsMenu.lua
--
--	Options menu for code editor related options
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_CodeEditorOptionsMenu(parentName)
	if class then
		return class;
	end

	local loc = GHI_Loc()
	local parentWidth = InterfaceOptionsFramePanelContainer:GetWidth() - 20;

	local miscAPI = GHI_MiscAPI().GetAPI();
	local LoadSyntaxColors;
	local UpdateSyntaxPreview, ResetColors
	local colorConfig = {};
	local syntaxColorPreview
	local syntaxHighlight = GHM_CodeField_SyntaxHighlight()
	local categories = syntaxHighlight.GHM_GetSyntaxCatagories();
	
	local colorCatObjs = {}
	
	for i,cata in pairs(categories) do
		table.insert(colorCatObjs,
			{
				alight = "l",
				type = "Color",
				width = 100,
				text = loc["SYNTAX_" .. string.upper(cata)] or cata,
				tooltip = loc.SYNTAX_TT_1..loc["SYNTAX_" .. string.upper(cata)]..loc.SYNTAX_TT_2,
				label = cata,
				OnChange = function(r,g,b)
					syntaxHighlight.GHM_SetSyntaxColor(cata, r, g, b)
					UpdateSyntaxPreview()
				end
			}
		)
	end

	local t = {
		onOk = function(self) end,
		{
			{
				{
					align = "c",
					type = "Text",
					text = loc.SCRIPT_CODE_EDITOR_SETTINGS,
					fontSize = 13,
				},
			},
			{
				{
					align = "l",
					type = "CheckBox",
					text = loc.SCRIPT_USE_WIDE,
					label = "useWideEditor",
				},
				{
					align = "r",
					type = "CheckBox",
					text = loc.SCRIPT_DISABLE_SYNTAX,
					label = "disableSyntax",
				},
			},
			{
				{
					height = 15,
					type = "Dummy",
					align = "l",
					width = 20,
				},
				{
					type = "HBar",
					align = "c",
					width = parentWidth-100,
				},
			},
			{
				{
					align = "l",
					type = "Text",
					label = "color_title",
					text = loc.OPT_SYNTAX_HIGHLIGHT_COLOR,
					fontSize = 13,
				},
				{
					height = 20,
					type = "Dummy",
					align = "l",
					width = 20,
				},
			},
			{
				colorCatObjs[1],
				colorCatObjs[2],
				colorCatObjs[3],
				colorCatObjs[4],
				colorCatObjs[5],
				{
					type = "Button",
					label = "ResetColors",
					align = "r",
					text = loc.SCRIPT_RESET_COLORS,
					compact = false,
					OnClick = function(self)
						ResetColors()
					end,
				},
			},
			{
				{
					height = 170,
					type = "Dummy",
					align = "r",
					yOff = -20,
					width = 300,
					label = "SyntaxColorAnchor"
				},				
			},
		}
		,
		OnShow = function()
		end,
		title = loc.SCRIPT_CODE_EDITOR_SETTINGS,
		height = 400,
		name = "GHI_OptionsCodeEditorSettingsFrame",
		theme = "BlankTheme",
		width = parentWidth,
	}
	
	local menuFrame = GHM_NewFrame(CreateFrame("frame"), t);

	syntaxColorPreview = CreateFrame("Frame", nil, menuFrame);
	syntaxColorPreview:SetAllPoints(menuFrame.GetLabelFrame("SyntaxColorAnchor"))
	syntaxColorPreview.title = syntaxColorPreview:CreateFontString();
	syntaxColorPreview.title:SetFontObject(GHM_GameFontSmall);
	syntaxColorPreview.title:SetTextColor(1, 1, 1)

	syntaxColorPreview.title:SetText(loc.OPT_SYNTAX_PREVIEW)
	syntaxColorPreview.title:SetPoint("TOPLEFT", 0, 10)
	syntaxColorPreview:SetWidth(parentWidth - 250)

	syntaxColorPreview.text = syntaxColorPreview:CreateFontString();
	syntaxColorPreview.text:SetFontObject(GameFontHighlight);
	syntaxColorPreview.text:SetJustifyH("LEFT");
	syntaxColorPreview.text:SetPoint("TOPLEFT", 6, -6)

	syntaxColorPreview:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	});
	syntaxColorPreview:SetBackdropColor(0, 0, 0, 1);
	syntaxColorPreview:Show()
	
	local function ToggleSyntaxHighlight(on)
		if on == false then
				local butt = menuFrame.GetLabelFrame("ResetColors")
				local title = menuFrame.GetLabelFrame("color_title")
				for i,v in pairs(colorCatObjs) do
					local f = menuFrame.GetLabelFrame(v.label)
					f:Hide()
				end
				butt:Hide()
				syntaxColorPreview:Hide()
				title:Hide()
		elseif on == true then
				local butt = menuFrame.GetLabelFrame("ResetColors")
				local title = menuFrame.GetLabelFrame("color_title")
				for i,v in pairs(colorCatObjs) do
					local f = menuFrame.GetLabelFrame(v.label)
					f:Show()
				end
				butt:Show()
				syntaxColorPreview:Show()
				title:Show()
		end
	end
	
	local syntax = menuFrame.GetLabelFrame("disableSyntax")
	syntax.SetOnClick(
		function()
			if menuFrame.GetLabel("disableSyntax") == true then
				ToggleSyntaxHighlight(false)
			else
				ToggleSyntaxHighlight(true)
			end
		end
	)
				
	UpdateSyntaxPreview = function()
		
		local syntaxColors = syntaxHighlight.GHM_SyntaxColorList
		local makePreviewLine = function(str, cat)
			return miscAPI.GHI_ColorString(str, unpack(syntaxColors[cat]));
		end
		local strings = {
			makePreviewLine("--Syntax colors example", "comment"),
			makePreviewLine("local", "keyword") .. " i = " .. makePreviewLine("12", "number") .. ";",
			makePreviewLine("if", "keyword") .. " ( i > " .. makePreviewLine("10", "number") .. ") " .. makePreviewLine("then", "keyword"),
			"   print(" .. makePreviewLine("\"Hello World\"", "string") .. ");",
			makePreviewLine("   return", "keyword") .. " " .. makePreviewLine("true", "boolean") .. ";",
			makePreviewLine("end", "keyword"),
		};
		local s = strjoin("\n", unpack(strings));
		syntaxColorPreview.text:SetText(s)
	end
	
	ResetColors = function()
		syntaxHighlight.GHM_ResetSyntaxColors()
		local syntaxColors = syntaxHighlight.GHM_SyntaxColorList
		for cat,color in pairs(syntaxColors) do
			menuFrame.ForceLabel(cat,color)	
		end
	end
	
	local LoadSyntaxColors = function()
		local syntaxColors = syntaxHighlight.GHM_SyntaxColorList
			for cat,color in pairs(syntaxColors) do
				menuFrame.ForceLabel(cat,color)	
			end
	end

	local bool = function(b)
		if b then return true; end
		return false;
	end
	
	local LoadSettings = function()
		local useWideEditor = bool(GHI_MiscData.useWideEditor);
		GHI_ScriptMenu_UseWideEditor(useWideEditor);
		menuFrame.ForceLabel("useWideEditor", useWideEditor)
		local syntaxDisabled = bool(GHI_MiscData.syntaxDisabled);
		menuFrame.ForceLabel("disableSyntax",syntaxDisabled);
		if syntaxDisabled == true then
			ToggleSyntaxHighlight(false)
		end
		LoadSyntaxColors()
	end
	
	menuFrame.name = loc.SCRIPT_CODE_EDITOR;
	menuFrame.refresh = function()
		syntaxColorPreview:SetHeight(syntaxColorPreview:GetHeight());
		UpdateSyntaxPreview()
		LoadSettings()
	end
	
	menuFrame.okay = function()
		local useWideEditor = bool(menuFrame.GetLabel("useWideEditor"));
		local syntaxDisabled = bool(menuFrame.GetLabel("disableSyntax"));
		GHI_ScriptMenu_UseWideEditor(useWideEditor);
		GHI_MiscData.useWideEditor = useWideEditor;
		GHI_MiscData.syntaxDisabled = syntaxDisabled
		GHI_MiscData.SyntaxColor = syntaxHighlight.GHM_SyntaxColorList
	end;
	
	menuFrame.parent = parentName;
	syntaxHighlight.GHM_LoadSyntaxColorList()
	LoadSettings();

	InterfaceOptions_AddCategory(menuFrame)

	class.Show = function()
		InterfaceOptionsFrame_OpenToCategory(menuFrame);
	end

	return class;
end