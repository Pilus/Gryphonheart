--===================================================
--
--				GHI_ExpressionMenu
--				GHI_ExpressionMenu.lua
--
--		Menu for GHI_Expression action
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local loc = GHI_Loc()
local menus = {};
local miscAPI;
local icon = "Interface\\Icons\\Spell_Shadow_SoothingKiss";
local expressionTypes = { "Say", "Emote" };
local expressionTypesName = { loc.SAY,loc.EMOTE };

function GHI_ExpressionMenu(_OnOkCallback, _editAction)
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
	local class = GHClass("GHI_ExpressionMenu");
	table.insert(menus, class);

	local menuFrame, OnOkCallback;
	local inUse = false;
	local menuIndex = 1;
	while _G["GHI_ExpressionMenu" .. menuIndex] do menuIndex = menuIndex + 1; end


	class.Show = function(_OnOkCallback, _editAction)
		OnOkCallback = _OnOkCallback;
		inUse = true;
		if (_editAction) then
			class.editAction = _editAction;
			local info = class.editAction.GetInfo();
			menuFrame.ForceLabel("text", info.text);
			menuFrame.ForceLabel("type", 1);

			for i, eType in pairs(expressionTypes) do
				if string.lower(eType) == string.lower(info.expression_type) then
					menuFrame.ForceLabel("type", i);
				end
			end

			menuFrame.ForceLabel("delay", info.delay);
		else
			class.editAction = nil;
			menuFrame.ForceLabel("text", "");
			menuFrame.ForceLabel("type", 1);
			menuFrame.ForceLabel("delay", 0);
		end
		menuFrame:AnimatedShow();
	end

	class.IsInUse = function() return inUse; end

	local OnOk = function()
		local action;
		local text = menuFrame.GetLabel("text");
		local expressionType = menuFrame.GetLabel("type");
		local delay = menuFrame.GetLabel("delay");

		local t = {
			Type = "expression",
			type_name = loc.EXPRESSION,
			icon = icon,
			details = (expressionTypesName[expressionType] or "") .. ": " .. string.sub(text, 0, 100),
			text = text,
			expression_type = expressionTypes[expressionType],
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
					type = "Text",
					fontSize = 11,
					width = 390,
					text = loc.EXPRESSION_TEXT,
					color = "white",
					align = "l",
				},
			},
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.TEXT;
					label = "text",
					texture = "Tooltip",
					OnTextChanged = function(self)
					end,
					width = 200,
				},
			},
			{
				{
					type = "RadioButtonSet",
					text = loc.TYPE,
					align = "l",
					label = "type",
					texture = "Tooltip",
					returnIndex = true,
					data = { loc.SAY, loc.EMOTE },
				},
				{
					align = "r",
					type = "Time",
					text = loc.DELAY;
					label = "delay",
					texture = "Tooltip",
				},
			},
			{
				{
					type = "Text",
					fontSize = 11,
					width = 380,
					text = string.gsub(loc.EXPRESSION_TIP,"|CFFFFD100",string.format("|CFF%s",GHM_ColorToHex(GHM_GetHeadTextColor()))),
					color = "white",
					align = "l",
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
		title = loc.EXPRESSION,
		name = "GHI_ExpressionMenu" .. menuIndex,
		theme = "BlankTheme",
		width = 400,
		useWindow = true,
		OnShow = UpdateTooltip,
		icon = icon,
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


