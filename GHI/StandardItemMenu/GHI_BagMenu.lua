--===================================================
--
--					GHI_BagMenu
--				GHI_BagMenu.lua
--
--				Simple action menu
--
--		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local loc = GHI_Loc()
local menus = {};
local miscAPI;
local ICON = "Interface\\Icons\\INV_Misc_Bag_09_Blue";
local NAME = "GHI_BagMenu";
local TYPE = "bag";
local TYPE_LOC = loc.BAG;

function GHI_BagMenu(_OnOkCallback, _editAction)
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

	local textures = { "-Normal", "-Bank", "-Keyring" };
	local textures_loc = { loc.NORMAL, loc.BANK, loc.KEYRING };

	class.Show = function(_OnOkCallback, _editAction)
		OnOkCallback = _OnOkCallback;
		inUse = true;
		if (_editAction) then
			class.editAction = _editAction;
			local info = class.editAction.GetInfo();
			menuFrame.ForceLabel("size", info.size);
			menuFrame.ForceLabel("texture", 1);
			for i, tex in pairs(textures) do
				if tex == info.texture then
					menuFrame.ForceLabel("texture", i);
				end
			end
			menuFrame.ForceLabel("tradeable",info.tradeable);
		else
			class.editAction = nil;
			menuFrame.ForceLabel("size", 8);
			menuFrame.ForceLabel("texture", 1);
			menuFrame.ForceLabel("tradeable",false);
		end
		menuFrame:AnimatedShow();
	end

	class.IsInUse = function() return inUse; end

	local OnOk = function()
		local action;

		local size = menuFrame.GetLabel("size");
		local textureI = menuFrame.GetLabel("texture");
		local tradeable = menuFrame.GetLabel("tradeable");

		local t = {
			Type = TYPE,
			type_name = TYPE_LOC,
			icon = ICON,
			details = string.format(loc.SLOTS_NUMBER, size),
			size = size,
			texture = textures[textureI],
			tradeable = tradeable,
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
					width = 400,
					text = loc.BAG_TEXT,
					color = "white",
					align = "l",
				},
			},
			{
				{
					type = "SlotSlider",
					label = "size",
					align = "l",
					text = loc.SLOTS,
					width = 150,
				},
				{
					type = "RadioButtonSet",
					texture = "Tooltip",
					label = "texture",
					align = "r",
					text = loc.TEXTURE,
					data = textures_loc,
					returnIndex = true,
				},
			},
			{
				{
					align = "l",
					type = "CheckBox",
					text = loc.BAG_TRADEABLE,
					label = "tradeable",
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
		----background = "INTERFACE\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains",
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