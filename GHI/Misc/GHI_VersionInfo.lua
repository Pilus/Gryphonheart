--===================================================
--
--				GHI_VersionInfo
--  			GHI_VersionInfo.lua
--
--	Handles version requests and information about other clients
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local function CompareNumbers(t1, t2)
	local v1 = t1[1];
	local v2 = t2[1];
	v1 = tonumber(v1) or 0;
	v2 = tonumber(v2) or 0;

	if v1 > v2 then
		return true;
	elseif v1 < v2 then
		return false;
	else --  v1 = v2
		table.remove(t1, 1);
		table.remove(t2, 1);
		if #(t2) == 0 then
			return true;
		elseif #(t1) == 0 then
			return false;
		else
			return CompareNumbers(t1, t2);
		end
	end
end

local function CompareVersions(v1, v2)
	if not (type(v1) == "string" or type(v1) == "number") then return false end
	if not (type(v2) == "string" or type(v2) == "number") then return false end
	local t1 = { strsplit(".", v1) };
	local t2 = { strsplit(".", v2) };
	return CompareNumbers(t1, t2);
end

local class;
function GHI_VersionInfo()
	if class then
		return class;
	end
	class = GHClass("GHI_VersionInfo");
	local comm = GHI_Comm();
	local log = GHI_Log();
	local playerOnline = {};
	local event = GHI_Event();

	class.timeout = 10;
	local e = {
		CHAT_MSG_CHANNEL = true,
		CHAT_MSG_EMOTE = true,
		CHAT_MSG_GUILD = true,
		CHAT_MSG_OFFICER = true,
		CHAT_MSG_PARTY = true,
		CHAT_MSG_PARTY_LEADER = true,
		CHAT_MSG_RAID = true,
		CHAT_MSG_SAY = true,
		CHAT_MSG_TEXT_EMOTE = true,
		CHAT_MSG_WHISPER = true,
		CHAT_MSG_YELL = true,
	};
	
	local function OnFindEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
		-- when others joining ("CHAT_MSG_CHANNEL_JOIN")
		if event == "CHAT_MSG_CHANNEL_JOIN" then
			class.NoticePlayer(arg2);
		elseif event == "CHAT_MSG_CHANNEL_LEAVE" then
			comm.Send("NORMAL", arg2,"DummyMsg");
		end

		-- on chat message
		if e[event] and not (arg6 == "GM") then
			class.NoticePlayer(arg2);
		end

		if event == "CHAT_MSG_ADDON" then
			class.NoticePlayer(arg4);
		end

		if event == "CHAT_MSG_SYSTEM" then
			local player = gsub(string.match(arg1, "'.*'") or "", "'", "");
			if player and format(ERR_CHAT_PLAYER_NOT_FOUND_S, player) == arg1 then
				class.RemovePlayer(player)
				playerOnline[player] = nil;
				return;
			end
		end

		-- friendslist Update
		if event == "FRIENDLIST_UPDATE" then
			for i = 1, GetNumFriends() do
				local name, _, _, _, connected = GetFriendInfo(i);
				if connected then
					class.NoticePlayer(name);
				end
			end
		end

		-- on trade Frame
		if event == "TRADE_REQUEST" then
			class.NoticePlayer(arg1);
		end
	end


	local function SetUp()
		GHI_Event("CHAT_MSG_CHANNEL_NOTICE", OnFindEvent);
		GHI_Event("CHAT_MSG_CHANNEL_JOIN", OnFindEvent);
		GHI_Event("CHAT_MSG_CHANNEL_LEAVE", OnFindEvent);
		GHI_Event("CHAT_MSG_SYSTEM", OnFindEvent);
		GHI_Event("CHAT_MSG_CHANNEL", OnFindEvent);
		GHI_Event("CHAT_MSG_EMOTE", OnFindEvent);
		GHI_Event("CHAT_MSG_GUILD", OnFindEvent);
		GHI_Event("CHAT_MSG_OFFICER", OnFindEvent);
		GHI_Event("CHAT_MSG_PARTY", OnFindEvent);
		GHI_Event("CHAT_MSG_PARTY_LEADER", OnFindEvent);
		GHI_Event("CHAT_MSG_RAID", OnFindEvent);
		GHI_Event("CHAT_MSG_ADDON", OnFindEvent);
		GHI_Event("CHAT_MSG_TEXT_EMOTE", OnFindEvent);
		GHI_Event("CHAT_MSG_WHISPER", OnFindEvent);
		GHI_Event("CHAT_MSG_YELL", OnFindEvent);
		GHI_Event("FRIENDLIST_UPDATE", OnFindEvent);
		GHI_Event("TRADE_REQUEST", OnFindEvent);

		class.NoticePlayer(UnitName("player"));
	end

	local addOnList;
	local notifyFuncs = {};
	local existingPlayers = {};
	local playerAddOns = {};

	local function GetAddOnList()
		if not (addOnList) then
			-- generate the list
			addOnList = {};
			for i = 1, GetNumAddOns() do
				local addOnName, addOnTitle, addOnNotes, addOnEnabled, addOnLoadable, addOnReason, addOnSecurity = GetAddOnInfo(i);

				if string.find(addOnTitle, "Gryphonheart") and addOnEnabled then
					-- check if X-Lib is not true
					if not (GetAddOnMetadata(addOnName, "X-Lib") == "true") then
						table.insert(addOnList, {
							short = addOnName,
							title = addOnTitle,
							version = GetAddOnMetadata(addOnName, "Version"),
							devVersion = GetAddOnMetadata(addOnName, "X-DevVersion")
						});
					end
				end
			end
		end

		return addOnList;
	end
		
	-- Get all players with a given addon. Version is optional
	class.GetAllPlayers = function(addOnShort, version)
		addOnShort = addOnShort or "GHI"; -- default value for addOn is GHI

		local players = {};

		for player, addons in pairs(playerAddOns) do
			if class.PlayerGotAddOn(player, addOnShort, version) then
				table.insert(players, player);
			end
		end

		return players
	end

	class.NumPlayersWithAddOn = function(addOnShort, version)
		addOnShort = addOnShort or "GHI"; -- default value for addOn is GHI
		local num = 0;
		for player, addons in pairs(playerAddOns) do
			if class.PlayerGotAddOn(player, addOnShort, version) then
				num = num + 1;
			end
		end

		return num
	end

	-- return a list of addons the player has
	class.GetPlayerAddOns = function(player)

		player = Ambiguate(player, "none");

		local result = {};
		local t = playerAddOns[player] or {};

		for _, addon in pairs(t) do
			table.insert(result, addon.short);
		end

		return result;
	end

	class.GetPlayerAddOnVer = function(player, addOnShort)
		addOnShort = addOnShort or "GHI"; -- default value for addOn is GHI

		player = Ambiguate(player, "none");

		local t = playerAddOns[player] or {};
		-- look for the addon
		for _, addon in pairs(t) do
			if type(addon) == "table" then
				if addon.short == addOnShort then
					return addon.version, addon.devVersion
				end
			end
		end
	end

	class.PlayerGotAddOn = function(player, addOnShort, version)
		addOnShort = addOnShort or "GHI"; -- default value for addOn is GHI

		player = Ambiguate(player, "none");

		-- look for the addon
		if type(playerAddOns[player]) == "table" then
			for _, addon in pairs(playerAddOns[player]) do
				if type(addon) == "table" then
					if addon.short == addOnShort then

						-- if a version is given, make sure the addon is newer than the given version
						if version then
							return CompareVersions(addon.version or 0, version);
						else
							return true;
						end
					end
				end
			end
		end
		return false;
	end

	class.IsPlayerOnline = function(player)
		player = Ambiguate(player, "none");
		return playerOnline[player];
	end

	-- Notice a player and update the player if it was unknown or outdated
	class.NoticePlayer = function(player)
		if not (player) or string.len(player or "") == 0 then
			return;
		end

		player = Ambiguate(player, "none");

		playerOnline[player] = true;

		-- check if the player is already known and recently updated
		if (existingPlayers[player] and (GetTime() - existingPlayers[player]) < class.timeout * 60) then
			-- no new info, so return
			return;
		end

		-- save noticed time
		existingPlayers[player] = GetTime();

		-- request information about the players addons
		if player == UnitName("player") then
			playerAddOns[player] = GetAddOnList();
			class.NotifyAll(player)
		else
			comm.Send("NORMAL", player, "ReqAddOns");
		end
	end

	-- Set timeout for refreshing
	class.SetTimeout = function(timeout)
		assert(type(timeout) == "number", "Timeout must be a number");
		class.timeout = timeout;
	end

	class.RemovePlayer = function(player)
		player = Ambiguate(player, "none");
		if existingPlayers[player] and existingPlayers[player] > 0 then
			existingPlayers[player] = 0;
			event.TriggerEvent("GHI_PLAYER_GONE_OFFLINE",player);
		end
	end

	-- send message to all registered notifiers when the player is updated
	class.NotifyAll = function(player)
		for _, notifier in pairs(notifyFuncs) do
			if class.PlayerGotAddOn(player, notifier.addOnShort, notifier.version) then
				notifier.func(player)
			end
		end
	end

	-- register functions for notification
	class.RegNotifyFunc = function(func, addOnShort, version)
		table.insert(notifyFuncs, {
			func = func,
			addOnShort = addOnShort,
			version = version,
			devVersion = devVersion,
		});
	end

	-- Answer with table of addon info
	comm.AddRecieveFunc("ReqAddOns", function(player, ...)
		comm.Send("NORMAL", player, "AddOns", GetAddOnList());
	end)

	comm.AddRecieveFunc("AddOns", function(player, addons, ...)
		player = Ambiguate(player, "none");
		playerAddOns[player] = addons;
		class.NotifyAll(player)
	end)

	-- channel scan
	local channelScanNum;
	local channels = {};
	local channelInfoReady = false;

	local SpotChannelMembers = function(i)

		local n1 = GetChannelRosterInfo("" .. i, 1);
		if (n1) then
			local j = 1;
			local name = GetChannelRosterInfo("" .. i, j);
			while (name) do
				class.NoticePlayer(name);
				j = j + 1;
				name = GetChannelRosterInfo("" .. i, j);
			end
		end
	end

	GHI_Timer(function()
		if not (ChannelFrame:IsShown()) and channelScanNum then
			if channelScanNum <= #(channels) then
				if not (channelInfoReady) then
					log.Add(3,"Selecting channel for scan",{channelScanNum})
					SetSelectedDisplayChannel(channels[channelScanNum]);
					channelInfoReady = true;
				else
					log.Add(3,"Scanning channel",{channelScanNum})
					SpotChannelMembers(channels[channelScanNum])
					channelScanNum = channelScanNum + 1;
					channelInfoReady = false;
				end
			end
		end
	end, 2);

	local InitializeChannelScan = function()
		log.Add(3,"Initializing channel scan for players.")
		channelInfoReady = false;
		channels = {};
		for i = 1, 20 do
			local n1, isHeader = GetChannelDisplayInfo("" .. i);
			if not (isHeader) and n1 then
				table.insert(channels, i .. "");
			end
		end
		channelScanNum = 1;
	end

	GHI_Timer(InitializeChannelScan, 60 * 15);

	SetUp()
	GHI_Timer(InitializeChannelScan, 30 * 5 , true); -- when logging in, the channel information might first be available after a few minutes

	-- request via channel
	local cc = GHI_ChannelComm()
	cc.AddRecieveFunc("GHI_AddOnsReq",function(player)
		if not(player == UnitName("player")) then
			comm.Send("NORMAL", player, "AddOns", GetAddOnList());
		end
	end);
	cc.Send("ALERT","GHI_AddOnsReq","");

	return class;
end

