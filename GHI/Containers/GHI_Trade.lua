--===================================================
--
--						GHI Trade
--						GHI_Trade.lua
--						<< Singleton >>
--
--				Trade of items between players
--
-- 				(c)2013 The Gryphonheart Team
--					All rights reserved
--
--===================================================

local class
function GHI_Trade()
	if class then return class end;

	class = GHClass("GHI_Trade","frame");

	local tradeItemsPlayer = {};
	local tradeItemsRecipient = {};
	local tradeLinksSend = {}; --needed?
	local playerAcceptState, recipientAcceptState;
	local tradePlayer;
	local comm = GHI_Comm();
	local orig = {};
	local ping = GHI_Ping();
	local tradeRecipientGotGHI;
	local tradeItemTypeTexts = {};
	local recipientItemTypeTexts = {};
	local itemDataTransfer = GHI_ItemDataTransfer();
	local sendLinksIDs = {};
	local miscApi = GHI_MiscAPI().GetAPI();
	local actionApi = GHI_ActionAPI().GetAPI();
	local containerApi = GHI_ContainerAPI().GetAPI();
	local cursor = GHI_CursorHandler();
	local containerList = GHI_ContainerList();
	local versionInfo = GHI_VersionInfo();
	local itemInfoList = GHI_ItemInfoList();

	local loc = GHI_Loc();

	local GetFreeBagIndex, AcceptTrade, ClearRecipientButton, ClearTradeButton, ClickTradeButton, GetGhiItemFromSlot, GetRecipientTradeItem, GetTradeItemBagInfo, GetTradeItemDuration;
	local InsertItem, OnEvent, PickUpGhiItem, PickupGhiItemPlaceGhiItem, PickupGhiItemPlaceWowItem, PickupNonePlaceGhiItem, PickupWowItemPlaceGhiItem, RecieveBag;
	local RecieveItem, RecievePlayerPing, RecieveRemoveTradeItem, RecieveTradeItem, RemoveBag, RemoveItem, SendTradeInfo, SetGhiItemInSlot, SetTradeItem, UpdateRecipientTradeItem;
	local UpdateTradeInfo, ClearAll, CreateItemTypeTexts, NoTradeResponceError, SetTradeItemDuration, CancelAcceptTrade, GetGhiItemFromCursor, CancelTrade;
	local GetBagInfoForBagAndSubBags, GetTradeItemBagGuid, SendLinkData, SendLinkDataForAllItemsInBag, LockAllBags;

	local GetRecipientFullName = function()
		return GHUnitName("npc")
	end

	RecievePlayerPing = function(player, version)
		if player == tradePlayer then
			tradeRecipientGotGHI = true;
		end
	end
	ping.RegisterRecievePingFunc(RecievePlayerPing);

	OnEvent = function(self, event, arg1, arg2, ...)
		if (event == "TRADE_CLOSED") then
			if (playerAcceptState == 1 and recipientAcceptState == 1) then

				comm.Send(nil, tradePlayer, "TradeAccepted", nil);
				AcceptTrade(tradePlayer);
			end
		elseif (event == "TRADE_ACCEPT_UPDATE") then
			playerAcceptState = TradeHighlightPlayer:IsShown();
			recipientAcceptState = TradeHighlightRecipient:IsShown();

		elseif (event == "TRADE_SHOW") then
			ClearAll();
			tradePlayer = GetRecipientFullName();
			ping.SendPing(tradePlayer, true);
		elseif (event == "TRADE_REQUEST_CANCEL") then
			CancelTrade();
		end
	end

	ClearAll = function()
		tradeItemsPlayer = {}
		tradeItemsRecipient = {}
		tradeLinksSend = {};
		playerAcceptState = nil;
		recipientAcceptState = nil;
		tradePlayer = nil;
		tradeRecipientGotGHI = nil;
		sendLinksIDs = {};

		for _, f in pairs(tradeItemTypeTexts) do
			f:Hide();
		end
		for _, f in pairs(recipientItemTypeTexts) do
			f:Hide();
		end
	end

	CreateItemTypeTexts = function()
		for i = 1, 6 do
			local f = TradeFrame:CreateFontString();
			f:SetPoint("LEFT", _G["TradePlayerItem" .. i .. "Name"], "LEFT", -2, -12);
			f:SetFontObject(GameFontHighlightSmall);
			f:SetTextColor(1, 0.8196079, 0);
			f:Hide();
			tradeItemTypeTexts[i] = f;
		end

		for i = 1, 6 do
			local f = TradeFrame:CreateFontString();
			f:SetPoint("LEFT", _G["TradeRecipientItem" .. i .. "Name"], "LEFT", -2, -12);
			f:SetFontObject(GameFontHighlightSmall);
			f:SetTextColor(1, 0.8196079, 0);
			f:Hide();
			recipientItemTypeTexts[i] = f;
		end
	end

	ClickTradeButton = function(slot)
		if slot > 6 then return orig.ClickTradeButton(slot); end;

		local cursorGotGhiItem = cursor.GetCursor() == "GHI_ITEM";
		local slotGotGhiItem = tradeItemsPlayer[slot] and true;
		local slotGotNormalItem = GetTradePlayerItemInfo(slot) and true;
		local slotGotNoItem = not (slotGotGhiItem or slotGotNormalItem);

		if cursorGotGhiItem and not (tradeRecipientGotGHI) then
			return NoTradeResponceError();
		end

		if cursorGotGhiItem and slotGotNormalItem then
			PickupWowItemPlaceGhiItem(slot);
		elseif cursorGotGhiItem and slotGotGhiItem then
			PickupGhiItemPlaceGhiItem(slot);
		elseif cursorGotGhiItem and slotGotNoItem then
			PickupNonePlaceGhiItem(slot);
		elseif not (cursorGotGhiItem) and slotGotNormalItem then
			orig.ClickTradeButton(slot)
		elseif not (cursorGotGhiItem) and slotGotGhiItem then
			PickupGhiItemPlaceWowItem(slot) -- placing nothing instead of wow item
		elseif not (cursorGotGhiItem) and slotGotNoItem then
			orig.ClickTradeButton(slot)
			return
		end

		CancelAcceptTrade();
	end
	orig["ClickTradeButton"] = _G["ClickTradeButton"];
	_G["ClickTradeButton"] = ClickTradeButton;

	NoTradeResponceError = function()
		local player = GetRecipientFullName();
		if player and versionInfo.PlayerGotAddOn(player, "GHI") then
			GHI_Message(loc.TRADE_BUSY);
			ping.SendPing(player, true);
			return
		end
		GHI_Message(loc.TRADE_NO_GHI);
	end;

	PickupNonePlaceGhiItem = function(slot)
		SetGhiItemInSlot(slot, GetGhiItemFromCursor());
		cursor.ClearCursorWithoutFeedback();
	end

	PickupWowItemPlaceGhiItem = function(slot)
		local item = { GetGhiItemFromCursor() };
		orig.ClickTradeButton(slot)
		SetGhiItemInSlot(slot, unpack(item));
		cursor.ClearCursorWithoutFeedback();
	end

	PickupGhiItemPlaceWowItem = function(slot)
		local item = { GetGhiItemFromSlot(slot) };
		ClearTradeButton(slot);
		orig.ClickTradeButton(slot);
		PickUpGhiItem(unpack(item));
	end

	PickupGhiItemPlaceGhiItem = function(slot)
		local item = { GetGhiItemFromCursor() };
		local item2 = { GetGhiItemFromSlot(slot) };
		PickUpGhiItem(unpack(item2));
		SetGhiItemInSlot(slot, unpack(item));
	end

	GetGhiItemFromCursor = function()
		local cursorType, containerGuid, containerSlotID, stack, amount = cursor.GetCursor();
		local splitStack, origStackClone;
		if not (amount == nil) then
			origStackClone = stack.Clone();
			splitStack = stack.CompleteSplitStack(amount);
		else
			local _;
			_, _, amount = stack.GetContainerItemInfo();
		end
		return amount, containerGuid, containerSlotID, stack, splitStack, origStackClone;
	end

	LockAllBags = function(bagInfo)
		for bagguid,_ in pairs(bagInfo) do
			local container = containerList.GetContainerObj(bagguid);
			if container then
				container.SetLocked(true);
			end
		end
	end

	SetGhiItemInSlot = function(slot, amount, containerGuid, containerSlotID, stack, splitStack, origStackClone)
		local item;
		if splitStack then
			item = splitStack.GetItemInfo();
		elseif stack then
			item = stack.GetItemInfo();
		else
			return;
		end

		tradeItemsPlayer[slot] = {
			amount = amount,
			containerGuid = containerGuid,
			containerSlotID = containerSlotID,
			stack = stack,
			splitStack = splitStack,
			origStackClone = origStackClone,
			bagGuid = stack.GetAttribute("bagContainerGuid",1),
			item = item;
		};

		local bagInfo = {};
		if stack then -- Tradeable bags are always in a non split stack
			GetBagInfoForBagAndSubBags(stack,bagInfo)
		end
		local gotBags = false;
		for i,v in pairs(bagInfo) do
			gotBags = true;
			break;
		end

		if gotBags then
			if not(versionInfo.PlayerGotAddOn(tradePlayer, "GHI","2.1.2")) then
				tradeItemsPlayer[slot] = nil;
				if stack then
					stack.SetLocked(false);
				end
				GHI_Message(loc.TRADE_BAG_VERSION_ERROR);
				return
			end
		end

		tradeItemsPlayer[slot].bagInfo = bagInfo;

		local name, icon, _, _, itemType = item.GetItemInfo();

		LockAllBags(bagInfo);
		SetTradeItem(slot, amount, name, icon, item.GetColoredItemTypeText())
		SendTradeInfo(tradePlayer, slot, item, amount, splitStack or stack, bagInfo)
	end

	GetGhiItemFromSlot = function(slot)
		local t = tradeItemsPlayer[slot];
		if not (type(t) == "table") then
			return
		end
		return t.amount, t.containerGuid, t.containerSlotID, t.stack, t.splitStack, t.origStackClone, t.bagGuid, t.bagInfo;
	end

	SetTradeItem = function(slot, amount, name, texture, coloredItemTypeText)
		local itemButton = _G["TradePlayerItem" .. slot .. "ItemButton"];
		SetItemButtonTexture(itemButton, texture);
		SetItemButtonCount(itemButton, amount);
		tradeItemTypeTexts[slot]:Show();
		tradeItemTypeTexts[slot]:SetText(coloredItemTypeText);
		_G["TradePlayerItem" .. slot .. "Name"]:SetText(name);
	end

	local RemoveFromTradeIfPresent = function(stack)
		for i = 1,6 do
			local _, _, _, _, _, _, _, tradeStack = GetRecipientTradeItem(i);
			if stack == tradeStack then
				ClearTradeButton(i);
			end
		end
	end

    GetBagInfoForBagAndSubBags = function(stack,bagInfo)
   		local bagGuid = GetTradeItemBagGuid(stack);
		if bagGuid then
			local cont = containerList.GetContainerObj(bagGuid);
			if cont and not(bagInfo[bagGuid]) then
				bagInfo[bagGuid] = cont.GetContainerInfoTable();
				local size = cont.GetContainerInfo();
				for i=1,size do
					local substack = cont.GetStack(i);
					if substack then
						RemoveFromTradeIfPresent(substack);
						GetBagInfoForBagAndSubBags(substack,bagInfo);
					end
				end
			end
		end
	end

	GetTradeItemBagGuid = function(stack)
		return stack.GetAttribute("bagContainerGuid",1)
	end

	SendLinkData = function(guid)
		if not (sendLinksIDs[guid]) then
			itemDataTransfer.SyncItemLinkData(tradePlayer, guid);
			sendLinksIDs[guid] = true;
		end
	end

	SendLinkDataForAllItemsInBag = function(bagGuid)
		local cont = containerList.GetContainerObj(bagGuid);
		if cont then
			for i=1,cont.GetContainerInfo() do
				local substack = cont.GetStack(i);
				if substack then
					SendLinkData(substack.GetContainerItemInfo())
				end
			end
		end
	end

	SendTradeInfo = function(player, slot, item, amount, stackToSend, bagInfo)
		local guid = item.GetGUID();
		local name, icon, _, _, itemType = item.GetItemInfo();

		comm.Send("ALERT",player,"ExpectTradeItem", slot)
		SendLinkData(guid);

		-- link all items in bags
		if bagInfo then
			for bagguid,_ in pairs(bagInfo) do
				SendLinkDataForAllItemsInBag(bagguid);
			end
		end
		comm.Send(nil, player, "TradeItem", slot, guid, amount, name, icon, itemType, {}, bagInfo, stackToSend.GetStackInfoTable());
	end

	GetTradeItemBagInfo = function(stack)
		local bagGuid = GetTradeItemBagGuid(stack);
		if bagGuid then
			local container = containerList.GetContainerObj(bagGuid);
			return container.GetContainerInfoTable();
		end
	end

	local expectTradeItem = {};
	local GetNumExpecting = function()
		local c = 0;
		for _,v in pairs(expectTradeItem) do
			if v then
				c = c + 1;
			end
		end
		return c;
	end
	comm.AddRecieveFunc("ExpectTradeItem", function(player,slot)
		if player == tradePlayer and tradeItemsPlayer[slot] == nil then
			expectTradeItem[slot] = true;
			CancelAcceptTrade();
			TradeFrameTradeButton_Disable();
			local itemType = miscApi.GHI_ColorString(loc.TRADE_DATA_WAIT,1.0,0.1,0.1);
			recipientItemTypeTexts[slot]:Show();
			recipientItemTypeTexts[slot]:SetText(itemType);
		end
	end);

	RecieveTradeItem = function(player, slot, guid, amount, name, texture, itemType, duration, bagInfo, stack, ...)
		if player == tradePlayer then
			if not (itemType) or itemType == 3 then
				itemType = 1;
			end
			CancelAcceptTrade();
			tradeItemsRecipient[slot] = {
				guid = guid,
				amount = amount,
				name = name,
				itemType = itemType,
				texture = texture,
				duration = duration,
				bagInfo = bagInfo,
				stack = stack,
			};
			expectTradeItem[slot] = nil;
			UpdateRecipientTradeItem(slot, name, texture, amount, itemType);
		end
	end
	comm.AddRecieveFunc("TradeItem", RecieveTradeItem);

	CancelAcceptTrade = function()
		local n = GetPlayerTradeMoney();
		SetTradeMoney(1);
		SetTradeMoney(n);
	end

	UpdateRecipientTradeItem = function(slot, name, texture, amount, itemType)
		if (GetTradeTargetItemInfo(slot)) then
			-- Wait with updating until the item is gone
			GHI_Timer(function() UpdateRecipientTradeItem(slot, name, texture, amount, itemType) end, 1, true);
		end

		local itemButton = _G["TradeRecipientItem" .. slot .. "ItemButton"];

		SetItemButtonTexture(itemButton, texture);
		SetItemButtonCount(itemButton, amount);

		local itemType = miscApi.GHI_ColorString(GHI_ITEM_TYPE_NAME[itemType], GHI_ITEM_TYPE_COLOR[itemType].r, GHI_ITEM_TYPE_COLOR[itemType].g, GHI_ITEM_TYPE_COLOR[itemType].b);-- todo: localization:Was not sure how, think most locales are in for it though?
		recipientItemTypeTexts[slot]:Show();
		recipientItemTypeTexts[slot]:SetText(itemType);
		_G["TradeRecipientItem" .. slot .. "Name"]:SetText(name);
		if GetNumExpecting() == 0 then
			TradeFrameTradeButton_Enable();
		end
	end

	UpdateTradeInfo = function(slot, guid, amount, itemType)
		local item = itemInfoList.GetItemInfo(guid);
		if not (item) and TradeFrame:IsShown() then
			GHI_Timer(function() UpdateTradeInfo(slot, guid, amount, itemType) end, 1, true);
		else
			local name, icon = item.GetItemInfo();
			UpdateRecipientTradeItem(slot, name, icon, amount, itemType);
		end
	end

	ClearTradeButton = function(slot)
		tradeItemsPlayer[slot] = nil;
		local itemButton = _G["TradePlayerItem" .. slot .. "ItemButton"];
		SetItemButtonTexture(itemButton, "");
		SetItemButtonCount(itemButton, 1);
		_G["TradePlayerItem" .. slot .. "Name"]:SetText("");
		tradeItemTypeTexts[slot]:Hide();
		comm.Send("ALERT", tradePlayer, "RemoveTradeItem", slot);
		if GetNumExpecting() == 0 then
			TradeFrameTradeButton_Enable();
		end
	end

	RecieveRemoveTradeItem = function(player, slot)
		CancelAcceptTrade();
		ClearRecipientButton(slot);
	end
	comm.AddRecieveFunc("RemoveTradeItem", RecieveRemoveTradeItem);

	PickUpGhiItem = function(splitAmount, containerGuid, containerSlotID, stack, splitStack, origStackClone)
		if splitStack then
			local container = stack.GetParentContainer();
			container.ReplaceStack(containerSlotID, origStackClone);
			stack = origStackClone;
			stack.SetLocked(true);
		else
			splitAmount = nil;
		end
		local _, texture = stack.GetContainerItemInfo();
		cursor.SetCursor("ITEM", texture, function() stack.SetLocked(false); end, function(...) StaticPopup_Show("GHI_DELETE_ITEM"); end, "GHI_ITEM", containerGuid, containerSlotID, stack, splitAmount);
	end

	ClearRecipientButton = function(slot)
		tradeItemsRecipient[slot] = {};
		local itemButton = _G["TradeRecipientItem" .. slot .. "ItemButton"];

		SetItemButtonTexture(itemButton, "");
		SetItemButtonCount(itemButton, 1);

		recipientItemTypeTexts[slot]:Hide();
		_G["TradeRecipientItem" .. slot .. "Name"]:SetText("");
		CancelAcceptTrade();
	end

	local itemDataSynced = {};
	local SyncItemData = function(playerName,guid)
		local item = itemInfoList.GetItemInfo(guid);
		local _,_,_,_,itemType = item.GetItemInfo();
		if not(itemDataSynced[guid]) and not (itemType == 4) then
			itemDataTransfer.SyncItemActionData(playerName, guid);
			itemDataSynced[guid] = true;
		end
	end

	local SyncAllItemDataForAllItemsInContainer = function(playerName,container)
		local size = container.GetContainerInfo();
		for i=1,size do
			local substack = container.GetStack(i);
			if substack then
				local itemGuid = substack.GetContainerItemInfo();
				SyncItemData(playerName,itemGuid)
			end
		end
	end

	AcceptTrade = function(name, ...)
		if name == tradePlayer then
			-- delete
			for slot = 1, 6 do
				local amount, containerGuid, containerSlotID, stack, splitStack, _, bagGuid, bagInfo = GetGhiItemFromSlot(slot);
				if stack then
					if splitStack then
						stack.SetLocked(false);
					else
						local container = stack.GetParentContainer();
						container.ReplaceStack(containerSlotID, nil);
					end
				end

				if bagInfo then
					for aBagGuid,_ in pairs(bagInfo) do
						containerList.RemoveContainer(aBagGuid)
					end
				end
			end

			-- insert
			itemDataSynced = {};
			for i = 1, 6 do
				local guid, amount, _, _, itemType, _, bagInfo, stack = GetRecipientTradeItem(i);
				if guid then
					SyncItemData(name,guid)
					if stack then

						local stackObj = GHI_Stack(nil, stack)
						containerList.InsertStackInMainBag(stackObj);
						stackObj.TriggerUpdateSequences("tradeRecieve");

						if bagInfo then
							for _,info in pairs(bagInfo) do
								local container = GHI_ContainerInfo(info)
								containerList.SetContainerObj(container);
								SyncAllItemDataForAllItemsInContainer(name,container)

							end
						end
					else
						local _,stack = containerList.InsertItemInMainBag(guid, amount);
						stack.TriggerUpdateSequences("tradeRecieve")
					end
				end
			end
			ClearAll();
		end
	--GHI_UpdateContainers();
	end

	CancelTrade = function()
		for slot = 1, 6 do
			local amount, containerGuid, containerSlotID, stack, splitStack, origStackClone, bagGuid, bagInfo = GetGhiItemFromSlot(slot);
			if stack then
				if splitStack then
					local container = stack.GetParentContainer();
					container.ReplaceStack(containerSlotID, origStackClone);
					origStackClone.SetLocked(false);
				else
					stack.SetLocked(false);
				end

				if bagInfo then
					for guid,_ in pairs(bagInfo) do
						local container = containerList.GetContainerObj(guid);
						if container then
							container.SetLocked(false);
						end
					end
				end
			end
		end
		ClearAll();
	end

	GetRecipientTradeItem = function(slot)
		local t = tradeItemsRecipient[slot];
		if type(t) == "table" then
			return t.guid, t.amount, t.name, t.texture, t.itemType, t.duration, t.bagInfo, t.stack;
		end
	end

	local TradeItemButtonOnEnter = function(self, slot) -- updated
		local ID = GetGhiItemFromSlot(slot);
		if ID then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			local showInspectionDetails = false;
			local _, _, cursorType = miscApi.GHI_GetCurrentCursor();
			if cursorType == "GHI_INSPECT" then
				showInspectionDetails = true;
			end

			local amount, containerGuid, containerSlotID, stack, splitStack = GetGhiItemFromSlot(slot);
			containerApi.GHI_DisplayContainerItemTooltip(containerGuid, containerSlotID, GameTooltip, self, showInspectionDetails);
		end
	end
	local TradeItemButtonOnUpdate = function(self, elapsed)
		if (self.updateTooltip) then
			self.updateTooltip = self.updateTooltip - elapsed;
			if (self.updateTooltip > 0) then
				return;
			end
		end

		if (GameTooltip:IsOwned(self)) then
			TradeItemButtonOnEnter(self, self:GetParent():GetID());
		end
	end
	local RecipientTradeItemButtonOnEnter = function(self, slot)

		local ID = GetRecipientTradeItem(slot);
		if ID then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");

			local guid = GetRecipientTradeItem(slot);
			local item = itemInfoList.GetItemInfo(guid);
			if item then
				item.DisplayItemTooltip(GameTooltip);
			end
		end
	end
	local RecipientTradeItemButtonOnUpdate = function(self, elapsed)
		if (self.updateTooltip) then
			self.updateTooltip = self.updateTooltip - elapsed;
			if (self.updateTooltip > 0) then
				return;
			end
		end

		if (GameTooltip:IsOwned(self)) then
			RecipientTradeItemButtonOnEnter(self, self:GetParent():GetID());
		end
	end

	-- SetUp
	class:SetScript("OnEvent", OnEvent);
	class:RegisterEvent("TRADE_CLOSED");
	class:RegisterEvent("TRADE_ACCEPT_UPDATE");
	class:RegisterEvent("TRADE_SHOW");
	class:RegisterEvent("TRADE_REQUEST_CANCEL");

	comm.AddRecieveFunc("TradeAccepted", AcceptTrade);

	local Old_Script_ItemButton = TradePlayerItem1ItemButton:GetScript("OnEnter");
	local Old_Script_ItemButtonUpdate = TradePlayerItem1ItemButton:GetScript("OnUpdate");
	local Old_Script_RecipientItemButton = TradeRecipientItem1ItemButton:GetScript("OnEnter");
	local Old_Script_RecipientItemButtonUpdate = TradeRecipientItem1ItemButton:GetScript("OnUpdate");

	for i = 1, 6 do
		_G["TradePlayerItem" .. i .. "ItemButton"]:SetScript("OnEnter", function(self) Old_Script_ItemButton(self); TradeItemButtonOnEnter(self, self:GetParent():GetID()); end);
		_G["TradePlayerItem" .. i .. "ItemButton"]:SetScript("OnUpdate", function(self, arg1) Old_Script_ItemButtonUpdate(self); TradeItemButtonOnUpdate(self, arg1); end);
		_G["TradeRecipientItem" .. i .. "ItemButton"]:SetScript("OnEnter", function(self) Old_Script_RecipientItemButton(self); RecipientTradeItemButtonOnEnter(self, self:GetParent():GetID()); end);
		_G["TradeRecipientItem" .. i .. "ItemButton"]:SetScript("OnUpdate", function(self, arg1) Old_Script_RecipientItemButtonUpdate(self); RecipientTradeItemButtonOnUpdate(self, arg1); end);
	end

	CreateItemTypeTexts();

	if TradeFrame:IsShown() then
		OnEvent(nil, "TRADE_SHOW");
	end
	return class;
end

