--
--
--				GHP_EquippedItemsAPI
--  			GHP_EquippedItemsAPI.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--
local MAIN_HAND_INDEX = 1;
local SLOTS = {
	{
		guid = "mainHand",
		emptyTexture = "Interface/PaperDoll/UI-PaperDoll-Slot-Hands",
	},
	{
		guid = "offHand",
		emptyTexture = "Interface/PaperDoll/UI-PaperDoll-Slot-Hands",
	},
	{
		guid = "sheath",
		emptyTexture = "Interface/PaperDoll/UI-PaperDoll-Slot-Ammo",
	},
	{
		guid = "bag",
		emptyTexture = "Interface/PaperDoll/UI-PaperDoll-Slot-Bag",
	},
	{
		guid = "belt",
		emptyTexture = "Interface/PaperDoll/UI-PaperDoll-Slot-Waist",
	},
};
local GUID = "GHP_EQUIPPED_ITEMS";
local INTERACTION_RANGE = 2.0;

local INITIALIZED = false;
local ITEMS_LOADED = false;
local INIT;
GHI_Event("GHP_LOADED",function()
	ITEMS_LOADED = true;
	if INIT then
		INIT();
	end
end)

function GHP_EquippedItemsAPI(userGuid)
	local class = GHClass("GHP_EquippedItemsAPI");

	local containerList = GHI_ContainerList();
	local itemList = GHI_ItemInfoList();
	local loc = GHP_Loc();


	-- Initialization function
	if not(INITIALIZED) then
		INIT = function()
			INITIALIZED = true;
			local size = containerList.GetContainerInfo(GUID);
			if not(size) then
				local containerInfo = GHI_ContainerInfo({
					guid = GUID,
					name = "Equipped items",
					size = 36, -- A large fixed number. Since this will not be opened by a bag, then it does not matter. It gives us a limit of 36 equip slots
					icon = "",
					texture = nil,
				});
				containerList.SetContainerObj(containerInfo);
			end
			local container = containerList.GetContainerObj(GUID);
			container.SetOwnerItem(itemList.GetItemInfo("000001")); -- Set the dummy item as the owner, allowing contributing and official items into the equipped items
		end
		if ITEMS_LOADED then
			INIT();
		end
	end

	local event;
	event = GHI_Event("GHI_CONTAINER_UPDATE",function(e,guid)
		if guid == GUID then
			event.TriggerEvent("GHP_EQUIPPED_ITEMS_UPDATE")
		end
	end);

	class.GetNumEquippedItemSlots = function()
		return #(SLOTS);
	end

	class.GetIndexOfEquippedItemSlot = function(guid)
		for i,v in pairs(SLOTS) do
			if v.guid == guid then
				return i;
			end
		end
	end

	class.GetEquippedItemSlotInfo = function(i)
		if i <= #(SLOTS) then
			return SLOTS[i].guid,SLOTS[i].emptyTexture;
		end
	end

	class.GetEquippedItemInfo = function(i)
		if i <= #(SLOTS) then
			return containerList.GetContainerItemInfo(GUID,i)
		end
	end

	class.DisplayEquippedItemTooltip = function(i,tooltipFrame)
		local itemGuid = containerList.GetContainerItemInfo(GUID,i)
		if itemGuid then
			containerList.DisplayItemTooltip(GUID,i,tooltipFrame,tooltipFrame:GetOwner());
		elseif i <= #(SLOTS) then   -- empty
			tooltipFrame:ClearLines();

			tooltipFrame:AddLine(loc["GHP_EQUIP_SLOT_NAME_"..(SLOTS[i].guid):upper()]);
			tooltipFrame:Show();
		end
	end

	class.PickupEquippedItem = function(i)
		if i <= #(SLOTS) then
			containerList.PickupContainerItem(GUID,i);
		end
	end



	-- Hand item functionality
	local comm = GHI_Comm();
	local pos = GHI_Position();
	local versionInfo = GHI_VersionInfo();
	local itemDataTransfer = GHI_ItemDataTransfer();
	local miscAPI = GHI_MiscAPI().GetAPI();
	local errorThrower = GHI_ErrorThrower();
	local handingToPlayer;

	class.HandItemToPlayer = function(playerName)
		local stack = containerList.GetStack(GUID,MAIN_HAND_INDEX);
		if stack then
			if not(versionInfo.PlayerGotAddOn(playerName,"GHP")) then
				-- The player does not have GHP
				return  UIErrorsFrame:AddMessage(string.format(loc.PLAYER_NO_GHP,playerName), 1.0, 0.0, 0.0, 53, 5);
			end
			handingToPlayer = playerName;
			stack.SetLocked(true);
			comm.Send("ALERT",playerName,"GHP_IsPlayerNearPosition",pos.GetPlayerPos());
		end
	end

	comm.AddRecieveFunc("GHP_IsPlayerNearPosition",function(playerName,position)
		comm.Send("ALERT",playerName,"GHP_IsPlayerNearPositionAnswer",pos.IsPosWithinRange(position,INTERACTION_RANGE));
	end);

	comm.AddRecieveFunc("GHP_IsPlayerNearPositionAnswer",function(playerName,isWithinRange)
		local stack = containerList.GetStack(GUID,MAIN_HAND_INDEX);
		if stack and stack.IsLocked() and handingToPlayer == playerName then
			if isWithinRange then
				local guid,icon,count,_,quality = stack.GetContainerItemInfo();
				local name = stack.GetItemInfo().GetItemInfo();

				-- Start transfer of item data
				itemDataTransfer.SyncItemActionData(playerName,guid);

				comm.Send("ALERT",playerName,"GHP_HandItem",guid,count,name,icon,quality,stack.Serialize());
				print(string.format(loc.HANDING_ITEM,name,playerName));
			else
				errorThrower.TooFarAway();
				stack.SetLocked(false);
			end
		end
	end);
	StaticPopupDialogs["GHP_ACCEPT_HANDED_ITEM"] = {
		button1 = loc.ACCEPT,
		button2 = loc.DENY,
		timeout = 0,
		whileDead = 1,
		exclusive = 1,
		showAlert = nil,
		hideOnEscape = 1
	};
	comm.AddRecieveFunc("GHP_HandItem",function(playerName,guid,count,name,icon,quality,stackData)
		local container = containerList.GetContainerObj(GUID);

		local coloredName = miscAPI.GHI_ColorString("["..name.."]",
			ITEM_QUALITY_COLORS[quality].r,
			ITEM_QUALITY_COLORS[quality].g,
			ITEM_QUALITY_COLORS[quality].b
		);
		local iconString = string.format("|T%s:16|t",icon);

		StaticPopupDialogs["GHP_ACCEPT_HANDED_ITEM"].text = string.format(loc.HAND_ITEM,playerName,count,iconString,coloredName);
		StaticPopupDialogs["GHP_ACCEPT_HANDED_ITEM"].OnUpdate = function(self)
			local existingStack = containerList.GetStack(GUID,MAIN_HAND_INDEX);
			if existingStack then
				self.button1:Disable();
			else
				self.button1:Enable();
			end
		end
		StaticPopupDialogs["GHP_ACCEPT_HANDED_ITEM"].OnAccept = function()
			local stack = GHI_Stack(container,stackData);
			container.ReplaceStack(MAIN_HAND_INDEX,stack)
			comm.Send("ALERT",playerName,"GHP_AcceptHandedItem");
		end
		StaticPopupDialogs["GHP_ACCEPT_HANDED_ITEM"].OnCancel = function()
			comm.Send("ALERT",playerName,"GHP_RejectHandedItem");
		end

		-- display popup
		StaticPopup_Show("GHP_ACCEPT_HANDED_ITEM");
	end);
	comm.AddRecieveFunc("GHP_RejectHandedItem",function(playerName)
		if handingToPlayer == playerName then
			local stack = containerList.GetStack(GUID,MAIN_HAND_INDEX);
			stack.SetLocked(false);
			handingToPlayer = nil;
			print(string.format(loc.HAND_TO_RECIEPENT_REJECTED,playerName))

		end
	end);

	comm.AddRecieveFunc("GHP_AcceptHandedItem",function(playerName)
		if handingToPlayer == playerName then
			local container = containerList.GetContainerObj(GUID);
			container.ReplaceStack(MAIN_HAND_INDEX,nil)
			handingToPlayer = nil;
			print(string.format(loc.HAND_TO_RECIEPENT_ACCEPTED,playerName))

		end
	end);

	StaticPopupDialogs["GHP_RECIEVER_HAND_ITEM"] = {
		text = loc.GIVE_RECIEVER_HAND_ITEM,
		EditBoxOnEnterPressed = function(self)
			local name = self:GetParent().editBox:GetText();
			class.HandItemToPlayer(name);
		end,
		OnAccept = function(self)
			local name = self.editBox:GetText();
			class.HandItemToPlayer(name);
		end,
		EditBoxOnTextChanged = function (self, data)
			if string.len(self:GetText()) > 0 then
		    	self:GetParent().button1:Enable()
			else
				self:GetParent().button1:Disable()
			end
		end,
		button1 = OKAY,
		button2 = CANCEL,
		timeout = 0,
		whileDead = 1,
		exclusive = 1,

		showAlert = nil,
		hideOnEscape = 1,
		hasEditBox  = true,
	};

	local players = GHP_ActivePlayers();
	class.GetEquippedItemInteractionOptions = function(index)
		local stack = containerList.GetStack(GUID,index);
		if not(stack) or stack.IsLocked() then
			return {};
		end

		local options = {
			{
				name = "Use item",
				func = function()
					containerList.UseItem(GUID,index);
				end,
			}
		};

		if index == MAIN_HAND_INDEX then
			local nearbyPlayers = players.GetNearbyActivePlayers();
			local t = {
				name = loc.HAND_TO,
				sub = {
					{
						name = "...",
						func = function()
							StaticPopup_Show("GHP_RECIEVER_HAND_ITEM");
						end
					},
				},
			};

			for _,name in pairs(nearbyPlayers) do
				table.insert(t.sub,{
					name = name,
					func = function()
						class.HandItemToPlayer(name);
					end
				});
			end

			table.insert(options,t);
		end

		return options;
	end

	return class;
end

