--
--									
--			GHI Group Communication
--				GHI_GroupComm.lua
--
--		Handler of communication between
--		 clients over group addon channels
--
-- 			(c)2013 The Gryphonheart Team
--				All rights reserved
--

local libComm = LibStub("AceComm-3.0");
local libSerial = LibStub("AceSerializer-3.0");
local libCompress = LibStub("LibCompress")
local libEncode = libCompress:GetAddonEncodeTable()
local addOnPrefix = "GHI";
local FILTER_ADDONS_MSGS = true;

local class;
function GHI_GroupComm(channelName)
	-- group channel is decalred when the class ic set up each time. Just like passing an item to item editing classes.
	if class then
		return class;
	end
	class = GHClass("GHI_Comm","frame");
	
	local versionInfo;
	
	channelName = strupper(channelName)
	
	local recieveFuncs = {};
	local playersCommunicatedWith = {};
	local registeredFrames, OnEvent, ParseEventToFrames;
	local log = GHI_Log();

	local groupReceive, groupSend
	
	-- Register special recieve func
	class.AddRecieveFunc = function(_prefix, _recieveFunc)
		recieveFuncs[_prefix] = _recieveFunc;
	end

	-- SendAddonMessage
	local cache = {};
	local cachePointer = 1;
	
	---Usage notes: This was copied from Channel come but made to be used with group formats such as:
	--PARTY,RAID,INSTANCE,GUILD,CHANNEL(Added in WoD)
	---so set up would be as local comm = GHI_GroupComm("GUILD")
	class.Send = function(prio, prefix, ...)--class.send changed to take channelName(channel) arugment
		assert(not (target == "WHISPER"), "Non updated sending of info");
		GHCheck("GHI_GroupComm.Send", { "StringNil", "String" }, { prio, prefix })

		log.Add(3, "Send " .. prefix .. " to " .. channelName, { ... });
		
		-- dont send to GMs
		if GMChatFrame_IsGM then return end	
		
		local v = { prefix, ... };
		local a = libSerial:Serialize(v);

		local b;
		
		for i,v in pairs(cache) do
			if v.key == a then
				b = v.value;
				break;
			end
		end

		if not(b) then
			b = libCompress:CompressHuffman(a);
			cache[cachePointer] = cache[cachePointer] or {};
			cache[cachePointer].key = a;
			cache[cachePointer].value = b;
			cachePointer = cachePointer + 1;
			if cachePointer > 10 then
				cachePointer = 1;
			end
		end
		local finalMsg = libEncode:Encode(b);

		libComm:SendCommMessage(addOnPrefix, finalMsg, channelName, nil, prio)

	end
	
	groupReceive = function(prefix, data, channelName, sender) 
		local one = libEncode:Decode(data)

		--Decompress the decoded data
		local message = libCompress:Decompress(one)
		if (not message) then
			--GHI_Message("GHI: error decompressing")
			log.Add(1, "Error decompressing data from " .. sender, { message });
			return
		end

		-- Deserialize the decompressed data
		local success, data = libSerial:Deserialize(message)
		if (not success) then
			log.Add(1, "Error deserializing data from " .. sender, { data });
			return
		end

		local prefix = table.remove(data, 1);
		log.Add(3, "Recieved " .. prefix .. " from " .. sender.." in "..channelName, data);
		if recieveFuncs[prefix] then
			recieveFuncs[prefix](sender, unpack(data));
		end
	end

	class.GetQueueSize = function()
		local size = 0;
		for prioname, Prio in pairs(ChatThrottleLib.Prio) do
			if type(Prio.Ring) == "table" and type(Prio.Ring.pos) == "table" then
				for prioname, data in pairs(Prio.Ring.pos) do
					size = size + (data.nSize or 0);
				end
			end
		end
		return size;
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(self, event, msg, ...)
		if event == "CHAT_MSG_SYSTEM" then
			local blockedStrings = { ERR_CHAT_PLAYER_NOT_FOUND_S, '%s is Away from Keyboard: %s', '%s wishes to not be disturbed and cannot receive whisper messages: %s' };
			for _, str in pairs(blockedStrings) do
				local pattern = string.format(str, "(.-)", "(.-)");
				local player = string.match(msg, pattern);

				if player and playersCommunicatedWith[player] then
					log.Add(3, "CHAT_MSG_SYSTEM blocked", { msg, ... });
					return true;
				end
			end

			log.Add(3, "CHAT_MSG_SYSTEM not blocked", { msg, ... });
		end
	end);

	libComm:RegisterComm(addOnPrefix, groupReceive);

	versionInfo = GHI_VersionInfo();

	return class;
end

 