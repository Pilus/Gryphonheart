--
--
--				GHP_ObjectAPI
--  			GHP_ObjectAPI.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--
local INTERACTION_RANGE = 1;
function GHP_ObjectAPI(userGuid)
	local class = GHClass("GHP_ObjectAPI");

	local reg = GHP_ObjectInstanceRegister();
	local objectList = GHP_ObjectList();
	local itemList = GHI_ItemInfoList();
	local containerList = GHI_ContainerList();
	local errorThrower = GHI_ErrorThrower();
	local pos = GHI_Position();
	local systemList = GHP_ProfessionSystemList();
	local abilityList = GHP_AbilityList();
	local professionList = GHP_ProfessionList();
	local loc = GHP_Loc();

	local SPAWNED_OBJ_GUID = (userGuid or "").."_OBJECTS2_";

	class.GetNumNearbyObjects = function(visibleOnly)
		return reg.GetNumNearbyObjects(visibleOnly);
	end

	class.GetObjectInfo = function(index,visibleOnly)
		local obj = reg.GetObjectInstance(index,visibleOnly)
		if obj then
			return obj.GetInfo();
		end
	end

	class.GetObjectGuid = function(index,visibleOnly)
		local obj = reg.GetObjectInstance(index,visibleOnly)
		if obj then
			return obj.GetObjectGuid();
		end
	end

	class.GetObjectInstance = function(index,visibleOnly)
		local objIns = reg.GetObjectInstance(index,visibleOnly)
		if objIns then

			local canEdit = false
			if objIns.IsItem() then
				local item = objIns.GetItemInfo();
				canEdit = item.IsCreatedByUser(userGuid);
			else
				local obj = objIns.GetObject();
				canEdit = obj.IsCreatedByUser(userGuid);
			end

			return {
				GetAttribute = function(attName)
					return objIns.GetAttributeValue(attName);
				end,
				SetAttribute = function(attName,attValue)
					if canEdit then
						objIns.SetAttributeValue(attName,attValue);
					else
						error("You do not have write access to this attribute")
					end
				end,
				GetPosition = function()
					return objIns.GetPosition();
				end,
				SetPosition = function(pos)
					if canEdit then
						objIns.SetPosition(pos);
					end
				end,
				Consume = function(amount)
					reg.RemoveObjectInstance(objIns);
					if objIns.IsItem() then
						containerList.DeleteItemFromBag(objIns.GetParentContainer().GetGUID(),objIns.GetParentContainer().GetSlotIDOfStack(objIns),amount);
					end
				end,
				GetStack = function()
					if objIns.IsItem() then
						local api,_ = objIns.GetAPI(canEdit);
						return api;
					end
				end
			};

		end
	end

	class.DisplayObjectTooltip = function(index,tooltipFrame,visibleOnly)
		local objIns = reg.GetObjectInstance(index,visibleOnly)
		if objIns then
			objIns.DisplayTooltip(tooltipFrame)
		end
	end




	class.SpawnObject = function(objGuid,position,attributes)
		assert(type(objGuid)=="string")
		assert(type(position)=="table")
		assert(type(attributes)=="table" or type(attributes)=="nil")

		local obj = objectList.GetObject(objGuid);
		if not(obj) then
			error("Object unknown");
		end

		if not(obj.IsCreatedByUser(userGuid)) then
			error("No write access");
		end

		local objIns = GHP_ObjectInstance({
			guid = GHI_GUID().MakeGUID(),
			objectGuid = objGuid,
			position = position,
			attributes = attributes,
		});
		objIns.Activate();
	end

	class.SpawnItemAsObject = function(itemGuid,position,attributes,amount)
		assert(type(itemGuid)=="string")
		assert(type(position)=="table")
		assert(type(attributes)=="table" or type(attributes)=="nil")
		assert(type(amount)=="number" or type(amount)=="nil")

		local item = itemList.GetItemInfo(itemGuid);
		if not(item) then
			error("Object unknown");
		end

		if not(item.IsCreatedByUser(userGuid)) then
			error("No write access");
		end
		local bagGuid = SPAWNED_OBJ_GUID;
		local i = 1;
		while ( true) do
			local size = containerList.GetContainerInfo(bagGuid..i);
			if not(size) then
				break;
			end

			if not(containerList.IsContainerFull(bagGuid..i)) then
				break;
			end

			i = i + 1;
		end


		-- 000001
		local container = containerList.GetContainerObj(bagGuid..i);
		if not(container) then
			containerList.SetContainerObj(GHI_ContainerInfo({
				guid = bagGuid..i,
				size = 32,
			}));
			container = containerList.GetContainerObj(bagGuid..i);
		end
		container.SetOwnerItem(itemList.GetItemInfo("000001")); -- Set the dummy item as the owner, allowing contributing and official items into the bag

		local success,container,slot = containerList.InsertItemInBag(itemGuid, amount,bagGuid..i,position);
		if success then
			local stack = containerList.GetStack(container,slot);
			for i,v in pairs(attributes or {}) do
				stack.SetAttribute(i,v);
			end
			stack.Activate();
		else
			error("stack generation failed "..(container or "nil"))
		end
	end

	local GetInteractionOptions = function(objIns)
		--[[ Get a list of all object interaction options:
		* 'Perform: X' for all the objects abilities that is know to the player. None if the object is an item
		* 'Perform: X' for all the abilities from any profession that involves this item in its current state. Only if the object is an item.
		* Change owner
		* Change public / private
		* Pick up item
		--]]

		if not(pos.IsPosWithinRange(objIns.GetPosition(),INTERACTION_RANGE)) then
			errorThrower.TooFarAway();
			return {};
		end

		local options = {};
		if objIns.IsItem() then
			-- 'Perform: X' for all the abilities from any profession that involves this item
			local itemGuid = objIns.GetContainerItemInfo();
			local systemGuids = systemList.GetSystemGuids();
			for _,systemGuid in pairs(systemGuids) do
				local system = systemList.GetSystem(systemGuid);
				local allKnown = system.GetAllAbilities("known");
				for profGuid,abilities in pairs(allKnown) do
					for _,abilityGuid in pairs(abilities) do
						local ability = abilityList.GetAbility(abilityGuid);
						if ability.CanInitializeFrom(itemGuid) then
							local profession = professionList.GetProfession(profGuid);
							local abilityIns = profession.GetAbilityInstance(abilityGuid);

							local _,name,icon = ability.GetInfo();
							table.insert(options,{
								name = string.format("Perform: %s",name),
								icon = icon,
								func = function()
									abilityIns.Execute(systemGuid,profGuid,abilityGuid,objIns.GetGuid())
								end,
							})
						end
					end
				end
			end
			table.insert(options,{
				name = loc.PICK_UP_ITEM,
				func = function()
					containerList.PickupContainerItem(objIns.GetParentContainer().GetGUID(),objIns.GetParentContainer().GetSlotIDOfStack(objIns));
				end,
			})
		else
			-- 'Perform: X' for all the objects abilities that is know to the player
			local obj = objIns.GetObject();
			local abilityInstances = obj.GetAbilityInstances();
			for _,abilityInstance in pairs(abilityInstances) do
				local abilityGuid = abilityInstance.GetAbilityGuid();

				local systemGuids = systemList.GetSystemGuids();
				for _,systemGuid in pairs(systemGuids) do
					local system = systemList.GetSystem(systemGuid);
					local known,_,profGuid = system.AbilityIsKnown(abilityGuid);
					if known then
						local ability = abilityInstance.GetAbility();
						local _,name,icon = ability.GetInfo();
						table.insert(options,{
							name = string.format("Perform: %s",name),
							icon = icon,
							func = function()
								obj.Execute(systemGuid,profGuid,abilityGuid,objIns.GetGuid())
							end,
						})
					end
				end
			end


		end
		return options;
	end

	class.GetObjectInteractionOptions = function(index)
		local visibleOnly = true; -- visible only can be assumed
		local objIns = reg.GetObjectInstance(index,visibleOnly)
		if objIns then
	   		return GetInteractionOptions(objIns);
		end
		return {};
	end

	return class;
end

