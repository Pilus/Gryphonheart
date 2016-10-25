--
--
--				GHI_RemoveBuffMenu
--			GHI_RemoveBuffMenu.lua
--
--				Simple action menu
--
-- 			(c)2013 The Gryphonheart Team
--				All rights reserved
--
local loc = GHI_Loc()
local menus = {};
local miscAPI;
local ICON = "Interface\\Icons\\Spell_Arcane_Arcane02";
local NAME = "GHI_RemoveBuffMenu";
local TYPE = "remove_buff";
local TYPE_LOC = loc.REMOVE_BUFF;

function GHI_RemoveBuffMenu(_OnOkCallback, _editAction)
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
			menuFrame.ForceLabel("name", info.name);
			menuFrame.ForceLabel("filter", info.filter);
			menuFrame.ForceLabel("amount", info.amount);
			menuFrame.ForceLabel("delay", info.delay);
		else
			class.editAction = nil;
			menuFrame.ForceLabel("name", "");
			menuFrame.ForceLabel("filter", 1);
			menuFrame.ForceLabel("amount", "");
			menuFrame.ForceLabel("delay", 0);
		end
		menuFrame:AnimatedShow();
	end

	class.IsInUse = function() return inUse; end

	local OnOk = function()
		local action;

		local name = menuFrame.GetLabel("name");
		local filter = menuFrame.GetLabel("filter");
		local amount = menuFrame.GetLabel("amount");
		local delay = menuFrame.GetLabel("delay");

		local t = {
			Type = "script",
			dynamic_rc_type = TYPE,
			type_name = TYPE_LOC,
			icon = ICON,
			details = name,
			name = name,
			dynamic_rc = true,
			filter = filter,
			amount = amount,
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
					type = "Dummy",
					height = 30,
					width = 10,
					align = "l",
				},
				{
					type = "Text",
					fontSize = 11,
					width = 390,
					text = loc.REMOVE_BUFF_TEXT,
					color = "white",
					align = "l",
				},
			},
			{
				{
					type = "Editbox",
					texture = "Tooltip",
					label = "name",
					align = "l",
					text = loc.BUFF_NAME,
					width = 210,
				},
				{
					type = "Editbox",
					texture = "Tooltip",
					label = "amount",
					align = "r",
					text = loc.AMOUNT,
					numbersOnly = true,
					width = 50,
				},
				
			},
			{
				{
					type = "RadioButtonSet",
					texture = "Tooltip",
					width = 110,
					label = "filter",
					align = "r",
					text = loc.BUFF_DEBUFF,
					data = {
						loc.HELPFUL,
						loc.HARMFUL,
					},
					returnIndex = true,
				},
				{
					type = "Time",
					texture = "Tooltip",
					label = "delay",
					align = "l",
					text = loc.DELAY,
				},
			},
			{
				{
					height = 10,
					type = "Dummy",
					align = "c",
					width = 10,
				},
			},
			{
				{
					type = "Dummy",
					height = 10,
					width = 30,
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
					width = 30,
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
		width = 340,
		useWindow = true,
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