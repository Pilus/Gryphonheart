--
--
--				GHM_ColorPickerList
--  			GHM_ColorPickerList.lua
--
--	          Handler for the Icon Picker windows
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local class;
function GHM_ColorPickerList()
	if class then
		return class;
	end
	class = GHClass("GHM_ColorPickerList");

	local menus = {};

	local GetMenu = function()
		for i, menu in pairs(menus) do
			if not (menu.IsInUse()) then
				return menu
			end
		end
		local menu = GHM_ColorPicker();
		table.insert(menus, menu);
		return menu;
	end

	class.New = function(_callback, hex)
		GetMenu().New(_callback, hex);
	end
	
	class.Edit = function(color,_callback, hex)
		GetMenu().Edit(color,_callback, hex);
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

