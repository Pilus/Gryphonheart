--
--
--			GHI_UsageStatisticsManager
--			GHI_UsageStatisticsManager.lua
--
--	Manager of GHI user statistics
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local class;
local ownStatistics;
function GHI_UsageStatisticsManager()
	if class then
		return class;
	end
	class = GHClass("GHI_UsageStatisticsManager");

	local itemInfo = GHI_ItemInfoList();
	local comm = GHI_Comm();

	local sendPlayer;
	local SendStatistics = function(player)
		comm.Send("BULK", player, "UsageStatistics",ownStatistics.Serialize())
	end

	comm.AddRecieveFunc("ReqUsageStatistics",SendStatistics)
	comm.AddRecieveFunc("ReqUsageStatisticsChannel",SendStatistics)

	local expectingStatisticsFunc;
	comm.AddRecieveFunc("UsageStatistics",function(player,statistics)
		if expectingStatisticsFunc then
			expectingStatisticsFunc(GHI_UsageStatisticsSet(statistics));
		end
	end);

	class.GatherStatisticsFromAll = function()
		local recievedStats = {};
		expectingStatisticsFunc = function(statistics)
			table.insert(recievedStats,statistics)
		end;
		comm.SendToChannel("BULK","ReqUsageStatisticsChannel");
		GHI_RecievedStatistics = recievedStats;
	end

	return class;
end

local GatherStatistics = true;
local Statistics = {};
GHI_Event("GHI_LOADED",function()
	GHI_UsageStatisticsManager()
	local versionInfo = GHI_VersionInfo();
	GatherStatistics = false;
	Statistics.addonVersions = versionInfo.GetPlayerAddOns(UnitName("player"));
	Statistics.GHI_MiscData = GHI_MiscData;
	ownStatistics = GHI_UsageStatisticsSet(Statistics);
end);

GHI_SaveStatistic = function(index,index2)
	if GatherStatistics then
		if not(index2) then
			if not(type(Statistics[index]) == "table") then
				Statistics[index] = (Statistics[index] or 0) + 1;
			end
		else
			if not(Statistics[index]) then Statistics[index]= {}; end
			Statistics[index][index2] = (Statistics[index][index2] or 0) + 1;
		end
	end
end