--===================================================
--
--				GHG_PlayerDataList
--  			GHG_PlayerDataList.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local DATA_SAVE_TABLE = "GHG_SavedPlayerData";

local class;
local variablesLoaded = false;
function GHG_PlayerDataList()
	if class then
		return class;
	end
	class = GHClass("GHG_PlayerDataList");

	local playerData = {};

	local savedPlayerData = GHI_SavedData(DATA_SAVE_TABLE,GetRealmName());
	local event = GHI_Event();
	local sharer;
	local msp = GHI_MarySueAPI().GetAPI();

	local DecompressGuid = function(guid)
		if string.startsWith(guid,"0x") then
			return guid;
		end
		return "0x"..string.rep("0",16-string.len(guid))..guid;
	end

	local CompressGuid = function(guid)
		if string.startsWith(guid,"0x") then
			guid = string.sub(guid,3);
		end
		while (string.startsWith(guid,"0")) do
			guid = string.sub(guid,2);
		end
		return guid;
	end
	local g = UnitGUID("player");

	class.GetPlayerData = function(guid)
		guid = DecompressGuid(guid);
		return playerData[guid];
	end

	local SetPlayerData = function(pData)
		local guid = pData.GetGuid();
		local existingPData = playerData[guid];
		if not(existingPData) or pData.GetVersion() > existingPData.GetVersion() then
			playerData[guid] = pData;
			savedPlayerData.SetVar(guid,pData.Serialize())
			event.TriggerEvent("GHP_PLAYER_UPDATED",guid);
		end
	end

	class.SetPlayerData = function(guid,value)
		if type(value) == "table" then
			if type(value.IsClass) == "function" then
				if value.IsClass("GHG_PlayerData") then
					SetPlayerData(value);
				end
			else
				SetPlayerData(GHG_PlayerData(value));
			end
		end
	end

	class.GetAllPlayerGuids = function()
		local t = {};
		for guid,_ in pairs(playerData) do
			table.insert(t,CompressGuid(guid));
		end
		return t;
	end

	local lastUpdate = 0;
	local UpdateOwnPlayerData = function()
		local guid = UnitGUID("player");
		local current = class.GetPlayerData(guid);
		local version = 0;
		if current then
			version = current.GetVersion();
		end

		local icName,icTitle,icHouse,icNickname = msp.GHI_GetCharacterWho(UnitName("player"));

		local info = {
			guid = guid,
			name = UnitName("player"),
			lastOnline = GHG_GetServerTime(),
			version = version + 1,
			level = UnitLevel("player"),
			class = UnitClass("player"),
			zone = GetRealZoneText(),
			race = UnitRace("player"),
			icName = icName,
			icTitle = icTitle,
			guild = GetGuildInfo("player"),
			gender = UnitSex("player"),
		}

		local new = GHG_PlayerData(info);
		class.SetPlayerData(guid,new);
		sharer.DatasetChanged(guid);
		lastUpdate = time();
	end


	GHI_Event("VARIABLES_LOADED",function()
		local data = savedPlayerData.GetAll();
		playerData = {};

		for index,value in pairs(data) do
			playerData[index] = GHG_PlayerData(value);
		end

		sharer = GH_DataSharer("GHG","GHG_PlayerData2",class.GetPlayerData,class.SetPlayerData,class.GetAllPlayerGuids,true);



		GHI_Event("PLAYER_LEVEL_UP",UpdateOwnPlayerData)
		GHI_Event("ZONE_CHANGED",UpdateOwnPlayerData)
		GHI_Timer(function()
			local dt = time() - lastUpdate;
			if dt >= 30*60 then
				UpdateOwnPlayerData();
			end
		end,1);

		GHI_VersionInfo().RegNotifyFunc(function() event.TriggerEvent("GHP_PLAYER_UPDATED") end,"GHG");

		local init = false;
		GHI_Timer(function()
			if init == false and not(GetRealZoneText()=="") then
				UpdateOwnPlayerData();
				init = true;
			end
		end,1)
	end);


	return class;
end

GHG_GetServerTime = function()
	local hour,minute = GetGameTime();
	local weekday, month, day, year = CalendarGetDate();
	return time({min = minute, hour = hour, day=day, month=month, year=year})
end

