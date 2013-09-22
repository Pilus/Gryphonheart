--===================================================
--
--				GHP_ActivePlayers
--  			GHP_ActivePlayers.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHP_ActivePlayers()
	if class then
		return class;
	end
	class = GHClass("GHP_ActivePlayers");

	local players = {
		[1] = {},
	};

	GHI_Timer(function()

		for i=6,2,-1 do
			players[i] = players[i-1];
		end
		players[1] = {};
	end,60)


	local eventFunc = function(event,arg1,name)
		for _,v in pairs(players) do
			v[name] = nil;
		end
		players[1][name] = true;
	end
	GHI_Event("CHAT_MSG_EMOTE",eventFunc);
	GHI_Event("CHAT_MSG_YELL",eventFunc);
	GHI_Event("CHAT_MSG_SAY",eventFunc);
	GHI_Event("CHAT_MSG_TEXT_EMOTE",eventFunc);

	class.GetNearbyActivePlayers = function()
   		local t = {}
   		for _,ps in pairs(players) do
			for name,_ in pairs(ps) do
				table.insert(t,name);
			end
		end
		return t;
	end

	return class;
end

