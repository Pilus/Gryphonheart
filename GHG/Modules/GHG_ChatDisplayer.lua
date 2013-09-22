--===================================================
--
--				GHG_ChatDisplayer
--  			GHG_ChatDisplayer.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local DEFAULT = {
	GHG_GROUP_ADMIN = {r=1.0,g=1,0,b=0.0,chat1 = true, },
	GHG_GROUP_TOASTS = {r=1.0,g=1,0,b=0.0,chat1 = true, },
	GHG_DEBUG = {r=1,g=1,b=1},
}

local class;
function GHG_ChatDisplayer()
	if class then
		return class;
	end
	class = GHClass("GHG_ChatDisplayer");

	local chatConfig = GHG_ChatConfig();
	local loc = GHG_Loc();

	GHG_MiscData = GHG_MiscData or {};
	GHG_MiscData.Chat = GHG_MiscData.Chat or {};

	local function FireChatEvent(evt,...)

		local bIsChat = (strsub(evt, 1,9)=="CHAT_MSG_");
		local chattype = strsub(evt, 10); -- might just be garbage if bIsChat==false, but in that case we don't use it


		for i=1,NUM_CHAT_WINDOWS do
			if(not bIsChat or GHG_MiscData.Chat[chattype]["chat"..i]) then
				local this = getglobal("ChatFrame"..i);
				ChatFrame_OnEvent(this,evt,...);
			end
		end
	end

	local ORIG_GetChatWindowMessages = GetChatWindowMessages;
	function GetChatWindowMessages(n)
		ret = { ORIG_GetChatWindowMessages(n) };
		for chattype,settings in pairs(GHG_MiscData.Chat) do
			if(settings[n]) then
				tinsert(ret, chattype);
			end
		end
		return unpack(ret);
	end


	local ORIG_AddChatWindowMessages = AddChatWindowMessages;
	function AddChatWindowMessages(n, chattype)
		if(GHG_MiscData.Chat[chattype]) then
			GHG_MiscData.Chat[chattype][n]=true;
		else
			ORIG_AddChatWindowMessages(n,chattype);
		end
	end


	local ORIG_RemoveChatWindowMessages = RemoveChatWindowMessages;
	function RemoveChatWindowMessages(n, chattype)
		if(GHG_MiscData.Chat[chattype]) then
			GHG_MiscData.Chat[chattype][n]=false;
		else
			ORIG_RemoveChatWindowMessages(n,chattype);
		end
	end


	local ORIG_ChangeChatColor = ChangeChatColor;
	function ChangeChatColor(chattype, r,g,b)
		if(GHG_MiscData.Chat[chattype]) then
			GHG_MiscData.Chat[chattype].r=r;
			GHG_MiscData.Chat[chattype].g=g;
			GHG_MiscData.Chat[chattype].b=b;
			FireChatEvent("UPDATE_CHAT_COLOR", chattype, r,g,b);
		else
			ORIG_ChangeChatColor(chattype,r,g,b);
		end
	end

	GHI_Event("VARIABLES_LOADED",function()
		if(not GHG_MiscData) then GHG_MiscData = {}; end
		if(not GHG_MiscData.Chat) then
			GHG_MiscData.Chat={}
		end
		if(not GHG_MiscData.Msg) then
			GHG_MiscData.Msg={}
		end




		for chattype,info in pairs(GHG_MiscData.Chat) do
			ChatTypeGroup[chattype] = {
				"CHAT_MSG_"..chattype
			};

			ChatTypeInfo[chattype] = info;
		end

		local allKeys = {}
		for i,_ in pairs(GHG_MiscData.Msg) do allKeys[i] = true; end
		for i,_ in pairs(DEFAULT) do allKeys[i] = true; end

		for msgType,_ in pairs(allKeys) do

			GHG_MiscData.Msg[msgType] = GHG_MiscData.Msg[msgType] or DEFAULT[msgType];

			chatConfig.AddChatType("general",msgType,loc[msgType],nil,
			function()
				local t = GHG_MiscData.Msg[msgType];
				return t.r,t.g,t.b;
			end,function(r,g,b)
				GHG_MiscData.Msg[msgType].r = r;
				GHG_MiscData.Msg[msgType].g = g;
				GHG_MiscData.Msg[msgType].b = b;
			end,function(id)
				return GHG_MiscData.Msg[msgType]["chat"..id];
			end,function(id,shown)
				GHG_MiscData.Msg[msgType]["chat"..id] = shown and true;
			end);
		end

	end);

	class.PostMsg = function(msgType,msg)
		local t = {};
		if (GHG_MiscData and  GHG_MiscData.Msg) then
			t = GHG_MiscData.Msg[msgType] or DEFAULT[msgType];
		else
			t = DEFAULT[msgType];
		end
		assert( t,string.format("Message type not defined: %s",msgType))

		for i=1,NUM_CHAT_WINDOWS do
			if(t["chat"..i]) then
				local this = getglobal("ChatFrame"..i);
				this:AddMessage(msg,t.r,t.g,t.b);
			end
		end
	end

	local defined = {};

	class.DefineChatType = function(chatType,header,defaultColor,name,chatSlashCmds)
		local completeHeader = "["..header.."] %s: ";

		_G["CHAT_MSG_"..chatType] = "Where is this?"
		_G["CHAT_"..chatType.."_GET"] = completeHeader;
		ChatTypeGroup[chatType] = {	"CHAT_MSG_"..chatType };
		_G["CHAT_"..chatType.."_SEND"] = header..": ";
		ChatTypeInfo[chatType] = { sticky = 1, flashTab = false, flashTabOnGeneral = false };

		if not(GHG_MiscData.Chat[chatType]) then
			GHG_MiscData.Chat[chatType] = { chat1=true; r=defaultColor.r; g=defaultColor.g; b=defaultColor.b; default=true;};
		elseif GHG_MiscData.Chat[chatType].default == true then
			GHG_MiscData.Chat[chatType].r=defaultColor.r;
			GHG_MiscData.Chat[chatType].g=defaultColor.g;
			GHG_MiscData.Chat[chatType].b=defaultColor.b;
		end
		for i,v in pairs(chatSlashCmds) do
			_G["SLASH_"..chatType..i] = "/"..v;
		end

		ChatTypeInfo[chatType] = GHG_MiscData.Chat[chatType];
		ChatTypeInfo[chatType].sticky = 1;
		ChatTypeInfo[chatType].flashTab = false;
		ChatTypeInfo[chatType].flashTabOnGeneral = false;

		if not(defined[chatType]) then
			chatConfig.AddChatType("group",chatType,name,nil,function()
				local t = GHG_MiscData.Chat[chatType]
				return t.r,t.g,t.b;
			end,function(r,g,b)
				GHG_MiscData.Chat[chatType].r = r;
				GHG_MiscData.Chat[chatType].g = g;
				GHG_MiscData.Chat[chatType].b = b;
				ChatTypeInfo[chatType] = GHG_MiscData.Chat[chatType];
			end,function(id)
				return GHG_MiscData.Chat[chatType]["chat"..id];
			end,function(id,shown)
				GHG_MiscData.Chat[chatType]["chat"..id] = shown and true;
			end);
		end
		defined[chatType] = true;
	end

	class.Msg = function(chattype, txt,senderName,senderGuid,chatFlag)
		assert(GHG_MiscData.Chat[chattype],"Chat type not defined");
		local language = "";
		FireChatEvent("CHAT_MSG_"..chattype,
			txt,senderName,language,"",senderName,
			chatFlag,0,0,"",0,
			0,senderGuid,0,false,false
		);
	end

	return class;
end

