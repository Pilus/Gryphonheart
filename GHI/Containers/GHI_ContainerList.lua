--===================================================
--
--				GHI_ContainerList
--				GHI_ContainerList.lua
--
--			Handler for all containers
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local CONTAINER_DATA_SAVE_TABLE = "GHI_ContainerData";
local MAIN_BAG_SIZE = 24;

local class;
function GHI_ContainerList()
	if class then
		return class;
	end
	class = GHClass("GHI_ContainerList");

	local containers, savedContainerInfo, currentMainBagGuid;
	local event = GHI_Event();
	local cursor = GHI_CursorHandler();
	local itemList = GHI_ItemInfoList();
	local containerAPI;


	local DisplayTooltip;
	DisplayTooltip = function(frame)
		local guid = frame.guid

		if ( GetCVar("UberTooltips") == "1" ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, frame);
		else
			local parent = frame:GetParent();
			if ( parent == MultiBarBottomRight or parent == MultiBarRight or parent == MultiBarLeft ) then
				GameTooltip:SetOwner(frame, "ANCHOR_LEFT");
			else
				GameTooltip:SetOwner(frame, "ANCHOR_RIGHT");
			end
		end
		itemList.DisplayItemTooltip(guid,GameTooltip);
		frame.UpdateTooltip = DisplayTooltip;
	end

	local actionBar = GHI_ActionBarUI(
		"GHI_ITEM",
		function(guid)
			local bag,slot = containerAPI.GHI_FindOneItem(guid);
			if bag and slot then
				class.UseItem(bag,slot);
			end
		end,
		function(guid) -- returns icon,count,cooldown
			if not(guid) then return end
			if not(containerAPI) then
				containerAPI = GHI_ContainerAPI().GetAPI();
			end
			local count = containerAPI.GHI_CountItem(guid);
			local item = itemList.GetItemInfo(guid);
			if item then
				local _, icon = item.GetItemInfo();
				local cooldown,timeSinceCast = item.GetCooldown();
				return icon,count,cooldown,timeSinceCast;
			end
			return "",0,0,0;
		end,
		DisplayTooltip,
		"GHI_CONTAINER_UPDATE"
	);
	cursor.SetActionBarHandler(actionBar);

	GHI_Event("GHI_CONTAINER_UPDATE", function(event, guid, ...)
		local i = 101;
		while (containers[i] and i < 201) do
			i = i + 1;
		end
		local lastMain = i - 1;

		if lastMain == 100 then
			containers[101] = GHI_ContainerInfo({ guid = 101, size = MAIN_BAG_SIZE });
		else
			local free = containers[lastMain].GetNumFreeSlots();
			if free < MAIN_BAG_SIZE / 2 and lastMain < 200 then
				containers[lastMain + 1] = GHI_ContainerInfo({ guid = lastMain + 1, size = MAIN_BAG_SIZE });
				class.SaveContainer(lastMain + 1);
			elseif free == MAIN_BAG_SIZE and lastMain > 101 then
				local free2 = containers[lastMain - 1].GetNumFreeSlots();
				if free2 >= MAIN_BAG_SIZE / 2 then
					containers[lastMain] = nil;
					class.SaveContainer(lastMain);
				end
			end
		end
		class.SaveContainer(guid);
	end);

	class.GetCurrentMainBagGUID = function() return currentMainBagGuid; end

	class.GetContainerItemInfo = function(containerGuid, slotID)
		if containers[containerGuid] then
			return containers[containerGuid].GetContainerItemInfo(slotID);
		end
	end

	class.LoadFromSaved = function()
		local loaded = savedContainerInfo.GetAll();
		local lastMain = 101;
		if type(loaded) == "table" then
			for index, containerTable in pairs(loaded) do
				if type(index) == "number" and index > 100 and index < 201 then
					containerTable.guid = index;
					containerTable.size = MAIN_BAG_SIZE;
					if index > lastMain then
						lastMain = index;
					end
					savedContainerInfo.SetVar(index, containerTable);
				end

				local containerInfo = GHI_ContainerInfo(containerTable);
				containers[containerInfo.GetGUID()] = containerInfo;
			end
		end
		for i = 101, lastMain do
			if not (containers[i]) then
				containers[i] = GHI_ContainerInfo({ guid = i, size = MAIN_BAG_SIZE });
			end
		end
		event.TriggerEvent("GHI_ITEM_UPDATE");
	end

	local containersScheduledForSave = {};

	class.SaveContainer = function(guid)
		if guid then
			containersScheduledForSave[guid] = true;
		end
	end

	GHI_Timer(function()
		local saved = false;
		for guid, _ in pairs(containersScheduledForSave) do
			local container = containers[guid];
			containersScheduledForSave[guid] = nil;
			if (container) then
				local info = container.GetContainerInfoTable();
				savedContainerInfo.SetVar(guid, info);
			else
				savedContainerInfo.SetVar(guid, nil);
			end
			saved = true;
		end
		if saved == true then
			event.TriggerEvent("GHI_CONTAINER_UPDATE",currentMainBagGuid)
		end
	end, 1, false, "containersScheduledForSave")

	class.DisplayItemTooltip = function(containerGuid, slotID, tooltipFrame, anchorFrame, showInspectionDetails)
		if containers[containerGuid] then
			containers[containerGuid].DisplayItemTooltip(slotID, tooltipFrame, anchorFrame, showInspectionDetails);
		end
	end

	class.GotNextMainBagPage = function()
		if containers[currentMainBagGuid + 1] then
			return true;
		end
		return false;
	end

	class.NextMainBagPage = function()
		if class.GotNextMainBagPage() then
			currentMainBagGuid = currentMainBagGuid + 1;
			event.TriggerEvent("GHI_CONTAINER_UPDATE", currentMainBagGuid);
		end
	end

	class.GotPrevMainBagPage = function()
		if containers[currentMainBagGuid - 1] then
			return true;
		end
		return false;
	end

	class.PrevMainBagPage = function()
		if class.GotPrevMainBagPage() then
			currentMainBagGuid = currentMainBagGuid - 1;
			event.TriggerEvent("GHI_CONTAINER_UPDATE", currentMainBagGuid);
		end
	end

	class.UseItem = function(containerGuid, slotID)
		if containers[containerGuid] then
			containers[containerGuid].UseItem(slotID);
		end
	end

	class.PickupContainerItem = function(containerGuid, slotID)
		if containers[containerGuid] then
			local container = containers[containerGuid];

			if not (container.IsContainerAccessible()) or container.IsLocked() then
				return;
			end

			local cursorType, cursorContainerGuid, cursorSlotID, cursorStack, amount, cursorItemGuid = cursor.GetCursor();
			local cursorAndSlotItemAreIdentical, isSameStack = container.IsSameItem(slotID, cursorStack);
			if not(cursorStack) then
				local itemGuid = container.GetContainerItemInfo(slotID);
				cursorAndSlotItemAreIdentical = (itemGuid == cursorItemGuid);
			end
			if container.IsSlotLocked(slotID) and not (isSameStack) then
				return;
			end



			local slotIsEmpty = (container.GetContainerItemInfo(slotID) == nil);
			local cursorGotValidItem = (containers[cursorContainerGuid] and cursorType == "GHI_ITEM");
			local cursorGotCopyItem = (cursorType == "GHI_ITEM" and cursorContainerGuid == nil and cursorSlotID == nil and cursorStack == nil);
			local cursorGotSplittedStack = not (amount == nil);

			if cursorStack and not(container.CanHoldItem(cursorStack)) then
				UIErrorsFrame:AddMessage("You cannnot place a contributing or official item there.", 1, 0, 0, 53, 5);
				return
			end


			if cursorGotCopyItem then
				local copyItem = itemList.GetItemInfo(cursorItemGuid);


				if slotIsEmpty then
					local _,_,_,stackSize = copyItem.GetItemInfo();
					local cursorCopyStack = copyItem.GenerateStack(math.min(amount,stackSize));
					container.ReplaceStack(slotID, cursorCopyStack);
					if amount > stackSize then
						local cursorTexType,cursorDetail,func1,func2 = cursor.GetCursorInfo();
						cursor.SetCursor( cursorTexType,cursorDetail,func1,func2,cursorType, cursorContainerGuid, cursorSlotID, cursorStack, amount - stackSize , cursorItemGuid);
					else
						cursor.ClearCursor();
					end
				elseif cursorAndSlotItemAreIdentical then
					local cursorCopyStack = copyItem.GenerateStack(amount);
					container.MergeStacks(slotID, cursorCopyStack);
					if (cursorCopyStack and ((cursorCopyStack.disposed) or cursorCopyStack.GetTotalAmount() == 0)) then
						cursor.ClearCursor();
					else
						local cursorTexType,cursorDetail,func1,func2 = cursor.GetCursorInfo();
						cursor.SetCursor( cursorTexType,cursorDetail,func1,func2,cursorType, cursorContainerGuid, cursorSlotID, cursorStack, cursorCopyStack.GetTotalAmount() , cursorItemGuid);
					end
				else
				   	UIErrorsFrame:AddMessage("You cannnot place the copied item there.", 1, 0, 0, 53, 5);
					return
				end
			elseif cursorGotValidItem and isSameStack then
				cursor.ClearCursor();
			elseif cursorGotValidItem and cursorAndSlotItemAreIdentical and cursorGotSplittedStack then
				local targetItemGuid,_,targetAmount = container.GetContainerItemInfo(slotID);
				local _,_,_,targetStackSize = itemList.GetItemInfo(targetItemGuid).GetItemInfo();

				local transferAmount = math.min(targetStackSize-targetAmount,amount)
				if (transferAmount > 0) then
					local mergeStack = containers[cursorContainerGuid].CompleteSplitStack(cursorSlotID, transferAmount);
					container.MergeStacks(slotID, mergeStack);
					local remainingAmount = amount - transferAmount;
					if (remainingAmount > 0) then
						local cursorTexType,cursorDetail,func1,func2 = cursor.GetCursorInfo();
						cursor.ClearCursorWithoutFeedback();
						cursor.SetCursor( cursorTexType,cursorDetail,func1,func2,cursorType, cursorContainerGuid, cursorSlotID, nil, remainingAmount , cursorItemGuid);
					else
						cursor.ClearCursor();
					end
				end
			elseif cursorGotValidItem and cursorAndSlotItemAreIdentical then

				local remainingStack = container.MergeStacks(slotID, cursorStack);
				if not(remainingStack) then
					containers[cursorContainerGuid].ReplaceStack(cursorSlotID, nil);
					cursor.ClearCursor();
				else
				    local cursorTexType,cursorDetail,func1,func2 = cursor.GetCursorInfo();
					cursor.ClearCursorWithoutFeedback();
					cursor.SetCursor( cursorTexType,cursorDetail,func1,func2,cursorType, cursorContainerGuid, cursorSlotID, cursorStack, nil , cursorItemGuid);
				end
			elseif cursorGotValidItem and cursorGotSplittedStack and slotIsEmpty then
				local splitStack = containers[cursorContainerGuid].CompleteSplitStack(cursorSlotID, amount);
				cursor.ClearCursor();
				container.ReplaceStack(slotID, splitStack)
			elseif cursorGotValidItem and cursorGotSplittedStack then
				cursor.ClearCursor();
				UIErrorsFrame:AddMessage(ERR_SPLIT_FAILED, 1, 0, 0, 53, 5);
			elseif cursorGotValidItem then
				cursor.ClearCursor();
				local replacedStack = container.ReplaceStack(slotID, cursorStack);
				containers[cursorContainerGuid].ReplaceStack(cursorSlotID, replacedStack);

			elseif not (slotIsEmpty) then
				container.PickupContainerItem(slotID);
			end
			event.TriggerEvent("GHI_CONTAINER_UPDATE", containerGuid);
		end
	end

	class.SplitContainerItem = function(containerGuid, slotID, amount)
		if containers[containerGuid] then
			containers[containerGuid].PickupContainerItem(slotID, amount);
			event.TriggerEvent("GHI_CONTAINER_UPDATE", containerGuid);
		end
	end

	class.CopyContainerItem = function(containerGuid, slotID, amount)
		if containers[containerGuid] then
			containers[containerGuid].CopyContainerItem(slotID, amount);
		end
	end

	class.OpenBag = function(containerGuid, openedByStack, size, texture, name, icon)
		if containers[containerGuid] then
			if size then
				--containers[containerGuid].UpdateSize(size);
			end
			containers[containerGuid].SetName(name);
			containers[containerGuid].SetTexture(texture);
			containers[containerGuid].SetIcon(icon);
			containers[containerGuid].Open();
		else
			local containerInfo = GHI_ContainerInfo({
				guid = containerGuid,
				name = name,
				size = size,
				icon = icon,
				texture = texture,
			});
			containers[containerInfo.GetGUID()] = containerInfo;
			containerInfo.Open();
		end
	end



	class.DeleteItemFromBag = function(containerGuid, ...)
		if containers[containerGuid] then
			containers[containerGuid].DeleteItemFromBag(...);
		end
	end

	class.FindAllStacks = function(guid)
	--local item = itemList.GetItemInfo(guid);
		local t = {}
		for containerGuid, container in pairs(containers) do
			if container.IsContainerAccessible() then
				local res = container.FindAllStacks(guid)
				for slot, stack in pairs(res) do
					local addr = {containerGuid=containerGuid,slot = slot};
					t[addr] = stack;
				end
			end
		end
		return t;
	end

	class.InsertItemInMainBag = function(guid, amount)
		local item = itemList.GetItemInfo(guid);
		if item then
			local stack = item.GenerateStack(amount);
			return class.InsertStackInMainBag(stack),stack;
		end
		return false;
	end

	class.InsertStackInMainBag = function(stack)
		local i = 101;
		while (containers[i] and not (containers[i].InsertItem(stack))) do
			i = i + 1;
		end
		if not (containers[i]) then
			return false;
		end
		event.TriggerEvent("GHI_CONTAINER_UPDATE", i);
		return true;
	end

	class.InsertItemInBag = function(guid, amount, containerGuid,position)
		local item = itemList.GetItemInfo(guid);
		if item then
			local stack = item.GenerateStack(amount,position);
			local i = containerGuid;

			while type(i) == "number" and i < 200 do
				if containers[i] then
					local success,slot = containers[i].InsertItem(stack);
					if success then
						event.TriggerEvent("GHI_CONTAINER_UPDATE", i);
						return success,containerGuid,slot;
					end
				end
				i = i + 1;
			end

			if not(type(containerGuid) == "number") or  containerGuid >= 200 then
				if not(containers[containerGuid]) then
					containers[containerGuid] = GHI_ContainerInfo({
						guid = containerGuid,
						size = 32,
					});
				end

				local success,slot = containers[containerGuid].InsertItem(stack);
				if success then
					event.TriggerEvent("GHI_CONTAINER_UPDATE", containerGuid);
					return success,containerGuid,slot;
				end
				return false,slot;
			end
			return false,"Bag issue";
		end
		return false,"Item unknown";
	end

	class.GetContainerInfo = function(containerGuid)
		if containers[containerGuid] then
			return containers[containerGuid].GetContainerInfo();
		end
	end

	class.SetContainerObj = function(containerInfo)  -- Always overwrites.
		containers[containerInfo.GetGUID()] = containerInfo;
        class.SaveContainer(containerInfo.GetGUID());
		event.TriggerEvent("GHI_CONTAINER_UPDATE", containerInfo.GetGUID());
	end

	class.RemoveContainer = function(guid)
		containers[guid]= nil;
        class.SaveContainer(guid);
	end

	class.GetContainerObj = function(guid)
		return containers[guid];
	end

	class.GetStack = function(containerGuid,...)
		if containers[containerGuid] then
			return containers[containerGuid].GetStack(...);
		end
	end

	class.IsContainerFull = function(containerGuid)
		if containers[containerGuid] then
			return containers[containerGuid].GetNumFreeSlots() <= 0;
		end
		return false;
	end

	containers = {};
	savedContainerInfo = GHI_SavedData(CONTAINER_DATA_SAVE_TABLE);
	currentMainBagGuid = 101;


	return class;
end

