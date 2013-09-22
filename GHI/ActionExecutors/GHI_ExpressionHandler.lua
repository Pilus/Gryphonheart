--===================================================
--								GHI Expression Handler
--									ghi_expressionHandler.lua
--
--		Application Interface for scripts to execute functions relevant for actions
--	
-- 						(c)2013 The Gryphonheart Team
--								All rights reserved
--===================================================	

local ALLOWED_POSTS_PR_MIN = 20;

local class;
function GHI_ExpressionHandler()
	if class then
		return class;
	end
	class = GHClass("GHI_ExpressionHandler");
	local IsCommandAStdEmote, spamCounter;
	local delayedMessages = {};
	local miscAPI = GHI_MiscAPI().GetAPI();
	local loc = GHI_Loc()
	spamCounter = 0;
	local lastDisallowedMessage = 0;

	GHI_Timer(function()
		for i, v in pairs(delayedMessages) do
			if type(v) == "table" and (v.time or 0) <= time() then
				class.SendChatMessage(v.text, v.chatType, v.language, v.channel, 0, v.guid, v.spamLimitApplied);
				delayedMessages[i] = nil;
			end
		end
	end, 1);

	GHI_Timer(function()
		spamCounter = max(0, spamCounter - 1);
	end, 60 / ALLOWED_POSTS_PR_MIN);

	class.SendChatMessage = function(text, chatType, language, channel, waitTime, guid, applySpamLimit)
		if not (chatType) then
			chatType = "SAY"
		end
		if type(waitTime) == "number" and waitTime > 0 then
			table.insert(delayedMessages, {
				text = text,
				chatType = chatType,
				language = language,
				channel = channel,
				time = time() + waitTime,
				guid = guid,
				spamLimitApplied = applySpamLimit
			});
			return;
		end

		local playChatMessage = GHI_MiscData.chatMsgPermission or 1;
		if (playChatMessage == 3) then
			if (lastDisallowedMessage <= time() - 300) then
				GHI_Message(loc.ERR_MSG_BLOCK);
				lastDisallowedMessage = time();
			end
			return;
		elseif playChatMessage == 2 then
			local confirm = GHI_ChatConfirm()
			confirm.QueueMessage(text, chatType, language, channel);
			return;
		end

		if applySpamLimit and spamCounter == ALLOWED_POSTS_PR_MIN then
			GHI_Message(loc.ERR_SPAM_BLOCK);
			return;
		elseif applySpamLimit and spamCounter > ALLOWED_POSTS_PR_MIN then
			return;
		else
			spamCounter = spamCounter + 1;
		end
		class.ExecuteSendMessage(text, chatType, language, channel, guid);
	end

	class.ExecuteSendMessage = function(text, chatType, language, channel, guid)

		if chatType:lower() == "emote" then
			local isStdEmote, stdEmoteIndex = IsCommandAStdEmote(text);
			if isStdEmote then
				local d = _G["EMOTE" .. stdEmoteIndex .. "_TOKEN"];
				DoEmote(d,channel);
				return
			end
		end

		if guid then
			text = class.InsertLinksInText(text, guid);
		end

		SendChatMessage(text, chatType, language, channel);

	end

	IsCommandAStdEmote = function(command)
		if not (type(command) == "string") then return false end
		if command == "" then return false end;

		local i = 1;
		for i = 1, 600 do
			local j = 1;

			local cmdString = _G["EMOTE" .. i .. "_CMD" .. j];
			while (cmdString) do

				if cmdString == "/" .. command then
					return true, i;
				end

				j = j + 1;
				cmdString = _G["EMOTE" .. i .. "_CMD" .. j];
			end
		end
		return false, 0;
	end

	class.InsertLinksInText = function(text, guid)
		if guid then
			local link = miscAPI.GHI_GenerateLink(guid);
			return gsub(text,"%%[Ll]",link);
		end

	end

	return class;
end
