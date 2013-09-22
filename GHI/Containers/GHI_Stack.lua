--===================================================
--
--				GHI_Stack
--  			GHI_Stack.lua
--
--	          Holds information for an item stack
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
GHI_ItemGuidsOfStacksLoaded = {};

function GHI_Stack(parentContainer, info1, info2, tempItemInfo)
	local class;
	if type(info1) == "table" and info1.position and GHP_ObjectInstanceWithItem then
		class = GHP_ObjectInstanceWithItem(info1);  --   print("object item")
	else
		class = GHClass("GHI_Stack");-- if type(info1)=="table" then print("stack",info1.position) end
	end

	local itemGuid, itemInstances, locked, GetAllTooltipLinesSorted, RemoveItemInstance;
	local guid = GHI_GUID().MakeGUID();
	local itemInfoList = GHI_ItemInfoList();
	local event = GHI_Event();
	local log = GHI_Log();
	local position;

	local item;

	local Initialize = function()
		itemInstances = {};
		locked = false;

		if type(info1) == "table" then
			itemGuid = info1.guid or info1.ID;
			position = info1.position;
			local itemInfo = itemInfoList.GetItemInfo(itemGuid) or tempItemInfo;
			if not (itemInfo) then
				class = nil;
				return false, "No parent item info found. ("..(itemGuid or "nil")..")";
			end
			if #(info1) > 0 then
				itemInstances = {};
				for i = 1, #(info1) do
					if info1[i].amount > 0 then
						table.insert(itemInstances, GHI_ItemInstance(info1[i],itemInfo));
					end
				end
			else
				itemInstances = { GHI_ItemInstance(info1,itemInfo) };
			end
		elseif type(info1) == "string" and type(info2) == "number" then
			itemGuid = info1;
			local itemInfo = itemInfoList.GetItemInfo(itemGuid)
			if not (itemInfo) then
				class = nil;
				return false, "Parent item not found.";
			end
			local instance = GHI_ItemInstance(info2,itemInfo);
			itemInstances = { instance };
		else
			return false, "Incorrect data";
		end
		GHI_ItemGuidsOfStacksLoaded[itemGuid] = true;
		item = itemInfoList.GetItemInfo(itemGuid);

		return true;
	end

	GHI_Event("GHI_ITEM_UPDATE", function(event, _guid)
		if _guid == itemGuid then
			item = itemInfoList.GetItemInfo(itemGuid);
		end
	end,true);

	--@description Gets the guid (non saved) of the stack
	--@args
	--@returns guid
	class.GetGUID = function()
		return guid;
	end -- non saved guid

	class.GetStackInfoTable = function()
		local info = {};
		info.guid = itemGuid;
		info.ID = itemGuid;
		info.amount = class.GetTotalAmount()
		info.position = position;
		for i, itemInstance in pairs(itemInstances) do
			info[i] = itemInstance.GetItemInstanceInfoTable();
		end
		return info; --@returns table<GHI_ItemInstance>
	end
	class.Serialize = function()
		return class.GetStackInfoTable();
	end

	class.Clone = function()
		return GHI_Stack(parentContainer, class.GetStackInfoTable());
	end

	class.GetParentContainer = function()
		return parentContainer;
	end

	class.SetParentContainer = function(_parentContainer)
		if parentContainer then
			event.TriggerEvent("GHI_CONTAINER_UPDATE", parentContainer.GetGUID())
		end
		parentContainer = _parentContainer;
		event.TriggerEvent("GHI_CONTAINER_UPDATE", parentContainer.GetGUID())
		if class.OnSetParentContainer then
			class.OnSetParentContainer(_parentContainer);
		end
	end

	class.GetTotalAmount = function()
		local c = 0;
		for i, instance in pairs(itemInstances) do
			c = c + instance.amount;
		end
		return c;
	end

	class.GetContainerItemInfo = function()
		if itemGuid then
			local _, texture, quality = itemInfoList.GetItemInfo(itemGuid).GetItemInfo();
			local count = class.GetTotalAmount();

			local altIconTexture = class.GetAttribute("icon");
			if type(altIconTexture) == "string" and strlen(altIconTexture) > 0 then
				texture = altIconTexture;
			end

			return itemGuid, texture, count, locked, quality;
		else
			return nil, "Interface\\Icons\\INV_Misc_QuestionMark";
		end
	end

	class.GetItemInfo = function()
		return item;
	end

	class.CanCopy = function()
		if item then
			return item.CanCopy();
		end
		return false;
	end

	class.DisplayItemTooltip = function(tooltipFrame, anchorFrame, showInspectionDetails)
		tooltipFrame:ClearLines();
		local lines = GetAllTooltipLinesSorted(showInspectionDetails);
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

				tooltipFrame:AddLine(text, 1, 1, 1, true, line.order);
			else
				tooltipFrame:AddLine(line.text, line.r, line.g, line.b, true, line.order);
			end
		end

		tooltipFrame:Show();
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

	GetAllTooltipLinesSorted = function(showInspectionDetails)
		if itemGuid then
			local lines = item.GetTooltipLines(class);
			--local i = #(lines);
			if item.GetAllCustomTooltips then
				InsertLines(lines, item.GetAllCustomTooltips())
			end
			--print(i,"to",#(lines));
			if showInspectionDetails then
				InsertLines(lines, item.GetInspectionLines());
			end

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

	class.IsLocked = function() return locked; end
	class.SetLocked = function(newLocked)
		if newLocked == true then
			locked = true;
		else
			locked = false;
		end
		event.TriggerEvent("GHI_CONTAINER_UPDATE", parentContainer.GetGUID())
	end

	local ItemInstancesBestSuited = function(amount)
		if not(item.GetItemComplexity()=="advanced") then
			return itemInstances[1];
		end


		local t = {};
		for i,v in pairs(itemInstances) do
			t[i] = v;
		end


		local stackOrder = item.GetStackOrder();

		if stackOrder == "first" then
			-- dont do anything
		elseif stackOrder == "last" then
			local t2 = {};
			for i=1,#(t) do
				t2[#(t)-i+1] = t[i];
			end
			t = t2;
		elseif stackOrder == "largest" then
			table.sort(t, function(a,b) return a.amount>b.amount end)
		elseif stackOrder == "smallest" then
			table.sort(t, function(a,b) return a.amount<b.amount end)
		end

		local selected = {};
		local i = 1;
		while (amount > 0 and i <= #(t)) do
			table.insert(selected,t[i]);
			amount = amount - t[i].amount;
			i = i + 1;
		end

		return unpack(selected);
	end

	class.GetAllInstancesSorted = function()
		return ItemInstancesBestSuited(class.GetTotalAmount());
	end

	RemoveItemInstance = function(itemInstance)
		for i, instance in pairs(itemInstances) do
			if instance == itemInstance then
				table.remove(itemInstances, i);
				if parentContainer then
					event.TriggerEvent("GHI_CONTAINER_UPDATE", parentContainer.GetGUID())
				end
				return;
			end
		end
	end

	class.CompleteSplitStack = function(amount)
		if class.GetTotalAmount() < amount then return end;

		local itemInstancesForSplit = { ItemInstancesBestSuited(amount) };
		local c = 0;
		local smallestItemInstance;
		for i, instance in pairs(itemInstancesForSplit) do
			c = c + instance.amount;
			if not (smallestItemInstance) or instance.amount < smallestItemInstance.amount then  -- to bo changed in #127
				smallestItemInstance = instance;
			end
			RemoveItemInstance(instance);
		end;

		-- there might be taken too much away
		local overflow = c - amount;

		if overflow > 0 then
			local remainingInstance = GHI_ItemInstance(smallestItemInstance);
			smallestItemInstance.amount = smallestItemInstance.amount - overflow;
			remainingInstance.amount = remainingInstance.amount - smallestItemInstance.amount;

			table.insert(itemInstances, remainingInstance);
		end

		itemInstancesForSplit.guid = itemGuid;
		local newStack = GHI_Stack(nil, itemInstancesForSplit);

		if parentContainer then
			event.TriggerEvent("GHI_CONTAINER_UPDATE", parentContainer.GetGUID())
		end
		return newStack;
	end

	class.IsSameItem = function(otherStack)
		local otherGuid = otherStack.GetContainerItemInfo()
		if not (itemGuid) then
			return false, false;
		end
		if otherGuid == itemGuid then
			return true, otherStack == class;
		end
		return false, false;
	end

	local CanAllAttributesBeMerged = function(targetInstance, mergingInstance)
		local attributes = item.GetAllAttributes();

		for i,att in pairs(attributes) do
			if not(att.CanMerge() or targetInstance.IsAttributeIdentical(att.GetName(),mergingInstance)) then
				return false;
			end
		end
		return true;
	end

	local MergeAttributes = function(targetInstance, mergingInstance)

		local attributes = item.GetAllAttributes();

		for i,att in pairs(attributes) do
			att.Merge(targetInstance, mergingInstance)
		end
		targetInstance.amount = targetInstance.amount + mergingInstance.amount;
	end

	local SplitItemInstancesToFitStackSize = function()
		local itemInfo = itemInfoList.GetItemInfo(itemGuid)
		local stackSize = itemInfo.GetStackSize()
		local changed = false;

		for i,inst in pairs(itemInstances) do
			local delta = inst.amount - stackSize
			if delta > 0 then
				inst.amount = stackSize;
				local info = inst.GetItemInstanceInfoTable();
				info.amount = delta;
				table.insert(itemInstances,GHI_ItemInstance(info));
				changed = true;
			end
		end

		if changed then
			GHI_ContainerList().SaveContainer(parentContainer.GetGUID())
		end
	end

	class.MergeStacks = function(otherStack)

		local _,_,_,stackSize = item.GetItemInfo();


		local mergetAmount = math.max(0,math.min(stackSize - class.GetTotalAmount(),otherStack.GetTotalAmount()));
		local remainingAmount = otherStack.GetTotalAmount() - mergetAmount;

		local remainingStack;
		local stackToMerge;
		if remainingAmount > 0 then
			stackToMerge = otherStack.CompleteSplitStack(mergetAmount);
			remainingStack = otherStack;
		else
			stackToMerge = otherStack;
		end

		local otherItemInstances = stackToMerge.GetAllItemInstances();
		for _, otherItemInstance in pairs(otherItemInstances) do
			for i, itemInstance in pairs(itemInstances) do
				if itemInstance.IsAttributesIdentical(otherItemInstance) then

					itemInstance.amount = itemInstance.amount + otherItemInstance.amount;
					otherItemInstance.amount = 0;
					break;
				end
			end
			if otherItemInstance.amount > 0 then
				if itemInstances[1] and CanAllAttributesBeMerged(itemInstances[1], otherItemInstance) then
					MergeAttributes(itemInstances[1], otherItemInstance);
				else
					table.insert(itemInstances, otherItemInstance)
				end
			else
				otherItemInstance.Dispose();
			end
		end

		stackToMerge.Dispose();
		event.TriggerEvent("GHI_CONTAINER_UPDATE", parentContainer.GetGUID())
		return remainingStack;
	end

	class.GetAllItemInstances = function()
		return itemInstances;
	end

	class.UseItem = function()
		log.Add(3,"Use item.",{itemGuid=itemGuid});
		local itemInfo = itemInfoList.GetItemInfo(itemGuid);

		itemInfo.UseItem(class);
		event.TriggerEvent("GHI_CONTAINER_UPDATE", parentContainer.GetGUID())
	end

	class.GetItemInstanceCount = function()
		return #(itemInstances);
	end

	class.GetItemInstanceAmount = function(itemInstanceIndex)
		if itemInstances[itemInstanceIndex] then
			return itemInstances[itemInstanceIndex].amount;
		end
		return 0;
	end

	class.GetFirstItemInstanceByOrder = function(stackOrder)
		if stackOrder == "first" then
			return 1;
		elseif stackOrder == "last" then
			return class.GetItemInstanceCount();
		elseif stackOrder == "smallest" then
			local smallestIndex = 1;
			local smallestAmount = itemInstances[1].amount;
			for i=1,#(itemInstances) do
				if (itemInstances[i].amount < smallestAmount) then
					smallestIndex = i;
					smallestAmount = itemInstances[i].amount
				end
			end
			return smallestIndex;
		elseif stackOrder == "largest" then
			local largestIndex = 1;
			local largestAmount = itemInstances[1].amount;
			for i=1,#(itemInstances) do
				if (itemInstances[i].amount < largestAmount) then
					largestIndex = i;
					largestAmount = itemInstances[i].amount
				end
			end
			return largestIndex;
		else
			return 1;
		end
	end

	class.GetFirstInstance = function()
		local order = item.GetStackOrder();
		return class.GetFirstItemInstanceByOrder(order);
	end

	class.GetAttribute = function(attributeName, itemInstanceIndex)
		GHCheck("stack.GetAttribute", { "stringNumber", "numberNil" }, { attributeName, itemInstanceIndex });
		if not(item.GetItemComplexity) then error("Incomplete item info"..((item.GetType and item.GetType()) or "nil")); end

		if attributeName=="bagContainerGuid" then
			return (itemInstances[itemInstanceIndex or 1] or {})[attributeName]
		end

		if not(item.GetItemComplexity() == "advanced") then
			return
		end

		local instance = itemInstances[itemInstanceIndex or 1];

		local attribute = item.GetAttribute(attributeName);
		local defaultValue
		if attribute then
			defaultValue = attribute.GetDefaultValue();
		end

		if instance then
			if not(instance[attributeName]  == nil) then
				return instance[attributeName];
			end
		end

		return defaultValue;
	end

	class.SetAttribute = function(attributeName, value, itemInstanceIndex)
		GHCheck("stack.SetAttribute", { "stringNumber", "any", "numberNil" }, { attributeName, value, itemInstanceIndex });
		local instance = itemInstances[itemInstanceIndex or 1];
		local item = class.GetItemInfo();
		if item then
			if attributeName == "bagContainerGuid" and type(value) == "string" then -- special case for tradeable bags
				if instance then
					instance[attributeName] = value;
					event.TriggerEvent("GHI_CONTAINER_UPDATE", parentContainer.GetGUID())
				end
			elseif item.GetItemComplexity() == "advanced" then
				local attribute = class.GetItemInfo().GetAttribute(attributeName);


				if instance then
					if attribute then
						if attribute.ValidateValue(value) then
							instance[attributeName] = value;
							event.TriggerEvent("GHI_CONTAINER_UPDATE", parentContainer.GetGUID())
						else
							print("Attribute value not valid",attributeName,type(value))
						end
					end
				end
			end
		end
	end

	class.DeleteItem = function(amount)
		local itemInstancesForDelete = { ItemInstancesBestSuited(amount) };
		for _, itemInstance in pairs(itemInstancesForDelete) do
			if itemInstance.amount >= amount then
				itemInstance.amount = itemInstance.amount - amount;
				break;
			else
				amount = amount - itemInstance.amount;
				itemInstance.amount = 0;
			end
		end
		class.MaintainItemAmounts();
	end

	class.MaintainItemAmounts = function()
		for _, itemInstance in pairs(itemInstances) do
			if itemInstance.amount == 0 then
				RemoveItemInstance(itemInstance);
			end
		end

		if class.GetTotalAmount() <= 0 then
			parentContainer.RemoveEmpty();
		end
		event.TriggerEvent("GHI_CONTAINER_UPDATE", parentContainer.GetGUID())
	end

     --do i need this?
     --[[class.ExecuteReq = function(rType,rAlais,rDetail,execOrder)
          --handle execute order then send over to
          --IsRequirementFullfilled
          --this all may need to be in GHI_ItemInfo UseItem
           --rFulf 1 = GHI_RUN_ALWAYS, 2 = GHI_IS_FORFILLED, 3 = GHI_IS_NOT_FORFILLED, 4 = GHI_BEFORE_REQ }
          local itemInfo = itemInfoList.GetItemInfo(itemGuid);
          --local res =  simpleAction.IsRequirementFullfilled(rType,rAlias,rDetail)
          if execOrder == 1 then
               --Execute action
          elseif execOrder == 2 then
               --if res == true then
               --run action possibly after another check
               --end
          elseif execOrder == 3 then
               --if res == false then
               --execute action
               --end
          elseif execOrder ==4 then

               --run it before anything else
          else
                 --execute action anyway
          end



     end  ]]--

	class.GetStackAPI = function(canModify)
		return {
			GetAmount = class.GetTotalAmount,
			GetInstanceCount = class.GetItemInstanceCount,
			GetInstanceAmount = function(num) -- num is optional
				return class.GetItemInstanceAmount(num or class.GetFirstInstance());
			end,
			SetInstanceAmount = function(amount,num)  -- num is optional
				if canModify then
					local instance = itemInstances[num or class.GetFirstInstance()];
					if instance then
						instance.amount = amount
						class.MaintainItemAmounts();
					end
				end
			end,
			ChangeInstanceAmount = function(amount)
				if canModify then
					local dir;
					if (amount > 0) then
						dir = 1;
						local _,_,_,stackSize = item.GetItemInfo();
						amount = math.min(amount,stackSize - class.GetTotalAmount());
					else
						dir = -1;
						amount = - amount;
						amount = math.min(amount,class.GetTotalAmount());
					end

					if dir == 1 then
						local instance = itemInstances[class.GetFirstInstance()];
						if instance then
							instance.amount = instance.amount + amount;
							class.MaintainItemAmounts();
						end
					else
						while (amount > 0) do
							local instance = itemInstances[class.GetFirstInstance()];
							if instance then
								local dAmount = math.min(amount,instance.amount);
								instance.amount = instance.amount - dAmount;
								amount = amount - dAmount;
								class.MaintainItemAmounts();
							else
								break;
							end
						end
					end
				end
			end,
			GetItemGuid = function() return itemGuid; end,
			GetPosition = function() return parentContainer.GetGUID(), parentContainer.GetSlotIDOfStack(class); end,
			GetContainerGuid = function() return parentContainer.GetGUID(); end,
			GetContainerSlot = function() return parentContainer.GetSlotIDOfStack(class); end,
			GetAttribute = class.GetAttribute,
			SetAttribute = function(...)
				if canModify then
					return class.SetAttribute(...);
				else
					print("SetAttribute Access denied")
				end
			end
		};
	end

	class.GetAPI = function(canModify)
   		return class.GetStackAPI(canModify),"stack";
	end

	class.GetCooldown = function()
		local cd, elapsed = item.GetCooldown();
		local lastCastTime = class.GetAttribute("lastCastTime") or item.GetLastCastTime();
		return class.GetAttribute("cooldown") or cd, time() - lastCastTime;
	end

	class.IsOnCooldown = function()
		local cooldown = class.GetCooldown();
		local lastCastTime = class.GetAttribute("lastCastTime") or item.GetLastCastTime();
		cooldown = class.GetAttribute("cooldown") or cooldown;

		if lastCastTime and time() - lastCastTime < cooldown then
			return true;
		end
		return false;
	end

	-- GHP, item as object
	class.GotPersonalData = function()
		for _,ins in pairs(itemInstances) do
			if ins.GotPersonalData() then
				return true;
			end
		end
		return false;
	end

	class.SetPersonalData = function(data)
		local itemInfo = itemInfoList.GetItemInfo(itemGuid)
		for i,v in pairs(data) do
			itemInstances[i] = GHI_ItemInstance(v,itemInfo)
		end
	end


	-- update sequence
	-- On Load
	-- On Load
	local TriggerUpdateSequences = function(freq)
		if itemGuid then
			item = itemInfoList.GetItemInfo(itemGuid);
			if item and item.GetAllUpdateSequences then
				local updateSequences = item.GetAllUpdateSequences()
				for i, seq in pairs(updateSequences) do
					if seq.frequency == freq then
						for i, instance in pairs(itemInstances) do
							seq.sequence.Execute("onupdate", class, i, true);
						end
					end
				end
			end
		end
	end
	class.TriggerUpdateSequences = TriggerUpdateSequences;

	GHI_Event("GHI_LOADED", function()
		TriggerUpdateSequences("login")
	end)

	local lastUpdate = {}

	local timer = GHI_Timer(function()
		if itemGuid then
			if item and item.GetAllUpdateSequences then
				local updateSequences = item.GetAllUpdateSequences()
				for i,seq in pairs(updateSequences) do
					if type(seq.frequency) == "number" and (not(lastUpdate[seq]) or (GetTime() - lastUpdate[seq] >= seq.frequency)) then
						lastUpdate[seq] = GetTime();

						for i, instance in pairs(itemInstances) do
							seq.sequence.Execute("onupdate", class, i, true);
						end

					end
				end--]]
			end
		end
	end, 1, false, "UpdateSequences");

	GHI_Event("GHI_ITEM_MOVED",function(e,_itemGuid,containerGuid,slotID)
		if itemGuid == _itemGuid and containerGuid == parentContainer.GetGUID() and slotID == parentContainer.GetSlotIDOfStack(class) then
			if item and item.GetAllUpdateSequences then
				local updateSequences = item.GetAllUpdateSequences()
				for i,seq in pairs(updateSequences) do
					if seq.frequency == "containerChange" then
						for i, instance in pairs(itemInstances) do
							seq.sequence.Execute("onupdate", class, i, true);
						end

					end
				end
			end
		end
	end);

	GHI_Event("GHI_ITEM_UPDATE",function(e,_itemGuid)
		if itemGuid == _itemGuid then
			SplitItemInstancesToFitStackSize();
		end
	end);


	class.Dispose = function()
	    itemGuid = nil;
		wipe(timer);
	    --wipe(class);
		class.disposed = true;
	end

	local success, reason = Initialize();
	if success then
		return class;
	end



	print("Stack generation failed.", reason)
end

