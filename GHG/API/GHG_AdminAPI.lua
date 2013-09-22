--===================================================
--
--				GHG_AdminAPI
--  			GHG_AdminAPI.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHG_AdminAPI(userGuid)
	assert(type(userGuid)=="string","A guid must be given to the API")

	local class = GHClass("GHG_AdminAPI");

	local groupList = GHG_GroupList();

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

	local GetGroupByIndex = function(index)
		local g = GetGroupsUserBeingMemberIn();

		return groupList.GetGroup(g[index] or "");
	end

	local currentAdmin;
	local adminRankIndex;
	class.BeginGroupAdministration = function(index)
		local group = GetGroupByIndex(index);

		if not(group) then
			return
		end

		local rank = group.GetRankOfMember(userGuid);
		if not(rank and rank.CanEditRanksAndPermissions()) then
			return
		end
		currentAdmin = group.Clone();
		adminRankIndex = group.GetRankIndex(rank);
	end

	class.SaveGroupAdministration = function()
		assert(currentAdmin,"Administration not active");
		currentAdmin.UpdateVersion();
		groupList.SetGroup(currentAdmin);
	end

	class.Admin_GetOwnRankIndex = function()
		return adminRankIndex;
	end

	class.Admin_GetGroupInfo = function()
		assert(currentAdmin,"Administration not active");
		return currentAdmin.GetName(),currentAdmin.GetIcon();
	end

	class.Admin_SetGroupName = function(name)
		assert(currentAdmin,"Administration not active");
		currentAdmin.SetName(name);
	end

	class.Admin_SetGroupIcon = function(icon)
		assert(currentAdmin,"Administration not active");
		currentAdmin.SetIcon(icon);
	end

	class.Admin_GetNumRanks = function()
		assert(currentAdmin,"Administration not active");
		return currentAdmin.GetNumRanks();
	end

	class.Admin_GetRankInfo = function(index)
		assert(currentAdmin,"Administration not active");
		local rank = currentAdmin.GetRank(index);
		if rank then
			return rank.GetName(),rank.CanEditRanksAndPermissions(),rank.CanInvite(),rank.CanKickMember(),
			rank.CanPromoteDemote(),
			rank.CanEditOfficersNote(),rank.CanViewOfficersNote(),
			rank.CanEditPublicNote(),rank.CanViewPublicNote(),
			rank.CanTalkInChat(),rank.CanHearChat();
		end
	end

	class.Admin_SetRankInfo = function(index,...)
		assert(currentAdmin,"Administration not active");
		assert(type(index)=="number","Usage Admin_SetRankInfo(number,...)")
		assert(adminRankIndex == 1 or index > adminRankIndex,"Cannot edit rank equal or higher than your own")
		local t = {};

		local rank = currentAdmin.GetRank(index);
		if rank then
			t = rank.Serialize();
		end

		t.name,t.canEditRanksAndPermissions,t.canInvite,t.CanKickMember,t.canPromoteDemote,t.canEditOfficersNote,t.canViewOfficersNote,
			t.canEditPublicNote,t.canViewPublicNote,t.canTalkInChat,t.canHearChat = unpack({...});

		if index == 1 then
			t.canEditRanksAndPermissions = true; -- The leader can always edit ranks and permissions
		end

		currentAdmin.SetRank(index,GHG_GroupRank(t));
	end

	class.Admin_SwapRanks = function(index1,index2)
		assert(currentAdmin,"Administration not active");
		assert(not(index1 == 1 or index2 == 1),"Can not swap with the first rank");
		assert(index1 <= currentAdmin.GetNumRanks() and index2 <= currentAdmin.GetNumRanks(),"Rank index out of limit");
		assert(adminRankIndex == 1 or (index1 > adminRankIndex and index2 > adminRankIndex),"Cannot swap ranks equal or higher than your own")

		local rank1 = currentAdmin.GetRank(index1);
		local rank2 = currentAdmin.GetRank(index2);
		currentAdmin.SetRank(index1,rank2);
		currentAdmin.SetRank(index2,rank1);
	end

	class.Admin_DeleteRank = function(index)
		assert(currentAdmin,"Administration not active");
		assert(not(index == 1),"Can not delete the first rank");
		assert(index > adminRankIndex,"Cannot delete rank equal or higher than your own")
		assert(not(index==currentAdmin.GetNumRanks() ) or (adminRankIndex +1 < index),"Can not delete rank. There must be a new rank to move members to.")

		currentAdmin.DeleteRank(index);
	end



	return class;
end

