--===================================================
--
--				GHP_Profession
--  			GHP_Profession.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHP_Profession(info)
	local class = GHP_AuthorInfo(info,"GHP_Profession");

	local name,icon,guid,version;
	local abilities = {};
	local objectSpawners = {};

	local InsertAbilityInOrder = function(abilityInstance)
		local lvl = abilityInstance.GetSkillLevels() or 0;
		for i,otherInstance in pairs(abilities) do
			local otherLvl = otherInstance.GetSkillLevels() or 0;
			if lvl < otherLvl then
				table.insert(abilities,i,abilityInstance);
				return
			end
		end
		table.insert(abilities,abilityInstance);
	end

	class.GetGuid = function()
		return guid;
	end

	class.GetNumAbilities = function()
		return #(abilities);
	end

	class.GetInfo = function()
		return guid,name,icon;
	end

	class.GetAllAbilities = function(filter)
		local t = {};

		for i,abilityInstance in pairs(abilities) do
			local ability = abilityInstance.GetAbility();
			if filter == "shownInSpellbook" or filter == "shownInSpellbookAndKnown" then
				if ability.ShownInSpellbook() then
					table.insert(t,ability.GetGuid());
				end
			else
				table.insert(t,ability.GetGuid());
			end
		end

		return t;
	end

	class.GetVersion = function()
		return version;
	end

	class.GotPersonalData = function()
		for _,spawner in pairs(objectSpawners) do
			if spawner.GotPersonalData() then
				return true;
			end
		end
		return false;
	end

	class.SetPersonalData = function(data)
		for _,subdata in pairs(data.objectSpawners or {}) do
			for _,spawner in pairs(objectSpawners) do
				if spawner.GetGuid() == subdata.guid then
					spawner.SetPersonalData(subdata);
					break;
				end
			end
		end
	end

	class.GetAbilityInstance = function(instanceGuid)
		for _,ability in pairs(abilities) do
			if ability.GetAbilityGuid() == instanceGuid then
				return ability;
			end
		end
	end

	class.Activate = function()
		for _,spawner in pairs(objectSpawners) do
			spawner.Activate();
		end
	end

	class.Deactivate = function()
		for _,spawner in pairs(objectSpawners) do
			spawner.Deactivate();
		end
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or {};

		t.abilities = {};

		for _,ability in pairs(abilities) do
			table.insert(t.abilities,ability.Serialize(stype));
		end

		t.objectSpawners = {};
		for _,objectSpawner in pairs(objectSpawners) do
			table.insert(t.objectSpawners,objectSpawner.Serialize(stype));
		end

		t.guid = guid;

		if not (stype) or stype == "nonpersonal" then
			t.name = name;
			t.icon = icon;
			t.version = version;
		end
		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	name = info.name;
	icon = info.icon;
	guid = info.guid;
	version = info.version;

	for _,abilityInfo in pairs(info.abilities or {}) do
		InsertAbilityInOrder(GHP_AbilityInstance(abilityInfo));
	end
	for _,objectSpawnerInfo in pairs(info.objectSpawners or {}) do
		table.insert(objectSpawners,GHP_ObjectSpawner(objectSpawnerInfo));
	end


	return class;
end

