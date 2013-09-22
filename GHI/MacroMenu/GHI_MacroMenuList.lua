--===================================================
--
--				GHI_MacroMenuList
--  			GHI_MacroMenuList.lua
--
--	          Handler for the Macro menus
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_MacroMenuList()
	if class then
		return class;
	end
	class = GHClass("GHI_MacroMenuList");

	local menus = {};

	local GetMenu = function()
		for i, menu in pairs(menus) do
			if not (menu.IsInUse()) then
				return menu
			end
		end
		local menu = GHI_MacroMenu();
		table.insert(menus, menu);
		return menu;
	end

	class.New = function()
		GetMenu().New();
	end
	
	return class;
end

