--
--
--				GHI_Attribute
--  			GHI_Attribute.lua
--
--	Holds information about an attribute for an item
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHI_Attribute(name, attType, additionalData, defaultValue, modifyAccess, mergeRule)
	if type(name) == "table" then -- if created from a table
		local t = name;
		name = t.name;
		attType = t.attType;
		additionalData = t.additionalData;
		defaultValue = t.defaultValue;
		modifyAccess = t.modifyAccess;
		mergeRule = t.mergeRule;
	end

	local class = GHClass("GHI_Attribute");

	class.GetName = function() return name; end
	class.GetType = function() return attType; end
	class.GetDefaultValue = function() return defaultValue; end

	class.GetInfoTable = function()
		local t = {
			name = name,
			attType = attType,
			additionalData = additionalData,
			defaultValue = defaultValue,
			modifyAccess = modifyAccess,
			mergeRule = mergeRule,
		};
		return t;
	end

	class.ValidateValue = function(value)
		return GHM_Input_Validate(attType, value)
	end

	class.CanMerge = function()
		return ((mergeRule or false) and not(mergeRule == "none"));
	end

	class.Merge = function(targetInstance,mergingInstance)
		targetInstance[name] = GHM_Input_Merge(attType,mergeRule,targetInstance[name],targetInstance.amount,mergingInstance[name],mergingInstance.amount);
	end

	class.CanBeModifiedByAll = function()
		return modifyAccess == "allItems";
	end

	return class;
end

