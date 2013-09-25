--===================================================
--
--				GHI_ViewAttributeMenu
--				GHI_ViewAttributeMenu.lua
--
--		View attribute values for a item instance
--
--		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local menuIndex = 1;

function GHI_ViewAttributeMenu()
	local class = GHClass("GHI_ViewAttributeMenu");

	local loc = GHI_Loc();
	local inUse;
	local currentStack,currentID,UpdateList;

	local modifyAttributeMenuList = GHI_MenuList("GHI_ModifyAttributeMenu");

	local menuFrame;
	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				{
					type = "Dummy",
					height = 30,
					width = 1,
					align = "c",
				},
				{
					type = "Text",
					fontSize = 11,
					width = 335,
					text = "",
					color = "white",
					align = "l",
					label = "menuText",
				},
			},
			{
				{
					type = "List",
					lines = 5,
					align = "l",
					label = "attributes",
					column = {
						{
							type = "Text",
							catagory = loc.NAME,
							width = 85,
							label = "name",
						},
						{
							type = "Text",
							catagory = loc.TYPE,
							width = 85,
							label = "type",
						},
						{
							type = "Text",
							catagory = loc.VALUE,
							width = 85,
							label = "value",
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 85,
							label = "view",
							onClick = function(t)
								modifyAttributeMenuList.New(t.attType,t.attValue,t.name,t.editable,t.editFunc);
							end
						},
					},
					OnLoad = function(obj)
						obj:SetBackdropColor(0, 0, 0, 0.5);
					end,
				},
			},
			{
				{
					type = "Button",
					text = CLOSE,
					align = "c",
					label = "ok",
					compact = false,
					OnClick = function(obj)
						menuFrame:Hide();
					end,
				},
			},
		},
		title = loc.VIEW_ATTRIBUTE_MENU_TITLE,
		name = "GHI_ViewAttribute_Menu" .. menuIndex,
		theme = "BlankTheme",
		width = 365,
		useWindow = true,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	});
	menuIndex = menuIndex + 1;

	class.New = function(stack,id)
		currentStack = stack;
		currentID = id;

		inUse = true;
		menuFrame:AnimatedShow();

		local item  = stack.GetItemInfo();
		local attributes = item.GetAllAttributes();
		local modifyItem = item.IsCreatedByPlayer() or item.IsEditable();

		UpdateList = function()
			local data = {};
			for i,att in pairs(attributes) do
				local name = att.GetName();
				local typeName = loc["ATTYPE_" .. att.GetType():upper()] or att.GetType();
				local value = stack.GetAttribute(name,id);

				if value == nil then
					value = att.GetDefaultValue();
				end

				table.insert(data, {
					name = name,
					type = typeName,
					value = GHM_Input_ToString(att.GetType(),value),
					view = loc.VIEW_MODIFY;
					attValue = value,
					attType = att.GetType(),
					editable = modifyItem or att.CanBeModifiedByAll(),
					editFunc = function(value)
						if modifyItem or att.CanBeModifiedByAll() then
							stack.SetAttribute(name,value,id)
							UpdateList();
						end
					end,
				});
			end
			menuFrame.ForceLabel("attributes", data);
		end
		UpdateList();

		local item = stack.GetItemInfo();
		local stackOrder = item.GetStackOrder();
		local text = string.format(loc.VIEW_ATTRIBUTE_MENU_TEXT,stack.GetItemInstanceAmount(id));
		menuFrame.ForceLabel("menuText",text);
	end

	class.Edit = function(...)
		error("Edit menu for viewing instance is not relevant.")
	end

	class.IsInUse = function()
		return inUse;
	end

	class.GetEditGuid = function()
		return currentStack.GetGUID();
	end

	return class;
end

