--===================================================
--
--				GHI_ScriptMenu
--				GHI_ScriptMenu.lua
--
--			Simple action menu
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local loc = GHI_Loc()
local USE_WIDE_EDITOR = false;
local menus = {};

GHI_ScriptMenu_UseWideEditor = function(useWide)
	if USE_WIDE_EDITOR == useWide then
		return;
	end
	USE_WIDE_EDITOR = useWide;
	for i, menu in pairs(menus) do
		menu.Suspend();
	end
end


local miscAPI;
local icon = "Interface\\Icons\\Trade_Engineering";
local soundMenuList,iconMenuList,imageMenuList;
function GHI_ScriptMenu(_OnOkCallback, _editAction)
	if not (miscAPI) then miscAPI = GHI_MiscAPI().GetAPI(); end
	local playerGUID = GHUnitGUID("player");

	for i, menu in pairs(menus) do
		if _editAction and menu.IsInUse() and menu.editAction == _editAction then
			GHI_Message(loc.ACTION_BEING_EDITED);
			return;
		end
	end

	for i, menu in pairs(menus) do
		if not (menu.IsInUse()) and not (menu.IsSuspended()) then
			menu.Show(_OnOkCallback, _editAction)
			return menu
		end
	end
	local class = GHClass("GHI_ScriptMenu");
	table.insert(menus, class);

	local menuFrame, OnOkCallback;
	local suspended = false;
	local inUse = false;
	local menuIndex = 1;
	local editField;
	while _G["GHI_ScriptMenu" .. menuIndex] do menuIndex = menuIndex + 1; end

	if not(soundMenuList) then
		soundMenuList = GHI_MenuList("GHM_SoundSelectionMenu");
	end
	local iconMenuList = GHM_IconPickerList()
	local imageMenuList = GHM_ImagePickerList()
	
	class.Show = function(_OnOkCallback, _editAction)
		OnOkCallback = _OnOkCallback;
		inUse = true;
		if (_editAction) then
			class.editAction = _editAction;
			local info = class.editAction.GetInfo();
			menuFrame.ForceLabel("delay", info.delay);
			menuFrame.ForceLabel("code", string.join("", unpack(info.code)));
		else
			class.editAction = nil;
			menuFrame.ForceLabel("delay", "");
			menuFrame.ForceLabel("code", "");
		end

		menuFrame:Show();
	end

	class.IsInUse = function() return inUse; end
	class.IsSuspended = function() return suspended; end
	class.Suspend = function() suspended = true; end

	local OnOk = function()
		local action;
		local code = menuFrame.GetLabel("code");
		local delay = menuFrame.GetLabel("delay");
		local t = {
			Type = "script",
			type_name = loc.SCRIPT,
			icon = icon,
			details = string.sub(code, 0, 100),
			code = { code },
			delay = delay,
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
					type = "CodeField",
					height = 430,
					text = loc.SCRIPT .. ":",
					width = USE_WIDE_EDITOR and 780 or 380,
					label = "code",
					align = "c",
					toolbarButtons = {
						{
							texture = "INTERFACE\\ICONS\\Ability_Rogue_Sprint",
							tooltip = loc.SCRIPT_TEST,
							func = function()
								local code = menuFrame.GetLabel("code");
								local env = GHI_ScriptEnvList().GetEnv(playerGUID);
								env.ExecuteScript(code)
							end,
						},
						{
							texture = "Interface\\AddOns\\GHM\\GHI_Icons\\_Reverse_Red",
							tooltip = loc.SCRIPT_RELOAD_ENV,
							func = function()
								local code = menuFrame.GetLabel("code");
								local env = GHI_ScriptEnvList().ReloadEnv(playerGUID);
							end,
						},
						{
							texture = "Interface\\Icons\\Spell_Holy_MagicalSentry",
							tooltip = loc.SCRIPT_OPTIONS_NL,
							func = function()
								GHI_CodeEditorOptionsMenu().Show();
							end,
						},
						{
							texture = "Interface\\Icons\\INV_Misc_Drum_02",
							tooltip = loc.SCRIPT_INSERT_SOUND,
							func = function()
								soundMenuList.New(function(sound)
								local soundPath = string.gsub(sound.path,[[\]],[[\\]]);
									editField:Insert(string.format([["%s"]],soundPath));
								end);
							end,
						},
						{
							texture = "INTERFACE\\ICONS\\priest_icon_chakra_blue",
							tooltip = loc.SCRIPT_INSERT_ICON,
							func = function()
								iconMenuList.New(function(icon)
								local iconPath = string.gsub(icon,[[\]],[[\\]]);
									editField:Insert(string.format([["%s"]],iconPath));
								end);
							end,
						},
						{
							texture = "Interface\\Icons\\INV_MISC_FILM_01",
							tooltip = "Image",
							func = function()
								imageMenuList.New(function(selectedImage, selectedX, selectedY)
								local imagePath = string.gsub(selectedImage,[[\]],[[\\]]);
								editField:Insert(string.format([["%s"]],imagePath))
								--selectedX.." "..selectedY;
								end)
							end,
						},
						{
							texture = "Interface\\Icons\\INV_Misc_Map03",
							tooltip = "Insert current coordinates",
							func = function()
								local x,y,w = GHI_Position().GetCoor("player",3);
								editField:Insert(string.format("{x=%s,y=%s,world=%s}",x,y,w));
							end,
						},
						{
							texture = "Interface\\Icons\\Ability_Repair",
							tooltip = "Insert Item GUID",
							func = function()            
								miscAPI.GHI_SetSelectItemCursor(function(guid)
									editField:Insert(string.format([["%s"]],guid))
								end, nil, "GHI_INSPECT");
							end,
						},
					},
				},
			},
			{
				{
					align = "l",
					type = "Time",
					text = loc.DELAY;
					label = "delay",
					yOff = -10,
					texture = "Tooltip",
					numbersOnly = true,
				},
			},
			{
				{
					type = "Dummy",
					height = 10,
					width = 10,
					align = "c",
				},
			},
			{
				{
					type = "Dummy",
					height = 10,
					width = 10,
					align = "l",
				},
				{
					type = "Text",
					fontSize = 11,
					width = USE_WIDE_EDITOR and 780 or 380,
					text = loc.SCRIPT_TEXT,
					color = "white",
					align = "l",
				},
			},
			{
				{
					type = "Dummy",
					height = 10,
					width = 10,
					align = "c",
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
		title = loc.SCRIPT,
		name = "GHI_ScriptMenu" .. menuIndex,
		theme = "BlankTheme",
		width = USE_WIDE_EDITOR and 800 or 400,
		useWindow = true,
		OnShow = UpdateTooltip,
		icon = icon,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	});
	editField = menuFrame.GetLabelFrame("code").field;
	editField.executionEnv = GHI_ScriptEnvList().GetEnv(playerGUID);
	class.Show(_OnOkCallback, _editAction)

	return class;
end

