--===================================================
--
--				GHG_GroupRemove
--  			GHG_GroupRemove.lua
--
--	Handles messages when removing a member from a group.
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHG_GroupRemove()
	if class then
		return class;
	end
	class = GHClass("GHG_GroupRemove");

	local channelComm = GHI_ChannelComm();
	local event = GHI_Event();
	local groupList = GHG_GroupList();

	class.RemovePlayerFromGroup = function(playerName,group)

		-- check that the person is not already a member
		local groupName = group.GetName();

		channelComm.Send("ALERT","GHG_PlayerRemoved",group.GetGuid(),playerName,UnitName("player"));
	end

	channelComm.AddRecieveFunc("GHG_PlayerRemoved",function(sender,groupGuid,playerName,adminName)
		local group = groupList.GetGroup(groupGuid);
		if group and group.IsPlayerMemberOfGuild(UnitGUID("player")) then
			local groupName = group.GetName();
			event.TriggerEvent("GHG_PLAYER_REMOVED",playerName,groupName,adminName);
		end
	end);

	return class;
end

