--
--									
--			GHI Item Data Transfer
--			GHI_ItemDataTransfer.lua
--
--	Syncronisation and transfering of item data
--				betweet clients
-- 						(c)2013 The Gryphonheart Team
--								All rights reserved
--

local class;
function GHI_ItemDataTransfer()
	if class then
		return class;
	end
	class = GHClass("GHI_ItemDataTransfer");

	local itemInfoList = GHI_ItemInfoList();
	local dynamicActionList = GHI_DynamicActionList();
	local comm = GHI_Comm();
	local log = GHI_Log();
	local recieveItemFeedbackFunc = {};

	class.AddRecieveDataItemFeedbackFunction = function(func)
		table.insert(recieveItemFeedbackFunc, func);
	end

	class.SyncItemLinkData = function(player, guid)
		local item = itemInfoList.GetItemInfo(guid)
		local version = 0;
		if item then
			version = item.GetVersions();
		end
		comm.Send("ALERT", player, "ItemVersion", guid, version);
	end

	local recieveItemDataRequest = function(player, guid, ...)
		local item = itemInfoList.GetItemInfo(guid)
		local data = item.Serialize("link");
		comm.Send(nil, player, "ItemData", guid, data)
	end
	comm.AddRecieveFunc("ItemDataRequest", recieveItemDataRequest);

	local recieveItemVersion = function(player, guid, version, ...)
		local item = itemInfoList.GetItemInfo(guid)
		local ownVersion = 0;
		if item then
			ownVersion = item.GetVersions();
		end
		if ownVersion < version then
			comm.Send("ALERT", player, "ItemDataRequest", guid);
		elseif ownVersion > version then
			recieveItemDataRequest(player, guid);
		else
			for _, f in pairs(recieveItemFeedbackFunc) do
				f(player, guid, false);
			end
		end
	end
	comm.AddRecieveFunc("ItemVersion", recieveItemVersion);

	local recieveItemData = function(player, guid, data, ...)
		if not (data.guid) then
			data.guid = guid;
		end
		local recievedItem = GHI_ItemInfo(data);
		local itemGotUpdated = itemInfoList.UpdateItem(recievedItem);

		for _, f in pairs(recieveItemFeedbackFunc) do
			f(player, guid, itemGotUpdated);
		end
	end
	comm.AddRecieveFunc("ItemData", recieveItemData);

	class.SyncItemActionData = function(player, guid)
		class.SyncItemLinkData(player, guid);
		local item = itemInfoList.GetItemInfo(guid)
		local _, version = 0,0;
		if item then
			_, version = item.GetVersions();
		end
		comm.Send("ALERT", player, "ItemActionVersion", guid, version, 1);
	end

	local recieveItemActionVersion = function(player, guid, version, format,...)
		local actionFormat = "oldAction";
		if format == 1 then
			actionFormat = "action";
		end

		local item = itemInfoList.GetItemInfo(guid)
		if item then
			local _, ownVersion = item.GetVersions();
			if ownVersion > version then
				local data = item.Serialize(actionFormat);

				-- split "rightClick" away from the rest of the data
				local rcData = data.rightClick;
				local otherData = {};
				for i, v in pairs(data) do
					if not (i == "rightClick") then
						otherData[i] = v;
					end
				end

				comm.Send("BULK", player, "ItemActionData", guid, rcData, otherData);
				comm.Send("ALERT", player, "ExpectItemActionData", guid, comm.GetQueueSize());

			elseif ownVersion < version then
				class.SyncItemActionData(player, guid);
			else
				log.Add(3, "Item action request unhandled. Versions are identical.", { guid = guid, version = version, ownVersion = ownVersion });
			end
		else
			log.Add(3, "Item action request unhandled. Item unknown.", { guid = guid, version = version });
		end
	end
	comm.AddRecieveFunc("ItemActionVersion", recieveItemActionVersion);

	local awaitingActionData = {};
	local receivedActionData = {};
	local SetAwaitingActionDataTime = function(guid,t)
		if not(receivedActionData[guid]) or (time() - receivedActionData[guid] > 15) then -- skip if the await flag arrives just after the data
			awaitingActionData[guid] = t;
		end
	end

	class.GetAwaitingActionDataTime = function(guid)
		return awaitingActionData[guid];
	end

	local recieveItemActionData = function(player, guid, rcData, otherData, ...)
		local data = otherData or {};
		data.rightClick = rcData;
		--awaitingActionData[guid] = nil;
		SetAwaitingActionDataTime(guid,nil);
		receivedActionData[guid] = time();
		local item = itemInfoList.GetItemInfo(guid);

		local currentData = item.Serialize("link");
		for i,v in pairs(data) do
			currentData[i] = v;
		end
		local newItem = GHI_ItemInfo(currentData);

		local itemGotUpdated = itemInfoList.UpdateItem(newItem)

		if itemGotUpdated then
			local dependingItems = newItem.GetDependingItems();
			for _, dependingGuid in pairs(dependingItems) do
				class.SyncItemLinkData(player, dependingGuid);
			end
			if #(dependingItems) > 0 then

				for i, dependingGuid in pairs(dependingItems) do
					GHI_Timer(function()
						class.SyncItemActionData(player, dependingGuid);
					end,(i-1)*5+#(dependingItems)*2,true);
				end

				receivedActionData[guid] = nil;
				SetAwaitingActionDataTime(guid,time()+#(dependingItems)*10);
				GHI_Timer(function() SetAwaitingActionDataTime(guid,nil); end,#(dependingItems)*10,true)

			end

			if newItem.GetItemComplexity() == "advanced" then
				local set = newItem.GetDynamicActionSet();
				if set then
					local guids = set.GetInstanceGuids();
					for _,daGuid in pairs(guids) do
						dynamicActionList.SyncDynamicAction(player,daGuid);
					end
				end
			end

		end
	end
	comm.AddRecieveFunc("ItemActionData", recieveItemActionData);

	local recieveExpectItemActionData = function(player, guid, queueSize, ...)
		if queueSize and queueSize > 5000 then
			--awaitingActionData[guid] = (queueSize / 250) + time();
			SetAwaitingActionDataTime(guid,(queueSize / 250) + time());
		else
			SetAwaitingActionDataTime(guid,nil);
		end
	end
	comm.AddRecieveFunc("ExpectItemActionData", recieveExpectItemActionData);

	return class;
end

