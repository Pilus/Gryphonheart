--===================================================
--
--				GHI_ConnectionsLayoutInfo
--  			GHI_ConnectionsLayoutInfo.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_ConnectionsLayoutInfo(actionLocations)
	local class = GHClass("GHI_ConnectionsLayoutInfo");

	local connectionList;

	local UpdateConnectionsForPort = function(startInstance,startTier,startNumber,startPortIndex)
		assert(startInstance and startTier and startNumber and startPortIndex,"Missing info for UpdateConnectionsForPort",startInstance,startTier,startNumber,startPortIndex)

		local startPortGuid, _, _, connectionInfo = startInstance.GetPortInfo("out", startPortIndex);
		if connectionInfo then
			local endInstance = connectionInfo.instance;
			local endPortGuid = connectionInfo.portGuid
			local endTier, endNumber = actionLocations.GetLocationOfAction(endInstance:GetGUID())
			if endTier and endNumber then
				local _, endPortIndex = endInstance.IdentifyPort(endPortGuid);

				local connectDirectly = false;
				if startNumber == endNumber and startTier < endTier then
					connectDirectly = true;
					--[[for i = startTier + 1, endTier - 1 do -- todo: for connections over areas with no actions
						if sub[i] then
							connectDirectly = false;
						end
					end --]]
				end

				assert(startPortGuid and endPortGuid and endInstance and endPortIndex and endTier and endNumber,"Some info not calculated correctly",startPortGuid , endPortGuid , endInstance , endPortIndex,  endTier , endNumber)
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
					length = abs(startTier - endTier),
				})
			end
		end
	end


	local UpdateConnectionList = function()
		connectionList = {};
		for tier = 1,actionLocations.GetNumTiers() do
			for actionNum = 1,actionLocations.GetNumActionsInTier(tier) do
				local instance = actionLocations.GetInstance(tier,actionNum);
				if instance then
					for portIndex = 1, instance.GetPortsOutCount() do
						UpdateConnectionsForPort(instance,tier,actionNum,portIndex)
					end
				end
			end
		end
	end

	class.GetRaw = function()
		return connectionList;
	end

	class.GetConnectionsInVerticalChannel = function(tier)
		local connections = {};
		for _, connection in pairs(connectionList) do
			if (connection.startTier == tier or connection.endTier == tier + 1) and not(connection.startTier == connection.endTier - 1 and connection.startPortIndex == connection.endPortIndex and connection.startNumber == connection.endNumber) then
				table.insert(connections, connection);
			end
		end
		return connections;
	end

	class.GetConnectionsInHorizontalChannel = function(number)
		local connections = {};
		for _, connection in pairs(connectionList) do
			if math.min(connection.startNumber, connection.endNumber) == number and connection.startTier ~= connection.endTier-1 then
				table.insert(connections, connection);
			end
		end
		return connections;
	end

	class.GetNumConnections = function()
		return #(connectionList);
	end

	class.GetConnection = function(i)
		return connectionList[i];
	end


	UpdateConnectionList();

	return class;
end

