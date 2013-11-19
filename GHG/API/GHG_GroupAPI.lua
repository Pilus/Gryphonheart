--===================================================
--
--				GHG_GroupAPI
--  			GHG_GroupAPI.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local apis = {}
function GHG_GroupAPI(userGuid)
	assert(type(userGuid)=="string","A guid must be given to the API")

	if apis[userGuid] then
		return apis[userGuid]
	end

	local class = GHClass("GHG_GroupAPI");
	apis[userGuid] = class;

	local groupList = GHG_GroupList();
	local playerDataList = GHG_PlayerDataList();

	local event = GHI_Event();
	local comm = GH_Comm();
	local channelComm = GHI_ChannelComm();
	local toasts = GHG_GroupToasts();


	local GenerateChatHeaderAndSlashCommand = function(groupName)
		if string.len(groupName) <= 6 then
			-- The group name is short enough to be the chat header
			return groupName, string.lower(gsub(groupName, " ", ""));
		elseif string.count(groupName," .") >= 2 then
			-- The name consists of two or more words. Use an acronym
			local acronym = string.sub(groupName,0,1);
			string.gsub(groupName," .",function(letter)
				acronym = acronym .. strtrim(letter);
			end);
			return acronym, string.lower(acronym);
		else
			-- The name is one or more long words. Use the first 6 letters.
			local first = string.sub(groupName, 0, 6);
			return first, string.lower(gsub(first, " ", ""));
		end
	end

	local RandomChatColor;
	RandomChatColor = function()
		local c = {r = random(100)/100, g = random(100)/100, b = random(100)/100 }
		if (c.r + c.g + c.b) < 0.90 then -- too dark
			return RandomChatColor();
		end
		return c;
	end

	class.CreateGroup = function(name)
		GHCheck("CreateGroup", { "string" }, { name });
		local group = GHG_Group();

		GHG_GroupKeys[group.GetGuid()] = {random(100),random(100)};
		group.InitializeCryptatedData();

		group.SetName(name);
		local chatHeader, slashCmd = GenerateChatHeaderAndSlashCommand(name);
		group.SetChatName(name);
		group.SetChatHeader(chatHeader);
		group.SetChatSlashCommand({slashCmd});
		group.SetChatColor(RandomChatColor());

		group.AddRank("Leader");
		local leaderRank = group.GetRank(1);
		group.AddRank("Member");

		local pName = "Unknown";
		if userGuid == UnitGUID("player") then
			pName = UnitName("player");
		end
		group.AddMember(userGuid,pName,leaderRank.GetGuid());

		groupList.SetGroup(group);

	end

	local GetGroupsUserBeingMemberIn = function()
		local groupGuids = {}
		local guids = groupList.GetAllGroupGuids();

		for _,guid in pairs(guids) do
			local group = groupList.GetGroup(guid);

		   	if group.CanRead() and group.IsPlayerMemberOfGuild(userGuid) then
				table.insert(groupGuids,group.GetGuid());
			end
		end

		return groupGuids;
	end

	class.GetNumberOfGroups = function()
		return #(GetGroupsUserBeingMemberIn());
	end

	local GetGroupByIndex = function(index)
		local g = GetGroupsUserBeingMemberIn();

		return groupList.GetGroup(g[index] or "");
	end

	class.GetGroupInfo = function(index)
		GHCheck("GetGroupInfo", { "number" }, { index });
		local group = GetGroupByIndex(index);
		if group then
			return group.GetName(),group.GetIcon();
		end
	end

	class.GetNumberOfGroupMembers = function(index)
		GHCheck("GetNumberOfGroupMembers", { "number" }, { index });
		local group = GetGroupByIndex(index);
		if group then
			return group.GetNumMembers()
		end
		return 0;
	end

	class.GetNumberOfGroupMembersOnline = function(index)
		GHCheck("GetNumberOfGroupMembersOnline", { "number" }, { index });
		local group = GetGroupByIndex(index);
		local c = 0;
		if group then

			for i=1,group.GetNumMembers() do
			 	if group.GetMember(i) then
					local member = group.GetMember(i);
					local guid = member.GetGuid();
					local p = playerDataList.GetPlayerData(guid);
					if p and p.IsOnline() then
						c = c + 1;
					end
				end
			end

		end
		return c;
	end

	class.GetGroupMemberInfo = function(index,i)
		GHCheck("GetGroupMemberInfo", { "number", "number" }, { index,i });
		local group = GetGroupByIndex(index);

		if group and group.GetMember(i) then
			local member = group.GetMember(i);
			local guid = member.GetGuid();
			local p = playerDataList.GetPlayerData(guid);
			local rank = group.GetRankOfMember(guid);
			local rankIndex = group.GetRankIndex(rank);
			local rankName = rank.GetName();
			if p then
				return p.GetName(),rankName, rankIndex,p.GetLevel(),p.GetClass(),p.GetZone(),p.IsOnline(),p.GetRace(),p.GetGuild();
			else
				return nil,rankName, rankIndex,0;
			end
		end

	end

	class.GetGroupMemberMSPInfo = function(index,i)
		GHCheck("GetGroupMemberInfo", { "number", "number" }, { index,i });
		local group = GetGroupByIndex(index);

		if group and group.GetMember(i) then
			local member = group.GetMember(i);
			local guid = member.GetGuid();
			local p = playerDataList.GetPlayerData(guid);
			if p then
				return p.GetIcName(),p.GetIcTitle();
			end
		end

	end

	local TimeDiffInUnits = function(t)
		local H = 60*60;
		local D = H*24;
		local M = D*30;
		local Y = D*365;

		local years = floor(t/Y);
		local months = floor((t-years*Y)/M);
		local days = floor((t-years*Y-months*M)/D);
		local hours = floor((t-years*Y-months*M-days*D)/H);
		return years,months,days,hours;
	end

	class.GetGroupMemberLastOnline = function(index,i)
		GHCheck("GetGroupMemberLastOnline", { "number", "number" }, { index,i });
		local group = GetGroupByIndex(index);

		if group and group.GetMember(i) then
			local member = group.GetMember(i);
			local guid = member.GetGuid();
			local p = playerDataList.GetPlayerData(guid);
			if p then
				local t = p.GetLastOnline();
				local dt = GHG_GetServerTime() - t;
				return TimeDiffInUnits(dt);
			end
			return 0;
		end
	end

	class.GetNumGroupEventLogEntries = function(index)
		GHCheck("GetNumGroupEventLogEntries", { "number" }, { index });
		local group = GetGroupByIndex(index);

		if group then
			return #(group.GetLogEvents());
		end
	end

	class.GetGroupEventLogEntry = function(index,i)
		GHCheck("GetGroupEventLogEntry", { "number", "number" }, { index,i });
		local group = GetGroupByIndex(index);

		if group then
			local events = group.GetLogEvents();
			if events and events[i] then
				local eventType, timeStamp, author, args = events[i].GetInfo();
				if eventType == GHG_LogEventType.PROMOTE or eventType == GHG_LogEventType.DEMOTE then
					local rankIndex = group.GetRankIndex(args[1]);
					local rank = group.GetRank(rankIndex);
					if rank then
						return eventType, timeStamp, author, rank.GetName(), args[2], args[3], args[4];
					end
				end
				return eventType, timeStamp, author, unpack(args);
			end
		end
	end


	-- ======== Invite player to group ===========
	local invite = GHG_GroupInvite();
	class.InvitePlayerToGroup = function(index,playerName)
		GHCheck("InvitePlayerToGroup", { "number", "string" }, { index,playerName });

		local group = GetGroupByIndex(index);
		if not(group) then
			return;
		end

		-- check access
		local rank = group.GetRankOfMember(userGuid);
		if rank and rank.CanInvite() then
			invite.InvitePlayerToGroup(group,playerName)
		end
	end

	class.AcceptGroupInvitation = function()
		invite.AcceptGroupInvitation();
	end

	class.DeclineGroupInvitation = function()
		invite.DeclineGroupInvitation();
	end

	class.LeaveGroup = function(index)
		GHCheck("LeaveGroup", { "number" }, { index });

		local group = GetGroupByIndex(index);
		if not(group) then
		return;
		end
		group = group.Clone();
		group.RemoveMember(userGuid);
		group.UpdateVersion()
		groupList.SetGroup(group);
	end

	class.KickMemberFromGroup = function(index,i)
		GHCheck("KickMemberFromGroup", { "number","number" }, { index, i });
		local group = GetGroupByIndex(index);
		if not(group) then
			return;
		end

		local rank = group.GetRankOfMember(userGuid);
		if rank and rank.CanKickMember() then
			local member = group.GetMember(i);
			if member then
				group.RemoveMember(member.GetGuid());
				group.UpdateVersion();
				groupList.SetGroup(group);
			end
		end

	end

	class.GetIndexOfGroupByGuid = function(gGuid)
		local guids = groupList.GetAllGroupGuids();
		local i = 0;
		for _,guid in pairs(guids) do
			local group = groupList.GetGroup(guid);
			if  group.CanRead() and group.IsPlayerMemberOfGuild(userGuid) then
				i = i + 1;
				if guid == gGuid then
					return i;
				end
			end
		end
	end

	-- ========= chat info ========
	class.GetGroupChatInfo = function(index)
		GHCheck("GetGroupChatInfo", { "number" }, { index });
		local group = GetGroupByIndex(index);
		if group then
			return group.GetGroupChatInfo()
		end
	end

	class.SendChatMessage = function(index,msg)
		GHCheck("GetGroupChatInfo", { "number","string" }, { index,msg });
		local group = GetGroupByIndex(index);
		if group then
			group.SendChatMessage(msg);
		end

	end

	-- Access
	class.GetPromoteDemoteLimit = function(index)
		GHCheck("GetPromoteDemoteLimit", { "number" }, { index });
		local group = GetGroupByIndex(index);
		if group then
			local ownRank = group.GetRankOfMember(userGuid);
			if ownRank.CanPromoteDemote() then
			    local limit = group.GetRankIndex(ownRank)+1;
				if limit == 2 then
					return 1;
				end
				return limit;
			end
		end
	end

	class.GetNumberOfRanks = function(index)
		GHCheck("GetNumberOfRanks", { "number" }, { index });
		local group = GetGroupByIndex(index);
		if group then
			return group.GetNumRanks();
		end
	end

	class.GetRankName = function(index,i)
		GHCheck("GetRankName", { "number","number" }, { index,i });
		local group = GetGroupByIndex(index);
		if group then
			local rank = group.GetRank(i);
			if rank then
				return rank.GetName();
			end
		end
	end

	class.ChangeRank = function(index,i,newRankIndex)
		GHCheck("ChangeRank", { "number","number","number" }, { index,i,newRankIndex });
		local group = GetGroupByIndex(index);
		if group then
			local member = group.GetMember(i);
			local guid = member.GetGuid();
			local rank = group.GetRankOfMember(guid);
			local currentRankIndex = group.GetRankIndex(rank);

			local newRank = group.GetRank(newRankIndex);
			local newRankGuid = newRank.GetGuid();
			local limit = class.GetPromoteDemoteLimit(index);

			if currentRankIndex >= limit and newRankIndex >= limit and not(currentRankIndex == newRankIndex) then
				local modifiedGroup = group.Clone();
				modifiedGroup.SetRankOfMember(guid,newRankGuid);
				modifiedGroup.UpdateVersion();
				groupList.SetGroup(modifiedGroup);
				toasts.PromoteDemote(group.GetGuid(),member.GetName(),newRank.GetName(),newRankIndex < currentRankIndex);
			end
		end
	end

	class.CanViewPublicNote = function(index)
		GHCheck("CanViewPublicNote", { "number" }, { index });

		local group = GetGroupByIndex(index);
		if not(group) then
			return;
		end

		-- check access
		local rank = group.GetRankOfMember(userGuid);
		if rank and rank.CanViewPublicNote() then
			return true;
		end
		return false;
	end

	class.GetPublicNote = function(index,i)
		GHCheck("CanViewPublicNote", { "number" }, { index });

		local group = GetGroupByIndex(index);
		if not(group) then
			return;
		end

		-- check access
		local rank = group.GetRankOfMember(userGuid);
		if rank and rank.CanViewPublicNote() then
			local member = group.GetMember(i);
			if member then
				return member.GetPublicNote();
			end
		end
	end

	class.CanEditPublicNote = function(index)
		GHCheck("CanEditPublicNote", { "number" }, { index });

		local group = GetGroupByIndex(index);
		if not(group) then
			return;
		end

		-- check access
		local rank = group.GetRankOfMember(userGuid);
		if rank and rank.CanEditPublicNote() then
			return true;
		end
		return false;
	end

	class.SetPublicNote = function(index,i,note)
		GHCheck("SetPublicNote", { "number","number","string" }, { index,i,note });

		local group = GetGroupByIndex(index);
		if not(group) then
			return;
		end
		group = group.Clone();

		-- check access
		local rank = group.GetRankOfMember(userGuid);
		if rank and rank.CanEditPublicNote() then
			local member = group.GetMember(i);
			if member then
				member.SetPublicNote(note);
				group.UpdateVersion();
				groupList.SetGroup(group);
				return
			end
		end
	end

	class.CanViewOfficersNote = function(index)
		GHCheck("CanViewOfficersNote", { "number" }, { index });

		local group = GetGroupByIndex(index);
		if not(group) then
			return;
		end

		-- check access
		local rank = group.GetRankOfMember(userGuid);
		if rank and rank.CanViewOfficersNote() then
			return true;
		end
		return false;
	end

	class.GetOfficersNote = function(index,i)
		GHCheck("CanViewOfficersNote", { "number" }, { index });

		local group = GetGroupByIndex(index);
		if not(group) then
			return;
		end

		-- check access
		local rank = group.GetRankOfMember(userGuid);
		if rank and rank.CanViewOfficersNote() then
			local member = group.GetMember(i);
			if member then
				return member.GetOfficersNote();
			end
		end
	end

	class.CanEditOfficersNote = function(index)
		GHCheck("CanEditOfficersNote", { "number" }, { index });

		local group = GetGroupByIndex(index);
		if not(group) then
			return;
		end

		-- check access
		local rank = group.GetRankOfMember(userGuid);
		if rank and rank.CanEditOfficersNote() then
			return true;
		end
		return false;
	end

	class.SetOfficersNote = function(index,i,note)
		GHCheck("SetOfficersNote", { "number","number","string" }, { index,i,note });

		local group = GetGroupByIndex(index);
		if not(group) then
			return;
		end
		group = group.Clone();

		-- check access
		local rank = group.GetRankOfMember(userGuid);
		if rank and rank.CanEditOfficersNote() then
			local member = group.GetMember(i);
			if member then
				member.SetOfficersNote(note);
				group.UpdateVersion();
				groupList.SetGroup(group);
				return
			end
		end
	end
	
	return class;
end

