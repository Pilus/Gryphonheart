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
local libEncode = libCompress:GetChatEncodeTable()
local ADDON_PREFIX = "GHI";
local MSG_SINGLE = "\001"
local MSG_MULTI_FIRST = 	{"\002","\005","\006","\007","\016"}
local MSG_MULTI_MIDDLE = 	{"\003","\008","\009","\011","\017"}
local MSG_MULTI_LAST = 		{"\004","\012","\014","\015","\018"}

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
	local sendCounter = {
		NORMAL = 0,
		ALERT = 0,
		BULK = 0,
	}

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
		local msg = libSerial:Serialize({ prefix, ... });
		local chunks = ChunkUpMsg(msg);

		if (#(chunks) == 1) then
			CTL:SendChatMessage(prio, prefix, ADDON_PREFIX .. MSG_SINGLE .. chunks[1], "CHANNEL", nil, channelNum);
		else
			local counter = sendCounter[prio];
			sendCounter[prio] = sendCounter[prio] + 1;
			CTL:SendChatMessage(prio, prefix, ADDON_PREFIX .. MSG_MULTI_FIRST[mod(counter,#(MSG_MULTI_FIRST))+1] .. chunks[1], "CHANNEL", nil, channelNum);
			for i = 2, #(chunks) - 1 do
				CTL:SendChatMessage(prio, prefix, ADDON_PREFIX .. MSG_MULTI_MIDDLE[mod(counter,#(MSG_MULTI_MIDDLE))+1] .. chunks[i], "CHANNEL", nil, channelNum);
			end
			CTL:SendChatMessage(prio, prefix, ADDON_PREFIX .. MSG_MULTI_LAST[mod(counter,#(MSG_MULTI_LAST))+1] .. chunks[#(chunks)], "CHANNEL", nil, channelNum);
		end
	end

	Recieve = function(msg, sender)
		--Decompress the decoded data
		local message = libEncode:Decode(msg)
		if (not message) then
			log.Add(1, "Error decoding channel data from " .. sender, { message });
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

	SetupInputBuffer = function(sender, num, firstMsg)
		inputBuffer[sender] = inputBuffer[sender] or {};
		if inputBuffer[sender][num] then
			log.Add(1, "Recieved new channel message from sender before end of first message. " .. sender, {num});
		end
		inputBuffer[sender][num] = {};
		AddMsgToInputBuffer(sender,num, firstMsg);
	end

	AddMsgToInputBuffer = function(sender, num, msg)
		inputBuffer[sender] = inputBuffer[sender] or {};
		table.insert(inputBuffer[sender][num] or {}, strsub(msg, ADDON_PREFIX:len() + 2));
	end

	AddLastMsgToInputBufferAndRecieve = function(sender, num, lastMsg)
		AddMsgToInputBuffer(sender,num, lastMsg)
		local msg = strjoin("", unpack(inputBuffer[sender][num] or {}));
		inputBuffer[sender][num] = nil;
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

	local GetIndexOf = function(t,v)
		for i,v2 in pairs(t) do
			if v2 == v then
				return i;
			end
		end
	end

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
			elseif tContains(MSG_MULTI_FIRST,ctrl) then
				SetupInputBuffer(sender,GetIndexOf(MSG_MULTI_FIRST,ctrl), msg);
			elseif tContains(MSG_MULTI_MIDDLE,ctrl) then
				AddMsgToInputBuffer(sender,GetIndexOf(MSG_MULTI_MIDDLE,ctrl), msg);
			elseif tContains(MSG_MULTI_LAST,ctrl) then
				AddLastMsgToInputBufferAndRecieve(sender,GetIndexOf(MSG_MULTI_LAST,ctrl), msg);
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



