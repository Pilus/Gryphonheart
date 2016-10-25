--
--
--				GHI_HorizontalChannel
--  			GHI_HorizontalChannel.lua
--
--	Holds information about the horizontal channels
--	of connections.
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHI_HorizontalChannel(number,connectionLayout,verticalChannels)
	local class = GHClass("GHI_HorizontalChannel");

	local GetConnectionCoors = function(connection)
		local fromTier,toTier,fromLane,toLane;
		if connection.startTier < connection.endTier then -- forwards
			fromTier,toTier = connection.startTier,connection.endTier;
			fromLane = verticalChannels[fromTier].GetConnectionLaneNumber(connection);
			toLane = verticalChannels[toTier-1].GetConnectionLaneNumber(connection);
		else
			fromTier,toTier = connection.endTier,connection.startTier;
			fromLane = verticalChannels[fromTier-1].GetConnectionLaneNumber(connection);
			toLane = verticalChannels[toTier].GetConnectionLaneNumber(connection);
		end
		return fromTier,toTier,fromLane,toLane;
	end

	local ConnectionsIsColliding = function(connection1,connection2)
		local fromTier1,toTier1,fromLane1,toLane1 = GetConnectionCoors(connection1);
		local fromTier2,toTier2,fromLane2,toLane2 = GetConnectionCoors(connection2);

		if toTier1 < fromTier2 or toTier2 < fromTier1 then
			return false;
		elseif (toTier1 == fromTier2 and toLane1 < fromLane2) or (toTier2 == fromTier1 and toLane2 < fromLane1) then
			return false;
		else
			return true;
		end
	end

	--[[ Sort rules
	-- 	1: Left side going / coming from up
	 - 		a: Sorted by tier of left side horizontal channel  (highest first)
	  			I: Sort by lane number of left side horizontal channel (highest first)
	   	2: Left side going / coming from down
	   		a: Sorted by tier of left side horizontal channel (lowest first)
	   			I: Sort y lane number of left side horizontal channel (lowest first)
	--]]

	local GetLeftInfo = function(connection)
		local leftTier,leftNumber,leftVLaneNumber;
		if connection.startTier < connection.endTier+1 then
			leftTier = connection.startTier;
			leftNumber = connection.startNumber;
		else
			leftTier = connection.endTier - 1;
			leftNumber = connection.endNumber;
		end
		leftVLaneNumber = verticalChannels[leftTier].GetConnectionLaneNumber(connection);
		return leftTier,leftNumber,leftVLaneNumber;
	end

	local CompareConnections = function(connection1,connection2)
   		local leftTier1,leftNumber1,leftVLaneNumber1 = GetLeftInfo(connection1);
   		local leftTier2,leftNumber2,leftVLaneNumber2 = GetLeftInfo(connection2);

		if (leftNumber1 == leftNumber2) then
			if leftNumber1 <= number then -- 1: Left side going / coming from up
				if (leftTier1 == leftTier2) then
					-- I: Sort by lane number of left side horizontal channel (highest first)
					return (leftVLaneNumber1 > leftVLaneNumber2);
				else -- a: Sorted by tier of left side horizontal channel  (highest first)
					return (leftTier1 > leftTier2);
				end
			else -- 2: Left side going / coming from down
				if (leftTier1 == leftTier2) then
					-- I: Sort y lane number of left side horizontal channel (lowest first)
					return (leftVLaneNumber1 < leftVLaneNumber2);
				else -- a: Sorted by tier of left side horizontal channel (lowest first)
					return (leftTier1 < leftTier2);
				end
			end
		else
			return (leftNumber1<leftNumber2);
		end
	end

	local connections = connectionLayout.GetConnectionsInHorizontalChannel(number);
	table.sort(connections,CompareConnections);

	local lanes = {};

	-- todo: let the channel consider a uneven roof
	for i,connection in pairs(connections) do
		local inserted = false;
		for i=1,#(lanes) do
			local spaceAvailableInLane = true;
			for i,otherConnection in pairs(lanes[i] or {}) do
				spaceAvailableInLane = spaceAvailableInLane and not(ConnectionsIsColliding(connection,otherConnection));
			end
			if spaceAvailableInLane  then
				table.insert(lanes[i],connection);
				inserted = true;
			end
		end

		if inserted == false then
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
		error("Lane not found in horizontal "..number)
	end

	return class;
end

