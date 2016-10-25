--
--
--				GHQ_SimpleQuestMenuList
--  			GHQ_SimpleQuestMenuList.lua
--
--	          Handler for the Simple Quest menus
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local class;
function GHQ_SimpleQuestMenuList()
	if class then
		return class;
	end
	class = GHClass("GHI_SimpleQuestMenuList");

	local menus = {};

	local GetMenu = function()
		for i, menu in pairs(menus) do
			if not (menu.IsInUse()) then
				return menu
			end
		end
		local menu = GHQ_SimpleQuestMenu();
		table.insert(menus, menu);
		return menu;
	end

	class.New = function()
		GetMenu().New();
	end
	class.Edit = function(guid)
		GetMenu().Edit(guid);
	end
	class.IsBeingEdited = function(guid)
		for i, menu in pairs(menus) do
			if (menu.IsInUse()) and menu.GetQuestGuid() == guid then
				return true;
			end
		end
		return false
	end
	
	return class;
end

