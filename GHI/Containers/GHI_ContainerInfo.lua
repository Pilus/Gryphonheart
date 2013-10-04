--===================================================
--
--				GHI_ContainerInfo
--				GHI_ContainerInfo.lua
--
--	Information and handling for each container / bag
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_ContainerInfo(info)

	local miscAPI = GHI_ActionAPI().GetAPI()
	local class = GHClass("GHI_ContainerInfo");

	local guid, name, isPublic, isItemArea, location, size, icon, stacks, texture, ownerItemGuid, locked;
	local cursor = GHI_CursorHandler();
	local event = GHI_Event();
	local containerList = GHI_ContainerList();
	local itemList = GHI_ItemInfoList();

	local Initialize = function()
		guid = 0;
		name = "";
		isPublic = false;
		isItemArea = false;
		location = nil;
		size = 0;
		icon = "Interface\\Icons\\INV_Misc_QuestionMark";
		texture = "";
		stacks = {};
		locked = false;

		if type(info) == "table" then
			local t = info[0];
			if type(t) == "table" and type(t.item_id) == "string" then
				guid = info.guid or (t.item_id .. "Bag") or guid;
				size = info.size or t.size or size;
			else
				size = info.size or size;
				guid = info.guid or guid;
			end

			if not(type(size)=="number") then
				size = tonumber(size) or 32;
			end

			-- Fix malformed size (due to earlier error)
			if size > 1 and mod(size,2) == 1 then
				size = size - 1;
			end

			name = info.name or name;
			isPublic = info.isPublic or isPublic;
			isItemArea = info.isItemArea or isItemArea;

			icon = info.icon or icon;
			ownerItemGuid = info.ownerItemGuid;

			texture = info.texture or "";
			for index, stackInfo in pairs(info) do
				if type(index) == "number" and index > 0 and type(stackInfo) == "table" then
					stacks[index] = GHI_Stack(class, stackInfo);
					if not(stacks[index]) then
						-- trigger an update to clean the failed stack away from save data
						event.TriggerEvent("GHI_CONTAINER_UPDATE", guid);
					else
						if stacks[index].Activate then
							stacks[index].Activate() -- Activate evt object
						end
					end
				end
			end
		end
	end

	class.GetContainerInfoTable = function()
		local info = {};
		info[0] = { size = size };
		info.guid = guid;
		info.name = name;
		info.size = size;
		info.isPublic = isPublic;
		info.isItemArea = isItemArea;
		info.icon = icon;
		info.texture = texture;
		info.ownerItemGuid = ownerItemGuid;
		for i, stack in pairs(stacks) do
			info[i] = stack.GetStackInfoTable();
		end
		return info;
	end

	local GetFirstFreeSlot = function()
		local index = 1;
		while (stacks[index]) do
			index = index + 1;
		end
		return index;
	end

	local IsBagEmpty = function()
		local free = class.GetNumFreeSlots()
		if size == free then
			return true;
		else
			return false;
		end
	end

	class.GetNumFreeSlots = function()
		local c = 0;
		for i = 1, size do
			if not (stacks[i]) then
				c = c + 1;
			end
		end
		return c;
	end

	class.IsEmpty = function()
		for i = 1, size do
			if (stacks[i]) then
				return false;
			end
		end
		return true;
	end

	class.GetGUID = function()
		return guid;
	end

	class.IsLocked = function()
		return locked;
	end

	class.SetLocked = function(lock)
		locked = lock;
		event.TriggerEvent("GHI_CONTAINER_UPDATE",guid)
	end

	class.IsSlotLocked = function(slotID)
		if stacks[slotID] then
			return stacks[slotID].IsLocked();
		end
	end

	class.UpdateSize = function(_size)


		for i = _size+1,size do
			if stacks[i] then
				local s = stacks[i];
				stacks[i] = nil;
				stacks[GetFirstFreeSlot()] = s;
			end
		end
		size = max(GetFirstFreeSlot(),_size);


		containerList.SaveContainer(guid)
	end 

	class.InsertItem = function(stack)
		if not (class.IsContainerAccessible()) or class.IsLocked() then
			return false,"Container not accessable";
		end
		local free = GetFirstFreeSlot();
		if free > size then
			return false,"Container is full";
		end

		if not(class.CanHoldItem(stack)) then
			return false,"Container can not hold item";
		end

		stacks[free] = stack;
		stack.SetParentContainer(class);

		if stack then
			local itemGuid = stack.GetGUID();
			event.TriggerEvent("GHI_ITEM_MOVED",itemGuid,guid,free)
		end

		event.TriggerEvent("GHI_CONTAINER_UPDATE", guid)
		return true, free;
	end

	class.SetTexture = function(_texture)
		texture = _texture or texture;
		event.TriggerEvent("GHI_CONTAINER_UPDATE", guid)
	end
	class.SetIcon = function(_icon)
		icon = _icon or icon;
		event.TriggerEvent("GHI_CONTAINER_UPDATE", guid)
	end
	class.SetName = function(_name)
		name = _name or name;
		event.TriggerEvent("GHI_CONTAINER_UPDATE", guid)
	end

	class.Open = function()
		event.TriggerEvent("GHI_BAG_OPEN", guid)
	end

	class.GetContainerInfo = function()
		if texture == "-Normal" then
			texture = "";
		end
		return size, name, icon, texture;
	end

	class.GetContainerItemInfo = function(slotID)
		if isItemArea == false then
			if stacks[slotID] then
				local itemGuid, texture, count, stacklocked, quality = stacks[slotID].GetContainerItemInfo();
                return itemGuid, texture, count, locked or stacklocked, quality;
			end
		end
	end

	class.DisplayItemTooltip = function(slotID, tooltipFrame, anchorFrame, showInspectionDetails)
		if stacks[slotID] then
			stacks[slotID].DisplayItemTooltip(tooltipFrame, anchorFrame, showInspectionDetails);
		else
			tooltipFrame:Hide();
		end
	end

	class.GetSlotIDOfStack = function(_stack)
		for slot, stack in pairs(stacks) do
			if stack == _stack then
				return slot;
			end
		end
	end

	StaticPopupDialogs["GHI_DELETE_ITEM"] = {
		text = DELETE_ITEM,
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			local cursorType, containerGuid, containerSlotID, stack, amount = cursor.GetCursor();
			containerList.DeleteItemFromBag(containerGuid, containerSlotID, amount);
			cursor.ClearCursor()
		end,
		OnCancel = function()
			cursor.ClearCursor()
		end,
		OnUpdate = function()
			if not (cursor.GetCursor() == "GHI_ITEM") then
				StaticPopup_Hide("GHI_DELETE_ITEM");
			end
		end,
		timeout = 0,
		whileDead = 1,
		exclusive = 1,
		showAlert = 1,
		hideOnEscape = 1
	};

	class.PickupContainerItem = function(slotID, amount)
		if not(class.IsLocked()) and stacks[slotID] and stacks[slotID].IsLocked() == false then
			local stack = stacks[slotID];
            if amount and not(amount < stack.GetTotalAmount()) then
                return;
            end
			stack.SetLocked(true);
			local itemGuid, texture = stack.GetContainerItemInfo();
			local item = stack.GetItemInfo();
			local name = item.GetItemInfo();
			cursor.SetCursor("ITEM", texture, function() if stack and stack.SetLocked then stack.SetLocked(false); end end,
			function(...)
				StaticPopup_Show("GHI_DELETE_ITEM",name);
			end, "GHI_ITEM", guid, slotID, stack, amount, itemGuid);
		end
	end

	class.CopyContainerItem = function(slotID, amount)
	   	if stacks[slotID] and stacks[slotID].CanCopy() == true then
			local stack = stacks[slotID];
			local itemGuid, texture = stack.GetContainerItemInfo();
			cursor.SetCursor("ITEM", texture, function() end, function(...) cursor.ClearCursor(); end, "GHI_ITEM", nil, nil, nil, amount, itemGuid);
		end
	end

	class.DeleteItemFromBag = function(slotID, amount)

		if stacks[slotID] then
			local IsEmpty = true;
			--todo when tradeable bags are implemented, they should be emptied before deletion. The same should apply if it got a bag action and is the last of its item
			if IsEmpty == false then
				GHI_Message("Please empty the bag before deleting it.");
				return;
			end
			local stack = stacks[slotID];

			if not (amount) then
				local _;
				_, _, amount = stack.GetContainerItemInfo();
			end

			stack.DeleteItem(amount)

		end
	end

	class.RemoveEmpty = function()
		for slotID,stack in pairs(stacks) do
			if stack.GetTotalAmount() <= 0 then
				stacks[slotID] = nil;
				stack.Dispose();
			end
		end
	end

	class.ReplaceStack = function(slotID, newStack)
		local oldStack = stacks[slotID];
		stacks[slotID] = newStack;
		if newStack then
			newStack.SetParentContainer(class);
		end
		if newStack then
			local itemGuid = newStack.GetGUID();
			event.TriggerEvent("GHI_ITEM_MOVED",itemGuid,guid,slotID)
		end
		event.TriggerEvent("GHI_CONTAINER_UPDATE", guid);
		return oldStack;
	end

	class.CompleteSplitStack = function(slotID, amount)
		if stacks[slotID] then
			local newStack =  stacks[slotID].CompleteSplitStack(amount);

			if newStack then
				local itemGuid = newStack.GetGUID();
				event.TriggerEvent("GHI_ITEM_MOVED",itemGuid,guid,slotID)
			end

			return newStack;
		end
	end

	class.IsSameItem = function(slotID, otherStack)
		if stacks[slotID] and otherStack then
			return stacks[slotID].IsSameItem(otherStack);
		end
		return false;
	end

	class.MergeStacks = function(slotID, otherStack)
		local mergeStack;
		if class.IsSameItem(slotID, otherStack) and stacks[slotID].IsLocked() == false then
			mergeStack = stacks[slotID].MergeStacks(otherStack);

			if mergeStack then
				local itemGuid = mergeStack.GetGUID();
				event.TriggerEvent("GHI_ITEM_MOVED",itemGuid,guid,slotID)
			end
		else
			error("Merge item error");
		end
		event.TriggerEvent("GHI_CONTAINER_UPDATE", guid);
		return mergeStack;
	end

	class.FindAllStacks = function(guid, slotID)

		local t = {}
		for i, stack in pairs(stacks) do
			if stack.GetContainerItemInfo() == guid then
				tinsert(t,i, stack)
			end
		end
		return t
	end

	class.GetStack = function(slotID)
		return stacks[slotID];
	end

	class.IsContainerAccessible = function()
		if not (location) then
			return true;
		end
	end

	class.UseItem = function(slotID)
		if class.IsContainerAccessible() and not(class.IsLocked()) and not (class.IsSlotLocked(slotID)) then
			if stacks[slotID] then
				stacks[slotID].UseItem();
			end
		end
	end

	class.SetOwnerItem = function(_ownerItem)
		ownerItemGuid = _ownerItem.GetGUID();
	end

	class.CanHoldItem = function(stack)
		local item = stack.GetItemInfo();
		local _,_,_,_,itemType = item.GetItemInfo();
		if itemType == 2 or itemType == 4 then
			if ownerItemGuid and itemList.GetItemInfo(ownerItemGuid) then
				local ownerItem = itemList.GetItemInfo(ownerItemGuid);
				local _,_,_,_,ownerItemType = ownerItem.GetItemInfo();
				if (ownerItemType == 2 or ownerItemType == 4) then
					return true;
				end
			end
			return false;
		end
		return true
	end

	Initialize();

	return class;
end


