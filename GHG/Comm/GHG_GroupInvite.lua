--
--
--				GHG_GroupInvite
--  			GHG_GroupInvite.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local class;
function GHG_GroupInvite()
	if class then
		return class;
	end
	class = GHClass("GHG_GroupInvite");

	local comm = GH_Comm();
	local channelComm = GHI_ChannelComm();
	local event = GHI_Event();
	local groupList = GHG_GroupList();

	local invitedPlayers = {};
	class.InvitePlayerToGroup = function(group,playerName)

		-- check that the person is not already a member
		local groupName = group.GetName();
		if group.IsPlayerMemberOfGuild(playerName) then
			event.TriggerEvent("GHG_INVITED_PLAYER_IS_MEMBER",groupName,playerName);
			return
		end

		local groupGuid = group.GetGuid();

		comm.Send("ALERT",playerName,"GHG_Invite",groupGuid,groupName);
		event.TriggerEvent("GHG_INVITE_SEND",groupName,playerName);

		invitedPlayers[groupGuid..playerName] = true;
	end

	local currentInvitation;
	comm.AddRecieveFunc("GHG_Invite",function(sender,groupGuid,groupName)
		local func;
		func = function()
			if not(currentInvitation) then
				currentInvitation = {groupGuid,sender};
				event.TriggerEvent("GHG_INVITE_RECEIVED",groupName,sender);
			else
				GHI_Timer(func,1,true);
			end
		end
		func();
	end);

	local expectedGroupInfoForJoinedGroups = {};
	class.AcceptGroupInvitation = function()
		if currentInvitation then
			local groupGuid,sender,groupName = unpack(currentInvitation);
			comm.Send("ALERT",sender,"GHG_InviteAccepted",groupGuid,GHUnitGUID("player"));
			expectedGroupInfoForJoinedGroups[groupGuid] = true;
			currentInvitation = nil;
		end
	end

	comm.AddRecieveFunc("GHG_InviteAccepted",function(playerName,groupGuid,playerGuid)
		if invitedPlayers[groupGuid..playerName] then

			groupList.SendKeyTo(groupGuid,playerName);

			local group = groupList.GetGroup(groupGuid);

			group.AddMember(playerGuid,playerName);
			group.UpdateVersion();
			groupList.SetGroup(group);

			invitedPlayers[groupGuid..playerName] = nil;
			event.TriggerEvent("GHG_SEND_INVITE_ACCEPTED",playerName);
		else
			event.TriggerEvent("GHG_DEBUG",string.format("GHG_InviteAccepted - No invite had been send to target matching %s.",groupGuid..playerName));
		end
	end);

	class.DeclineGroupInvitation = function()
		if currentInvitation then
			local groupGuid,sender,groupName = unpack(currentInvitation);
			comm.Send("ALERT",sender,"GHG_InviteDeclined",groupGuid);
			currentInvitation = nil;
		end
	end

	comm.AddRecieveFunc("GHG_InviteDeclined",function(playerName,groupGuid)
		if invitedPlayers[groupGuid..playerName] then
			event.TriggerEvent("GHG_SEND_INVITE_DECLINED",playerName);
			invitedPlayers[groupGuid..playerName] = nil;
		end
	end);

	GHI_Event("GHG_GROUP_UPDATED",function(e,groupGuid)
		local group = groupList.GetGroup(groupGuid);
		if expectedGroupInfoForJoinedGroups[groupGuid] and group and group.IsPlayerMemberOfGuild(GHUnitGUID("player")) then
			channelComm.Send("ALERT","GHG_PlayerJoined",groupGuid,UnitName("player"));
			expectedGroupInfoForJoinedGroups[groupGuid] = nil;
		end
	end);

	channelComm.AddRecieveFunc("GHG_PlayerJoined",function(sender,groupGuid,playerName)
		local group = groupList.GetGroup(groupGuid);
		if group and group.IsPlayerMemberOfGuild(GHUnitGUID("player")) then
			local groupName = group.GetName();
			event.TriggerEvent("GHG_PLAYER_JOINED",playerName,groupName);
		end
	end);

	return class;
end

