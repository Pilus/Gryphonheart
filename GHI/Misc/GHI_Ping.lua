--
--
--					GHI Ping
--					GHI_Ping.lua
--
--			Manual ping to other clients
--	
-- 			(c)2013 The Gryphonheart Team
--				All rights reserved
--

local class;
function GHI_Ping()
	if class then
		return class;
	end
	class = GHClass("GHI_Ping");
	local misc = GHI_MiscAPI().GetAPI();

	local PING = "Ping";
	local PING_REPLY = "PingReply";
	local CapitalizeFirstLetterOfString;

	local pingedPlayer = {};
	local comm = GHI_Comm();
	local pingCallbackFuncs = {};

	local loc = GHI_Loc()

	CapitalizeFirstLetterOfString = function(str)
		return strupper(strsub(str, 0, 1)) .. strlower(strsub(str, 2));
	end

	local RecievePing = function(sender, version, ...)
		if pingedPlayer[Ambiguate(sender:lower(), "none")] then
			GHI_Message(loc.PING_REPLY .. (sender or "nil"));
			GHI_Message(loc.VERSION .. (version or "nil"));
			pingedPlayer[Ambiguate(sender:lower(), "none")] = nil;
		end

		for _, func in pairs(pingCallbackFuncs) do
			func(sender, version);
		end
	end

	local AnswerPing = function(sender, ...)
		local playerGhiVersion = GetAddOnMetadata("GHI", "Version");
		comm.Send("ALERT", sender, PING_REPLY, playerGhiVersion);
	end

	class.SendPing = function(player, silent)
		if not (strlen(player) > 0) then
			return;
		end

		comm.Send("ALERT", player, PING);

		if not (silent) then
			pingedPlayer[Ambiguate(player:lower(), "none")] = true;
		end
	end

	class.RegisterRecievePingFunc = function(func)
		assert(type(func) == "function");
		table.insert(pingCallbackFuncs, func);
	end

	comm.AddRecieveFunc(PING, AnswerPing)
	comm.AddRecieveFunc(PING_REPLY, RecievePing);
	return class;
end


