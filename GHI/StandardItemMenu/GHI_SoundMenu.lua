--===================================================
--
--					GHI_SoundMenu
--				GHI_SoundMenu.lua
--
--				Simple action menu
--
-- 			(c)2013 The Gryphonheart Team
--				All rights reserved
--===================================================
local loc = GHI_Loc()
local menus = {};
local miscAPI;
local ICON = "Interface\\Icons\\INV_Misc_Drum_02";
local NAME = "GHI_SoundMenu";
local TYPE = "sound";
local TYPE_LOC = loc.SOUND;

function GHI_SoundMenu(_OnOkCallback, _editAction)
	if not (miscAPI) then miscAPI = GHI_MiscAPI().GetAPI(); end

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
			menuFrame.ForceLabel("currentSound", info.sound_path);
			menuFrame.ForceLabel("range", info.range);
			menuFrame.ForceLabel("delay", info.delay);
		else
			class.editAction = nil;
			menuFrame.ForceLabel("currentSound", loc.NONE);
			menuFrame.ForceLabel("range", "");
			menuFrame.ForceLabel("delay", "0");
		end
		menuFrame:AnimatedShow();
	end

	class.IsInUse = function() return inUse; end

	local OnOk = function()
		local action;

		local path = menuFrame.GetLabel("currentSound");
		local delay = menuFrame.GetLabel("delay");
		local range = menuFrame.GetLabel("range");

		local t = {
			Type = TYPE,
			type_name = TYPE_LOC,
			icon = ICON,
			details = string.sub(path, 0, 100),
			sound_path = path,
			delay = delay,
			range = range,
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
					height = 20,
					width = 10,
					align = "l",
				},
				{
					type = "Text",
					fontSize = 11,
					width = 390,
					text = loc.SOUND_SEL,
					color = "white",
					align = "l",
				},
			},
			{
				{
					align = "c",
					type = "SoundSelection",
					label = "soundTree",
					width = 390,
					height = 300,
					texture = "Tooltip",
					OnSelect = function(path,duration)
						if not(menuFrame) then return end
						menuFrame.ForceLabel("currentSound", path);
						local timeString = miscAPI.GHI_GetPreciseTimeString(duration);
						if duration == 0.05 or duration == 0 then
							timeString = "(Unknown)"
						end
						local coloredTimeString = miscAPI.GHI_ColorString(timeString, 0.0, 0.7, 0.5);
						menuFrame.ForceLabel("duration", coloredTimeString);
					end,
				},
			},
			{
				{
					type = "Dummy",
					height = 5,
					width = 10,
					align = "l",
				},
				{
					type = "Text",
					fontSize = 11,
					width = 150,
					text = loc.CURRENTLY_SELECTED,
					color = "yellow",
					yOff = 15,
					align = "c",
					singleLine = true,
				},
				{
					type = "Text",
					fontSize = 11,
					width = 300,
					height = 50,
					xOff = 0,
					text = loc.NONE,
					color = "white",
					yOff = -15,
					align = "l",
					label = "currentSound",
					singleLine = true,
				},
				{
					type = "Dummy",
					height = 10,
					width = 10,
					xOff = -10,
					align = "r",
					label = "playSoundAnchor",
				},
				{
					type = "Text",
					fontSize = 11,
					width = 250,
					xOff = -20,
					text = "",
					color = "white",
					yOff = 0,
					align = "r",
					label = "duration",
					singleLine = true,
				},
			},
			{
				{
					type = "Time",
					texture = "Tooltip",
					label = "delay",
					align = "r",
					yOff = -10,
					text = loc.DELAY,
				},
				{
					type = "Editbox",
					texture = "Tooltip",
					label = "range",
					align = "l",
					text = loc.RANGE,
					numbersOnly = true,
					width = 60,
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
		width = 400,
		useWindow = true,
		OnShow = function(self)
			if not (menuFrame.playButton) then
				local parent = menuFrame.GetLabelFrame("playSoundAnchor");
				local playBtn = CreateFrame("Button", nil, parent);
				playBtn:SetWidth(24);
				playBtn:SetHeight(24);
				playBtn:SetPoint("CENTER", 0, 0);
				playBtn:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up");
				playBtn:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down");
				playBtn:SetScript("OnClick", function(self)
					local path = menuFrame.GetLabel("currentSound");
					PlaySoundFile(path);
				end);
				playBtn:RegisterForClicks("AnyUp");
				menuFrame.playButton = playBtn;
			end
		end,
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