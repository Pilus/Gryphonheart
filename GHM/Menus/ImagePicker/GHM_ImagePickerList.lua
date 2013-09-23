--===================================================
--
--				GHM_ImagePickerList
--  			GHM_ImagePickerList.lua
--
--	          Handler for the Icon Picker windows
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHM_ImagePickerList()
	if class then
		return class;
	end
	class = GHClass("GHM_ImagePickerList");

	local menus = {};

	local GetMenu = function()
		for i, menu in pairs(menus) do
			if not (menu.IsInUse()) then
				return menu
			end
		end
		local menu = GHM_ImagePicker();
		table.insert(menus, menu);
		return menu;
	end

	class.New = function(_callback)
		GetMenu().New(_callback);
	end
	class.Edit = function(icon, x, y,_callback)
		GetMenu().Edit(icon, x, y,_callback);
	end
	class.IsBeingEdited = function()
		for i, menu in pairs(menus) do
			if (menu.IsInUse()) then
				return true;
			end
		end
		return false
	end

	return class;
end

