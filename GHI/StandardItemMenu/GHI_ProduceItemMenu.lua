--
--
--				GHI_ProduceItemMenu
--				GHI_ProduceItemMenu.lua
--
--				Simple action menu
--
-- 			(c)2013 The Gryphonheart Team
--				All rights reserved
--
local loc = GHI_Loc()
local menus = {};
local miscAPI;

local ICON = "Interface\\Icons\\Spell_ChargePositive";
local NAME = "GHI_ProduceItemMenu";
local TYPE = "produce_item";
local TYPE_LOC = loc.PRODUCE_ITEM;

function GHI_ProduceItemMenu(_OnOkCallback, _editAction)
	local class = GHClass(NAME);

	if not (miscAPI) then miscAPI = GHI_MiscAPI().GetAPI(); end
	local itemlist = GHI_ItemInfoList();

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

	table.insert(menus, class);

	local menuFrame, OnOkCallback;
	local inUse = false;
	local menuIndex = 1;
	while _G[NAME .. menuIndex] do menuIndex = menuIndex + 1; end

	local GetItemTextLine = function(guid)
		local item = itemlist.GetItemInfo(guid)
		local lines = item.GetTooltipLines()

		local infoLine = "";
		for _, line in pairs(lines) do
			local linetext = miscAPI.GHI_ColorString(line.text, line.r, line.g, line.b)

			if infoLine == "" then
				infoLine = linetext;
			else
				infoLine = infoLine .. "\n" .. linetext;
			end
		end
		return infoLine;
	end


	class.Show = function(_OnOkCallback, _editAction)
		OnOkCallback = _OnOkCallback;
		inUse = true;
		if (_editAction) then
			class.editAction = _editAction;
			local info = class.editAction.GetInfo();
			menuFrame.ForceLabel("loot_text", info.loot_text);
			menuFrame.ForceLabel("amount", info.amount);
			menuFrame.ForceLabel("delay", info.delay);
			menuFrame.ForceLabel("ItemInfo", GetItemTextLine(info.guid or info.id));
			menuFrame.produceGuid = info.guid or info.id;
		else
			class.editAction = nil;
			menuFrame.ForceLabel("loot_text", loc.LOOT);
			menuFrame.ForceLabel("amount", 1);
			menuFrame.ForceLabel("delay", 0);
			menuFrame.ForceLabel("ItemInfo", loc.NO_ITEM_SELECTED);
		end
		menuFrame:AnimatedShow();
	end

	class.IsInUse = function() return inUse; end

	local OnOk = function()
		local action;

		local loot_text = menuFrame.GetLabel("loot_text");
		local amount = menuFrame.GetLabel("amount");
		local delay = menuFrame.GetLabel("delay");
		local ItemInfo = menuFrame.GetLabel("ItemInfo");

		local t = {
			Type = "script",
			type_name = TYPE_LOC,
			icon = ICON,
			details = string.sub(ItemInfo, 0, 100),
			loot_text = loot_text,
			amount = amount,
			delay = delay,
			dynamic_rc = true,
			dynamic_rc_type = TYPE,
			--ItemInfo = ItemInfo,
			guid = menuFrame.produceGuid,
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
					type = "Text",
					fontSize = 11,
					height = 30,
					text = loc.PRODUCE_TEXT,
					color = "white",
					align = "l",
				},
			},
			{
				{
					type = "Editbox",
					texture = "Tooltip",
					label = "amount",
					align = "r",
					text = loc.AMOUNT,
					numbersOnly = true,
					width = 45,
				},
				{
					type = "DropDown",
					texture = "Tooltip",
					label = "loot_text",
					align = "l",
					text = loc.MESSAGE_TEXT,
					data = {
						loc.LOOT,
						loc.CREATE,
						loc.CRAFT,
						loc.RECIEVE,
						loc.PRODUCE,
					},
					returnIndex = false,
				},
			},
			{
				{
					type = "Button",
					label = "choose_item",
					align = "l",
					text = loc.CHOOSE_ITEM,
					compact = true,
					OnClick = function(self)
						miscAPI.GHI_SetSelectItemCursor(function(guid)
							menuFrame.ForceLabel("ItemInfo", GetItemTextLine(guid))
							menuFrame.produceGuid = guid;
						end);
					end
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
					fontSize = 11,
					label = "ItemInfo",
					align = "l",
					text = "Item info",--todo: localize
					type = "Text",
				},
			},
			{
				{
					height = 20,
					type = "Dummy",
					align = "c",
					width = 10,
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
		width = 370,
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