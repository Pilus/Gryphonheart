--===================================================
--
--				GHG_Group
--  			GHG_Group.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local TrimForSpaces = function(text)
	return string.gsub(text,".",function(s) if not(s==" ") then return s; end return ""; end);
end

--[[
 Some thing => St
 Something => Something
 Some of a Thing => SoaT
]]
local GenerateHeaderFromName = function(name)
	if name:len() <= 8 and not(string.find(name," ")) then
		return name;
	end


	local header = name:sub(0,1);
	string.gsub(name,"%s.",function(s)
		s = string.sub(s,s:len())
		if not(s==" ") then
			header = header..s;
		end
		return "";
	end);

	if header:len() < 2 then
		return string.sub(name,0,8);
	end

	return header;
end

assert("St"==GenerateHeaderFromName("Some thing"))
assert("Somethin"==GenerateHeaderFromName("Something"))
assert("SoaT"==GenerateHeaderFromName("Some of a Thing"))


local RandomChatColor;
RandomChatColor = function()
	local c = {r = random(100)/100, g = random(100)/100, b = random(100)/100 }
	if (c.r + c.g + c.b) < 0.90 then -- too dark
		return RandomChatColor();
	end
	return c;
end


function GHG_Group(info)
	local class = GHClass("GHG_Group");

	local guid,name,version,icon;
	local members = {};
	local ranks = {};
	local chatName,chatHeader,chatColor,chatSlashCmds;

	local cryptatedDataInitialized = false;
	local crypt;

	local groupChat;
	local active = false;
	local chat;

	local Encrypt;
	Encrypt = function(v)
		if type(v) == "string" then
			local swap = crypt.Swap(v);
			return crypt.Encrypt(swap);
		elseif type(v) == "table" then
			local t = {}
			for i,vv in pairs(v) do
				t[i] = Encrypt(vv);
			end
			return t;
		else
			return v;
		end
	end
	local Decrypt;
	Decrypt = function(v)
		if type(v) == "string" then
			local decrypted = crypt.Decrypt(v);
			return crypt.Deswap(decrypted)
		elseif type(v) == "table" then
			local t = {}
			for i,vv in pairs(v) do
				t[i] = Decrypt(vv);
			end
			return t;
		else
			return v;
		end
	end


	class.CanRead = function()
		return cryptatedDataInitialized;
	end

	class.GetGuid = function()
		return guid;
	end

	class.GetVersion = function()
		return version;
	end

	class.UpdateVersion = function()
		version = GHTimeBasedVersion();
	end

	class.SetName = function(_name)
		name = _name;
	end

	class.GetName = function()
		return name;
	end

	class.GetIcon = function()
		return icon;
	end

	class.SetIcon = function(_icon)
		icon = _icon;
	end

	-- Members
	local GetMemberByGuid = function(guid)
		for _,member in pairs(members) do
			if member.GetGuid() == guid then
				return member;
			end
		end
	end

	class.GetNumMembers = function()
		return #(members);
	end

	class.GetMember = function(i)
		return members[i];
	end

	class.IsPlayerMemberOfGuild = function(playerGuidOrName)
		for _,member in pairs(members) do
			if member.GetGuid() == playerGuidOrName or member.GetName() == playerGuidOrName then
				return true;
			end
		end
		return false;
	end

	class.AddMember = function(guid,name,rankGuid)
		if not(rankGuid) then -- default to lowest rank
			local rank = ranks[#(ranks)];
			rankGuid = rank.GetGuid();
		end

		local member = GHG_GroupMember({
			guid = guid,
			name = name,
			rankGuid = rankGuid,
		})
		table.insert(members,member);
	end

	class.RemoveMember = function(guid)
		for i,member in pairs(members) do
			if member.GetGuid() == guid then
				table.remove(members,i);
				return
			end
		end
	end



	-- Rank
	local GetRankByGuid = function(guid)
		for _,rank in pairs(ranks) do
			if rank.GetGuid() == guid then
				return rank;
			end
		end
	end

	class.AddRank = function(rankName)
		local rank = GHG_GroupRank({ name = rankName},#(ranks)==0);
		table.insert(ranks,rank);
	end

	class.GetNumRanks = function()
		return #(ranks);
	end

	class.GetRank = function(i)
		return ranks[i]
	end

	class.SetRank = function(i,rank)
		ranks[i] = rank;
	end

	class.GetRankIndex = function(rankOrRankGuid)
		for i=1,#(ranks) do
			if rankOrRankGuid == ranks[i] or rankOrRankGuid == ranks[i].GetGuid() then
				return i;
			end
		end
	end

	class.GetRankOfMember = function(guid)
		local member = GetMemberByGuid(guid);
		if member then
			return GetRankByGuid(member.GetRankGuid());
		end
	end

	class.SetRankOfMember = function(guid,rankGuid)
		local member = GetMemberByGuid(guid);
		if member then
			member.SetRankGuid(rankGuid);
		end
	end

	class.DeleteRank = function(index)
		assert(ranks[index],"")
		local deleteRank = ranks[index];
		local replacingRank;
		if index == #(ranks) then
			replacingRank = ranks[index-1];
		else
			replacingRank = ranks[index+1];
		end

		for _,member in pairs(members) do
			if member.GetRankGuid() == deleteRank.GetGuid() then
				member.SetRankGuid(replacingRank.GetGuid());
			end
		end

		table.remove(ranks,index);

	end


	class.GetGroupChatInfo = function()
		return chatName,chatHeader,chatColor,chatSlashCmds;
	end

	class.SendChatMessage = function(msg)
		chat.SendChatMessage(msg)
	end


	class.Activate = function()
		active = true;
		if chat then
			chat.Activate();
		end
	end

	class.Deactivate = function()
		active = false;
		if chat then
			chat.Deactivate();
		end
	end

	class.Clone = function()
		return GHG_Group(class.Serialize());
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or info or {};
		if not(cryptatedDataInitialized) then
			return info;
		end

		if not (stype) then
			t.guid = guid;
			t.version = version;

			t.name = Encrypt(name);
			t.icon = Encrypt(icon);

			local SaveNested = function(objs)
				local info = {};
				for i,v in pairs(objs) do
					info[i] = v.Serialize();
				end
				return Encrypt(info);
			end

			t.members = SaveNested(members);
			t.ranks = SaveNested(ranks);

			t.chatName = chatName;
			t.chatHeader = chatHeader;
			t.chatColor = chatColor;
			t.chatSlashCmds = chatSlashCmds;
		end

		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	guid = info.guid or GHI_GUID().MakeGUID();
	version = info.version or 0;

	class.InitializeCryptatedData = function()
		local keys = GHG_GroupKeys[guid];
		if not(keys) then
			return
		end

		crypt = GHI_Crypt(keys[1],keys[2]);

		cryptatedDataInitialized = true;

		name = Decrypt(info.name) or "";
		icon = Decrypt(info.icon) or "Interface/ICONS/INV_Misc_QuestionMark";

		local LoadNestedCryptated = function(t,classFunc,flagFirst)
			local info = Decrypt(t) or {};
			local info2 = {};
			for i=1,#(info) do
				local flag;
				if flagFirst and i==1 then
					flag = true;
				end
				info2[i] = classFunc(info[i],flag);
			end
			return info2;
		end

		members = LoadNestedCryptated(info.members or {},GHG_GroupMember);
		ranks = LoadNestedCryptated(info.ranks or {},GHG_GroupRank,true);

		chatName = info.chatName or name;
		chatHeader = info.chatHeader or GenerateHeaderFromName(name);
		chatColor = info.chatColor or RandomChatColor();
		chatSlashCmds = info.chatSlashCmds or {GenerateHeaderFromName(name)};

		chat = GHG_GroupChat(guid,keys);
		if active and class.IsPlayerMemberOfGuild(UnitGUID("player")) then
			chat.Activate();
		end
	end

	class.ReadyForModification = function()
		return cryptatedDataInitialized;
	end

	class.InitializeCryptatedData();

	return class;
end

-- [[
TEST = function(text)

	local crypt = GHI_Crypt(random(100),random(100))

	local swapped = crypt.Swap(text);

	print(swapped);

	local deswapped = crypt.Deswap(swapped);

	print(deswapped == text)

	print(deswapped);

end --]]
