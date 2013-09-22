--===================================================
--									
--										GHI Links
--									ghi_linksUI.lua
--
--				Dynamic handler of links in chat
--	
-- 						(c)2013 The Gryphonheart Team
--								All rights reserved
--===================================================	


function GHI_LinksUI(prefix, syncDataFunc, linkClickFunc)
	local class = GHClass("GHI_LinksUI");
	local handler = GHI_LinksUIHandler();

	--Class functions
	class.GenerateLink = function(...)
		return handler.GenerateLink(prefix, ...);
	end

	class.TriggerRecieveLink = function(sender, name, ID, color)
		handler.TriggerRecieveLink(sender, name, prefix, ID, color)
	end

	handler.RegisterSyncDataFunc(prefix, syncDataFunc);
	handler.RegisterLinkClickFunc(prefix, linkClickFunc);

	return class;
end

local class;
function GHI_LinksUIHandler()
	if class then
		return class;
	end
	class = GHClass("GHI_LinksUIHandler","frame");

	--Local variables
	local syncDataFuncs = {};
	local linkClickFuncs = {};
	local sendLinks = {};
	local supportedEvents = { "CHAT_MSG_CHANNEL", "CHAT_MSG_EMOTE", "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_RAID", "CHAT_MSG_SAY", "CHAT_MSG_WHISPER", "CHAT_MSG_YELL", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_RAID_WARNING", "CHAT_MSG_WHISPER_INFORM" };
	local chatTypesForEvents = {
		CHAT_MSG_CHANNEL = "CHANNEL",
		CHAT_MSG_EMOTE = "EMOTE",
		CHAT_MSG_GUILD = "GUILD",
		CHAT_MSG_OFFICER = "OFFICER",
		CHAT_MSG_PARTY = "PARTY",
		CHAT_MSG_PARTY_LEADER = "PARTY",
		CHAT_MSG_RAID = "RAID",
		CHAT_MSG_SAY = "SAY",
		CHAT_MSG_WHISPER = "WHISPER",
		CHAT_MSG_YELL = "YELL",
		CHAT_MSG_RAID_LEADER = "RAID",
		CHAT_MSG_RAID_WARNING = "RAID_WARNING",
		CHAT_MSG_WHISPER_INFORM = "WHISPER",
	};
	local ignoredChannels = { "xtensionxtooltip2" };
	local registeredFrames = {};
	local comm = GHI_Comm();
	local version = GHI_VersionInfo()
	local incommingEvents = {};
	local timer, timer2;
	local playerName = UnitName("player");
	local tooltipLinesSend = {};

	local orig = {};
	local SendChatMessage, GetCleanTextAndLinksFromText, OnEvent, ParseEventToFrames, ConvertEventNameToChatType, SubstractSuspectedLinkNames, SendSuspectedLinkName, StoreEvent;
	local IdentifyAndSendLinkInfo, RecieveLinkConfirm, RecieveLinkDeconfirm, HexColorToColorArray, InsertLinkInStoredEvent, TableContainsValue, RemoveValueFromTable, ParseEventsTimedOut;
	local SetItemRef, IsEventIgnoredChannelEvent, CheckForNewEventFrames, CleanRegexShortcutsFromString, RecieveSuspectedLinkName, ClearRegexControlcharsFromString;

	local MSG_TIMEOUT = 20;

	local log = GHI_Log();

	--Class functions
	class.RegisterSyncDataFunc = function(prefix, func)
		syncDataFuncs[prefix] = func;
	end
	class.RegisterLinkClickFunc = function(prefix, func)
		linkClickFuncs[prefix] = func;
	end
	class.GenerateLink = function(prefix, text, ID, color, tooltipLines)
		GHCheck("GHI_LinksUI.GenerateLink", { "String", "String", "String", "Table", "nilTable" }, { prefix, text, ID, color,tooltipLines })
		local index = #(tooltipLinesSend) + 1;
		tooltipLinesSend[index] = tooltipLines;
		return string.format("|cFF%s%s%s|Hgh_%s:%s:%s:0:0:0:0:0:0|h[%s]|h|r", string.format("%.2x", color.r * 255), string.format("%.2x", color.g * 255), string.format("%.2x", color.b * 255), prefix, ID, index, text);
	end

	class.TriggerRecieveLink = function(sender, name, prefix, ID, color)
		log.Add(3, "Triggering recieving of link from other object", { sender, name, prefix, ID, color.r, color.b, color.g });
		for _, chatType in pairs(chatTypesForEvents) do
			RecieveLinkConfirm(sender, name, prefix, ID, chatType, color)
		end
	end

	SendChatMessage = function(text, chatType, ...)
		local cleanText = GetCleanTextAndLinksFromText(text, chatType);
		return orig.SendChatMessage(cleanText, chatType, ...);
	end

	GetCleanTextAndLinksFromText = function(text, chatType)
		local clean = string.gsub(text, "|cFF(%x%x)(%x%x)(%x%x)|Hgh_(.-):(.-):(.-):0:0:0:0:0:0|h%[(.-)%]|h|r", function(r, g, b, prefix, ID, tooltipLinesIndex, name)
			tooltipLinesIndex = tonumber(tooltipLinesIndex);
			table.insert(sendLinks, 1, {
				prefix = prefix,
				ID = ID,
				name = name,
				color = HexColorToColorArray(r, g, b);
				time = time(),
				chatType = chatType,
				tooltipLinesIndex = tooltipLinesIndex,
			});
			return string.format("[%s]", name);
		end);
		return clean;
	end
	HexColorToColorArray = function(hexR, hexG, hexB)
		return {
			r = tonumber(hexR, 16) / 255,
			g = tonumber(hexG, 16) / 255,
			b = tonumber(hexB, 16) / 255,
		}
	end

	OnEvent = function(self, event, msg, author, ...)

	
	  if version.PlayerGotAddOn(author) then
		if not (IsEventIgnoredChannelEvent(event, ...)) then
			local linksInText = SubstractSuspectedLinkNames(msg);
			if #(linksInText) > 0 then


				if event == "CHAT_MSG_WHISPER_INFORM" then
					StoreEvent(event, msg, author, linksInText, ...);
					--if version.PlayerGotAddOn(author) then
					SendSuspectedLinkName(playerName, linksInText, event);
					--end
				else
					StoreEvent(event, msg, author, linksInText, ...);
					--if version.PlayerGotAddOn(author) then
					SendSuspectedLinkName(author, linksInText, event);
					--end
				end
				return;
			end
		 end
		end
		ParseEventToFrames(event, msg, author, ...)
	  
	end

	IsEventIgnoredChannelEvent = function(event, ...)
		if not (event == "CHAT_MSG_CHANNEL") then
			return;
		end
		local eventChannelName = string.lower(({ ... })[7] or "");
		for _, ignoredChannelName in pairs(ignoredChannels) do
			if eventChannelName == ignoredChannelName then
				return true;
			end
		end
		return;
	end

	ParseEventToFrames = function(event, ...)
		for _, frame in pairs(registeredFrames[event]) do
			if not (frame:IsEventRegistered(event)) then
				local s = frame:GetScript("OnEvent");
				if s then
					s(frame, event, ...);
				end
			end
		end
	end
	_G["ParseEventToFrames"] = ParseEventToFrames;
	
	SubstractSuspectedLinkNames = function(text)
		local links = {};
		--if string.find(text,"(.-)(|[cC][0-9a-fA-F]+|H[%a%A]-|h|r)") == nil or string.find(text,"MogIt") == nil then
          --if string.find(text .. " ", "%[(.-)%][^|]") then
               --print("yay link")
		string.gsub(text .. " ", "%[(.-)%][^|]", function(link)
		    
			table.insert(links, link);
		end);
         -- end
		--end
		return links;
	end

	StoreEvent = function(event, msg, author, linkNames, ...)
		table.insert(incommingEvents, {
			event = event,
			msg = msg,
			author = author,
			linkNames = linkNames,
			time = time(),
			args = { ... },
		});
	end

	SendSuspectedLinkName = function(author, linkNames, event)
		assert(type(linkNames) == "table", "");
		local chatType = ConvertEventNameToChatType(event);
	  
		log.Add(3, "Sending suspected link name", { author, linkNames, event });
		comm.Send("ALERT", author, "SuspectedLinkName", chatType, linkNames);
	end

	ConvertEventNameToChatType = function(event)
		return chatTypesForEvents[event] or "";
	end

	RecieveSuspectedLinkName = function(sender, chatType, linkNames)
		for _, linkName in pairs(linkNames) do
			IdentifyAndSendLinkInfo(sender, chatType, linkName);
		end
	end

	IdentifyAndSendLinkInfo = function(sender, chatType, linkName)
		for _, link in pairs(sendLinks) do
			if time() - link.time > 5 * 60 then
				break;
			end
			if link.name == linkName and (link.chatType == chatType or chatType == "any") then
				comm.Send("ALERT", sender, "LinkConfirm", link.name, link.prefix, link.ID, link.chatType, link.color, tooltipLinesSend[link.tooltipLinesIndex]);
				if syncDataFuncs[link.prefix] then
					syncDataFuncs[link.prefix](sender, link.ID);
				end
				return
			end
		end
		comm.Send("ALERT", sender, "LinkDeconfirm", linkName, chatType);
	end

	RecieveLinkConfirm = function(sender, name, prefix, ID, chatType, color, tooltipLines)
		local link = class.GenerateLink(prefix, name, ID, color, tooltipLines);
		InsertLinkInStoredEvent(sender, chatType, name, link);
	end

	RecieveLinkDeconfirm = function(sender, name, chatType)
		InsertLinkInStoredEvent(sender, chatType, name, "[" .. name .. "]");
	end

	ClearRegexControlcharsFromString = function(str)
		str = gsub(str, "%%", "%%%%");
		str = gsub(str, "%^", "%%%^");
		str = gsub(str, "%$", "%%%$");
		str = gsub(str, "%(", "%%%(");
		str = gsub(str, "%)", "%%%)");
		str = gsub(str, "%.", "%%%.");
		str = gsub(str, "%[", "%%%[");
		str = gsub(str, "%]", "%%%]");
		str = gsub(str, "%*", "%%%*");
		str = gsub(str, "%+", "%%%+");
		str = gsub(str, "%-", "%%%-");
		str = gsub(str, "%?", "%%%?");
		return str;
	end

	InsertLinkInStoredEvent = function(author, chatType, linkText, newLink)
		log.Add(3, "Insert item link in event", { author, chatType, linkText, newLink });
		for i, event in pairs(incommingEvents) do
			if ((event.event ~= "CHAT_MSG_WHISPER_INFORM"  and event.author == author) or (event.event == "CHAT_MSG_WHISPER_INFORM" and author == playerName)) and chatType == ConvertEventNameToChatType(event.event) then
				if TableContainsValue(event.linkNames, linkText) then
					event.msg = gsub(event.msg, "%[" .. ClearRegexControlcharsFromString(linkText) .. "%]([^|]?)", function(followingChar)
						return newLink .. followingChar;
					end)
					RemoveValueFromTable(event.linkNames, linkText);

					if #(event.linkNames) == 0 then
						ParseEventToFrames(event.event, event.msg, event.author, unpack(event.args));
						table.remove(incommingEvents, i);
					end
				end
			end
		end
	end

	TableContainsValue = function(t, value)
		for _, v in pairs(t) do
			if v == value then
				return true;
			end
		end
		return false;
	end

	RemoveValueFromTable = function(t, value)
		for i, v in pairs(t) do
			if v == value then
				t[i] = nil;
			end
		end
	end

	ParseEventsTimedOut = function()
		for i, event in pairs(incommingEvents) do
			if time() - event.time > MSG_TIMEOUT then
				log.Add(3, "Added text with link text after timeout", { event.event, event.msg, event.author, unpack(event.args) })
				ParseEventToFrames(event.event, event.msg, event.author, unpack(event.args));
				table.remove(incommingEvents, i);
			end
		end
	end
	timer = GHI_Timer(ParseEventsTimedOut, 1, false, "ParseEventsTimedOut");

	SetItemRef = function(link, text, button,...)
		local prefix, ID,lineIndex = string.match(link, "gh_(.-):(.-):(.-):");
		if prefix and ID then
			if IsShiftKeyDown() == 1 then
				ChatEdit_InsertLink(text)
			else
				if linkClickFuncs[prefix] then
					local lines;
					lineIndex = tonumber(lineIndex);
					if lineIndex and lineIndex > 0 then
						lines = tooltipLinesSend[lineIndex];
					end
					linkClickFuncs[prefix](ID,lines);
				end
			end
		else
			orig.SetItemRef(link, text, button,...);
		end
	end

	local loginTime = time();
	CheckForNewEventFrames = function()
		if time() < loginTime + 60 then
			for _, event in pairs(supportedEvents) do

				registeredFrames[event] = registeredFrames[event] or {};
				local unregisteredFrames = { GetFramesRegisteredForEvent(event) };
				for _, frame in pairs(unregisteredFrames) do
					if not (frame == class) then
						if not (TableContainsValue(registeredFrames[event], frame)) then
							table.insert(registeredFrames[event], frame);
							if not (frame.OrigUnregisterEvent) then
								frame.OrigUnregisterEvent = frame.UnregisterEvent;
							end
							frame.UnregisterEvent = function(self, event)
								if type(registeredFrames[event]) == "table" then
									for i, f in pairs(registeredFrames[event]) do
										if f == self then
											table.remove(registeredFrames[event], i);
											break;
										end
									end
								end
								self:OrigUnregisterEvent(event);
							end
						end
						frame:OrigUnregisterEvent(event);
					end
				end
				wipe(unregisteredFrames);
			end
		end
	end

	timer2 = GHI_Timer(CheckForNewEventFrames, 10, false, "CheckForNewEventFrames")

	comm.AddRecieveFunc("SuspectedLinkName", RecieveSuspectedLinkName);
	comm.AddRecieveFunc("LinkConfirm", RecieveLinkConfirm);
	comm.AddRecieveFunc("LinkDeconfirm", RecieveLinkDeconfirm);

	class:SetScript("OnEvent", OnEvent);

	orig.SendChatMessage = _G.SendChatMessage;
	_G.SendChatMessage = SendChatMessage;
	orig.SetItemRef = _G.SetItemRef;
	_G.SetItemRef = SetItemRef;

	CheckForNewEventFrames();
	for _, event in pairs(supportedEvents) do
		class:RegisterEvent(event);
	end

	return class;
end
