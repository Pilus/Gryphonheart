--
--
--				GHI_AdvancedItemMenuList
--				GHI_AdvancedItemMenuList.lua
--
--		List of menu for advanced items
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--
local class;
function GHI_AdvancedItemMenuList()
	if class then
		return class;
	end
	class = GHClass("GHI_AdvancedItemMenuList");
	local menus = {};

	local GetMenu = function()
		for i, menu in pairs(menus) do
			if not (menu.IsInUse()) then
				return menu
			end
		end
		local menu = GHI_AdvancedItemMenu();
		table.insert(menus, menu);
		return menu;
	end

	class.New = function(itemInProgress)
		GetMenu().New(itemInProgress);
	end

	class.Edit = function(itemInProgress)
		GetMenu().Edit(itemInProgress);
	end

	class.IsBeingEdited = function(guid)
		for i, menu in pairs(menus) do
			if (menu.IsInUse()) and menu.GetItemGuid() == guid then
				return true;
			end
		end
		return false
	end

	return class;
end
