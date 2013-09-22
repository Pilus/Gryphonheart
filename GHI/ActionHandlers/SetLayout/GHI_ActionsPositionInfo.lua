--===================================================
--
--				GHI_ActionsPositionInfo
--  			GHI_ActionsPositionInfo.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local ACTION_WIDTH = 3;
local ACTION_HEIGHT = 3; -- excluding ports

function GHI_ActionsPositionInfo(actionLocation,verticalChannels,horizontalChannels)
	local class = GHClass("GHI_ActionsPositionInfo");
	local actionCoordinates = {};
	local veticalChannelCoordinate = {};
	local horizontalChannelCoordinate = {};
	local portCoordinates = {};


	local y = 1;
	for number = 1,actionLocation.GetNumActionsInLargestTier() do
		local x = 2;
		local horizontalChannel = horizontalChannels[number];
		local lineActionHeight = 0;
		for tier = 0,actionLocation.GetNumTiers() do
			local verticalChannel = verticalChannels[tier];

			local instance = actionLocation.GetInstance(tier,number);
			if instance then
				local guid = instance.GetGUID();
				actionCoordinates[guid] = {x = x, y = y};
				-- Port coordinates
				portCoordinates[guid] = {};
				for i=1,instance.GetPortsInCount() do
					local portGuid = instance.GetPortInfo("in",i);
					portCoordinates[guid][portGuid] = {x = x, y = y+1+i};
				end

				for i=1,instance.GetPortsOutCount() do
					local portGuid = instance.GetPortInfo("out",i);
					portCoordinates[guid][portGuid] = {x = x+ACTION_WIDTH-1, y = y+1+i};
				end


				lineActionHeight = math.max(lineActionHeight,math.max(instance.GetPortsInCount(),instance.GetPortsOutCount()) + ACTION_HEIGHT);
			end

			if tier > 0 then
				x = x + ACTION_WIDTH;
			end

			veticalChannelCoordinate[tier] = x;
			x = x + verticalChannel.GetWidth();
		end
		y = y + lineActionHeight;

		horizontalChannelCoordinate[number] = y;

		y = y + horizontalChannel.GetWidth();
	end

	class.GetInstanceCoordinates = function(guid)
		local a = actionCoordinates[guid];
		if a then
			return a.x, a.y;
		end
	end

	class.GetPortCoordinates = function(instanceGuid,portGuid)
		assert(type(instanceGuid) == "string" and type(portGuid)=="string","Usage: GetPortCoordinates(string,string)")
		if portCoordinates[instanceGuid] and portCoordinates[instanceGuid][portGuid] then
			local c = portCoordinates[instanceGuid][portGuid];
			if c.x and c.y then
				return c.x, c.y;
			end
		end
		return 1, 3; -- todo: return correct coordinates for the particular set port
	end

	class.GetVerticalChannelPos = function(tier)
		return veticalChannelCoordinate[tier];
	end

	class.GetHorizontalChannelPos = function(number)
		return horizontalChannelCoordinate[number];
	end




	return class;
end

