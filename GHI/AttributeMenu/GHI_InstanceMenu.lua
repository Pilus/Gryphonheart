--
--
--				GHI_InstanceMenu
--				GHI_InstanceMenu.lua
--
--	Menu for inspecting the content of an item instance
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--
local menuIndex = 1;

function GHI_InstanceMenu()
	local class = GHClass("GHI_InstanceMenu");

	local loc = GHI_Loc();
	local inUse;
	local currentStack, showViewAttributeMenu;

	local menuFrame;
	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				{
					type = "Text",
					fontSize = 11,
					text = "",
					color = "white",
					align = "l",
					label = "instanceText",
				},
			},
			{
				{
					type = "List",
					lines = 5,
					align = "l",
					label = "instances",
					column = {
						{
							type = "Text",
							catagory = loc.ID,
							width = 60,
							label = "id",
						},
						{
							type = "Text",
							catagory = loc.AMOUNT,
							width = 60,
							label = "amount",
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 60,
							label = "view",
							onClick = function(t)
								showViewAttributeMenu(t.id);
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
		title = loc.INSTANCE_MENU_TITLE,
		name = "GHI_Instance_Menu" .. menuIndex,
		theme = "BlankTheme",
		width = 210,
		useWindow = true,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	});
	menuIndex = menuIndex + 1;

	local attributeMenuList = GHI_MenuList("GHI_ViewAttributeMenu");
	showViewAttributeMenu = function(id)
		attributeMenuList.New(currentStack,id)
	end

	class.New = function(stack)
		currentStack = stack;
		if stack.GetItemInstanceCount()  == 1 then
			showViewAttributeMenu(1);
		else
			inUse = true;
			menuFrame:AnimatedShow();

			local instancesSorted = {stack.GetAllInstancesSorted()};
			local instances = stack.GetAllItemInstances();
			local data = {};
			for i = 1, #(instancesSorted) do
				local id = 0;
				for j = 1,#(instances) do
					if instances[j] == instancesSorted[i] then
						id = j;
					end
				end

				table.insert(data, {
					id = id,
					amount = instancesSorted[i].amount,
					view = loc.VIEW;
				});
			end
			menuFrame.ForceLabel("instances", data);
			local item = stack.GetItemInfo();
			local stackOrder = item.GetStackOrder();
			local text = string.format(loc.INSTANCE_MENU_TEXT,stack.GetItemInstanceCount(),stackOrder);
			menuFrame.ForceLabel("instanceText",text);
		end
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

