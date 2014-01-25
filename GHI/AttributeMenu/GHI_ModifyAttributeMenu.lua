--===================================================
--
--				GHI_ModifyAttributeMenu
--				GHI_ModifyAttributeMenu.lua
--
--		Menu for modifying of attribute values
--			in an item instance
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local menuIndex = 1;

function GHI_ModifyAttributeMenu()
	local class = GHClass("GHI_ModifyAttributeMenu");

	local loc = GHI_Loc();
	local inUse;
	local attType,attValue,attName

	class.New = function(_attType,_attValue,_attName,canEdit,editFunc)
		attType,attValue,attName = _attType,_attValue,_attName;

		local title = string.format(loc.MODIFY_ATTRIBUTE_MENU_TITLE,attName);
		if not(canEdit) then
			title = string.format(loc.MODIFY_ATTRIBUTE_MENU_TITLE_VIEW,attName);
		end

		local menuFrame;
		local t =  {
			onOk = function(self) end,
			{
				{
					type = "Dummy",
					height = 10,
					width = 1,
					align = "c",
				},
				{
				},
				{
					type = "Dummy",
					height = 10,
					width = 1,
					align = "c",
				},
			},
			title = title,
			name = "GHI_MODIFY_Attribute_Menu" .. menuIndex,
			theme = "BlankTheme",
			width = 300,
			useWindow = true,
			OnHide = function()
				if not (menuFrame.window:IsShown()) then
					inUse = false;
				end
			end,
		};

		table.insert(t[1][2],GHM_Input_GenerateMenuObject(attType, attName..":", "attribute", true));

		if canEdit then
			t[1][4]= {
				{
					type = "Dummy",
					height = 10,
					width = 50,
					align = "l",
				},
				{
					type = "Button",
					text = OKAY,
					align = "l",
					label = "ok",
					compact = false,
					OnClick = function(obj)
						editFunc(menuFrame.GetLabel("attribute"));
						menuFrame:Hide();
					end,
				},
				{
					type = "Dummy",
					height = 10,
					width = 50,
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
				}
			};
		else
			t[1][4] = {
				{
					type = "Button",
					text = CLOSE,
					align = "c",
					label = "close",
					compact = false,
					OnClick = function(obj)
						menuFrame:Hide();
					end,
				}
			}
		end

		menuFrame = GHM_NewFrame(class,t);
		menuIndex = menuIndex + 1;

		inUse = true;
		menuFrame:AnimatedShow();
		menuFrame.ForceLabel("attribute",attValue);
	end

	class.Edit = function(...)
		error("Edit menu for viewing instance is not relevant.")
	end

	class.IsInUse = function()
		return inUse;
	end

	return class;
end

