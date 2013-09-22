--===================================================
--
--				GHP_ProfessionInstance
--  			GHP_ProfessionInstance.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHP_ProfessionInstance(info)
	local class = GHClass("GHP_ProfessionInstance");

	local professionList = GHP_ProfessionList();
	local abilityList = GHP_AbilityList();

	local guid,skillLevel,abilitiesKnown;

	class.GetProfession = function()
		return professionList.GetProfession(guid);
	end

	class.GetGuid = function()
		return guid;
	end

	class.AbilityIsKnown = function(abilityGuid)
		for _,v in pairs(abilitiesKnown) do
			if v == abilityGuid then
				return true;
			end
		end
		return false;
	end

	class.IsKnown = function()
		return skillLevel > 0;
	end

	class.LearnProfession = function()
		if not(class.IsKnown()) then
			skillLevel = 1;
			return true;
		end
		return false;
	end

	class.LearnAbility = function(abilityGuid)
		if not(class.AbilityIsKnown(abilityGuid)) then
			table.insert(abilitiesKnown,abilityGuid);
			return true;
		end
		return false;
	end

	class.GetAllAbilities = function(filter)
		local prof = class.GetProfession();
		if not(filter == "shownInSpellbookAndKnown" or filter == "known") then
			return prof.GetAllAbilities(filter);
		end
		if not(class.IsKnown()) then
			return
		end

		local abilitiesInProfession = prof.GetAllAbilities(filter);

		local abilities = {};
		for _,abilityGuid in pairs(abilitiesInProfession) do -- for each ability

			if class.AbilityIsKnown(abilityGuid) then
				table.insert(abilities,abilityGuid)
			end
		end
		return abilities;
	end

	class.GotPersonalData = function()
		return skillLevel > 0 or #(abilitiesKnown) > 0;
	end

	class.SetPersonalData = function(data)
		skillLevel = data.skillLevel or 0;
		abilitiesKnown = data.abilitiesKnown or {};
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or {};

		t.guid = guid;
		if not(stype) or stype == "personal" then
			t.skillLevel = skillLevel;
			t.abilitiesKnown = abilitiesKnown;
		end

		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	guid = info.guid;
	class.SetPersonalData(info);


	return class;
end

