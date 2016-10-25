--
--
--				GHP_ObjectInstanceWithItem
--  			GHP_ObjectInstanceWithItem.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHP_ObjectInstanceWithItem(info)
	local class = GHClass("GHI_Stack");

	local position;
	local pos = GHI_Position();

	class.GetGuid = function()
		return class.GetGUID();
	end;

	class.GetObject = function()
		return;
	end;

	class.GetObjectGuid = function()
		return;
	end

	class.GetInfo = function()
		local item = class.GetItemInfo();

		if item then
			local name,icon = item.GetItemInfo();
			local amount;

			name = class.GetAttribute("name") or name;
			icon = class.GetAttribute("icon") or icon;
			return name,icon,amount;
		end
	end



	class.GetAttributeValue = function(attName)
		return class.GetAttribute(attName);
	end

	class.SetAttributeValue = function(attName,value)
		class.SetAttribute(attName,value)
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
		local item = class.GetItemInfo();
		if item then
			local lines = item.GetTooltipLines();

			if item.GetAllCustomTooltips then
				InsertLines(lines, item.GetAllCustomTooltips())
			end

			if showInspectionDetails then
				InsertLines(lines, item.GetInspectionLines());
			end

			-- add direction and distance code
			local _,directionText,_,distanceText =pos.GetDirectionAndDistance(position);
			InsertLines(lines,{
				{
					order = 35,
					text = string.format("Location: %s %s",distanceText,directionText),
					r = 1,
					g = 1,
					b = 1,
				}
			})


			return lines;
		else
			return {
				{
					order = 10,
					text = "Unknown Item",
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

	local errorThrower = GHI_ErrorThrower();
	class.Execute = function()
		if pos.IsPosWithinRange(position,INTERACTION_RANGE) then
			local obj = objectList.GetObject(objectGuid);
			if obj then
				obj.Execute(nil,nil,guid)
			end
		else
			errorThrower.TooFarAway();
		end
	end

	local active = false;
	class.Activate = function()
		if active == false then
			active = true;
			GHP_ObjectInstanceRegister().AddObjectInstance(class);
		end
	end

	class.Deactivate = function()
		if active == true then
			active = false;
			GHP_ObjectInstanceRegister().RemoveObjectInstance(class);
		end
	end

	class.IsItem = function()
		return true;
	end

	class.OnSetParentContainer = function(parentContainer)
		if string.find(parentContainer.GetGUID(), "_OBJECTS2_") then
			class.Activate();
		else
			class.Deactivate();
		end
	end

	-- Serialization
	class.Serialize = function(stype, t)
		t = class.GetStackInfoTable();
		if not (stype) then
			t.position = position;
		end
		return t;
	end

	-- Initialize
	info = info or {};
	position = info.position;


	return class;
end

