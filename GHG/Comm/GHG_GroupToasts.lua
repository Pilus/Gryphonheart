--
--
--				GHG_GroupToasts
--  			GHG_GroupToasts.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local class;
function GHG_GroupToasts()
	if class then
		return class;
	end
	class = GHClass("GHG_GroupToasts");

	local channelComm = GHI_ChannelComm();
	local groupList = GHG_GroupList();
	local event = GHI_Event();



	GHI_Event("PLAYER_ALIVE",function()
		channelComm.Send("ALERT","GHG_OnlineToast");
	end)

	local IsInGuildOrOnFriendsList = function(sender)
		for i=1,GetNumFriends() do
			if GetFriendInfo(i) == sender then
				return true;
			end
		end

		for i=1,GetNumGuildMembers() do
	   		if GetGuildRosterInfo(i) == sender then
				return true;
			end
		end
		return false;
	end

	channelComm.AddRecieveFunc("GHG_OnlineToast",function(sender)
		if not(sender == UnitName("player") or IsInGuildOrOnFriendsList(sender)) then
			local groupGuids = groupList.GetAllGroupGuids();
			for _,guid in pairs(groupGuids) do
				local group = groupList.GetGroup(guid);
				if group and group.IsPlayerMemberOfGuild(sender) then
					event.TriggerEvent("GHG_PLAYER_ONLINE",sender,sender);
				end
			end

		end
	end);

	GHI_Event("GHI_PLAYER_GONE_OFFLINE",function(_,sender)
		if not(sender == UnitName("player") or IsInGuildOrOnFriendsList(sender)) then
			local groupGuids = groupList.GetAllGroupGuids();
			for _,guid in pairs(groupGuids) do
				local group = groupList.GetGroup(guid);
				if group and group.IsPlayerMemberOfGuild(sender) then
					event.TriggerEvent("GHG_PLAYER_OFFLINE",sender);
				end
			end

		end
	end);

	channelComm.AddRecieveFunc("GHG_PromoteDemoteToast",function(sender,groupGuid,playerName,rankName,isPromote)
		local group = groupList.GetGroup(groupGuid);
		if group and group.IsPlayerMemberOfGuild(sender) then
			if isPromote then
				event.TriggerEvent("GHG_PLAYER_PROMOTED",sender,group.GetName(),playerName,rankName);
			else
				event.TriggerEvent("GHG_PLAYER_DEMOTED",sender,group.GetName(),playerName,rankName);
			end

		end
	end);

	class.PromoteDemote = function(groupGuid,playerName,rankName,isPromote)
		channelComm.Send("ALERT","GHG_PromoteDemoteToast",groupGuid,playerName,rankName,isPromote);
	end

	return class;
end

GHG_GroupToasts()