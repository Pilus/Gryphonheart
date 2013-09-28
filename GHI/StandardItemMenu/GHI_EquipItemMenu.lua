--===================================================
--
--				GHI_EquipItemMenu
--				GHI_EquipItemMenu.lua
--
--		Simple action menu for equiping of wow item
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local loc = GHI_Loc()
local menus = {};
local miscAPI;
local ICON = "Interface\\Icons\\INV_Helmet_03";
local NAME = "GHI_EquipItemMenu";
local TYPE = "equip_item";
local TYPE_LOC = loc.EQUIP_ITEM;

function GHI_EquipItemMenu(_OnOkCallback, _editAction)
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
			menuFrame.ForceLabel("item_name", info.item_name);
			menuFrame.ForceLabel("delay", info.delay);
		else
			class.editAction = nil;
			menuFrame.ForceLabel("item_name", "");
			menuFrame.ForceLabel("delay", "");
		end
		menuFrame:AnimatedShow();
	end

	class.IsInUse = function() return inUse; end

	local OnOk = function()
		local action;

		local itemname = menuFrame.GetLabel("item_name");
		local delay = menuFrame.GetLabel("delay")

		local t = {
			Type = TYPE,
			type_name = TYPE_LOC,
			icon = ICON,
			item_name = itemname,
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
					height = 25,
					width = 10,
					align = "l",
				},
				{
					type = "Text",
					fontSize = 11,
					width = 390,
					text = loc.EQUIP_ITEM_TEXT,
					color = "white",
					align = "l",
				},
			},
			{
				{
					align = "l",
					type = "Editbox",
					texture = "Tooltip",
					text = loc.ITEM_NAME,
					label = "item_name",
					width = 200,
				},
				{
					type = "Time",
					texture = "Tooltip",
					label = "delay",
					align = "r",
					text = loc.DELAY,
				},
			},
			{
				{
					type = "Dummy",
					height = 10,
					width = 55,
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
					width = 55,
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
		width = 375,
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