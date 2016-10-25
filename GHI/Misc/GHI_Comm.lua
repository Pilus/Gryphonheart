--
--
--					GHI Communication
--						GHI_Comm.lua
--
--		Handler of all communication between clients
--	
-- 				(c)2013 The Gryphonheart Team
--					All rights reserved
--	

local libComm = LibStub("AceComm-3.0");
local libCommOld = LibStub("AceComm-3.0");
local libSerial = LibStub("AceSerializer-3.0");
local libCompress = LibStub("LibCompress")
local libEncode = libCompress:GetAddonEncodeTable()
local addOnPrefix = "GHI2";
local oldAddOnPrefix = "GHI";
local FILTER_ADDONS_MSGS = true;

local class;
function GHI_Comm()

	if class then
		return class;
	end
	class = GHClass("GHI_Comm","frame");

	local versionInfo;

	local channelName = "xtensionxtooltip2";
	local recieveFuncs = {};
	local playersCommunicatedWith = {};
	local registeredFrames, OnEvent, ParseEventToFrames;
	local log = GHI_Log();

	local sendNew, sendOld, recieveNew, recieveOld, ConvertArgumentsNewToOld, ConvertArgumentsOldToNew, UpdateProtocolVersionFromAddOnInfo;
	local playerAddOnProtocolVersion = {};
	local NEW_PROTOCOL = 2;
	local OLD_PROTOCOL = 1;
	local WRATH_PROTOCOL = 0; --v.1.3 change

	local channelComm;
	local _,_,_,tocNum = GetBuildInfo();
	if tocNum >= 30000 and tocNum < 40000 then
		channelComm = GHI_ChannelComm();
	end
	local CTL = ChatThrottleLib;
	local setUp = false;

	local chatIsReady = false;


	local ChatReady = function()
		chatIsReady = true;
		if not(GHI_MiscData["no_channel_comm"]) then
			chatIsReady = true;
			log.Add(2,"Communication channel ready");
		else
			log.Add(2,"Communication channel not joined due to option setting");
		end
	end
	
	-- Register special recieve func

	-- see http://www.wowace.com/addons/libcompress/#c1
	class.AddRecieveFunc = function(_prefix, _recieveFunc)
		recieveFuncs[_prefix] = _recieveFunc;
		if channelComm then
			channelComm.AddRecieveFunc(_prefix, _recieveFunc);
		end
	end

	-- SendAddonMessage
	class.Send = function(prio, target, prefix, ...)
		assert(not (target == "WHISPER"), "Non updated sending of info");
		GHCheck("GHI_Comm.Send", { "StringNil", "String", "String" }, { prio, target, prefix })

		if not(prefix == "ReqAddOns" or prefix == "AddOns" or prefix == "DummyMsg") or not(FILTER_ADDONS_MSGS) then
			log.Add(3, "Send " .. prefix .. " to " .. target, { ... });
		end

		-- dont send to GMs
		if GMChatFrame_IsGM then return end;

		playerAddOnProtocolVersion[target] = UpdateProtocolVersionFromAddOnInfo(target) or playerAddOnProtocolVersion[target];

		if playerAddOnProtocolVersion[target] then
			if playerAddOnProtocolVersion[target] == NEW_PROTOCOL then
				sendNew(prio, target, prefix, ...);
			elseif playerAddOnProtocolVersion[target] == OLD_PROTOCOL or playerAddOnProtocolVersion[target] == WRATH_PROTOCOL then
				sendOld(prio, target, prefix, ...);
			else
				error("Unhandled protocol of target")
			end
		else
			if string.startsWith(prefix,"GH_") then
				sendNew(prio, target, prefix, ...);
			else
				sendNew(prio, target, prefix, ...);
				sendOld(prio, target, prefix, ...);
			end
		end
	end

	class.SendToChannel = function(prio, prefix, ...)
		GHCheck("GHI_Comm.SendToChannel", { "StringNil", "String" }, { prio, prefix })

		if not(channelComm) then
			sendNew(prio, nil, prefix, ...);
		else
			channelComm.Send(prio, prefix);
		end
	end

	UpdateProtocolVersionFromAddOnInfo = function(player)
		if versionInfo.PlayerGotAddOn(player, "GHI", "1.0.4") then
			return NEW_PROTOCOL;
		elseif versionInfo.PlayerGotAddOn(player, "GHI", "0.99.1") then
			return OLD_PROTOCOL;
		end
	end

	local mem;
	local resetMem = function()
		UpdateAddOnMemoryUsage()
		mem = GetAddOnMemoryUsage("GHI");
	end
	local printMem = function(s)
		UpdateAddOnMemoryUsage()
		local newMem = GetAddOnMemoryUsage("GHI");
		local memoryDiff = newMem - mem;
		print(memoryDiff,"comm",s)
		mem = newMem;
	end

	local cache = {};
	local cachePointer = 1;

	sendNew = function(prio, target, prefix, ...)
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

		local channel = "WHISPER";
		if not(target) then
			channel = "CHANNEL";
			target = tostring(GetChannelName(channelName));
		end

		local finalMsg = libEncode:Encode(b);
		libComm:SendCommMessage(addOnPrefix, finalMsg, channel, target, prio)

		playersCommunicatedWith[target] = true;
	end

	sendOld = function(prio, target, prefix, ...)

		local data = { ConvertArgumentsNewToOld(target, prefix, ...) };
		if #(data) > 0 then
			for _, set in pairs(data) do
				if #(set) > 0 then
					libCommOld:SendCommMessage(oldAddOnPrefix, libSerial:Serialize(set), "WHISPER", target, prio);
				end
			end
		end
		playersCommunicatedWith[target] = true;
	end


	recieveNew = function(prefix, data, channel, sender)
		playerAddOnProtocolVersion[sender] = NEW_PROTOCOL;

		local one = libEncode:Decode(data)

		--Decompress the decoded data
		local message = libCompress:Decompress(one)
		if (not message) then
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
		if not(prefix == "ReqAddOns" or prefix == "AddOns" or prefix == "DummyMsg")  or not(FILTER_ADDONS_MSGS)  then
			log.Add(3, "Recieved " .. prefix .. " from " .. sender .. " (new protocol)", data);
		end

		if recieveFuncs[prefix] then
			recieveFuncs[prefix](sender, unpack(data));
		end
	end

	recieveOld = function(addonPrefix, data, channel, sender, ...)
		if playerAddOnProtocolVersion[sender] then
			if playerAddOnProtocolVersion[sender] == NEW_PROTOCOL then
				return;
			end
		elseif not (playerAddOnProtocolVersion[sender] == WRATH_PROTOCOL) then
			playerAddOnProtocolVersion[sender] = OLD_PROTOCOL;
		end

		local success, data = libSerial:Deserialize(data);
		local convertedData = { ConvertArgumentsOldToNew(sender, unpack(data)) };
		local prefix = table.remove(convertedData, 1);

		if not(prefix == "ReqAddOns" or prefix == "AddOns")  or not(FILTER_ADDONS_MSGS) then
			log.Add(3, "Recieved " .. prefix .. " from " .. sender .. " (old protocol)", convertedData);
		end

		if prefix and recieveFuncs[prefix] then
			recieveFuncs[prefix](sender, unpack(convertedData));
		end
	end

	local ConvertBuffInfoNewToOld = function(info)
		local info2 = {};
		for i, v in pairs(info) do
			if type(v) == "table" then
				local t = {};
				t.name = v.name;
				t.amount = v.count;
				t.timeCasted = v.expirationTime - v.totalDuration;
				if v.totalDuration == 0 then
					t.untilCancelled = 1;
				end
				t.lastUpdated = time();
				t.texture = v.icon;
				t.text = v.description;
				t.debuffType = v.debuffType;
				t.duration = v.totalDuration;
				info2[i] = t;
			end
		end
		return info2;
	end
	local ConvertBuffInfoOldToNew = function(info)
		local info2 = {};
		for i, v in pairs(info) do
			if type(v) == "table" then
				local t = {};
				t.name = v.name;
				t.count = v.amount;
				t.expirationTime = v.timeCasted + v.duration;
				t.totalDuration = v.duration;
				if v.untilCancelled == 1 then
					t.totalDuration = 0;
				end
				t.icon = v.texture;
				t.description = v.text;
				t.debuffType = v.debuffType;
				t.refID = v.name;
				info2[i] = t;
			end
		end
		return info2;
	end

	ConvertArgumentsNewToOld = function(target, prefix, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, ...)
		if prefix == "Ping" then
			return { true, "AddonVersionReq" };
		elseif prefix == "PingReply" then
			return { true, "AddonVersionAnswer", arg1 };
		elseif prefix == "ReqAddOns" then
			return { false, prefix }, { true, "AddonVersionReq" };
		elseif prefix == "AddOns" then
			return { false, prefix, arg1, arg2 };
		elseif prefix == "SuspectedLinkName" then
			local t = {};
			for _, msg in pairs(arg2) do
				table.insert(t, { false, prefix, msg });
			end
			return unpack(t);
		elseif prefix == "ItemVersion" then
			return { false, prefix, arg1, arg2 };
		elseif prefix == "ItemDataRequest" then
			return { false, prefix, arg1, arg2 };
		elseif prefix == "ItemData" then
			return { false, prefix, arg1, arg2 };
		elseif prefix == "LinkConfirm" then
			return {};
		elseif prefix == "TradeItem" then
			if arg7 then
				return { false, "TradeDuration", arg1, arg7[1], arg7[2], arg7[3] }, { true, "Trade<" .. arg1, arg2 .. "-" .. arg3 }, { false, "ItemVersion", arg2, 1 };
			else
				return { true, "Trade<" .. arg1, arg2 .. "-" .. arg3 }, { false, "ItemVersion", arg2, 1 };
			end
		elseif prefix == "RemoveTradeItem" then
			return { true, "Trade<" .. arg1, 0 };
		elseif prefix == "TradeAccepted" then
			return { false, "TradeAccepted" };
		elseif prefix == "ItemActionVersion" then
			return { false, "ItemDataVersions", arg1, 0, arg2 };
		elseif prefix == "ItemActionData" then
			return { false, "ItemRCData", arg1, arg2 };
		elseif prefix == "ExpectItemActionData" then
			return { false, "ExpectRCDataTime", arg1, arg2 }, { false, "EndRCData", arg1 };
		elseif prefix == "BuffSubscribe" then
			return { false, "BuffSubscribe", arg1 }, { true, "RequestBuffs", -2 }, { true, "RequestBuffs", -2 };
		elseif prefix == "BuffInfo" then
			if playerAddOnProtocolVersion[target] == WRATH_PROTOCOL then
				return { false, "BuffInfo", ConvertBuffInfoNewToOld(arg2) }, { false, "DebuffInfo", ConvertBuffInfoNewToOld(arg3) };
			else
				return { false, "BuffInfo", arg1, arg2, arg3 };
			end
		elseif prefix == "ApplyBuff" then
			local click = arg1;
			return { false, "ApplyBuff", click.buffName, click.buffDetails, click.buffIcon, click.untilCanceled, click.filter, click.buffType, click.buffDuration, click.cancelable, click.stackable, click.count or 1, click.delay or 0 };
		elseif prefix == "DummyMsg" then
			return {};
		else
			log.Add(2, "Could not convert new comm argument to old " .. (prefix or "nil"), { arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, ... })
		end
		return {};
	end

	local inputBuffer = {};
	ConvertArgumentsOldToNew = function(sender, isAncientSyntax, prefix, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, ...)
		if prefix == "AddonVersionReq" then
			return "Ping";
		elseif prefix == "AddonVersionAnswer" then
			recieveFuncs["AddOns"](sender, { { short = "GHI", title = "Gryphonheart Items", version = arg1 } });
			return "PingReply", arg1;
		elseif prefix == "ReqAddOns" then
			return prefix;
		elseif prefix == "AddOns" then
			return prefix, arg1, arg2;
		elseif prefix == "SuspectedLinkName" then
			return prefix, "any", { arg1 };
		elseif prefix == "ItemVersion" then
			return prefix, arg1, arg2;
		elseif prefix == "ItemDataRequest" then
			return prefix, arg1, arg2;
		elseif prefix == "ItemData" then
			return prefix, arg1, arg2, ...;
		elseif strsub(prefix, 0, 6) == "Trade<" then
			local slot = tonumber(strsub(prefix, 7, 7));
			if arg1 == 0 then
				return "RemoveTradeItem", slot;
			end
			local id, amount = strsplit("-", arg1);
			local duration = inputBuffer["trade" .. slot .. "duration"] or {};
			local name, icon = GHI_GetItemInfo(id);
			return "TradeItem", slot, id, tonumber(amount), name, icon, 3, duration, nil;
		elseif prefix == "TradeDuration" then
			local slot = arg1;
			inputBuffer["trade" .. slot .. "duration"] = { arg2, arg3, arg4 };
			return nil;
		elseif prefix == "TradeAccepted" then
			return "TradeAccepted";
		elseif prefix == "ItemDataVersions" then
			return "ItemActionVersion", arg1, arg3;
		elseif prefix == "ItemRCData" then
			return "ItemActionData", arg1, arg2;
		elseif prefix == "ExpectRCDataTime" then
			return "ExpectItemActionData", arg1, arg2;
		elseif prefix == "BuffSubscribe" then
			return "BuffSubscribe", arg1;
		elseif prefix == "BuffInfo" then
			if type(arg1) == "number" then
				return "BuffInfo", arg1, arg2, arg3;
			elseif UnitName("target") == sender and type(arg1) == "table" then
				return "BuffInfo", GHUnitGUID("target"), ConvertBuffInfoOldToNew(arg1);
			end
			return "";
		elseif prefix == "DebuffInfo" then
			if UnitName("target") == sender and type(arg1) == "table" then
				return "BuffInfo", GHUnitGUID("target"), false, ConvertBuffInfoOldToNew(arg1);
			end
			return "";
		elseif prefix == "ApplyBuff" then
			return "ApplyBuff", { buffName = arg1, buffDetails = arg2, buffIcon = arg3, untilCanceled = arg4, filter = arg5, buffType = arg6, buffDuration = arg7, cancelable = arg8, stackable = arg9, count = arg10, delay = arg11 };
		elseif prefix == "RequestBuffs" then --v.1.3 change
			if arg1 == -2 then return ""; end
			playerAddOnProtocolVersion[sender] = WRATH_PROTOCOL;
			return "BuffSubscribe", 10, true;
		else
			log.Add(2, "Could not convert old comm argument to new " .. (prefix or "nil"), { arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, ... })
		end
		return "";
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

			log.Add(3, "CHAT_MSG_SYSTEM not blocked", { msg, ... });
		end
	end);
	
	local JoinChannel = function()
		JoinChannelByName(channelName);
		local i = 1;
		while _G["ChatWindow" .. i] do
			ChatFrame_RemoveChannel(_G["ChatWindow" .. i], channelName);
		end
		log.Add(2, "Joined communication channel");
	end
	
	GHI_Timer(function()
		if not(chatIsReady) and not(GHI_MiscData["no_channel_comm"]) then
			local channelNum = GetChannelName(channelName);
			CTL:SendChatMessage("ALERT", addOnPrefix,addOnPrefix .. "ChannelReadyCheck", "CHANNEL", nil, channelNum);
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
		if event == "CHAT_MSG_CHANNEL" and channelNumber == GetChannelName(channelName) and strsub(msg, 0, addOnPrefix:len()) == addOnPrefix then
			
			if not(chatIsReady) then
				ChatReady();
			end
			if msg == addOnPrefix .."ChannelReadyCheck" then
				return
			end
		end	
		if setUp == false and not(GHI_MiscData["no_channel_comm"]) then
			setUp = true;
			JoinChannel()
		end
	end);
	class:RegisterEvent("CHAT_MSG_CHANNEL");
	class:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE");
    GHI_Event("PLAYER_ENTERING_WORLD",function() GHI_Timer(function() class:GetScript("OnEvent")(class,"CHAT_MSG_CHANNEL_NOTICE") end,30,true); end)


	libComm:RegisterComm(addOnPrefix, recieveNew);
	libCommOld:RegisterComm(oldAddOnPrefix, recieveOld);

	versionInfo = GHI_VersionInfo();

	return class;
end

 