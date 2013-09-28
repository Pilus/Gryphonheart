--===================================================
--
--				GHI_MenuList
--  			GHI_MenuList.lua
--
--	Dynamic list for any type of menu with the correct interface
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local classes = {};
function GHI_MenuList(menuName)
	if classes[menuName] then
		return classes[menuName];
	end

	local class = GHClass("GHI_MenuList");
	classes[menuName] = class;

	if not(type(_G[menuName])=="function") then
		print("no menu function",menuName);
	end

	local menus = {};

	local GetMenu = function()
		for i, menu in pairs(menus) do
			if not (menu.IsInUse()) then
				return menu
			end
		end
		local menu = _G[menuName]();
		table.insert(menus, menu);
		return menu;
	end

	class.New = function(...)
		GetMenu().New(...);
	end

	class.Edit = function(...)
		GetMenu().Edit(...);
	end

	class.IsBeingEdited = function(guid)
		for i, menu in pairs(menus) do
			if (menu.IsInUse()) and menu.GetEditGuid() == guid then
				return true;
			end
		end
		return false
	end

	return class;
end

