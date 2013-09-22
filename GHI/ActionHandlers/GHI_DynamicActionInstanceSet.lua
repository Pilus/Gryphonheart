--===================================================
--
--				GHI_DynamicActionInstanceSet
--  			GHI_DynamicActionInstanceSet.lua
--
--	    Holds a set of dynamic action instances
--
-- 	  (c)2013 The Gryphonheart Team
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

	class.Deserialize = function(t)      --print("set deserialized from data",class)
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


	--[[
	local GenerateSubTree;
	GenerateSubTree = function(dept, instance, remainingInstances)
	-- The actions are ordered in a tree structure including only the connections that goes into a 'SetUp' port (I1).
	-- A action can at this point have many children, each connected to a port from 1 to N.

		local tree = {
			dept = dept,
			instance = instance,
		};
		remainingInstances[instance] = nil;

		for i = 1, instance.GetPortsOutCount() do
			local pGuid, _, _, connectedTo = instance.GetPortInfo("out", i);
			if connectedTo then
				local firstGuid = connectedTo.instance.GetPortInfo("in", 1)
				if connectedTo.portGuid == firstGuid then
					table.insert(tree, GenerateSubTree(tree.dept + 1, connectedTo.instance,remainingInstances));
				end
			end
		end
		return tree;
	end

	local UpdateActionTree = function()
		local remainingInstances = {};
		for _,instance in pairs(instances or {}) do
			remainingInstances[instance] = true;
		end

		local tree = { dept = 1 };
		for _, portGuid in pairs(availablePorts) do
			if portConnections[portGuid] then
				local instance, instancePortGuid = unpack(portConnections[portGuid]);
				local firstUsedPortGuid;
				for i = 1,instance.GetPortsInCount() do
					local pg = instance.GetPortInfo("in", i);
					if pg then
						firstUsedPortGuid = pg;
					end
					break;
				end
				if instancePortGuid == firstUsedPortGuid then
					table.insert(tree, GenerateSubTree(tree.dept + 1, instance, remainingInstances));
				end
			else
				--print("no connections in",portGuid)
			end
		end

		for instance,_ in pairs(remainingInstances) do
			if remainingInstances[instance] == true then
				table.insert(tree,GenerateSubTree(2,instance,remainingInstances));
			end
		end

		return tree;
	end
	--]]

	--local locationActionTable = {}; -- contains the action at a given location
	--local actionLocationTable = {}; -- contains the location for a given action
    --[[
	local UpdateActionLocationTable;
	UpdateActionLocationTable = function(tree)
		local dept = tree.dept;
		if dept == 1 then
			locationActionTable = {};
			actionLocationTable = {};
		end
		locationActionTable.maxTier = math.max(locationActionTable.maxTier or 0, dept);
		if not (locationActionTable[dept]) then
			locationActionTable[dept] = {};
		end
		for i = 1, #(tree) do
			local subTree = tree[i];
			local instance = subTree.instance;
			if instance then
				table.insert(locationActionTable[dept], instance);
				local n = #(locationActionTable[dept]);
				actionLocationTable[instance.GetGUID()] = { dept, n };
				UpdateActionLocationTable(subTree);
			end
		end
	end  --]]

	--local connectionList;
	--[[local UpdateConnectionList = function()
		connectionList = {};
		for startTier, sub in pairs(locationActionTable) do
			if type(startTier) == "number" then
				for startNumber, startInstance in pairs(sub) do
					for startPortIndex = 1, startInstance.GetPortsOutCount() do
						local startPortGuid, _, _, connectionInfo = startInstance.GetPortInfo("out", startPortIndex);
						if connectionInfo then
							local endInstance = connectionInfo.instance;
							local endPortGuid = connectionInfo.portGuid
							local endLocation = actionLocationTable[endInstance:GetGUID()];
							if endLocation then
								local endTier, endNumber = unpack(endLocation);
								local _, endPortIndex = endInstance.IdentifyPort(endPortGuid);

								local connectDirectly = false;
								if startNumber == endNumber and startTier < endTier then
									connectDirectly = true;
									for i = startTier + 1, endTier - 1 do
										if sub[i] then
											connectDirectly = false;
										end
									end
								end


								table.insert(connectionList, {
									startInstance = startInstance,
									endInstance = endInstance,
									startPortGuid = startPortGuid,
									endPortGuid = endPortGuid,
									startPortIndex = startPortIndex,
									endPortIndex = endPortIndex,
									startTier = startTier,
									endTier = endTier,
									startNumber = startNumber,
									endNumber = endNumber,
									horizontalChannel = math.min(startNumber, endNumber),
									connectDirectly = connectDirectly,
									length = abs(startTier - endTier),
								})
							end
						end
					end
				end
			end
		end
	end --]]

	--local portCoordinates = {};
	--local actionCoordinates = {};

	--local horizontalChannelInfo;

	--[[
	local DetermineVerticalPos = function(tier, number)
		local instance = locationActionTable[tier][number];
		local guid = instance.GetGUID();
		if tier == 1 and number == 1 then
			local portGuid = availablePorts[number];
			portCoordinates[portGuid] = { x = 1, y = 3 }
			actionCoordinates[guid] = {
				x = 3,
				size = math.max(instance.GetPortsInCount(), instance.GetPortsOutCount()) + 3,
				y = 1
			};
		else
			local _, _, _, connectionTriggeringSetup = instance.GetPortInfo("in", 1);
			local minYCoor = 0;

			if connectionTriggeringSetup then
				local connectedPortNumber = 1;
				_,connectedPortNumber = connectionTriggeringSetup.instance.IdentifyPort(connectionTriggeringSetup.portGuid);
				local connectedInstanceGuid = connectionTriggeringSetup.instance:GetGUID();
				if connectedInstanceGuid then
					minYCoor = connectedPortNumber + actionCoordinates[connectedInstanceGuid].y - 1;
				end
			end



			if number == 1 then
				actionCoordinates[guid] = {
					x = tier * 5 - 2, -- temp number. Can be removed later when fully implemented
					size = math.max(instance.GetPortsInCount(), instance.GetPortsOutCount()) + 3,
					y = math.max(minYCoor, 1),
				};
			else
				local aboveInstance = locationActionTable[tier][number - 1];
				local aboveGuid = aboveInstance.GetGUID();
				local aboveSize = actionCoordinates[aboveGuid].size;
				local aboveY = actionCoordinates[aboveGuid].y;
				local aboveX = actionCoordinates[aboveGuid].x;
				local aboveChannelY = horizontalChannelInfo[number - 1].startY;
				local aboveChannelHeight = horizontalChannelInfo[number - 1].height;

				actionCoordinates[guid] = {
					x = aboveX, -- temp number. Can be removed later when fully implemented
					size = math.max(instance.GetPortsInCount(), instance.GetPortsOutCount()) + 2,
					y = math.max(minYCoor, aboveY + aboveSize, aboveChannelY + aboveChannelHeight),
				};
			end
		end
	--print(tier,"y",actionCoordinates[guid].y);
	end --]]

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

	--[[
	local ConsiderHorizontalChannel = function(number, lastTier)
	-- Determine the size of the channel
		local channelRoofSize = {};

		-- Definition of the size for the horizontal part of a VH transfer area for an action 'i'
		-- left: max( A[i].y + A[i].size, A[i+1].y + A[i+1].GetPortsInCount()+1 )
		-- right: max( A[i+1].y + A[i+1].size, A[i].y + A[i].GetPortsOutCount()+1 )

		local smallest;
		for tier = 1, lastTier do
			local instanceXprev = (locationActionTable[tier - 1] or {})[number];
			local instanceX = (locationActionTable[tier] or {})[number];
			local instanceXnext = (locationActionTable[tier + 1] or {})[number];

			local xPrevHeight;
			if instanceXprev then
				local guid = instanceXprev:GetGUID();
				local coor = actionCoordinates[guid];
				xPrevHeight = coor.y + instanceXprev.GetPortsOutCount() + 2;
			end

			local xHeight;
			if instanceX then
				local guid = instanceX:GetGUID();
				local coor = actionCoordinates[guid];
				xHeight = coor.y + coor.size;
			end


			local xNextHeight;
			if instanceXnext then
				local guid = instanceXnext:GetGUID();
				local coor = actionCoordinates[guid];
				xNextHeight = coor.y + instanceXnext.GetPortsInCount() + 2;
			end

			local key = (tier - 1) .. "-" .. tier;
			local height = math.max(xPrevHeight or 0, xHeight or 0, xNextHeight or 0);

			if height > 0 then
				smallest = math.min(height, smallest or height);
				channelRoofSize[key] = height;
			end
		end
		for tier = 1, lastTier do
			local key = (tier - 1) .. "-" .. tier;
			channelRoofSize[key] = (channelRoofSize[key] or 2 * smallest) - smallest;
		end

		local connections = {};
		for _, connection in pairs(connectionList) do
			if connection.horizontalChannel == number and connection.connectDirectly == false then
				connection.horizontalLane = nil;
				table.insert(connections, connection);
			end
		end
		-- look at the shortest connections first
		table.sort(connections, function(c1, c2)
			if not(c1 and c2) then
				return false;
			end
			if c1.length ~= c2.length then
				return c1.length < c2.length;
			elseif c1.startNumber == c2.startNumber and c1.startNumber == number then
				if c1.startTier == c2.startTier or c1.endTier == c2.endTier then
					if c1.endTier <= c1.startTier and c2.endTier <= c2.startTier then
						if c1.startPortIndex >= c2.startPortIndex then
							return true;
						else
							return false;
						end
					else
						if c1.startPortIndex <= c2.startPortIndex then
							return true;
						else
							return false;
						end
					end
				end
			end
			return true;
		end);

		local channelLanes = {};
		local lastLane = 0;
		for _, connection in ipairs(connections) do
			local preferedLaneNum = 1;
			while (true) do
				local freeLane = true;
				local laneInfo = channelLanes[preferedLaneNum];
				for _, otherConnection in pairs(laneInfo or {}) do
					if otherConnection.startTier == connection.startTier or otherConnection.endTier == connection.endTier then
						freeLane = false;
					elseif otherConnection.startTier > connection.startTier and otherConnection.startTier < connection.endTier then
						freeLane = false;
					elseif otherConnection.endTier > connection.startTier and otherConnection.endTier < connection.endTier then
						freeLane = false;
					end
				end
				if freeLane then
					if connection.startTier < connection.endTier then
						for i = connection.startTier + 1, connection.endTier - 1 do
							if channelRoofSize[(i - 1) .. "-" .. i] >= preferedLaneNum then
								freeLane = false;
							end
						end
					else
						for i = connection.endTier, connection.endTier do
							--print((i-1).."-"..i,"roof size",channelRoofSize[(i-1).."-"..i])
							if channelRoofSize[(i - 1) .. "-" .. i] >= preferedLaneNum then
								freeLane = false;
							end
						end
					end
				end
				if freeLane then
					break;
				else
					preferedLaneNum = preferedLaneNum + 1;
				end
			end

			channelLanes[preferedLaneNum] = channelLanes[preferedLaneNum] or {};
			table.insert(channelLanes[preferedLaneNum], connection);
			connection.horizontalLane = preferedLaneNum;
			lastLane = math.max(lastLane, preferedLaneNum);
		end

		horizontalChannelInfo[number] = {
			startY = smallest,
			height = lastLane,
		}
	end

	local UpdateVerticalPos = function()
		actionCoordinates = {};
		portCoordinates = {};

		local number = 1;
		while (number) do
			local lastTierInLine = 0;
			for tier = 1, locationActionTable.maxTier do
				if (locationActionTable[tier][number]) then
					DetermineVerticalPos(tier, number);
					lastTierInLine = tier;
				end
			end

			if lastTierInLine > 0 then
				ConsiderHorizontalChannel(number, lastTierInLine);
			else
				break;
			end
			number = number + 1;
		end
	end

	local verticalChannelInfo = {};
	local ConsiderVerticalChannel = function(tier)
		local connections = {};
		for _, connection in pairs(connectionList) do
			if connection.startTier == tier or connection.endTier == tier + 1 then
				table.insert(connections, connection);
			end
		end
		table.sort(connections, function(c1, c2)
			if not(c1 and c2) then
				return false;
			end
			if c1.startTier == tier then
				if c2.startTier == tier then
					--return true; -- eventual other sort requirements
					-- prioritize connections with a high output index
					if c1.startPortIndex >= c2.startPortIndex then
						return true;
					else
						return false;
					end
				else
					return true
				end
			else
				if c2.startTier == tier then
					return false
				else
					return false; -- evt. more sorting
				end
			end
		end);

		local startX = 1;
		local channelLanes = {};
		local lastLane = 0;
		for _, connection in ipairs(connections) do
			local preferedLaneNum = 1;


			local y1, y2;
			if connection.connectDirectly then
				if connection.startTier == tier then
					-- start of a direct connection. It might be needed to use a lane for vertical change
					local coor1 = actionCoordinates[connection.startInstance:GetGUID()];
					local coor2 = actionCoordinates[connection.endInstance:GetGUID()];
					y1 = coor1.y + 2 + connection.startPortIndex;
					y2 = coor2.y + 2 + connection.endPortIndex;
				else
					-- end of a direction connection (that starts in another tier). no vertical change is needed
					print("not implemented")
				end
			elseif connection.startTier == tier and connection.endTier == tier + 1 then
				-- connection between two actions without any need for horizontal channels
				local coor1 = actionCoordinates[connection.startInstance:GetGUID()];
				local coor2 = actionCoordinates[connection.endInstance:GetGUID()];
				y1 = coor1.y + 2 + connection.startPortIndex;
				y2 = coor2.y + 2 + connection.endPortIndex;
			elseif connection.startTier == tier then
				-- the connection starts at an action and follows the vertical channel to its horizontal channel
				local channelInfo = horizontalChannelInfo[connection.horizontalChannel];
				local coor = actionCoordinates[connection.startInstance:GetGUID()];
				y1 = channelInfo.startY + connection.horizontalLane - 1;
				y2 = coor.y + 2 + connection.startPortIndex;
			else
				-- the connection comes from an horizontal channel and follows the vertical channel to its action input port.
				local channelInfo = horizontalChannelInfo[connection.horizontalChannel];
				local coor = actionCoordinates[connection.endInstance:GetGUID()];
				y1 = channelInfo.startY + connection.horizontalLane - 1;
				y2 = coor.y + 2 + connection.endPortIndex;
			end
			local topY, bottomY = math.max(y1, y2), math.min(y1, y2);

			while (true) do
				local freeLane = true;
				for _, otherConnection in pairs(channelLanes[preferedLaneNum] or {}) do
					if topY >= otherConnection.bottomY and bottomY <= otherConnection.topY then
						freeLane = false;
					elseif otherConnection.topY >= bottomY and otherConnection.bottomY <= topY then
						freeLane = false;
					end
				end

				if freeLane then
					break;
				else
					preferedLaneNum = preferedLaneNum + 1;
				end
			end

			channelLanes[preferedLaneNum] = channelLanes[preferedLaneNum] or {};
			table.insert(channelLanes[preferedLaneNum], {
				con = connection,
				topY = topY,
				bottomY = bottomY,
			});
			if connection.startTier == tier then
				connection.startVerticalLane = preferedLaneNum;
			end
			if connection.endTier == tier + 1 then
				connection.endVerticalLane = preferedLaneNum;
			end


			lastLane = math.max(lastLane, preferedLaneNum);
		end
		verticalChannelInfo[tier] = {
			startX = 2,
			width = math.max(lastLane,1),
		};
	end

	local DetermineHorizontalPos = function(tier, number)
		local x = verticalChannelInfo[tier - 1].startX + verticalChannelInfo[tier - 1].width;
		for number, instance in pairs(locationActionTable[tier] or {}) do
			if instance then
				actionCoordinates[instance.GetGUID()].x = x;
			end
		end
		verticalChannelInfo[tier].startX = x + 3;
	end

	local UpdateHorizontalPos = function()
		ConsiderVerticalChannel(0);

		for tier, sub in pairs(locationActionTable) do
			if type(tier) == "number" then
				ConsiderVerticalChannel(tier); -- run before horizontal pos so the startX can be modified
				DetermineHorizontalPos(tier);
			end
		end
	end
	--]]
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
	--[[

	-- GUI functions
	class.GetInstanceCoordinates = function(guid)
		local a = actionCoordinates[guid];
		if a then
			return a.x, a.y;
		end
	end

	class.GetPortCoordinates = function(portGuid)
		if portCoordinates[portGuid] then
			local c = portCoordinates[portGuid];
			if c.x and c.y then
				return c.x, c.y;
			end
		end
		return 1, 3;
	end       --]]

	--[[
	class.GetNumConnections = function()
		local c = 0;
		for _, _ in pairs(portConnections) do c = c + 1; end

		return #(connectionList or {}) + c;
	end --]]


	--[[

	local GetStartPos = function(connection)
		local coor = actionCoordinates[connection.startInstance:GetGUID()];
		local x = coor.x + 3;
		local y = coor.y + 1 + connection.startPortIndex;
		return x, y;
	end

	local GetEndPos = function(connection)
		local coor = actionCoordinates[connection.endInstance:GetGUID()];
		local x = coor.x - 1;
		local y = coor.y + 1 + connection.endPortIndex;
		return x, y;
	end

	class.GetConnectionCoors = function(i)
		local connection = connectionList[i];
		local coors = {};

		if not (connection) then   -- the connections to the trigger ports
			i = i - #(connectionList or {});

			-- port connection
			local c = 0;
			for _, portGuid in pairs(availablePorts) do
				if portConnections[portGuid] then
					c = c + 1;
					if c == i then
						local endInstance = portConnections[portGuid][1];
						local endPortGuid = portConnections[portGuid][2];
						local _, endPortIndex = endInstance.IdentifyPort(endPortGuid)

						local startX, startY = class.GetPortCoordinates(portGuid)
						startX = startX + 1;
						local endX, endY = GetEndPos({ endInstance = endInstance, endPortIndex = endPortIndex });
						if startY == endY then
							if startX == endX then
								table.insert(coors, { x = startX, y = startY, t = "right" });
							else
								table.insert(coors, { x = startX, y = startY, t = "right" });
								table.insert(coors, { x = endX, y = endY, t = "right" });
							end
						else
							if startX == endX then
							else
							end
						end
						return coors;
					end
				end
			end
			return
		end

		if connection.connectDirectly then
			local startX, startY = GetStartPos(connection);
			local endX, endY = GetEndPos(connection);
			if startY == endY then
				table.insert(coors, { x = startX, y = startY, t = "right" });
				table.insert(coors, { x = endX, y = endY, t = "right" });
			elseif startY > endY then -- going up
		   		local verticalChannel1 = verticalChannelInfo[connection.startTier];
				local verX = verticalChannel1.startX + connection.startVerticalLane - 1;

				if startX < verX then
					table.insert(coors, { x = startX, y = startY, t = "right" });
				end
				table.insert(coors, { x = verX, y = startY, t = "bottomright" });
				table.insert(coors, { x = verX, y = endY, t = "topleft" });
				if endX > verX then
					table.insert(coors, { x = endX, y = endY, t = "right" });
				end
			else -- going down
				local verticalChannel1 = verticalChannelInfo[connection.startTier];
				local verX = verticalChannel1.startX + connection.startVerticalLane - 1;

				if startX < verX then
					table.insert(coors, { x = startX, y = startY, t = "right" });
				end
				table.insert(coors, { x = verX, y = startY, t = "topright" });
				table.insert(coors, { x = verX, y = endY, t = "bottomleft" });
				if endX > verX then
					table.insert(coors, { x = endX, y = endY, t = "right" });
				end
			end
		elseif connection.startTier == connection.endTier - 1 then     -- connection going directly from one action to another without going back or skipping an action
			local startX, startY = GetStartPos(connection);
			local endX, endY = GetEndPos(connection);
			local verX = startX + connection.startVerticalLane - 1;
			if connection.startVerticalLane > 1 then
				table.insert(coors, { x = startX, y = startY, t = "right" });
			end
			if startY < endY then
				table.insert(coors, { x = verX, y = startY, t = "topright" });
			else
				table.insert(coors, { x = verX, y = startY, t = "bottomright" });
			end
			if startY < endY then
				table.insert(coors, { x = verX, y = endY, t = "bottomleft" });
			else
				table.insert(coors, { x = verX, y = endY, t = "topleft" });
			end
			if verX < endX then
				table.insert(coors, { x = endX, y = endY, t = "right" });
			end
		else

			local startDirInv = "down";
			if connection.horizontalChannel >= connection.startNumber then
				startDirInv = "up";
			end
			local endDirInv = "down";
			if connection.horizontalChannel >= connection.endNumber then
				endDirInv = "up";
			end
			local hDir = "left"
			local hDirInv = "right";
			if connection.endNumber > connection.startNumber then
				hDirInv = "left";
				hDir = "right"
			end

			-- start pos
			local startX, startY = GetStartPos(connection);
			if connection.startVerticalLane > 1 then
				table.insert(coors, { x = startX, y = startY, t = "right" });
				-- vertical channel pos

				local verticalChannel1 = verticalChannelInfo[connection.startTier];
				local verX = verticalChannel1.startX + connection.startVerticalLane - 1;

				if startDirInv == "down" then
					table.insert(coors, { x = verX, y = startY, t = "bottomright" });
				else
					table.insert(coors, { x = verX, y = startY, t = "topright" });
				end
			else -- start pos are on top of vertical channel pos
				-- depending on dir
				if startDirInv == "down" then
					table.insert(coors, { x = startX, y = startY, t = "bottomright" });
				else
					table.insert(coors, { x = startX, y = startY, t = "topright" });
				end
			end

			-- channel transfer pos
			local horizontalChannel = horizontalChannelInfo[connection.horizontalChannel];
			local x = coors[#(coors)].x;
			--print(horizontalChannel.startY , connection.horizontalLane)
			local y = horizontalChannel.startY + connection.horizontalLane - 1;
			if startDirInv == "up" then
				table.insert(coors, { x = x, y = y, t = "bottomright" });
			else
				table.insert(coors, { x = x, y = y, t = "topright" });
			end

			-- channel transfer 2 pos
			local verticalChannel2 = verticalChannelInfo[connection.endTier - 1];
			local x = verticalChannel2.startX + connection.endVerticalLane - 1;

			if endDirInv == "up" then
				table.insert(coors, { x = x, y = y, t = "bottomleft"});
			else
				table.insert(coors, { x = x, y = y, t = "topleft"});
			end

			-- vertical channel 2 pos
			local endX, endY = GetEndPos(connection);
			if endDirInv == "down" then
				table.insert(coors, { x = x, y = endY, t = "bottomleft"});
			else
				table.insert(coors, { x = x, y = endY, t = "topleft"});
			end

			-- end pos
			if endX ~= x then
				table.insert(coors, { x = endX, y = endY, t = "left" });
			end
		end
		return coors;
	end
	  --]]
	--[[
	class.GetRequiredSize = function()
		local height, width = 4, 3;
		local i = 1;
		while horizontalChannelInfo[i] do
			height = horizontalChannelInfo[i].startY + horizontalChannelInfo[i].height;
			i = i + 1;
		end
		local i = 1;
		while verticalChannelInfo[i] do
			width = verticalChannelInfo[i].startX + verticalChannelInfo[i].width;
			i = i + 1;
		end
		return height, width;
	end          --]]
	return class;
end

