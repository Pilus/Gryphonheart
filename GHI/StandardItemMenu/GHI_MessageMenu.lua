--===================================================
--
--				GHI_MessageMenu
--			GHI_MessageMenu.lua
--
--			Simple action menu
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
 local loc = GHI_Loc()
local menus = {};
local miscAPI;
local ICON = "Interface\\Icons\\INV_Misc_Note_04";
local NAME = "GHI_MessageMenu";
local TYPE = "message";
local TYPE_LOC = loc.MESSAGE_TEXT_U;

function GHI_MessageMenu(_OnOkCallback, _editAction)
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

	local colors = miscAPI.GHI_GetColors();
	local colorDropdown = {};
	local colorRef = {};
	local colorNames = {};
	local loc = GHI_Loc();
	for i, info in pairs(colors) do
		table.insert(colorDropdown, miscAPI.GHI_ColorString(loc["COLOR_"..string.upper(i)], info.r, info.g, info.b));
		table.insert(colorRef, { r = info.r, g = info.g, b = info.b });
		table.insert(colorNames, i);
	end

	class.Show = function(_OnOkCallback, _editAction)
		OnOkCallback = _OnOkCallback;
		inUse = true;
		if (_editAction) then
			class.editAction = _editAction;
			local info = class.editAction.GetInfo();
			menuFrame.ForceLabel("text", info.text);
			menuFrame.ForceLabel("color", 8);

			for index, name in pairs(colorNames) do
				if name == info.color then
					menuFrame.ForceLabel("color", index);
				end
			end

			menuFrame.ForceLabel("delay", info.delay);
			menuFrame.ForceLabel("type", info.output_type);
		else
			class.editAction = nil;
			menuFrame.ForceLabel("text", "");
			menuFrame.ForceLabel("color", {1,1,1});
			menuFrame.ForceLabel("delay", 0);
			menuFrame.ForceLabel("type", 1);
		end
		menuFrame:AnimatedShow();
	end

	class.IsInUse = function() return inUse; end



	local OnOk = function()
		local action;

		local text = menuFrame.GetLabel("text");
		local color = menuFrame.GetLabel("color");

		local t = {
			Type = "script",
			dynamic_rc_type = TYPE,
			type_name = TYPE_LOC,
			icon = ICON,
			details = miscAPI.GHI_ColorString(string.sub(text, 0, 100), color.r, color.g, color.b),
			text = text,
			dynamic_rc = true,
			color = color,
			delay = menuFrame.GetLabel("delay"),
			output_type = menuFrame.GetLabel("type"),
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
					type = "Editbox",
					text = loc.TEXT,
					align = "l",
					label = "text",
					width = 260,
					texture = "Tooltip",
				},
				{
					type = "Color",
					text = loc.COLOR,
					align = "r",
					label = "color",
					texture = "Tooltip",
				},
			},
			{
				{
					type = "RadioButtonSet",
					text = loc.OUTPUT_TYPE,
					align = "l",
					label = "type",
					returnIndex = true,
					data = { loc.CHAT_FRAME, loc.ERROR_MSG_FRAME },
					texture = "Tooltip",
				},
				{
					type = "Time",
					text = loc.DELAY,
					align = "r",
					label = "delay",
					texture = "Tooltip",
				}
			},
			{
				{
					type = "Text",
					fontSize = 11,
					text = loc.MSG_TEXT,
					align = "l",
					color = "white",
					width = 400,
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
		OnShow = UpdateTooltip,
		icon = ICON,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	});

	class.Show(_OnOkCallback, _editAction)

	return class;
end