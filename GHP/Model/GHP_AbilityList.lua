--
--
--				GHP_AbilityList
--  			GHP_AbilityList.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local ABILITY_DATA_SAVE_TABLE = "GHP_AbilityData";

local class;
function GHP_AbilityList()
	if class then
		return class;
	end

	local abilities = {};
	local event = GHI_Event();

	local savedAbilityInfo = GHI_SavedData(ABILITY_DATA_SAVE_TABLE);

	class = GHClass("GHP_AbilityList");

	class.LoadFromSaved = function()
   		local data = savedAbilityInfo.GetAll();
		abilities = {};

		for index,value in pairs(data) do
			abilities[index] = GHP_Ability(value);
		end
	end

	class.GetAbility = function(guid)
		return abilities[guid];
	end

	local SetAbility = function(newAbility)
		local guid = newAbility.GetGuid();
		local existingAbility = abilities[guid];
		if not(existingAbility) or newAbility.GetVersion() > existingAbility.GetVersion() then
			abilities[guid] = newAbility;
			savedAbilityInfo.SetVar(guid,newAbility.Serialize())
			event.TriggerEvent("GHP_ABILITY_UPDATED",guid);
		end
	end

	class.SetAbility = function(value)
		if type(value) == "table" then
			if type(value.IsClass) == "function" then
				if value.IsClass("GHP_Ability") then
					SetAbility(value);
				end
			else
				SetAbility(GHP_Ability(value));
			end
		end
	end

	return class;
end

