--===================================================
--
--				GHP_ObjectInstance
--  			GHP_ObjectInstance.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local ZERO_POS = {
	x = 0,
	y = 0,
	world = 0,
};


function GHP_ObjectInstance(info)
	local class = GHClass("GHP_ObjectInstance");

	local guid,objectGuid,attributes,position;
	local objectList = GHP_ObjectList();
	local pos = GHI_Position();

	local event = GHI_Event();

	class.GetGuid = function()
		return guid;
	end;

	class.GetObject = function()
		return objectList.GetObject(objectGuid);
	end;

	class.GetObjectGuid = function()
		return objectGuid;
	end

	class.GetInfo = function()
		local obj = objectList.GetObject(objectGuid);
		if obj then
			local name,icon = obj.GetInfo();
			local amount;

			if attributes["name"] and GHM_Input_Validate("string",attributes["name"]) then
				name = attributes["name"];
			end
			if attributes["icon"] and GHM_Input_Validate("string",attributes["icon"]) then
				icon = attributes["icon"];
			end
			if attributes["amount"] and GHM_Input_Validate("number",attributes["amount"]) then
				amount = attributes["amount"];
			end
			return name,icon,amount;
		end
	end

	class.GotPersonalData = function()
		for i,v in pairs(attributes) do
			return true;
		end
		return false;
	end

	class.SetPersonalData = function(data)
		attributes = data.attributes or {};
	end

	class.GetAttributeValue = function(attName)
		local obj = objectList.GetObject(objectGuid);
		if obj then
			local attType,defaultVal = obj.GetAttributeInfo(attName);
			if attType then
				if attributes[attName] and GHM_Input_Validate(attType,attributes[attName]) then
					return attributes[attName];
				elseif GHM_Input_Validate(attType,defaultVal) then
					return defaultVal;
				else
					return GHM_Input_GetDefaultValue(attType);
				end
			end
		end
	end

	class.SetAttributeValue = function(attName,value)
		local obj = objectList.GetObject(objectGuid);
		local attType,defaultVal = obj.GetAttributeInfo(attName);
		if attType then
			if GHM_Input_Validate(attType,value) then
				local oldValue = attributes[attName];
				attributes[attName] = value

				if attName == "visible" then
					event.TriggerEvent("GHP_NEARBY_OBJECTS_UPDATED")
				end
			end
		end
	end

	class.GetPosition = function()
		return position;
	end

	local event = GHI_Event();
	class.SetPosition = function(pos)
		position = pos;
		event.TriggerEvent("GHP_OBJECT_MOVED",guid,position)
	end

	local InsertLines = function(lines, linesToInsert)
		for _, insertLine in pairs(linesToInsert) do
			local inserted = false;
			for i = 1, #(lines) do
				local line = lines[i];
				if insertLine.order == line.order then -- overwrite
					lines[i] = insertLine;
					inserted = true;
					break;
				elseif insertLine.order < line.order then
					table.insert(lines, i, insertLine);
					inserted = true;
					break;
				end
			end
			if inserted == false then
				table.insert(lines, insertLine);
			end
		end
	end

	local GetAllTooltipLinesSorted = function(showInspectionDetails)
		local object = objectList.GetObject(objectGuid or "");
		if object then
			local lines = object.GetTooltipLines();

			-- add direction and distance code
			local _,directionText,_,distanceText =pos.GetDirectionAndDistance(position);
			InsertLines(lines,{
				{
					order = 20,
					text = string.format("Location: %s %s",distanceText,directionText),
					r = 1,
					g = 1,
					b = 1,
				}
			})

			if object.GetAllCustomTooltips then
				InsertLines(lines, object.GetAllCustomTooltips())
			end

			return lines;
		else
			return {
				{
					order = 10,
					text = "Unknown Object",
					r = 1,
					g = 0.1,
					b = 0.1,
				},
			};
		end
	end

	class.DisplayTooltip = function(tooltipFrame)
		tooltipFrame:ClearLines();
		local lines = GetAllTooltipLinesSorted();
		for _, line in pairs(lines) do
			if line.sequence then
				line.sequence.Execute("OnTooltipUpdate", class, nil, true,
					{
						SetTooltipText = function(text)
							GHI_GlobalTemp = text;
						end,
					});
				local text = GHI_GlobalTemp;
				GHI_GlobalTemp = nil;

				tooltipFrame:AddLine(text, 1, 1, 1, true);
			else
				tooltipFrame:AddLine(line.text, line.r, line.g, line.b, true);
			end
		end

		tooltipFrame:Show();
	end



	class.Activate = function()
		GHP_ObjectInstanceRegister().AddObjectInstance(class);
	end

	class.Deactivate = function()
		GHP_ObjectInstanceRegister().RemoveObjectInstance(class);
	end

	class.IsItem = function()
		return false;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or {};
		if not (stype) then
			t.guid = guid;
			t.objectGuid = objectGuid;
			t.attributes = attributes;
			t.position = position;
		end
		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	guid = info.guid;
	objectGuid = info.objectGuid;
	attributes = info.attributes or {};
	position = info.position or ZERO_POS;

	return class;
end

