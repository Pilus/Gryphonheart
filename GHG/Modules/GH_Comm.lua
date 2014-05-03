--===================================================
--
--				GH_Comm
--  			GH_Comm.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local libversion = 1498; -- Version determined by subversion revision

if GH_Comm_Version and GH_Comm_Version >= libversion then
	return;
end
GH_Comm_Version = libversion;

local libComm = LibStub("AceComm-3.0");
local libSerial = LibStub("AceSerializer-3.0");
local libCompress = LibStub("LibCompress")
local libEncode = libCompress:GetAddonEncodeTable()
local addOnPrefix = "GH";

local class;
function GH_Comm()
	if class then
		return class;
	end
	class = GHClass("GH_Comm");

	local channel = "WHISPER";
	local recieveFuncs = {};
	local playersCommunicatedWith = {};

	local cache = {};
	local cachePointer = 1;
	local event = GHI_Event();

	class.AddRecieveFunc = function(_prefix, _recieveFunc)
		recieveFuncs[_prefix] = _recieveFunc;
	end

	class.Send = function(prio, target, prefix, ...)
		GHCheck("GH_Comm.Send", { "StringNil", "String", "String" }, { prio, target, prefix })

		if GMChatFrame_IsGM then return end;

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
		libComm:SendCommMessage(addOnPrefix, finalMsg, channel, target, prio)

		event.TriggerEvent("GHG_DEBUG",string.format("Msg send to %s. Prefix: %s",target,prefix));

		playersCommunicatedWith[target] = true;
	end

	local receive = function(prefix, data, channel, sender)
		local one = libEncode:Decode(data)

		--Decompress the decoded data
		local message = libCompress:Decompress(one)
		if (not message) then
			print("Error decompressing data from " .. sender, { message });
			return
		end

		-- Deserialize the decompressed data
		local success, data = libSerial:Deserialize(message)
		if not(success) then
			print("Error deserializing data from " .. sender, { data });
			return
		end

		local prefix = table.remove(data, 1);

		event.TriggerEvent("GHG_DEBUG",string.format("Msg received from %s. Prefix: %s",sender,prefix));

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
					return true;
				end
			end
		end
	end);

	libComm:RegisterComm(addOnPrefix, receive);


	local ready = false;
	local i = 0;
	--if UnitName("player") == "Quzelda" then
		GHI_Timer(function()
			if ready == false then
				i = i + 1;
				-- addOnPrefix, finalMsg, channel, target, prio
				libComm:SendCommMessage(addOnPrefix.."Ready", tostring(i), channel, "Larischa", "ALERT");
				libComm:SendCommMessage(addOnPrefix.."Ready", tostring(i), channel, "Quzelda", "ALERT");
				print("send", i);
			end
		end, 1)
	--end

	libComm:RegisterComm(addOnPrefix.."Ready", function(prefix, data, channel, sender)
		print("receive", sender, data)
		--ready = true;
	end);



	return class;
end

