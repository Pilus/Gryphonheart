--
--
--				GHI_MainOptionsMenu
--  			GHI_MainOptionsMenu.lua
--
--		The main options menu
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--

local class;
function GHI_MainOptionsMenu()
	if class then
		return class;
	end
	class = GHClass("GHI_MainOptionsMenu");
	local parentWidth = InterfaceOptionsFramePanelContainer:GetWidth() - 20;

	local version = GetAddOnMetadata("GHI", "Version")
	GHI_MiscData = GHI_MiscData or {};
	local loc = GHI_Loc();
	

	local menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				{
					align = "c",
					type = "Text",
					text = format("%s v. %s", loc.FULL_NAME, version or "unknown");
					fontSize = 14,
				},
			},
			{
				{
					align = "c",
					type = "Text",
					text = loc.CREDITS,
					fontSize = 11,
				},
			},
			{
				{
					height = 12,
					type = "Dummy",
					align = "c",
					width = 10,
				},
			},
			{
				{
					fontSize = 11,
					color = "white",
					text = loc.ADDON_INFO,
					align = "l",
					type = "Text",
					--width = parentWidth/2 - 10,
				},
			},
			{
				{
					fontSize = 11,
					color = "white",
					text = "...",
					align = "l",
					type = "Text",
					width = parentWidth - 20,
					label = "playersOnline"
				},
			},
			{
				{
					align = "l",
					type = "CheckBox",
					text = loc.BLOCK_STD_EMOTE,
					label = "block_std_emote",
				},
				{
					align = "c",
					type = "CheckBox",
					text = loc.HIDE_EMPTY_SLOTS,
					label = "hide_empty_slots",
				},
				{
					type = "Button",
					label = "center_buff",
					align = "r",
					text = loc.CENTER_BUFFS,
					compact = false,
					onclick = function(self)
						GHI_BuffUIResetAllPositions();
					end,
				},
				{
					type = "Button",
					label = "remove_buffs",
					align = "r",
					text = loc.REMOVE_BUFFS,
					compact = false,
					onclick = function(self)
						GHI_ActionAPI().GetAPI().GHI_RemoveAllBuffs();
					end,
				},
			},
			{
				{
					type = "RadioButtonSet",
					text = loc.TARGET_ICON,
					align = "l",
					label = "target_icon_display_method",
					returnIndex = true,
					data = { loc.TARGET_ICON_FRIENDLY, loc.TARGET_ICON_CONFIRMED, loc.TARGET_ICON_HIDE },
					width = 170,
				},
				{
					type = "RadioButtonSet",
					text = loc.CHAT_PERMISSONS,
					align = "c",
					label = "chatMsgPermission",
					returnIndex = true,
					data = { loc.CHAT_PERMISSONS_ALLOW, loc.CHAT_PERMISSONS_PROMT, loc.CHAT_PERMISSONS_BLOCK},
					width = 170,
				},
				{
					type = "RadioButtonSet",
					text = loc.SOUND_PERMISSONS,
					align = "r",
					label = "soundPermission",
					returnIndex = true,
					data = { loc.CHAT_PERMISSONS_ALLOW, loc.CHAT_PERMISSONS_PROMT,loc.CHAT_PERMISSONS_BLOCK},
					width = 170,
				},
			},
			{
				{
					align = "l",
					type = "CheckBox",
					text = loc.TOOLTIP_VERSION,
					label = "tooltip_version",
				},
				{
					align = "c",
					type = "CheckBox",
					text = loc.NO_CHANNEL_COMM,
					label = "no_channel_comm",
				},
				{
					align = "r",
					type = "CheckBox",
					text = loc.SHOW_AREA_SOUND_SENDER,
					label = "show_area_sound_sender",
				},
			},
			{
				{
					align = "l",
					type = "CheckBox",
					text = loc.BLOCK_AREA_BUFFS,
					label = "block_area_buff",
				},
				{
					align = "c",
					type = "CheckBox",
					text = loc.STICK_PLAYER_BUFFS,
					label = "stick_player_buffs",
				},
				{
					align = "r",
					type = "CheckBox",
					text = loc.STICK_TARGET_BUFFS,
					label = "stick_target_buffs",
				},
			},
			{
				{
					align = "l",
					type = "CheckBox",
					text = loc.HIDE_MOD_ATT_TOOLTIP,
					label = "hide_mod_att_tooltip",
				},
				{
					align = "c",
					type = "CheckBox",
					text = "Allow Animations to move camera.",
					label = "allow_camera_move",
				},
			},
		},
		title = loc.HELP_OPTIONS,
		width = InterfaceOptionsFramePanelContainer:GetWidth(),
		height = InterfaceOptionsFramePanelContainer:GetHeight(),
		lineSpacing = 10,
		name = "GHI_Help_Menu_Frame",
		theme = "BlankTheme",
		width = parentWidth,
	});

	menuFrame.name = loc.FULL_NAME;
	menuFrame.refresh = function()
		local show_msg = GHI_MiscData["block_std_emote"];

		if show_msg == false then
			menuFrame.ForceLabel("block_std_emote", nil);
		else
			menuFrame.ForceLabel("block_std_emote", 1);
		end

		menuFrame.ForceLabel("hide_empty_slots", GHI_MiscData["hide_empty_slots"]);
		menuFrame.ForceLabel("block_area_buff", GHI_MiscData["block_area_buff"]);
		menuFrame.ForceLabel("show_area_sound_sender", GHI_MiscData["show_area_sound_sender"]);
		menuFrame.ForceLabel("stick_player_buffs", GHI_MiscData["stick_player_buffs"]);
		menuFrame.ForceLabel("stick_target_buffs", GHI_MiscData["stick_target_buffs"]);
		menuFrame.ForceLabel("no_channel_comm", GHI_MiscData["no_channel_comm"]);
		menuFrame.ForceLabel("tooltip_version", GHI_MiscData["tooltip_version"]);
		menuFrame.ForceLabel("target_icon_display_method", GHI_MiscData["target_icon_display_method"]);
		menuFrame.ForceLabel("chatMsgPermission", GHI_MiscData["chatMsgPermission"]);
		menuFrame.ForceLabel("soundPermission", GHI_MiscData["soundPermission"]);
		menuFrame.ForceLabel("hide_mod_att_tooltip", GHI_MiscData["hide_mod_att_tooltip"]);
		menuFrame.ForceLabel("allow_camera_move", GHI_MiscData["allow_camera_move"]);
	end;

	menuFrame.okay = function()
		GHI_MiscData["block_std_emote"] = menuFrame.GetLabel("block_std_emote") or false;
		GHI_MiscData["hide_empty_slots"] = menuFrame.GetLabel("hide_empty_slots") or false;
		GHI_MiscData["block_area_buff"] = menuFrame.GetLabel("block_area_buff") or false;
		GHI_MiscData["show_area_sound_sender"] = menuFrame.GetLabel("show_area_sound_sender") or false;
		GHI_MiscData["stick_player_buffs"] = menuFrame.GetLabel("stick_player_buffs") or false;
		GHI_MiscData["stick_target_buffs"] = menuFrame.GetLabel("stick_target_buffs") or false;
		GHI_MiscData["no_channel_comm"] = menuFrame.GetLabel("no_channel_comm") or false;
		GHI_MiscData["tooltip_version"] = menuFrame.GetLabel("tooltip_version") or false;
		GHI_MiscData["target_icon_display_method"] = menuFrame.GetLabel("target_icon_display_method") or 1;
		GHI_MiscData["chatMsgPermission"] = menuFrame.GetLabel("chatMsgPermission") or 1;
		GHI_MiscData["soundPermission"] = menuFrame.GetLabel("soundPermission") or 1;
		GHI_MiscData["hide_mod_att_tooltip"] = menuFrame.GetLabel("hide_mod_att_tooltip") or false;
		GHI_MiscData["allow_camera_move"] = menuFrame.GetLabel("allow_camera_move") or false;

		if menuFrame.GetLabel("soundPermission") == 3 then --block
			GHI_MiscData["block_area_sound"]  = true;
		else
			GHI_MiscData["block_area_sound"] = false;
		end
		GHI_BuffHandler().UpdateBuffSticking();
	end;

	menuFrame.SetFrameLevel = function() end; -- Disable changes to frame level.
	InterfaceOptions_AddCategory(menuFrame);

	if not (GHI_MiscData["tooltip_version"] == false) then
		GHI_MiscData["tooltip_version"] = true;
	end

	class.Show = function(cat)
		InterfaceOptionsFrame_OpenToCategory(menuFrame);

		InterfaceOptionsFrameTab2:GetScript("OnClick")(InterfaceOptionsFrameTab2)

		local i = 1;
		local f = _G["InterfaceOptionsFrameAddOnsButton" .. i];
		while f and f.element do
			if f.element.name == loc.FULL_NAME and string.lower(f.toggle:GetNormalTexture():GetTexture() or "") == string.lower("Interface\\Buttons\\UI-PlusButton-Up") then
				f.toggle:Click();
				f:GetScript("OnClick")(f);
			end
			i = i + 1;
			f = _G["InterfaceOptionsFrameAddOnsButton" .. i];
		end
	end

	local onlineString = string.format(loc.ONLINE_PLAYERS,GetRealmName(),UnitFactionGroup("player"));
	local onlineLabel = menuFrame.GetLabelFrame("playersOnline");
	local versionInfo = GHI_VersionInfo();
	GHI_Timer(function()
		if onlineLabel:IsShown() then
			local num = versionInfo.NumPlayersWithAddOn();
			onlineLabel.Force(onlineString.." "..num)
		end
	end,1,false,"player list update")

	GHI_BagOptionsMenu(menuFrame.name);
	GHI_CodeEditorOptionsMenu(menuFrame.name);
	GHI_WhitelistMenu(menuFrame.name);
	GHI_MenuAppearanceOptionsMenu(menuFrame.name);
	GHI_DebugMenu(menuFrame.name);

	return class;
end

