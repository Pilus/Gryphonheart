--===================================================
--
--				GHI_VerticalChannel
--  			GHI_VerticalChannel.lua
--
--	Holds information about the vertical channels
--	of connections.
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_VerticalChannel(tier,connectionLayout)
	local class = GHClass("GHI_VerticalChannel");

	--[[  Rules for connection routing
		- A straight ahead connection is always allowed
		- Internal connections are determined by output priority

		Placing order indexes (left to right):
		1: Highest output going up  / lowest output going down etc.
		... ordering by degree of 1
		2: Any same level connections going from tier to tier + 1
        3: Any connection going from tier to tier + 1 (non same level)
		4: Highest input coming from down / lowest input coming from up
		... ordering by degree of 4
	-- ]]

	local GetPlacingOrderIndex = function(connection)
		if connection.startTier == connection.endTier - 1 then  -- 2 or 3
			if connection.startNumber == connection.endNumer then -- 2
				return 2;
			else -- 3
				return 3;
			end
		else  -- 1 or 4
			if connection.startTier == tier then  -- 1
				return 1;
			elseif connection.endTier - 1 == tier then   -- 4
				return 4;
			else
				error("Requesting place order index from a connection that is not related to the given channel");
			end
		end
	end

    local GetConnectionOrderValue = function(connection)
		local placingOrder = GetPlacingOrderIndex(connection);
		if placingOrder ~= 4 then
			-- Highest output going up  / lowest output going down
			if connection.startNumber > connection.endNumber then  -- going up
				return connection.startPortIndex;
			else -- going down
				return connection.startInstance.GetPortsOutCount() -  connection.startPortIndex + 1;
			end
		else
			-- Highest input coming from down / lowest input coming from up
			if connection.startNumber < connection.endNumber then  -- comming from up
				return connection.endInstance.GetPortsInCount() -  connection.endPortIndex + 1;
			else -- comming from down
				return connection.endPortIndex;
			end
		end
	end

	local CompareConnections = function(connection1,connection2)
		local placingOrder1 = GetPlacingOrderIndex(connection1);
		local placingOrder2 = GetPlacingOrderIndex(connection2);
		if placingOrder1 < placingOrder2 then
			return true;
		elseif placingOrder1 > placingOrder2 then
			return false
		else
			--print(GetConnectionOrderValue(connection1), GetConnectionOrderValue(connection2));
			return GetConnectionOrderValue(connection1) < GetConnectionOrderValue(connection2);
		end
	end

	local GetPredictedConnectionRange = function(connection)
		assert(connection,"A connection must be given")
		local placingOrder = GetPlacingOrderIndex(connection);
		if placingOrder == 1 then -- going to another tier
			-- Highest output going up  / lowest output going down
			if connection.startNumber > connection.endNumber then  -- going up
				return connection.endNumber,nil,connection.startNumber,connection.startPortIndex;
			else -- going down
				return connection.startNumber,connection.startPortIndex,connection.startNumber,nil;
			end
		elseif placingOrder == 2 or placingOrder == 3 then -- to next, same level / number
			if connection.startPortIndex > connection.endPortIndex then  -- going up
				return connection.endNumber,connection.endPortIndex,connection.startNumber,connection.startPortIndex;
			else -- going down
				return connection.startNumber,connection.startPortIndex,connection.endNumber,connection.endPortIndex;
			end
		else   -- connections for output , from another tier
			-- Highest input coming from down / lowest input coming from up
			if connection.startNumber < connection.endNumber then  -- comming from up
				return connection.startNumber,nil,connection.endNumber,connection.endPortIndex;
			else -- comming from down
				return connection.endNumber,connection.endPortIndex,connection.endNumber,nil;
			end
		end
	end

	local ConnectionsIsColliding = function(connection1,connection2)
		assert(connection1 and connection2,"Two connections must be compared")
		local fromNumber1,fromPort1,toNumber1,toPort1 = GetPredictedConnectionRange(connection1);
		local fromNumber2,fromPort2,toNumber2,toPort2 = GetPredictedConnectionRange(connection2);

		if (toNumber1 == fromNumber1 and toPort1 == fromPort1) or (toNumber2 == fromNumber2 and toPort2 == fromPort2) then -- straight over
			return false;
		elseif toNumber1 < fromNumber2 and toNumber2 < fromNumber1 then -- A B
			--print("AB")
			return false;
		elseif (toNumber1 == fromNumber2 and fromNumber1 < toNumber1 and fromPort2 == nil) or (toNumber2 == fromNumber1 and fromNumber2 < toNumber2 and fromPort1 == nil) then -- C D E F
			--print("CDEF")
			return false;
		elseif (toNumber1 == fromNumber2 and fromNumber1 < toNumber1 and toPort1 < fromPort2) or (toNumber2 == fromNumber1 and fromNumber2 < toNumber2 and toPort2 < fromPort1) then -- G H
			--print("GH")
			return false;
		elseif toNumber1 == fromNumber2 and fromNumber1 == toNumber1 and fromPort2 and math.max(fromPort1 or 0,toPort1 or 0) < (fromPort2) then -- I
			--print("I")
			return false
		elseif toNumber2 == fromNumber1 and fromNumber2 == toNumber2 and fromPort1 and math.max(fromPort2 or 0,toPort2 or 0) < (fromPort1) then -- J
			--print("J")
			return false
		elseif toNumber1 == toNumber2 and fromNumber1 == toNumber1 and toPort2 and math.min(fromPort1 or 99,toPort1 or 99) > (toPort2) then -- K
			--print("K")
			return false
		elseif toNumber2 == toNumber1 and fromNumber2 == toNumber2 and toPort1 and math.min(fromPort2 or 99,toPort2 or 99) > (toPort1) then -- L
			--print("L")
			return false
		else
			return true;
		end
	end

	-- Layout vertical channel
	local connections = connectionLayout.GetConnectionsInVerticalChannel(tier);
	table.sort(connections,CompareConnections);

	local lanes = {};--print("calculating lane layout for vertical",tier,"num connections:",#(connections));
	for i,connection in pairs(connections) do
		local spaceAvailableInLastLane = nil;
		for i,otherConnection in pairs(lanes[#(lanes)] or {}) do
			if spaceAvailableInLastLane == nil then
				spaceAvailableInLastLane = true;
			end
			spaceAvailableInLastLane = spaceAvailableInLastLane and not(ConnectionsIsColliding(connection,otherConnection));
		end
		if spaceAvailableInLastLane and #(lanes) > 0 then
			table.insert(lanes[#(lanes)],connection);
		else
			table.insert(lanes,{connection});
		end
	end

	class.GetWidth = function()
		return math.max(1,#(lanes));
	end

	class.GetConnectionLaneNumber = function(_connection)
		for laneNum,connectionsInLane in pairs(lanes) do
			for _,connection in pairs(connectionsInLane) do
				if connection == _connection then
					return laneNum;
				end
			end
		end
		error("Lane not found in vertical "..tier)
	end

	return class;
end

