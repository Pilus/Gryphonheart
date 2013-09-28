--===================================================
--
--				GHI_ConsumeItemMenu
--			GHI_ConsumeItemMenu.lua
--
--				Simple action menu
--
--		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local loc = GHI_Loc()
local menus = {};
local miscAPI;
local ICON = "Interface\\Icons\\Spell_ChargeNegative";
local NAME = "GHI_ConsumeItemMenu";
local TYPE = "consume_item";
local TYPE_LOC = loc.CONSUME;

function GHI_ConsumeItemMenu(_OnOkCallback, _editAction)
	if not (miscAPI) then miscAPI = GHI_MiscAPI().GetAPI(); end
	local itemlist = GHI_ItemInfoList()
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
			local guid = info.id;
			local item = itemlist.GetItemInfo(guid or "");
			if item then
				local lines = item.GetTooltipLines(guid)

				local infoLine = "";
				for _, line in pairs(lines) do


					local linetext = miscAPI.GHI_ColorString(line.text, line.r, line.g, line.b)

					if infoLine == "" then
						infoLine = linetext;
					else
						infoLine = infoLine .. "\n" .. linetext;
					end
				end
				menuFrame.ForceLabel("ItemInfo", infoLine)
				menuFrame.produceGuid = guid;
			else
				menuFrame.ForceLabel("ItemInfo", loc.NO_ITEM_SELECTED);
			end
			menuFrame.ForceLabel("amount", info.amount);
               menuFrame.ForceLabel("delay", info.delay);
		else
			class.editAction = nil;
			menuFrame.ForceLabel("amount", "");
			menuFrame.ForceLabel("ItemInfo", loc.NO_ITEM_SELECTED);
                menuFrame.ForceLabel("delay", 0);
		end
		menuFrame:AnimatedShow();
	end

	class.IsInUse = function() return inUse; end

	local OnOk = function()
		local action;

		local amount = menuFrame.GetLabel("amount");
		local ItemInfo = menuFrame.GetLabel("ItemInfo");
		local delay = menuFrame.GetLabel("delay");

		local t = {
			Type = "script",
			dynamic_rc_type = TYPE,
			type_name = TYPE_LOC,
			icon = ICON,
			details = string.sub(ItemInfo, 0, 100),
			amount = amount,
			dynamic_rc = true,
			id = menuFrame.produceGuid,
			delay=delay;
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
					text = loc.CONSUME_TEXT,
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
					type = "Dummy",
					height = 30,
					width = 44,
					align = "r",
				},
				{
					type = "Button",
					label = "choose_item",
					align = "l",
					text = loc.CHOOSE_ITEM,
					compact = true,
					OnClick = function(self)

						miscAPI.GHI_SetSelectItemCursor(function(guid)
							local item = itemlist.GetItemInfo(guid)
							local lines = item.GetTooltipLines(guid)

							local infoLine = "";
							for _, line in pairs(lines) do
								local linetext = miscAPI.GHI_ColorString(line.text, line.r, line.g, line.b)

								if infoLine == "" then
									infoLine = linetext;
								else
									infoLine = infoLine .. "\n" .. linetext;
								end
							end
							menuFrame.ForceLabel("ItemInfo", infoLine)
							menuFrame.produceGuid = guid;
						end);
					end
				},
			},
			{
				{
					fontSize = 11,
					label = "ItemInfo",
					align = "l",
					text = "Item info",
					type = "Text",
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
		lineSpacing = 10,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	});

	class.Show(_OnOkCallback, _editAction)

	return class;
end