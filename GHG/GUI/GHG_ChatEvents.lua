--===================================================
--
--				GHG_ChatEvents
--  			GHG_ChatEvents.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHG_ChatEvents()
	if class then
		return class;
	end
	class = GHClass("GHG_ChatEvents");

	local loc = GHG_Loc();
	local chat = GHG_ChatDisplayer();
	local api = GHG_GroupAPI(UnitGUID("player"));

	local msg = function(event,msgType,text)
		GHI_Event(event,function(e,...)
			chat.PostMsg(msgType,string.format(text,...));
		end);
	end

	local msgType = "GHG_GROUP_ADMIN";
	msg("GHG_INVITE_SEND",msgType,loc.INVITE_SEND);
	msg("GHG_INVITE_RECEIVED",msgType,loc.INVITE_RECEIVED);
	msg("GHG_SEND_INVITE_ACCEPTED",msgType,loc.SEND_INVITE_ACCEPTED);
	msg("GHG_SEND_INVITE_DECLINED",msgType,loc.SEND_INVITE_DECLINED);
	msg("GHG_PLAYER_JOINED",msgType,loc.PLAYER_JOINED);
	msg("GHG_PLAYER_LEFT",msgType,loc.PLAYER_LEFT);
	msg("GHG_PLAYER_PROMOTED",msgType,loc.PLAYER_PROMOTED);
	msg("GHG_PLAYER_DEMOTED",msgType,loc.PLAYER_DEMOTED);

	local msgType = "GHG_GROUP_TOASTS";
	msg("GHG_PLAYER_ONLINE",msgType,ERR_FRIEND_ONLINE_SS);
	msg("GHG_PLAYER_OFFLINE",msgType,ERR_FRIEND_OFFLINE_S);
	msg("GHG_PLAYER_REMOVED",msgType,loc.PLAYER_REMOVED);

	msg("GHG_DEBUG","GHG_DEBUG","%s");


	-- chats
	local chats = {}

	local UpdateChats = function()
		ChatMenu_OnLoad(ChatMenu);
		for guid,v in pairs(chats) do
			local f = function(self)
				ChatMenu_SetChatType(self:GetParent().chatFrame, guid);
			end
			UIMenu_AddButton(ChatMenu, v.name,"/"..v.chatSlashCmds[1]:lower(), f);
		end
		UIMenu_AutoSize(ChatMenu);
	end

	local f = function(e,guid)
		local groupIndex = api.GetIndexOfGroupByGuid(guid);
		if groupIndex then
			local name,header,defaultColor,chatSlashCmds = api.GetGroupChatInfo(groupIndex);
			if not(type(name)=="string" and type(header)=="string" and type(defaultColor)=="table" and type(chatSlashCmds)=="table") then
				return
			end
			chat.DefineChatType(guid,header,defaultColor,name,chatSlashCmds);

			local orig = SendChatMessage;
			SendChatMessage = function(text,chatType,...)
				if chatType == guid then
					api.SendChatMessage(groupIndex,text);
				else
					orig(text,chatType,...);
				end
			end
			chats[guid] = {
				name = name,
				chatSlashCmds = chatSlashCmds,
			}
			UpdateChats();
		end
	end
	GHI_Event("GHG_GROUP_LOADED",f);
	GHI_Event("GHG_GROUP_UPDATED",f);
	GHI_Event("GHG_CHAT_MSG",function(e,groupGuid,sender,senderGuid,text,chatFlag)
		chat.Msg(groupGuid,text,sender,senderGuid,chatFlag)
	end);


	chat.PostMsg("GHG_GROUP_ADMIN",loc.GHG_LOADED);

	return class;
end


GHI_Event("ADDON_LOADED",function(e,add)
	if add == "GHG" then
		GHG_ChatEvents();
	end
end)

-- /script MyAddOn_Msg("MYADDONMSG","testing")

-- /dump _G["CHAT_MYADDONMSG_GET"]