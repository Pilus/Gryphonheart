--===================================================
--
--				GHI_CodeEditorOptionsMenu
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
	class = GHClass("GHI_CodeEditorOptionsMenu");
	local parentWidth = InterfaceOptionsFramePanelContainer:GetWidth() - 20;

	local miscAPI = GHI_MiscAPI().GetAPI();
	local LoadSyntaxColors;
	local UpdateSyntaxPreview;
	local colorConfig = {};
	local catagories = GHM_GetSyntaxCatagories();
	local syntaxColorPreview

	local colorCatObjs = {}
	
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
					align = "c",
					type = "CheckBox",
					text = loc.SCRIPT_USE_WIDE,
					label = "useWideEditor",
				},
				{
					align = "l",
					type = "CheckBox",
					text = loc.SCRIPT_DISABLE_SYNTAX,
					label = "disableSyntax",
				},				
			},
			{
				{
					align = "c",
					type = "Text",
					label = "color_title",
					text = loc.OPT_SYNTAX_HIGHLIGHT_COLOR,
					fontSize = 13,
				}
			},
		},
		OnShow = function()
		end,
		title = loc.SCRIPT_CODE_EDITOR_SETTINGS,
		height = 400,
		name = "GHI_OptionsCodeEditorSettingsFrame",
		theme = "BlankTheme",
		width = parentWidth,
	}
	
	for i,cata in pairs(catagories) do
		table.insert(colorCatObjs,
		{
			alight = "l",
			type = "Color2",
			xOff = 20,
			text = loc["SYNTAX_" .. string.upper(cata)] or cata,
			tooltip = "Sets the color to highlight "..loc["SYNTAX_" .. string.upper(cata)].." elements in.",
			label = cata,
			scale = 0.75,
		}
		)
	end
	
	table.insert(t[1],
		{colorCatObjs[1],colorCatObjs[2],colorCatObjs[3],
			{
				type = "Button",
				label = "ResetColors",
				align = "r",
				text = loc.SCRIPT_RESET_COLORS,
				compact = false,
				onclick = function(self)
					LoadSyntaxColors(true);
				end,
			},
		}
	);
	table.insert(t[1],
		{colorCatObjs[4],colorCatObjs[5],
			{
				height = 170,
				type = "Dummy",
				yOff = -20,
				xOff = 20,
				align = "l",
				width = 300,
				label = "SyntaxColorAnchor"
			},
		}
	);

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
				
	local GetSyntaxColorsTable = function()
		local t = {};
			for i,v in pairs(colorCatObjs) do
				local label = v.label
				local color = {}
				color.r, color.g, color.b = GHM_GetSyntaxColor(label)
				t[label] = color
			end
			
		return t;
	end

	UpdateSyntaxPreview = function()
		local syntax = {}
		for i,v in pairs(colorCatObjs) do
				local label = v.label
				local color = menuFrame.GetLabel(label)
				syntax[label] = {color.r, color.g, color.b}
		end		
		
		local form = function(s, t)
			return miscAPI.GHI_ColorString(s, t.r or t[1],t.g or t[2],t.b or t[3]);
		end
		local strings = {
			form("--Syntax colors example", (syntax.comment)),
			form("local", (syntax.keyword)) .. " i = " .. form("12", (syntax.number)) .. ";",
			form("if", (syntax.keyword)) .. " ( i > " .. form("10", (syntax.number)) .. ") " .. form("then", (syntax.keyword)),
			"   print(" .. form("\"Hello World\"", (syntax.string)) .. ");",
			form("   return", (syntax.keyword)) .. " " .. form("true", (syntax.boolean)) .. ";",
			form("end", (syntax.keyword)),
		};
		local s = strjoin("\n", unpack(strings));
		syntaxColorPreview.text:SetText(s)
	end
	
	
	LoadSyntaxColors = function(default)
		for i,v in pairs(colorCatObjs) do
				local label = v.label
				local colorr,colorg,colorb = GHM_GetSyntaxColor(label,true)
				menuFrame.ForceLabel(label,{colorr,colorg,colorb})
		end
		
		UpdateSyntaxPreview();
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
		LoadSyntaxColors()
		UpdateSyntaxPreview();
		
		if syntaxDisabled == true then
			ToggleSyntaxHighlight(false)
		end
		
	end
	
	for i,v in pairs(colorCatObjs) do
		local f = menuFrame.GetLabelFrame(v.label)
		local _, mf = f:GetChildren()
		local _, colorPick = mf:GetChildren()
		colorPick:HookScript("OnColorSelect",function()
			local r,g,b = colorPick:GetColorRGB()
			UpdateSyntaxPreview()
		end)
	end

	menuFrame.name = loc.SCRIPT_CODE_EDITOR;
	menuFrame.refresh = function()
		syntaxColorPreview:SetHeight(syntaxColorPreview:GetHeight());
		LoadSyntaxColors();
		UpdateSyntaxPreview();
		LoadSettings();
	end
	
	menuFrame.okay = function()
		local t = GetSyntaxColorsTable();
		for i,v in pairs(colorCatObjs) do
			local label = v.label
			local color = menuFrame.GetLabel(label)
			GHM_SetSyntaxColor(label, color.r or color[1], color.g or color[2], color.b or color[3]);
		end
		local useWideEditor = bool(menuFrame.GetLabel("useWideEditor"));
		local syntaxDisabled = bool(menuFrame.GetLabel("disableSyntax"));
		GHI_ScriptMenu_UseWideEditor(useWideEditor);
		GHI_MiscData.useWideEditor = useWideEditor;
		GHI_MiscData.syntaxDisabled = syntaxDisabled
		
	end;
	
	menuFrame.parent = parentName;

	LoadSettings();

	InterfaceOptions_AddCategory(menuFrame)

	class.Show = function(cat)
		InterfaceOptionsFrame_OpenToCategory(menuFrame);
	end

	return class;
end

