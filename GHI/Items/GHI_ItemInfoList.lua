--
--
--			GHI_ItemInfoList
--			GHI_ItemInfoList.lua
--
--	Holds a list of all items known to the player
--
--		(c)2013 The Gryphonheart Team
--			All rights reserved
--
local LOAD_IN_COROUTINE = true;

local class;
local ITEM_DATA_SAVE_TABLE = "GHI_ItemData";
local COOLDOWN_DATA_SAVE_TABLE = "GHI_CooldownData";
function GHI_ItemInfoList()
	if class then
		return class;
	end
	class = GHClass("GHI_ItemInfoList");

	local items = {};
	local savedItemInfo = GHI_SavedData(ITEM_DATA_SAVE_TABLE);
	local savedCooldownInfo = GHI_SavedData(COOLDOWN_DATA_SAVE_TABLE);
	local event = GHI_Event();
	local itemDataTransfer = GHI_ItemDataTransfer();
	local containerAPI = GHI_ContainerAPI().GetAPI()

	local GetAllDependingItems;
	--@description Gets all items that the given item depends on
	--@args guid
	--@returns table<GHI_ItemInfo>
    GetAllDependingItems = function(guid,depending)
        local item = items[guid];
        if not (item) then return {}; end

        depending = depending or {};

        for _, dependingGuid in pairs(item.GetDependingItems()) do
            if containerAPI.GHI_FindOneItem(dependingGuid) == nil then --it is not in any bag
                if not (tContains(depending, dependingGuid)) then
                    table.insert(depending, dependingGuid);
                    local subDepending = GetAllDependingItems(dependingGuid,depending);
                    for _, subDependingGuid in pairs(subDepending) do
                        if not (tContains(depending, subDependingGuid)) then
                            table.insert(depending, subDependingGuid);
                        end
                    end
                end
            end
        end
        return depending;
    end

	local ClearItemCacheThread = function()
		local requiredItems = {}
		local c = 0;
		for guid, item in pairs(items) do
			if GHI_ItemGuidsOfStacksLoaded[guid] then

				if not (tContains(requiredItems, guid)) then
					table.insert(requiredItems, guid);
				end

				local depending = GetAllDependingItems(guid);

				for _, dependingGuid in pairs(depending) do
					if not (tContains(requiredItems, dependingGuid)) then
						table.insert(requiredItems, dependingGuid);
					end
				end
			end
			c = c + 1;
			if c >= 50 then
				if LOAD_IN_COROUTINE then
					coroutine.yield()
					c = 0;
				end
			end
		end

		for guid, item in pairs(items) do
			if not (tContains(requiredItems, guid)) then
				savedItemInfo.SetVar(guid, nil)
				items[guid] = nil;
			end
		end
		GHI_Event().TriggerEvent("GHI_ITEM_CACHE_CLEARED")
	end

	--@description Clears the item cache of all unneeded items
	--@args
	--@returns
	class.ClearItemCache = function()
		if LOAD_IN_COROUTINE then
			local thread = coroutine.create(ClearItemCacheThread);
			--

			GHI_Timer(function()
				if coroutine.status(thread) ~= "dead" then
					coroutine.resume(thread)
				end
			end, 0.5)
		else
			ClearItemCacheThread();
		end
	end

	--@description Adds an item to the item list
	--@args GHI_ItemInfo
	--@returns
	class.AddItem = function(item,dontSave)
		GHCheck("GHI_ItemInfoList.AddItem", { "GHI_ItemInfo_Basic" }, { item });
		items[item.GetGUID()] = item;
		if not(dontSave) then
			class.SaveItem(item.GetGUID());
		end
	end

	--@description Gets an item with a given guid
	--@args guid
	--@returns GHI_ItemInfo
	class.GetItemInfo = function(guid)
		return items[guid];
	end

	class.LoadItemFromTable = function(itemTable)
		local item = GHI_ItemInfo(itemTable);
		local existingItem = items[item.GetGUID()];
		if not(existingItem) or item.IsNewest(existingItem) then
			class.AddItem(item);
		end
	end

	local LoadAllSavedItem = function()
		local allItems = savedItemInfo.GetAll();
		local c = 0;

		if type(allItems) == "table" then
			for index, itemTable in pairs(allItems) do

				if not (itemTable.guid) then
					itemTable.guid = index;
					savedItemInfo.SetVar(index, itemTable);
				end
				local itemInfo = GHI_ItemInfo(itemTable);
				class.AddItem(itemInfo,true);

				c = c + 1;
				if c >= 100 then
					if LOAD_IN_COROUTINE then
						coroutine.yield()
						c = 0;
					end
				end
			end
		end

		local cooldowns = savedCooldownInfo.GetAll();
		for index, item in pairs(items or {}) do
			local guid = item.GetGUID();
			if type(cooldowns[guid]) == "number" then
				item.SetLastCastTime(cooldowns[guid]);
			end
		end

		GHI_Event().TriggerEvent("GHI_ITEM_INFO_LOADED")
	end

	--@description Loads all items from the saved data set
	--@args
	--@returns
	class.LoadFromSaved = function()
		if LOAD_IN_COROUTINE then
			local thread = coroutine.create(LoadAllSavedItem);

			GHI_Timer(function()
				if coroutine.status(thread) ~= "dead" then
					local t = {coroutine.resume(thread)};
					if t[1] == false then
						geterrorhandler()(t[2],thread);
					end
				end
			end, 0.1)
		else
			LoadAllSavedItem();
		end
	end

	--@description Gets all guids that have available item info
	--@args
	--@returns table<guid>
	class.GetGuidsWithItemInfo = function()
		local t = {};
		for index, item in pairs(items) do
			table.insert(t, item.GetGUID());
		end
		return t;
	end


	--@description Updates and exchanges one item instance with a newer one, if it is newer. The old item is disposed.
	--@args GHI_ItemInfo
	--@returns boolean
	class.UpdateItem = function(newItem)
		GHCheck("GHI_ItemInfoList.AddItem", { "GHI_ItemInfo_Basic" }, { newItem });
		for _, i in pairs(items) do
			if newItem.GetGUID() == i.GetGUID() then
				if newItem.IsNewest(i) then
					items[newItem.GetGUID()] = newItem;
					wipe(i);
					class.SaveItem(newItem.GetGUID());
					event.TriggerEvent("GHI_ITEM_UPDATE", newItem.GetGUID());
					return true;
				end

				return false;
			end
		end

		items[newItem.GetGUID()] = newItem;
		class.SaveItem(newItem.GetGUID());
		return true;
	end

	--@description Get an item update of an item from a given player
	--@args String, guid
	--@returns
	class.RetrieveItemUpdate = function(player, guid)
		itemDataTransfer.SyncItemLinkData(player, guid);
	end

	--@description Display the link of an item into an itemRefTooltip
	--@args guid
	--@returns
	class.DisplayItemLink = function(guid,sendLines)

		if items[guid] then
			ShowUIPanel(ItemRefTooltip);
			if (not ItemRefTooltip:IsShown()) then
				ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
			end
			local lines = items[guid].GetTooltipLines();

			for _,sline in pairs(sendLines or {}) do
				local inserted = false;
				if sline.order == 70 and sline.order == 80 then
					return
				end

				for i=1,#(lines) do
					if lines[i].order == sline.order then
						lines[i] = sline;
						inserted = true;
						break
					elseif lines[i].order > sline.order then
						table.insert(lines,i,sline);
						inserted = true;
						break
					end
				end
				if not(inserted) then
					table.insert(lines,sline);
				end
			end

			ItemRefTooltip:ClearLines();
			for _, line in pairs(lines) do
				if not(line.order == 75 or line.order == 85) then
					ItemRefTooltip:AddLine(line.text, line.r, line.g, line.b, true);
				end
			end
			ItemRefTooltip:Show();
		end
	end

	--@description Displays an item tooltip
	--@args guid, frame, frame
	--@returns
	class.DisplayItemTooltip = function(guid, tooltipFrame)
		if items[guid] then
			items[guid].DisplayItemTooltip(tooltipFrame)
		end
	end

	--@description Gets a list of items that the given item depends on
	--@args guid
	--@returns table<guid>
	class.GetDependingItems = function(guid)
		local item = items[guid]

		return item.GetDependingItems();
	end

	local itemsSchedueledForSaving = {};
	class.SaveItem = function(guid)
		if guid and items[guid] then
			itemsSchedueledForSaving[guid] = true;
		end
	end

	GHI_Timer(function()
		for guid, _ in pairs(itemsSchedueledForSaving) do
			local item = items[guid];
			if (item) then
				local info = item.Serialize();
				savedItemInfo.SetVar(guid, info);
			end
			itemsSchedueledForSaving[guid] = nil;
		end
	end, 2)

	GHI_Event("GHI_BAG_UPDATE_COOLDOWN", function(event, bagGuid, itemGuid)
		if items[itemGuid] then
			local lastCastTime = items[itemGuid].GetLastCastTime();
			local info = items[itemGuid].Serialize();
			info.lastCastTime = lastCastTime;
			savedItemInfo.SetVar(itemGuid, info);
		end
	end);

	return class;
end
