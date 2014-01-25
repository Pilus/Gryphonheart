--===================================================
--
--				GHI_DynamicActionInstanceSet
--  			GHI_DynamicActionInstanceSet.lua
--
--		Holds a set of dynamic action instances
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_DynamicActionInstanceSet(item, firstPortID, firstPortInfo)
	local class = GHClass("GHI_DynamicActionInstanceSet");

	local list = GHI_DynamicActionList();
	local instances = {};
	local availablePorts = { (firstPortID or "onclick"):lower() };
	local portConnections = {};
	local portInfo = {};
	portInfo[(firstPortID or "onclick"):lower()] = firstPortInfo;

	local RebuildDisplayStructure;
	local isUpdateSequence;

	class.Serialize = function()
		local t = {};
		t.instances = {};
		for i, instance in pairs(instances) do
			t.instances[i] = instance.Serialize();
		end
		t.availablePorts = availablePorts;
		t.portInfo = portInfo;
		t.isUpdateSequence = isUpdateSequence;
		t.portConnections = {};
		for portGuid, connectionSet in pairs(portConnections) do
			t.portConnections[portGuid] = {
				instanceGuid = connectionSet[1].GetGUID(),
				instancePortGuid = connectionSet[2],
			}
		end
		return t;
	end

	class.Deserialize = function(t)
		instances = {};
		for i, instanceData in pairs(t.instances) do
			instances[i] = GHI_DynamicActionInstance(nil, instanceData.guid, item.GetAuthorInfo());
			-- statistics
			GHI_SaveStatistic("totalDynamicActions");
			if item.IsCreatedByPlayer() then
				GHI_SaveStatistic("totalDynamicActionsByPlayer");
			end

		end -- parted into two for cross references
		for i, instanceData in pairs(t.instances) do
			instances[i].Deserialize(instanceData, class.GetInstance);
		end
		availablePorts = t.availablePorts;
		portInfo = t.portInfo or {};
		isUpdateSequence = t.isUpdateSequence;
		portConnections = {};
		for portGuid, connectionSet in pairs(t.portConnections) do
			if class.GetInstance(connectionSet.instanceGuid) then
				portConnections[portGuid] = {
					class.GetInstance(connectionSet.instanceGuid),
					connectionSet.instancePortGuid,
				}
			end
		end
	end

	class.AddInstance = function(instance)
		table.insert(instances, instance);
	end

	class.RemoveInstance = function(instance)
		for i,otherInstance in pairs(instances) do
			if instance == otherInstance then
				table.remove(instances,i);
			end
		end
	end

	class.GetGUID = function() return "set"; end -- for connected instance guid

	class.GetItem = function()
		return item;
	end

	class.SetInstanceAtPort = function(portGuid, instance, instancePortGuid)
		portGuid = portGuid:lower();
		if portConnections[portGuid] then
			local oldInstance,oldPortGuid = unpack(portConnections[portGuid]);
			oldInstance.SetInPortConnectionForSync(oldPortGuid,nil,nil);
		end

		if instance then
			portConnections[portGuid] = { instance, instancePortGuid };
			instance.SetInPortConnectionForSync(instancePortGuid, class, portGuid)
		else
		    portConnections[portGuid] = nil;
		end
		class.UpdateDisplayStructure();
	end

	class.GetInstanceAtPort = function(portGuid)
		portGuid = portGuid:lower();
		if portConnections[portGuid] then
			return unpack(portConnections[portGuid]);
		end
	end

	class.Execute = function(portGuid, stack, instanceIndex, isUpdateAction, feedbackFunctions, exeGuids)
		GHCheck("GHI_DynamicActionInstance.Execute", { "string", "table" , "numberNil","booleanNil","tableNil","tableNil"}, { portGuid, stack, instanceIndex, isUpdateAction, feedbackFunctions, exeGuids});
		local instance, instancePortGuid = class.GetInstanceAtPort(portGuid)
		if instance then
			instance.Execute(instancePortGuid, stack, instanceIndex, isUpdateAction, feedbackFunctions, exeGuids);
		end
	end

	class.GetAvailablePorts = function()
		return availablePorts;
	end

	class.GetPortInfo = function(portGuid)
		if portInfo[portGuid] then
			local t = portInfo[portGuid];
			return t.name,t.description;
		end
		return "Unknown","";
	end

	class.GetInstance = function(instanceGuid)
		if instanceGuid == "set" then
			return class;
		end
		for _, instance in pairs(instances) do
			if instance:GetGUID() == instanceGuid then
				return instance;
			end
		end
	end

	class.GetInstanceGuids = function()
		local t = {};
		for _, instance in pairs(instances) do
			table.insert(t, instance:GetGUID());
		end
		return t;
	end

	class.IsUpdateSequence = function()
		return isUpdateSequence;
	end

	class.SetIsUpdateSequence = function(_isUpdateSequence)
		isUpdateSequence = _isUpdateSequence;
	end

	class.GetDependingItems = function(stack)
		local t = {};
		for _,instance in pairs(instances) do
			local items = instance.GetDependingItems(stack);
			for _,item in pairs(items) do
				t[item] = true;
			end
		end

		local t2 = {};
		for i,_ in pairs(t) do
			table.insert(t2,i);
		end
		return t2;
	end

	local debugDraw = {};
	local DebugDraw = function(x, y)
		if not (debugDraw[x]) then
			debugDraw[x] = {};
		end
		debugDraw[x][y] = true;
	end
	class.GetDebugDraw = function(x, y)
		if debugDraw[x] then
			return debugDraw[x][y];
		end
	end

	class.UpdateDisplayStructure = function()
		debugDraw = {};

		local actionTreeStructure = GHI_ActionTreeStructure();
		local tree = actionTreeStructure.GenerateActionTree(availablePorts,portConnections,instances);

		local actionLocations = GHI_ActionsLocationInfo(tree);
		local connectionLayout = GHI_ConnectionsLayoutInfo(actionLocations);

		local verticalChannels = {};
		for i=0,actionLocations.GetNumTiers() do
			local verticalChannel = GHI_VerticalChannel(i,connectionLayout);
			verticalChannels[i] = verticalChannel;
		end

		local horizontalChannels = {};
		local maxNumber = actionLocations.GetNumActionsInLargestTier();
		for i=1,maxNumber do
			local horizontalChannel = GHI_HorizontalChannel(i,connectionLayout,verticalChannels);
			horizontalChannels[i] = horizontalChannel;
		end

		local actionsPositions = GHI_ActionsPositionInfo(actionLocations,verticalChannels,horizontalChannels);
		class.GetInstanceCoordinates = actionsPositions.GetInstanceCoordinates;
		class.GetPortCoordinates = actionsPositions.GetPortCoordinates;

		local connectionsPosition = GHI_ConnectionsPositionInfo(portConnections,connectionLayout,actionsPositions,verticalChannels,horizontalChannels);
		class.GetNumConnections = connectionsPosition.GetNumConnections;
		class.GetConnectionCoors = connectionsPosition.GetConnectionCoors;
		class.GetRequiredSize = connectionsPosition.GetRequiredSize;
	end

	return class;
end

