--===================================================
--
--				GHP_AbilityAPI
--  			GHP_AbilityAPI.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local ABILITY_ORDER = {
	["nil"] = 1,
	interactionWithObjectOrItem = 2,
	passive = 3,
};

local actionBar,cursor;
function GHP_AbilityAPI(userGuid)
	local class = GHClass("GHP_AbilityAPI");

	local systemList = GHP_ProfessionSystemList();
	local professionList = GHP_ProfessionList();
	local abilityList = GHP_AbilityList();
	local loc = GHP_Loc();
	local errorThrower = GHI_ErrorThrower();

	class.GetNumSpellbookAbilities = function(systemGuid)
		local system = systemList.GetSystem(systemGuid);
		if system then
			local c = 0;
			local profs = system.GetAllAbilities("shownInSpellbookAndKnown");
			for profGuid,abilityInstanceGuids in pairs(profs) do
				c = c + #(abilityInstanceGuids);
			end
			return c;
		end
		return 0;
	end

	local GetSpellbookAbilityInfoFromGuids = function(systemGuid,professionGuid,abilityGuid)
		if professionGuid and abilityGuid then
			local ability = abilityList.GetAbility(abilityGuid);
			if ability then
				local guid,name,icon = ability.GetInfo()
				return guid,name,icon,loc["ABILITY_TYPE_"..(ability.GetAbilityType() or "")];
			end
		end
	end

	local CompareAbilities = function(a1,a2)
		return (ABILITY_ORDER[a1.abilityType] or 999) > (ABILITY_ORDER[a2.abilityType] or 999);
	end

	local InsertAbilityInOrder = function(t,a)
		for i=1,#(t) do
	   		if CompareAbilities(t[i],a) then
				table.insert(t,i,a);
				return
			end
		end
		table.insert(t,a);
	end

	local GetAllAbilitiesOrdered = function(systemGuid)
		local system = systemList.GetSystem(systemGuid);
		local t = {}
		if system then
			local profs = system.GetAllAbilities("shownInSpellbook");
			for profGuid,abilityGuids in pairs(profs) do
				for _,abilityGuid in pairs(abilityGuids) do
					local ability = abilityList.GetAbility(abilityGuid);
					if ability then
						InsertAbilityInOrder(t,{
							abilityGuid = abilityGuid,
							profGuid = profGuid,
							abilityType = ability.GetAbilityType() or "nil",
						})
					end
				end
			end
		end
		return t
	end

	local GetProfAndAbilityInstanceGuids = function(systemGuid,index)
		local t = GetAllAbilitiesOrdered(systemGuid)
		if t[index] then
			return t[index].profGuid,t[index].abilityGuid;
		end
	end

	class.GetSpellbookAbilityInfo = function(systemGuid,i,...)
		if type(i) == "number" then
			return GetSpellbookAbilityInfoFromGuids(systemGuid,GetProfAndAbilityInstanceGuids(systemGuid,i));
		else
			return GetSpellbookAbilityInfoFromGuids(systemGuid,i,...);
		end
	end

	class.GetSpellbookAbilityGuids = function(systemGuid,i)

		return systemGuid,GetProfAndAbilityInstanceGuids(systemGuid,i);
	end

	local GetCooldown = function(systemGuid,professionGuid,abilityGuid)
		if abilityGuid then
			local ability = abilityList.GetAbility(abilityGuid);
			if ability then
				return ability.GetCooldown();
			end
		end
	end

	class.GetAbilityCooldown = function(systemGuid,i,...)
		if type(i) == "number" then
			return GetCooldown(systemGuid,GetProfAndAbilityInstanceGuids(systemGuid,i));
		else
			return GetCooldown(systemGuid,i,...);
		end
	end
	local CanPickupOrExecute = function(abilityGuid)
		local ability = abilityList.GetAbility(abilityGuid);
		if ability then
			return not(ability.GetAbilityType());
		end
		return false;
	end

	local ExecuteAbility = function(systemGuid,professionGuid,abilityGuid)
		if professionGuid and abilityGuid and CanPickupOrExecute(abilityGuid) then
			local ability = abilityList.GetAbility(abilityGuid);
			local profession = professionList.GetProfession(professionGuid);

			if ability and profession then
				local _,elapsed = ability.GetCooldown();
				if not(elapsed) then
					local instance = profession.GetAbilityInstance(abilityGuid);
					instance.Execute(systemGuid,professionGuid,abilityGuid);
				else
			   		errorThrower.CantUseItem(loc.ABILITY_NOT_READY_YET);
				end
			end
		end
	end



	class.ExecuteAbility = function(systemGuid,i,...)
		if type(i) == "number" then
			return ExecuteAbility(systemGuid,GetProfAndAbilityInstanceGuids(systemGuid,i));
		else
			return ExecuteAbility(systemGuid,i,...);
		end
	end

	if not(actionBar) then
		cursor = GHI_CursorHandler();
		actionBar = GHI_ActionBarUI(
			"GHP_ABILITY",
			function(guid)
				if type(guid) == "table" then
					local systemGuid,profGuid,abilityGuid,objGuid = unpack(guid);
					ExecuteAbility(systemGuid,profGuid,abilityGuid,objGuid);
				end
			end,
			function(guid)
				-- get info function
				if type(guid)=="table" then
					local systemGuid,profGuid,abilityGuid,objGuid = unpack(guid);
					local _,_,icon = GetSpellbookAbilityInfoFromGuids(systemGuid,profGuid,abilityGuid);
					local cd,elapsed = GetCooldown(systemGuid,profGuid,abilityGuid);
					return icon,1,cd,elapsed;
				end
			end,
			function(btn,guid)
				-- tooltip function
			end,
			"GHP_ABILITY_UPDATED"
		);
		cursor.SetActionBarHandler(actionBar);
	end

	local PickupAbility = function(systemGuid,profGuid,abilityGuid,objGuid)
		if CanPickupOrExecute(abilityGuid) then
			local _,_,icon = GetSpellbookAbilityInfoFromGuids(systemGuid,profGuid,abilityGuid,objGuid);
			cursor.SetCursor("ITEM", icon, function() end, function() end, "GHP_ABILITY", systemGuid, profGuid, abilityGuid, objGuid);
		end
	end

	class.PickupAbility = function(systemGuid,i,...)
		if type(i) == "number" then
			return PickupAbility(systemGuid,GetProfAndAbilityInstanceGuids(systemGuid,i));
		else
			return PickupAbility(systemGuid,i,...);
		end
	end

	class.GetAbility = function(abilityGuid)
		local ability = abilityList.GetAbility(abilityGuid);
		if ability then
			local a = {};

			a.GetInfo = function()
				return ability.GetInfo();
			end

			return a;
		end
	end

	local performUIList = GHI_MenuList("GHP_PerformActionUI");
	class.DisplayPerformUI = function(...)
		performUIList.New(...);
	end

	return class;
end

