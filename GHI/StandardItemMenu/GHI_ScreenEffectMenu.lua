--===================================================
--
--	GHI_ScreenEffectMenu
--	GHI_ScreenEffectMenu.lua
--
--	Simple action menu
--
-- 	(c)2013 The Gryphonheart Team
--	All rights reserved
--===================================================
local loc = GHI_Loc()
local menus = {};
local miscAPI;
local ICON = "Interface\\Icons\\spell_nature_astralrecal";
local NAME = "GHI_ScreenEffectMenu";
local TYPE = "screen_effect";
local TYPE_LOC = loc.SCREEN_EFFECT;



function GHI_ScreenEffectMenu(_OnOkCallback, _editAction)
	if not (miscAPI) then miscAPI = GHI_MiscAPI().GetAPI(); end

	local colors = miscAPI.GHI_GetColors();
	local colorDropdown = {};
	local colorRef = {};
	local colorNames = {};
	for i, info in pairs(colors) do
		table.insert(colorDropdown, miscAPI.GHI_ColorString(loc["COLOR_"..string.upper(i)], info.r, info.g, info.b));
		table.insert(colorRef, { r = info.r, g = info.g, b = info.b });
		table.insert(colorNames, i);
	end


	for i, menu in pairs(menus) do
		if _editAction and menu.IsInUse() and menu.editAction == _editAction then
			GHI_Message(loc.ACTION_BEING_EDITED);
			return;
		end
	end
	for i, menu in pairs(menus) do
		if not (menu.IsInUse()) then
			menu.Show(_OnOkCallback, _editAction)
			return menu
		end
	end
	local class = GHClass(NAME);
	table.insert(menus, class);

	local menuFrame, OnOkCallback;
	local inUse = false;
	local menuIndex = 1;
	while _G[NAME .. menuIndex] do menuIndex = menuIndex + 1; end


	class.Show = function(_OnOkCallback, _editAction)
		OnOkCallback = _OnOkCallback;
		inUse = true;
		if (_editAction) then
			class.editAction = _editAction;
			local info = class.editAction.GetInfo();				
			menuFrame.ForceLabel("color", 1)
			for i, v in pairs(colorNames) do
			--print(v)
			--print(info.colorName)
				if info.colorName == v then
				menuFrame.ForceLabel("color", i);
				end
			end

			menuFrame.ForceLabel("fade_in", info.fade_in);
			menuFrame.ForceLabel("fade_out", info.fade_out);
			menuFrame.ForceLabel("duration", info.duration);
            menuFrame.ForceLabel("delay",info.delay);
			menuFrame.ForceLabel("alpha",info.alpha)
			menuFrame.ForceLabel("flashRepeat",info.flashRepeat)
		else
			class.editAction = nil;
			menuFrame.ForceLabel("color", {1,1,1});
			menuFrame.ForceLabel("fade_in", 1);
			menuFrame.ForceLabel("fade_out", 1);
			menuFrame.ForceLabel("duration", 2);
            menuFrame.ForceLabel("delay",0);
			menuFrame.ForceLabel("alpha",1)
			menuFrame.ForceLabel("flashRepeat",1)
		end
		menuFrame:AnimatedShow();
	end

	class.IsInUse = function() return inUse; end

	local OnOk = function()
		local action;

		--local color = menuFrame.GetLabel("color");
		local fade_in = menuFrame.GetLabel("fade_in");
		local fade_out = menuFrame.GetLabel("fade_out");
		local duration = menuFrame.GetLabel("duration");
		local alpha = menuFrame.GetLabel("alpha");
		local flashRepeat = menuFrame.GetLabel("flashRepeat");
		local color = menuFrame.GetLabel("color");
		local delay = menuFrame.GetLabel("delay");


		local t = {
			Type = "script",
			dynamic_rc_type = TYPE,
			type_name = TYPE_LOC,
			icon = ICON,
			details = miscAPI.GHI_ColorString("Screen Effect", color.r, color.g, color.b),
			color = color,
			dynamic_rc = true,
			fade_in = tonumber(fade_in),
			fade_out = tonumber(fade_out),
			duration = tonumber(duration),
            delay = tonumber(delay),
			alpha = tonumber(alpha),
			flashRepeat = tonumber(flashRepeat),

		};

		if (class.editAction) then
			action = class.editAction;
			action.UpdateInfo(t);
		else
			action = GHI_SimpleAction(t);
		end

		if OnOkCallback then
			OnOkCallback(action);
		end
		inUse = false;
		menuFrame:Hide();
	end

	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
		  {
			{
			  type = "Dummy",
			  height = 30,
			  width = 10,
			  align = "l",
			},
			{
			  type = "Text",
			  fontSize = 11,
			  width = 440,
			  text = loc.SCREEN_EFFECT_TEXT,
			  color = "white",
			  align = "l",
			},
		  },
		  {
			{
			  type = "Color2",
			  text = loc.COLOR,
			  align = "l",
			  label = "color",
			},
			{
			  type = "Time",
			  text = loc.SCREEN_EFFECT_FADEOUT,
			  align = "r",
			  label = "fade_out",
			  yOff = 55,
			  width = 130,
			  texture = "Tooltip",
			  values = {0,0.5,1,2,3,4,5,10,15,20,25,30},
			},
			{
			  type = "Time",
			  text = loc.SCREEN_EFFECT_FADEIN,
			  align = "r",
			  label = "fade_in",
			  texture = "Tooltip",
			  xOff = -5,
			  width = 130,
			  values = {0,0.5,1,2,3,4,5,10,15,20,25,30},
			},
		  },
		  {
			{
			  type = "CustomSlider",
			  align = "r",
			  values = {0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.85,0.9,0.95,1},
			  yOff = 100,
			  width = 130,
			  label = "alpha",
			  text = loc.ALPHA,
			},        
			{
			  type = "Time",
			  text = loc.DURATION,
			  align = "r",
			  label = "duration",
			  texture = "Tooltip",
			  xOff = -5,
			  yOff = -10,
			  width = 130,
			  values = {0,0.5,1,2,3,4,5,10,15,20,25,30},
			},
		  },
		  {
			{
			  type = "Editbox",
			  text = "Repeat",
			  align = "r",
			  label = "flashRepeat",
			  width = 50,
			  texture = "Tooltip",
			  yOff = 80,
			  width = 130,
			},
			{
			  type = "Time",
			  text = loc.DELAY,
			  align = "r",
			  label = "delay",
			  xOff = -5,
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
			  OnClick = OnOk,
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
		title = TYPE_LOC,
		name = NAME .. menuIndex,
		theme = "BlankTheme",
		width = 450,
		useWindow = true,
		--background = "INTERFACE\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains",
		OnShow = UpdateTooltip,
		icon = ICON,
		lineSpacing = 20,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	});

	class.Show(_OnOkCallback, _editAction)

	return class;
end