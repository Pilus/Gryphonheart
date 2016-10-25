--
--
--				GHP_Ability
--  			GHP_Ability.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--




function GHP_Ability(info)
	local class = GHP_AuthorInfo(info,"GHP_Ability");

	local name,icon,guid,cooldown,lastCastTime,dynamicActionSet,version,attributes,shownInSpellbook,abilityType;
	local requirements,initializedFrom;
	local loc = GHP_Loc();
	local event = GHI_Event();

	class.Execute = function(abilityInstance,exeGuids)
		lastCastTime = time();
		dynamicActionSet.Execute("execute", abilityInstance,nil,nil,nil,exeGuids)
		event.TriggerEvent("GHP_ABILITY_UPDATED",guid);
	end

	class.GetCooldown = function()
		local elapsed;
		if (lastCastTime and time() < lastCastTime+cooldown) then
			elapsed = time() - lastCastTime;
		end
		return cooldown,elapsed;
	end

	class.ShownInSpellbook = function()
		return shownInSpellbook;
	end

	class.GetGuid = function()
		return guid;
	end

	class.GetInfo = function()
		return guid,name,icon;
	end

	class.GetAbilityType = function()
		return abilityType;
	end

	class.GetVersion = function()
		return version;
	end

	class.GetAttributeInfo = function(attName)
		local att = attributes[attName or ""];
		if type(att) == "table" then
			return att.type,att.defaultValue;
		end
	end

	class.CanInitializeFrom = function(guid)
		return tContains(initializedFrom,guid);
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype,t)
		t = t or {};
		t.name = name;
		t.icon = icon;
		t.guid = guid;
		t.cooldown = cooldown;
		t.version = version;
		t.attributes = attributes;
		t.dynamicActionSet = dynamicActionSet.Serialize();
		t.requirements = {};
		for i,req in pairs(requirements) do
			table.insert(t.requirements, req.Serialize());
		end
		t.initializedFrom = initializedFrom;
		t.shownInSpellbook = shownInSpellbook;
		t.abilityType = abilityType;
		if not(stype) then
			t.lastCastTime = lastCastTime;
		end
		if OtherSerialize then
			t = OtherSerialize(stype,t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	name = info.name;
	icon = info.icon;
	guid = info.guid;
	cooldown = info.cooldown;
	lastCastTime = info.lastCastTime or 0;
	version = info.version or 1;
	attributes = info.attributes or {};
	shownInSpellbook = info.shownInSpellbook or false;
	abilityType = info.abilityType;
	requirements = {};
	for i,v in pairs(info.requirements or {}) do
		table.insert(requirements,GHP_Requirement(v,class));
	end
	initializedFrom = info.initializedFrom or {};

	dynamicActionSet = GHI_DynamicActionInstanceSet(class,"execute",{name=loc.DYN_PORT_ABILITY_RUN_NAME,description=loc.DYN_PORT_ABILITY_RUN_DESCRIPTION});
	if info.dynamicActionSet then
		dynamicActionSet.Deserialize(info.dynamicActionSet);
	end

	return class;
end

