--===================================================
--
--				GHP_Main
--  			GHP_Main.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHP_Main()
	if class then
		return class;
	end
	class = GHClass("GHP_Main");

	local Load = function()
		local i = 1;
		while (_G["GHP_D"..i]) do
			local data,obj,func = _G["GHP_D"..i]();
			if _G[obj] then
				local o = _G[obj]();
				for _,d in pairs(data) do
					o[func](d);
				end
			end
			i = i + 1;
		end
	end

	GHP_ProfessionSystemList().LoadFromSaved();
	GHP_ProfessionList().LoadFromSaved();
	GHP_AbilityList().LoadFromSaved();

	GHP_FloorLevelDetermination();

	GHP_QuickBar();


	Load();

	GHP_AbilityAPI();

	GHI_Event().TriggerEvent("GHP_LOADED");
	return class;
end

GHI_Event("GHI_LOADED",GHP_Main);