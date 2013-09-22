--===================================================
--
--				GHP_ProfessionSystem_SkillSumRule
--  			GHP_ProfessionSystem_SkillSumRule.lua
--
--	          Profession system - For the Skill Sum Rule
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHP_ProfessionSystem_SkillSumRule(info)
	local class = GHP_ProfessionSystem(info);

	local professions;
	local independentAbilities;
	local event = GHI_Event();

	class.GetAllAbilities = function(filter)
		local abilities = {};
		for _,profInstance in pairs(professions) do
			--if not(filter == "shownInSpellbookAndKnown" or filter == "known") or profInstance.IsKnown() then
				abilities[profInstance.GetGuid()] = profInstance.GetAllAbilities(filter);

				--[[local prof = profInstance.GetProfession();
				if prof then

					local profInstanceGuid = profInstance.GetGuid();

				end --]]
			--end
		end
		return abilities;
	end

	class.AbilityIsKnown = function(abilityGuid)
		for _,profInstance in pairs(professions) do
			if  profInstance.IsKnown()  then
				if profInstance.AbilityIsKnown(abilityGuid) then
					return true,class.GetGuid(),profInstance.GetGuid();
				end
			end
		end
		return false;
	end

	class.GetProfessionInstanceGuids = function()
		local t = {};
		for i,v in pairs(professions) do
			table.insert(t,v.GetGuid());
		end
		return t;
	end

	class.AddProfessionInstance = function(value)
		if type(value) == "table" then
			if type(value.IsClass) == "function" then
				if value.IsClass("GHP_ProfessionInstance") then
					table.insert(professions,value);
				end
			else
				table.insert(professions,GHP_ProfessionInstance(value));
			end
		end
	end

	class.LearnProfession = function(profGuid)
		for _,profInstance in pairs(professions) do
			if profInstance.GetGuid() == profGuid then
				if profInstance.LearnProfession() then print("proffesion learned")
					event.TriggerEvent("GHP_PROFESSION_LEARNED",class.GetGuid(),profGuid);
				end
			end
		end
	end

	class.LearnAbility = function(profGuid,abilityGuid)
		for _,profInstance in pairs(professions) do
			if profInstance.GetGuid() == profGuid then
				if profInstance.LearnAbility(abilityGuid) then
					event.TriggerEvent("GHP_ABILITY_LEARNED",class.GetGuid(),profGuid,abilityGuid);
				end
			end
		end
	end

	class.GotPersonalData = function()
		for _,prof in pairs(professions) do
			if prof.GotPersonalData() then
				return true;
			end
		end
		return false;
	end

	class.SetPersonalData = function(data)
		for _,subdata in pairs(data) do
			if type(subdata) == "table" then
				local guid = subdata.guid;
				for _,prof in pairs(professions) do
					if prof.GetGuid() == guid then
						prof.SetPersonalData(subdata);
					end
				end
			end
		end
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or {};

		t.independentAbilities = {}
		if not(stype) or stype == "nonpersonal" then
			t.type = "SkillSumRule";
		end
		if not(stype) or stype == "personal" then
			for _,ab in pairs(independentAbilities) do
				table.insert(t.independentAbilities,{
					guid = ab.guid,
					known = ab.known,
				})
			end
		elseif stype == "nonpersonal" then
			for _,ab in pairs(independentAbilities) do
				table.insert(t.independentAbilities,{
					guid = ab.guid,
				})
			end
		end

		t.professions = {};
		for _,prof in pairs(professions) do
			table.insert(t.professions,prof.Serialize(stype));
		end




		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	professions = {};
	for _,v in pairs(info.professions or {}) do
		table.insert(professions,GHP_ProfessionInstance(v));
	end

	independentAbilities = {};
	for _,v in pairs(info.independentAbilities or {}) do
		table.insert(independentAbilities,{
			guid = v.guid,
			known = v.known,
		});
	end

	return class;
end

