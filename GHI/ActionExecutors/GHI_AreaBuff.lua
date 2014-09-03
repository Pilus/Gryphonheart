--===================================================
--									
--								GHI Area Buff
--								GHI_AreaBuff.lua
--
--	Handling of buffs applied to all GHI users within a given range
--	
-- 						(c)2013 The Gryphonheart Team
--								All rights reserved
--===================================================

local class;
function GHI_AreaBuff()
	if class then
		return class;
	end

	class = GHClass("AreaBuff");
	local position = GHI_Position(true);
	local comm = GHI_ChannelComm();
	local RecieveAreaBuff, applyBuffFunc;
	local MAX_RANGE = 50;

	class.SetApplyBuffFunc = function(func)
		applyBuffFunc = func;
	end

	class.Send = function(buffName, buffDetails, buffIcon, untilCanceled, filter, buffType, buffDuration, cancelable, stackable, count, delay, range)
		local buffData = {
			buffName = buffName,
			buffDetails = buffDetails,
			buffIcon = buffIcon,
			untilCanceled = untilCanceled,
			filter = filter,
			buffType = buffType,
			buffDuration = buffDuration,
			cancelable = cancelable,
			stackable = stackable,
			count = count or 1,
			delay = delay or 0,
		};

		if GHI_MiscData["block_area_buff"] then
			return;
		end

		local playerPos = position.GetPlayerPos();
		playerPos.continent = playerPos.world;
		comm.Send(nil, "AreaBuff", playerPos, range or 0, buffData)
	end

	RecieveAreaBuff = function(player, playerPos, range, data, ...)
		if GHI_MiscData["block_area_buff"] then
			return
		end

		if not(player) or not(type(playerPos)=="table") or not(type(range)=="number")  or not(type(data)=="table") then
			return
		end
		playerPos.world = playerPos.world or playerPos.continent;
		if not(playerPos.world) or not(playerPos.x) or not(playerPos.y) then
			return
		end

		if applyBuffFunc and playerPos.continent > 0 and position.IsPosWithinRange(playerPos, min(range, MAX_RANGE)) then
			applyBuffFunc(data.buffName, data.buffDetails, data.buffIcon, data.untilCanceled, data.filter, data.buffType, data.buffDuration, data.cancelable, data.stackable, data.count or 1, data.delay or 0)
		end
	end
	comm.AddRecieveFunc("AreaBuff", RecieveAreaBuff);

	return class;
end