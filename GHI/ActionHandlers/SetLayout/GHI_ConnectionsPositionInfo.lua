--===================================================
--
--				GHI_ConnectionsPositionInfo
--  			GHI_ConnectionsPositionInfo.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_ConnectionsPositionInfo(portConnections,connectionLayout,actionsPosition,verticalChannels,horizontalChannels)
	local class = GHClass("GHI_ConnectionsPositionInfo");


	class.GetNumConnections = function()
		local c = 0;
		for _, _ in pairs(portConnections) do
			c = c + 1;
		end

		return connectionLayout.GetNumConnections() + c;
	end

	local GetStartPos = function(connection)
		return actionsPosition.GetPortCoordinates(connection.startInstance.GetGUID(),connection.startPortGuid);
	end

	local GetEndPos = function(connection)
		return actionsPosition.GetPortCoordinates(connection.endInstance.GetGUID(),connection.endPortGuid);
	end

	local GetSetPortConnection = function(i)
		local c = 1;
		for guid,connection in pairs(portConnections) do
			if c == i then
				return guid,connection;
			end
			c = c + 1;
		end
	end

	local GetCoorsForSetPortConnection = function(i)
	   	local portGuid,portConnection = GetSetPortConnection(i);
		local coors = {};
		if not(portGuid) then
			return coors;
		end
		local endInstance,endPortGuid = unpack(portConnection);
		local _, endPortIndex = endInstance.IdentifyPort(endPortGuid)
		local startX, startY = 1,3*i; -- todo: change when supporting multiple ports
		local endX, endY = GetEndPos({ endInstance = endInstance, endPortIndex = endPortIndex, endPortGuid = endPortGuid });

		startX,endX = startX + 1, endX-1; -- Let the connections start in the field right of the port and end in the field left to the port

		if startY == endY then -- a straight connection
			if startX == endX then -- only one field
				table.insert(coors, { x = startX, y = startY, t = "right" });
			else
				table.insert(coors, { x = startX, y = startY, t = "right" });
				table.insert(coors, { x = endX, y = endY, t = "right" });
			end
		else    --print("Not implemented: Bending connection from a set port",startY,"~=",endY)
			if startX == endX then

			else
			end
		end
		return coors;
	end

	local GetConnectionCoors_DirectConnected = function(connection)
		local coors = {};

		local startX, startY = GetStartPos(connection);
		local endX, endY = GetEndPos(connection);

		startX,endX = startX + 1, endX-1; -- Let the connections start in the field right of the port and end in the field left to the port

		if startY == endY then
			table.insert(coors, { x = startX, y = startY, t = "right" });
			table.insert(coors, { x = endX, y = endY, t = "right" });
		elseif startY > endY then -- going up
			local verticalChannel = verticalChannels[connection.startTier];
			local laneNum = verticalChannel.GetConnectionLaneNumber(connection);
			local verticalChannelStartX = actionsPosition.GetVerticalChannelPos(connection.startTier);
			local verX = verticalChannelStartX + laneNum - 1;

			if startX < verX then
				table.insert(coors, { x = startX, y = startY, t = "right" });
			end
			table.insert(coors, { x = verX, y = startY, t = "bottomright" });
			table.insert(coors, { x = verX, y = endY, t = "topleft" });
			if endX > verX then
				table.insert(coors, { x = endX, y = endY, t = "right" });
			end
		else -- going down
			local verticalChannel = verticalChannels[connection.startTier];
			local laneNum = verticalChannel.GetConnectionLaneNumber(connection);
			local verticalChannelStartX = actionsPosition.GetVerticalChannelPos(connection.startTier);
			local verX = verticalChannelStartX + laneNum - 1;

			if startX < verX then
				table.insert(coors, { x = startX, y = startY, t = "right" });
			end
			table.insert(coors, { x = verX, y = startY, t = "topright" });
			table.insert(coors, { x = verX, y = endY, t = "bottomleft" });
			if endX > verX then
				table.insert(coors, { x = endX, y = endY, t = "right" });
			end
		end
		return coors;
	end

	class.GetConnectionCoors = function(i)
		local connection = connectionLayout.GetConnection(i)
		local coors = {};

		if not (connection) then   -- the connections to the trigger ports
			return GetCoorsForSetPortConnection(i-connectionLayout.GetNumConnections());
		end

		if connection.startTier == connection.endTier - 1 then     -- connection going directly from one action to another without going back or skipping an action
			coors = GetConnectionCoors_DirectConnected(connection)

			--[[
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
			end --]]
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
			startX = startX + 1; -- Let the connections start in the field right of the port and end in the field left to the port
			local startVerticalLane = verticalChannels[connection.startTier].GetConnectionLaneNumber(connection);
			if startVerticalLane > 1 then
				table.insert(coors, { x = startX, y = startY, t = "right" });
				-- vertical channel pos

				local verticalChannel1 = verticalChannels[connection.startTier];
				local verticalChannelLane = verticalChannel1.GetConnectionLaneNumber(connection);
				local verticalChannelPos = actionsPosition.GetVerticalChannelPos(connection.startTier);
				local verX = verticalChannelPos + verticalChannelLane - 1;

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
			local horizontalChannel = horizontalChannels[connection.horizontalChannel];
			local x = coors[#(coors)].x;

			local horizontalChannelLane = horizontalChannel.GetConnectionLaneNumber(connection);

			local horizontalChannelPos = actionsPosition.GetHorizontalChannelPos(connection.horizontalChannel);
			local y = horizontalChannelPos + horizontalChannelLane - 1;
			if startDirInv == "up" then
				table.insert(coors, { x = x, y = y, t = "bottomright" });
			else
				table.insert(coors, { x = x, y = y, t = "topright" });
			end

			-- channel transfer 2 pos
			local verticalChannel2 = verticalChannels[connection.endTier - 1];
			local verticalChannelLane = verticalChannel2.GetConnectionLaneNumber(connection);
			local verticalChannelPos = actionsPosition.GetVerticalChannelPos(connection.endTier - 1);
			local verX = verticalChannelPos + verticalChannelLane - 1;

			local x = verticalChannelPos + verticalChannelLane - 1;

			if endDirInv == "up" then
				table.insert(coors, { x = x, y = y, t = "bottomleft"});
			else
				table.insert(coors, { x = x, y = y, t = "topleft"});
			end

			-- vertical channel 2 pos
			local endX, endY = GetEndPos(connection);
			endX = endX-1; -- Let the connections start in the field right of the port and end in the field left to the port
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

	class.GetRequiredSize = function()
		local width = 3;
		local height = 4;
		if (#(verticalChannels) > 0) then
			width = actionsPosition.GetVerticalChannelPos(#(verticalChannels)) + verticalChannels[#(verticalChannels)].GetWidth();
		end
		if (#(horizontalChannels) > 0) then
			height = actionsPosition.GetHorizontalChannelPos(#(horizontalChannels)) + horizontalChannels[#(horizontalChannels)].GetWidth();
		end

		return height, width;
	end





	return class;
end

