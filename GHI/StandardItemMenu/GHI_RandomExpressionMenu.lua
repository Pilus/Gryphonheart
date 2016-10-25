--
--
--			GHI  Random Expression Menu
--			GHI_RandomExpressionMenu.lua
--
--				Simple action menu
--
-- 			(c)2013 The Gryphonheart Team
--				All rights reserved
--
local loc = GHI_Loc()
local menus = {};
local miscAPI;
local ICON = "Interface\\Icons\\Ability_Warrior_RallyingCry";
local NAME = "GHI_RandomExpressionMenu";
local TYPE = "random_expression";
local TYPE_LOC = loc.RANDOM_EXPRESSION;

function GHI_RandomExpressionMenu(_OnOkCallback, _editAction)
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
			for i = 1, 6 do
				menuFrame.ForceLabel("text" .. i, info.text[i] or "");
				menuFrame.ForceLabel("type" .. i, info.expression_type[i] or 1);
			end;
			menuFrame.ForceLabel("allowSame", info.allow_same)
		else
			class.editAction = nil;
			for i = 1, 6 do
				menuFrame.ForceLabel("text" .. i, "");
				menuFrame.ForceLabel("type" .. i, 1);
			end
			menuFrame.ForceLabel("allowSame", 0);
		end
		menuFrame:AnimatedShow();
	end

	class.IsInUse = function() return inUse; end

	local OnOk = function()
		local action;

		local texts = {};
		local types = {};
		for i = 1, 6 do
			local text = menuFrame.GetLabel("text" .. i);
			if string.len(text) > 0 then
				table.insert(texts, text);
				table.insert(types, menuFrame.GetLabel("type" .. i));
			end
		end

		local t = {
			Type = TYPE,
			type_name = TYPE_LOC,
			icon = ICON,
			details = string.sub(#(texts) .. " expressions", 0, 100),
			text = texts,
			expression_type = types,
			allow_same = menuFrame.GetLabel("allowSame"),
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

	local GenerateTextBoxAndType = function(index)
		return {
			{
				align = "l",
				type = "Editbox",
				text = loc.TEXT;
				label = "text" .. index,
				texture = "Tooltip",
				OnTextChanged = function(self)
				end,
				width = 200,
			},
			{
				type = "RadioButtonSet",
				text = loc.TYPE,
				align = "r",
				label = "type" .. index,
				texture = "Tooltip",
				returnIndex = true,
				data = { loc.SAY, loc.EMOTE },
			},
		};
	end;

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
					text = loc.RANDOM_EXPRESSION_TEXT,
					color = "white",
					align = "l",
				},
			},
			GenerateTextBoxAndType(1),
			GenerateTextBoxAndType(2),
			GenerateTextBoxAndType(3),
			GenerateTextBoxAndType(4),
			GenerateTextBoxAndType(5),
			GenerateTextBoxAndType(6),
			{
				{
					type = "CheckBox",
					text = loc.RANDOM_EXPRESSION_ALLOW_SAME,
					align = "l",
					label = "allowSame",
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