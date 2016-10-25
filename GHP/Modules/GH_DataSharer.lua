--
--
--				GH_DataSharer
--  			GH_DataSharer.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local libversion = 1474; -- Version determined by subversion revision
local QUEUE_TRESHOLD = 4096;

if GH_DataSharer_Version and GH_DataSharer_Version >= libversion then
	return;
end
GH_DataSharer_Version = libversion;

local IsTableEmpty = function(t)
	for i,v in pairs(t) do
		return false;
	end
	return true;
end

local DATAPIECE_SIZE = 1024;

function GH_DataSharer(addonShort,setGuid,getFunc,setFunc,getAllGuidFunc,dynamicPieceSizeChange)
	assert(type(setGuid)=="string","SetGuid must be a string");
	assert(type(addonShort)=="string","addonShort must be a string");
	assert(type(getFunc)=="function","getFunc must be a function");
	assert(type(setFunc)=="function","setFunc must be a function");
	assert(type(getAllGuidFunc)=="function","getAllGuidFunc must be a function");

	local class = GHClass("GH_DataSharer");

	local comm = GHI_Comm();
	local channelComm = GHI_ChannelComm();
	local versionInfo = GHI_VersionInfo();
	local serializer = LibStub("AceSerializer-3.0");

	local SendUpdatedData = function(players,subsetGuid,version,pieces)
		local firstPlayer = table.remove(players,1);
		for i=1,#(pieces) do
			comm.Send("BULK",firstPlayer,"GH_UpdatedData_"..setGuid,subsetGuid,version,players,pieces[i],i,#(pieces));
		end
	end

	class.DatasetChanged = function(subsetGuid)
		local obj = getFunc(subsetGuid);
		local version = obj.GetVersion();
		local data = obj.Serialize();

		local players = versionInfo.GetAllPlayers(addonShort);


		local serializedData = serializer:Serialize(data);
		local len = string.len(serializedData);
		local pieces = {};

		local pieceSize = DATAPIECE_SIZE;
		if dynamicPieceSizeChange then
			pieceSize = math.floor(len/10)+1;
		end

		for i=1,math.ceil(len/pieceSize) do
			table.insert(pieces,string.sub(serializedData,(i-1)*pieceSize,(i*pieceSize)-1));
		end--]]


		--UpdatedData (setGuid, subsetGuid, version, players, data)

		while(#(players) > 5 and #(players) > #(pieces)) do
			local partPlayers = {};
			for i=1,#(pieces) do
				table.insert(partPlayers,table.remove(players,1));
			end
			SendUpdatedData(partPlayers,subsetGuid,version,pieces)

		end
		SendUpdatedData(players,subsetGuid,version,pieces)
	end


	local incommingData = {};

	local AreAllPiecesReceived = function(t,num)
		for i = 1,num do
			if not(t[i]) then
				return false;
			end
		end
		return true;
	end

	local ReceivePiece = function(subsetGuid,data,pieceIndex,numPiecesTotal)    --
		incommingData[subsetGuid] = incommingData[subsetGuid] or {};
		incommingData[subsetGuid][pieceIndex] = data;

		---DEBUG3 = (DEBUG3 or "").." Received piece "..pieceIndex.." of "..numPiecesTotal;

		if AreAllPiecesReceived(incommingData[subsetGuid],numPiecesTotal) then -- All pieces are received
			--

			local str = "";
			for i=1,#(incommingData[subsetGuid]) do
				str = str..incommingData[subsetGuid][i];
			end
			local success,dataSet = serializer:Deserialize(str)
			setFunc(subsetGuid,dataSet);
			incommingData[subsetGuid] = nil;


		end
	end

	local cache,cacheEcho,queuedPlayers,queuedPlayersEcho = {},{},{},{};
	GHI_Timer(function()
		cacheEcho = cache;
		cache = {};
		queuedPlayersEcho = queuedPlayers;
		queuedPlayers = {};
	end,30);

	local SendUpdatedData = function(player,subsetGuid,version,players,data,pieceIndex,numPiecesTotal)
		comm.Send("BULK",player,"GH_UpdatedData_"..setGuid,subsetGuid,version,players,data,pieceIndex,numPiecesTotal);

		-- Save in cache
		if not(cache[subsetGuid]) then
			cache[subsetGuid] = {
				version = version,
				players = players,
				numPiecesTotal = numPiecesTotal,
			};
		end
		cache[subsetGuid][pieceIndex] = data;
	end


	comm.AddRecieveFunc("GH_UpdatedData_"..setGuid,function(sender,subsetGuid,version,players,data,pieceIndex,numPiecesTotal)
		-- Compare own version to version
		local ownVersion = 0;
		local obj = getFunc(subsetGuid);
		if not(obj) or obj.GetVersion() <= version then
			if not(obj) or obj.GetVersion() < version then
				ReceivePiece(subsetGuid,data,pieceIndex,numPiecesTotal)
			end

			local firstPlayer = table.remove(players,1);



			if not(firstPlayer) then
				return
			elseif comm.GetQueueSize() < QUEUE_TRESHOLD then -- queue is non full

				if queuedPlayers[firstPlayer] or queuedPlayersEcho[firstPlayer] then
					SendUpdatedData(firstPlayer,subsetGuid,version,{},data,pieceIndex,numPiecesTotal)
					local secondPlayer = table.remove(players,1);
					if secondPlayer then
						SendUpdatedData(secondPlayer,subsetGuid,version,players,data,pieceIndex,numPiecesTotal)
					end
				else
					SendUpdatedData(firstPlayer,subsetGuid,version,players,data,pieceIndex,numPiecesTotal)

                end
			else
				if pieceIndex == 1 then
					comm.Send("ALERT",sender,"GH_QueueFull_"..setGuid,subsetGuid)
				end
			end
		else -- Own version is newer
			if pieceIndex == 1 then
				class.DatasetChanged(subsetGuid);
			end
		end
	end);

	-- React to full queue situations
	comm.AddRecieveFunc("GH_QueueFull_"..setGuid,function(sender,subsetGuid)
		queuedPlayers[sender] = true;

		-- Send all in the cache to the next receiver
		local c1,c2 = cache[subsetGuid] or {},cacheEcho[subsetGuid] or {};
		local version = c1.version or c2.version;
		local players = c1.players or c2.players;
		local numPiecesTotal = c1.numPiecesTotal or c2.numPiecesTotal;
		if not(version and players and numPiecesTotal) then
			return
		end

		local firstPlayer = table.remove(players,1);
		for _,c in pairs({c1,c2}) do
			for i,data in pairs(c) do
				if type(i)=="number" then
					SendUpdatedData(firstPlayer,subsetGuid,version,players,data,i,numPiecesTotal)
				end
			end
		end

	end);

	local FollowUpOnRequestUpdateOnAllSet;

	class.RequestUpdateOnAllSets = function()
		local guids = getAllGuidFunc() or {};
		local versions = {};
		for _,guid in pairs(guids) do
			local obj = getFunc(guid);
			versions[guid] = obj.GetVersion();
		end

		channelComm.Send("ALERT","GH_DataVersions_"..setGuid,versions);
		GHI_Timer(FollowUpOnRequestUpdateOnAllSet,10,true)
	end

	channelComm.AddRecieveFunc("GH_DataVersions_"..setGuid,function(sender,versions)
		local offerVersions,requests,offerSizes = {},{},{};

		for guid,version in pairs(versions) do
			local obj = getFunc(guid);
			if not(obj) or obj.GetVersion() < version then
				table.insert(requests,guid);
			elseif obj.GetVersion() > version then
				offerVersions[guid] = obj.GetVersion();
				local data = obj.Serialize();
				local serializedData = serializer:Serialize(data);
				local len = string.len(serializedData);
				offerSizes[guid] = math.ceil(len/DATAPIECE_SIZE);
			end
		end

		local allGuids = getAllGuidFunc()
		for _,guid in pairs(allGuids or {}) do
			if versions[guid] == nil then
				local obj = getFunc(guid);
				offerVersions[guid] = obj.GetVersion();

				local data = obj.Serialize();
				local serializedData = serializer:Serialize(data);
				local len = string.len(serializedData);
				offerSizes[guid] = math.ceil(len/DATAPIECE_SIZE);
			end
		end

		--local allGuids = getAllGuidFunc


		if IsTableEmpty(offerVersions) == false then
			comm.Send("ALERT",sender,"GH_DataOffer_"..setGuid,offerVersions,offerSizes);
		end
		if IsTableEmpty(requests) == false then
			comm.Send("ALERT",sender,"GH_DataRequest_"..setGuid,requests);
		end


	end);

	local offersReceived = {};
	local sizesReceived = {};
	local followUpDone = false;


	local FindBestOffers = function()
		local bestOffers = {};
		for sender,t in pairs(offersReceived) do
			for guid,version in pairs(t) do
				if not(bestOffers[guid]) then
					bestOffers[guid] = {
						version = version,
						players = {sender},
						size = sizesReceived[sender][guid] or 1;
					};
				else
					local current = bestOffers[guid];
					if current.version == version then
						table.insert(current.players,sender);
					elseif current.version < version then
						bestOffers[guid] = {
							version = version,
							players = {sender},
							size = sizesReceived[sender][guid] or 1;
						};
					end
				end
			end
		end
		return bestOffers
	end

	local SortBestOffersByAmountOfPeers = function(offers) -- using insertion sort
		local t = {};
		for guid,offer in pairs(offers) do
			local inserted = false;
			local value = #(offer.players);
			for i=1,#(t) do
				local otherValue = #(t[i].offer.players);
				if value < otherValue then
					table.insert(t,i,{guid = guid, offer = offer});
					inserted = true;
					break;
				end
			end
			if inserted == false then
				table.insert(t,{guid = guid, offer = offer});
			end
		end
		return t;
	end

	local FollowUpOnOffersReceived = function()
		local bestOffers = SortBestOffersByAmountOfPeers(FindBestOffers());

		local requestsToSend = {};
		for _,value in pairs(bestOffers) do
			local guid,offer = value.guid,value.offer;

			for i=1,offer.size do
				local bestPlayer = offer.players[1];
				for j=2,#(offer.players) do
					local player = offer.players[j];
					if #(requestsToSend[player] or {}) < #(requestsToSend[bestPlayer] or {}) then
						bestPlayer = player;
					end
				end

				requestsToSend[bestPlayer] = requestsToSend[bestPlayer] or {};
				table.insert(requestsToSend[bestPlayer],{guid = guid, piece = i, size = offer.size})
				---DEBUG3 = (DEBUG3 or "").." Req piece "..i.." from "..bestPlayer..",";
			end
		end

		for player,reqs in pairs(requestsToSend) do
			local gatheredRequests = {};
			for _,req in pairs(reqs) do
				if req.size == 1 then
					gatheredRequests[req.guid] = "all";
				else
					gatheredRequests[req.guid] = gatheredRequests[req.guid] or {};
					table.insert(gatheredRequests[req.guid],req.piece);
				end
			end

			local requests = {};
			for guid,pieces in pairs(gatheredRequests) do
				local reqPieces;
				if type(pieces)=="table" then
					table.insert(requests,{guid=guid,pieces = pieces});
				else
					table.insert(requests,guid);
				end

			end
			comm.Send("ALERT",player,"GH_DataRequest_"..setGuid,requests);
		end

	end


	comm.AddRecieveFunc("GH_DataOffer_"..setGuid,function(sender,versions,sizes)
		offersReceived[sender]=versions;
		sizesReceived[sender]=sizes or {};
	end);

	local requestsReceived = {};


	local SendData = function(players,subsetGuid,piece)
		local obj = getFunc(subsetGuid);
		if not(obj) then
			return
		end

		local player;
		if type(players)=="string" then
			player = players;
			players = {};
		else
			player = table.remove(players,1);
		end

		local version = obj.GetVersion();
		local data = obj.Serialize();
		local serializedData = serializer:Serialize(data);


		local len = string.len(serializedData);
		local pieces = {};
		for i=1,math.ceil(len/DATAPIECE_SIZE) do
			table.insert(pieces,string.sub(serializedData,(i-1)*DATAPIECE_SIZE,(i*DATAPIECE_SIZE)-1));
		end--]]

		local a,b;
		if (piece) then
			a = piece;
			b = piece;
		else
			a = 1;
			b = #(pieces);
		end

		for i=a,b do

			comm.Send("BULK",player,"GH_UpdatedData_"..setGuid,subsetGuid,version,players,pieces[i],i,#(pieces));
		end
	end

	local FollowUpOnRequestsReceived = function(t)
		local requestsPrGuid = {}
		for sender,requests in pairs(t) do
			for _,request in pairs(requests) do
				if type(request) == "string" then
					local guid = request;
					requestsPrGuid[guid] = requestsPrGuid[guid] or {};
					table.insert(requestsPrGuid[guid],sender);

				elseif type(request) == "table" then
					local guid = request.guid;
					local pieces = request.pieces;
					--DEBUG3 = (DEBUG3 or "").." received request for piece "..pieces[1];
					requestsPrGuid[guid] = requestsPrGuid[guid] or {};
					requestsPrGuid[guid].pieces = requestsPrGuid[guid].pieces or {};
					for _,piece in pairs(pieces) do
						requestsPrGuid[guid].pieces[piece] = requestsPrGuid[guid].pieces[piece] or {};
						table.insert(requestsPrGuid[guid].pieces[piece],sender);
					end
				end
			end
		end

		-- gather the requests pr guid
		for guid,playersRequesting in pairs(requestsPrGuid) do

			-- handle piece requests
			local pieceReqs = playersRequesting.pieces
			for pieceIndex,players in pairs(pieceReqs or {}) do
				if #(players) > 0 then
					SendData(players,guid,pieceIndex);
				end
			end
			playersRequesting.pieces = nil;

			-- handle full data requests
			if #(playersRequesting) > 0 then
				SendData(playersRequesting,guid);
			end
		end

	end

	comm.AddRecieveFunc("GH_DataRequest_"..setGuid,function(sender,guids)
		if followUpDone then
			local t = {};
			t[sender]=guids;
			FollowUpOnRequestsReceived(t);
		else
			requestsReceived[sender]=guids;
		end
	end);

	FollowUpOnRequestUpdateOnAllSet = function()
		FollowUpOnOffersReceived();
		FollowUpOnRequestsReceived(requestsReceived);
		requestsReceived = {};
		followUpDone = true;
	end


	--   Lock 
	local activeLocks = {};
	local lockFuncs = {};
	class.RequestLock = function(guid,func)
		if not(activeLocks[guid]) then
			channelComm.Send("ALERT","GH_DataLock_"..setGuid,guid);
			lockFuncs[guid] = func;
		else
			func(false);
		end
	end

	channelComm.AddRecieveFunc("GH_DataLock_"..setGuid,function(sender,guid)
		if not(activeLocks[guid]) then
			activeLocks[guid] = {
				player = sender,
			};

			if lockFuncs[guid] then
				lockFuncs[guid](UnitName("player")==sender);
				lockFuncs[guid] = nil;
			end
		end
	end);

	class.ReleaseLock = function(guid)
		if (activeLocks[guid] or {}).player == UnitName("player") then
			channelComm.Send("ALERT","GH_DataUnlock_"..setGuid,guid);
		end
	end

	channelComm.AddRecieveFunc("GH_DataUnlock_"..setGuid,function(sender,guid)
		if (activeLocks[guid] or {}).player == sender then
			activeLocks[guid] = nil
		end
	end);

	class.RequestUpdateOnAllSets();

	return class;
end

