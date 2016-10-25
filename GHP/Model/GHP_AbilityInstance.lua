--
--
--				GHP_AbilityInstance
--  			GHP_AbilityInstance.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHP_AbilityInstance(info)
	local class = GHClass("GHP_AbilityInstance",true);

	local abilityList = GHP_AbilityList();

	local abilityGuid,skillLevels,orangeSkillsAwarded;
	local attributes;
	local abilityAPI;


	class.GetAbility = function()
		return abilityList.GetAbility(abilityGuid);
	end

	class.GetAbilityGuid = function()
		return abilityGuid;
	end

	class.GetSkillLevels = function()
		return unpack(skillLevels);
	end



	class.GetAttributeValue = function(attName)
		local ability = class.GetAbility();
		if ability then
			local attType,defaultVal = ability.GetAttributeInfo(attName);
			if attType then
				if attributes[attName] and GHM_Input_Validate(attType,attributes[attName]) then
					return attributes[attName];
				elseif GHM_Input_Validate(attType,defaultVal) then
					return defaultVal;
				else
					return GHM_Input_GetDefaultValue(attType);
				end
			else
				local _,name,icon = ability.GetInfo();
				if attName == "name" then
					return name;
				elseif attName == "icon" then
					return icon;
				end
			end
		end
	end

	class.SetAttributeValue = function(attName,value)
		local obj = class.GetAbility();
		local attType,defaultVal = obj.GetAttributeInfo(attName);
		if attType then
			if GHM_Input_Validate(attType,value) then
				attributes[attName] = value
			end
		end
	end

	class.Execute = function(systemGuid,profGuid,objGuid,objInsGuid)
		local obj = class.GetAbility();
		local guids = {systemGuid,profGuid,abilityGuid,objGuid,objInsGuid};
		obj.Execute(class,guids);
	end

	local InitializeAPICall = function()
		if not(abilityAPI) then
			local obj = class.GetAbility();
			local authorGuid = obj.GetAuthorInfo();
			abilityAPI = GHP_AbilityAPI(authorGuid);
		end
	end

	class.GetAPI = function(_,guids)
		InitializeAPICall();

		local systemGuid,profGuid,abilityGuid,objGuid,objInsGuid = unpack(guids);
		return abilityAPI.GetAbility(abilityGuid),"ability";
	end



	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or {};
		t.abilityGuid = abilityGuid;
		t.skillLevels = skillLevels;
		t.orangeSkillsAwarded = orangeSkillsAwarded;

		t.attributes = attributes;

		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};

	skillLevels = info.skillLevels or {};
	orangeSkillsAwarded = info.orangeSkillsAwarded or 1;
	shownInSpellbook = info.shownInSpellbook or false;
	attributes = info.attributes or {};
	abilityGuid = info.abilityGuid;



	return class;
end

