--===================================================
--
--				GHG_PlayerData
--  			GHG_PlayerData.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHG_PlayerData(info)
	local class = GHClass("GHG_PlayerData");

	local versionInfo = GHI_VersionInfo();

	local guid,name,level,pclass,race,zone,guild,gender;
	local version,lastOnline;
	local icName,icTitle;

	class.GetGuid = function()
		return guid;
	end

	class.GetVersion = function()
		return version;
	end

	class.GetName = function()
		return name;
	end

	class.GetLevel = function()
		return level;
	end

	class.GetClass = function()
		return pclass;
	end

	class.GetLastOnline = function()
		return lastOnline;
	end

	class.GetRace = function()
		return race;
	end

	class.GetZone = function()
		return zone;
	end

	class.IsOnline = function()
		return versionInfo.IsPlayerOnline(name);
	end

	class.GetIcName = function()
		return icName;
	end

	class.GetIcTitle = function()
		return icTitle;
	end

	class.GetGuild = function()
		return guild;
	end

	class.GetGender = function()
		return gender;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or {};
		if not (stype) then
			-- SERIALIZE CODE
			t.guid = guid;
			t.version = version;
			t.name = name;
			t.level = level;
			t.lastOnline = lastOnline;
			t.class = pclass;
			t.race = race;
			t.zone = zone;
			t.icName = icName;
			t.icTitle = icTitle;
			t.guild = guild;
			t.gender = gender;
		end
		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	assert(type(info.guid)=="string","No guid in data table")
	-- INITIALIZE CODE
	guid = info.guid;
	name = info.name or "unknown";
	level = info.level or 0;
	version = info.version or 0;
	lastOnline = info.lastOnline or 0;
	pclass = info.class or "";
	race = info.race or "";
	zone = info.zone or "";
	icName = info.icName or "";
	icTitle = info.icTitle or "";
	guild = info.guild or "";
	gender = info.gender or 1;

	return class;
end

