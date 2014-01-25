--===================================================
--
--				GHI Channel Communication
--					GHI_ChannelComm.lua
--
--	Handler of all communication between clients over channels
--	
-- 			(c)2013 The Gryphonheart Team
--				All rights reserved
--===================================================	

local libSerial = LibStub("AceSerializer-3.0");
local libCompress = LibStub("LibCompress")
local libEncode = libCompress:GetAddonEncodeTable()
local ADDON_PREFIX = "GHI";
local MSG_SINGLE = "\001"
local MSG_MULTI_FIRST = "\002"
local MSG_MULTI_MIDDLE = "\003"
local MSG_MULTI_LAST = "\004"

local class;
function GHI_ChannelComm()
	if GHI_MiscData and GHI_MiscData["NoChannelComm"] then
		return { Send = function(...) end, AddRecieveFunc = function(...) end };
	end

	if GHI_MiscData and GHI_MiscData["no_channel_comm"] == true then
		return { Send = function(...) end, AddRecieveFunc = function(...) end };
	end

	if class then
		return class;
	end
	class = GHClass("GHI_Comm","frame");

	local channelName = "xtensionxtooltip2";
	local recieveFuncs = {};
	local log = GHI_Log();
	local CTL = ChatThrottleLib;
	local Recieve, channelNumber, SetupInputBuffer, AddMsgToInputBuffer, AddLastMsgToInputBufferAndRecieve;
	local inputBuffer = {};
	local ChunkUpMsg, OneChunk;
	local HEADER_SIZE = 1 + ADDON_PREFIX:len();
	local setUp = false;

	local chatIsReady = false;
	local preSetupBuffer = {}

	local ChatReady = function()
		chatIsReady = true;
		log.Add(2,"Communication channel ready");
		for _,msg in pairs(preSetupBuffer) do
			class.Send(unpack(msg));
		end
	end

	class.AddRecieveFunc = function(_prefix, _recieveFunc)
		recieveFuncs[_prefix] = _recieveFunc;
	end

	OneChunk = function(msg)
		if (msg:len() < (255 - HEADER_SIZE)) then return msg; end
		local i = strlenutf8(strsub(msg, 0, 262));
		while (strsubutf8(msg, 0, i):len() >= (255 - HEADER_SIZE)) do
			i = i - 1;
		end
		return strsubutf8(msg, 0, i), strsubutf8(msg, i + 1)
	end

	ChunkUpMsg = function(msg)
		local t = {};
		while (msg and msg:len() > 0) do
			local chunk;
			chunk, msg = OneChunk(msg);
			table.insert(t, chunk);
		end
		return t;
	end

	class.Send = function(prio, prefix, ...)
		assert(not (target == "WHISPER"), "Non updated sending of info");
		GHCheck("GHI_ChannelComm.Send", { "StringNil", "String" }, { prio, prefix })

		if not(chatIsReady) then
			table.insert(preSetupBuffer,{prio, prefix, ...});
			log.Add(3, "Send " .. prefix .. " to channel (in queue for channel setup)");
			return
		end

		log.Add(3, "Send " .. prefix .. " to channel");
		local channelNum = GetChannelName(channelName);

		local prio = strupper(prio or "NORMAL");
		local msg = libEncode:Encode(libSerial:Serialize({ prefix, ... }));
		local chunks = ChunkUpMsg(msg);

		if (#(chunks) == 1) then
			CTL:SendChatMessage(prio, prefix, ADDON_PREFIX .. MSG_SINGLE .. chunks[1], "CHANNEL", nil, channelNum);
		else
			CTL:SendChatMessage(prio, prefix, ADDON_PREFIX .. MSG_MULTI_FIRST .. chunks[1], "CHANNEL", nil, channelNum);
			for i = 2, #(chunks) - 1 do
				CTL:SendChatMessage(prio, prefix, ADDON_PREFIX .. MSG_MULTI_MIDDLE .. chunks[i], "CHANNEL", nil, channelNum);
			end
			CTL:SendChatMessage(prio, prefix, ADDON_PREFIX .. MSG_MULTI_LAST .. chunks[#(chunks)], "CHANNEL", nil, channelNum);
		end
	end

	Recieve = function(msg, sender)
		--Decompress the decoded data
		local message = libCompress:Decompress(libEncode:Decode(msg))
		if (not message) then
			log.Add(1, "Error decompressing channel data from " .. sender, { message });
			return
		end

		-- Deserialize the decompressed data
		local success, data = libSerial:Deserialize(message)
		if (not success) then
			log.Add(1, "Error deserializing channel data from " .. sender, { data });
			return
		end

		local prefix = table.remove(data, 1);
		log.Add(3, "Recieved " .. prefix .. " from " .. sender .. " (channel)", data);
		if recieveFuncs[prefix] then
			recieveFuncs[prefix](sender, unpack(data));
		end
	end

	SetupInputBuffer = function(sender, firstMsg)
		if inputBuffer[sender] then
			log.Add(1, "Recieved new channel message from sender before end of first message. " .. sender, inputBuffer[sender]);
		end
		inputBuffer[sender] = {};
		AddMsgToInputBuffer(sender, firstMsg);
	end

	AddMsgToInputBuffer = function(sender, msg)
		table.insert(inputBuffer[sender] or {}, strsub(msg, ADDON_PREFIX:len() + 1));
	end

	AddLastMsgToInputBufferAndRecieve = function(sender, lastMsg)
		AddMsgToInputBuffer(sender, lastMsg)
		local msg = strjoin("", unpack(inputBuffer[sender] or {}));
		inputBuffer[sender] = nil;
		Recieve(msg, sender);
	end


	local JoinChannel = function()
		JoinChannelByName(channelName);
		local i = 1;
		while _G["ChatWindow" .. i] do
			ChatFrame_RemoveChannel(_G["ChatWindow" .. i], channelName);
		end
		log.Add(2, "Joined communication channel");
	end

	GHI_Timer(function()
		if not(chatIsReady) then
			local channelNum = GetChannelName(channelName);
			CTL:SendChatMessage("ALERT", ADDON_PREFIX,ADDON_PREFIX .. MSG_SINGLE .. "ChannelReadyCheck", "CHANNEL", nil, channelNum);
		end
	end,1);



	class:SetScript("OnEvent", function(self, event, msg, sender, arg3, arg4, arg5, arg6, arg7, channelNumber)
		if event == "CHAT_MSG_CHANNEL" and channelNumber == GetChannelName(channelName) and strsub(msg, 0, ADDON_PREFIX:len()) == ADDON_PREFIX then
			if not(chatIsReady) then
				ChatReady();
			end
			if msg == ADDON_PREFIX .. MSG_SINGLE .. "ChannelReadyCheck" then
				return
			end

			local ctrl = strsub(msg, ADDON_PREFIX:len() + 1, ADDON_PREFIX:len() + 1);
			if ctrl == MSG_SINGLE then
				Recieve(strsub(msg, ADDON_PREFIX:len() + 1), sender)
			elseif ctrl == MSG_MULTI_FIRST then
				SetupInputBuffer(sender, msg);
			elseif ctrl == MSG_MULTI_MIDDLE then
				AddMsgToInputBuffer(sender, msg);
			elseif ctrl == MSG_MULTI_LAST then
				AddLastMsgToInputBufferAndRecieve(sender, msg);
			else
				log.Add(1, "Recieved channel msg with unknown control char. From " .. sender, { raw = ctrl, byte = strbyte(ctrl) });
			end
		end

		if setUp == false then
			setUp = true;
			JoinChannel()
		end
	end);
	class:RegisterEvent("CHAT_MSG_CHANNEL");
	class:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE");

	GHI_Event("PLAYER_ENTERING_WORLD",function() GHI_Timer(function() class:GetScript("OnEvent")(class,"CHAT_MSG_CHANNEL_NOTICE") end,30,true); end)

	return class;
end



