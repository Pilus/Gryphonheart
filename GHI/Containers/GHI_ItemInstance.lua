--
--
--				GHI_ItemInstance
--  			GHI_ItemInstance.lua
--
--		Holds data about an instance of an item,
--			including different modifiers
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHI_ItemInstance(info)
	local class = GHClass("GHI_ItemInstance",true);

	local amount,attributeValues;

	local Initialize = function()
		amount = 0;
		attributeValues = {};
		if type(info) == "table" then
			amount = info.amount or amount;
			attributeValues = GHClone(info.attributeValues or {});
		elseif type(info) == "number" then
			amount = info;
		end
	end

	class.GetItemInstanceInfoTable = function()
		return {
			amount = amount,
			attributeValues = attributeValues,
		}
	end

	class.IsAttributeIdentical = function(att,otherItemInstance)
		return (attributeValues[att] == otherItemInstance.attributeValues[att]);
	end

	class.IsAttributesIdentical = function(otherItemInstance)
		for i, attribute in pairs(attributeValues) do
			if not (attribute == otherItemInstance.attributeValues[i]) then
				return false;
			end
		end
		return true;
	end

	class.GotPersonalData = function()
		for i,v in pairs(attributeValues) do
			return true;
		end
		return false;
	end

	local meta = getmetatable(class) or {};
	meta.__newindex = function(self,key,value)
		if key == "amount" and type(value) == "number" then
			if value < 0 then
				error("Amount lower than 0")
			end
			amount = value;

		elseif key == "attributeValues" then
			attributeValues = value;
		else
			attributeValues[key] = value;
		end
	end;
	meta.__index = function(self,key)
		if key == "amount" then
			return amount;
		elseif key == "attributeValues" then
			return attributeValues;
		else
			return attributeValues[key];
		end
	end;
	setmetatable(class,meta);

	Initialize();

	return class;
end

