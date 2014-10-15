--===================================================
--
--				GHG_GroupChat
--  			GHG_GroupChat.lua
--
--	          (description)
--
-- 	 chatinfo (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHG_GroupChat(groupGuid,keys)
	local class = GHClass("GHG_GroupChat");

	local crypt = GHI_Crypt(keys[1],keys[2]);
	local channelComm = GHI_ChannelComm();
	local event = GHI_Event();
	local active = false;

	class.SendChatMessage = function(text)
		local chatFlag = "";
		if UnitIsAFK("player") then
			chatFlag = "AFK";
		end

		if UnitIsDND("player") then
			chatFlag = "DND";
		end

		local swap = crypt.Swap(text);
		local cryptText = crypt.Encrypt(swap);

		channelComm.Send("ALERT","GHG_Chat_"..groupGuid,GHUnitGUID("player"),cryptText,chatFlag)
	end

	class.Activate = function()
		active = true;
	end

	class.Deactivate = function()
		active = false;
	end

	channelComm.AddRecieveFunc("GHG_Chat_"..groupGuid,function(sender,senderGuid,cryptText,chatFlag)
		if active then
			local decryptedText = crypt.Decrypt(cryptText);
			local text = crypt.Deswap(decryptedText);
			event.TriggerEvent("GHG_CHAT_MSG",groupGuid,sender,senderGuid,text,chatFlag);
		end
	end)

	return class;
end

