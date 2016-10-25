--
--
--				GHI_ItemInfo_Attributes
--  			GHI_ItemInfo_Attributes.lua
--
	--	Holds attribute information in itemss
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHI_ItemInfo_Attributes(info)
	local class = GHClass("GHI_ItemInfo_Attributes");

	-- Declaration and default values
	local attributes = {};
	local stackOrder = "last";

	-- Public functions
	class.GenerateStack = function(amount,position) -- Overwriting the GenerateStack in Basic
		local stackInfo = {};
		local attInfo = {};
		for i, att in pairs(attributes) do
			attInfo[att.GetName()] = att.GetDefaultValue();
		end

		stackInfo.attributeValues = attInfo;
		stackInfo.guid = class.GetGUID();
		local _,_,_,stackSize = class.GetItemInfo();
		stackInfo.amount = amount or stackSize;
		stackInfo.position = position;

		return GHI_Stack(nil, stackInfo, nil, class);
	end

	class.GetAllAttributes = function()
		return attributes;
	end

	class.GetAttribute = function(attributeName)
		for i, att in pairs(attributes) do
			if att.GetName() == attributeName then
				return att;
			end
		end
	end

	class.RemoveAttribute = function(attribute)
		for i, att in pairs(attributes) do
			if att == attribute then
				table.remove(attributes, i);
				return
			end
		end
	end

	class.SetAttribute = function(attribute, overwrite)
		for i, att in pairs(attributes) do
			if att.GetName() == attribute.GetName() then
				if (overwrite) then
					attributes[i] = attribute;
					return true;
				end
				return false;
			end
		end
		table.insert(attributes, attribute);
		return true;
	end

	class.GetStackOrder = function()
		return stackOrder;
	end

	class.SetStackOrder = function(order)
		stackOrder = order;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype,t)
		t = t or {};
		if not(stype) or stype == "link" then

		end
		if not(stype) or stype == "action" or stype == "oldAction" then
			local attData = {};
			for i, attribute in pairs(attributes) do
				attData[i] = attribute.GetInfoTable();
			end
			t.attributes = attData;
			t.stackOrder = stackOrder;
		end

		if OtherSerialize then
			t = OtherSerialize(stype,t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	if info.attributes then
		for i, attData in pairs(info.attributes) do
			table.insert(attributes, GHI_Attribute(attData));
		end
	end
	if info.stackOrder then
		stackOrder = info.stackOrder;
	end

	return class;
end

