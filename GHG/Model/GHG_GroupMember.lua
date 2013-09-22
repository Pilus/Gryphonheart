--===================================================
--
--				GHG_GroupMember
--  			GHG_GroupMember.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHG_GroupMember(info)
	local class = GHClass("GHG_GroupMember");

	local guid,name,rankGuid;
	local publicNote,officersNote;

	class.GetGuid = function()
		return guid;
	end

	class.GetName = function()
		return name;
	end

	class.GetRankGuid = function()
		return rankGuid;
	end

	class.SetRankGuid = function(_rankGuid)
		rankGuid = _rankGuid;
	end

	class.SetPublicNote = function(note)
		publicNote = note;
	end

	class.GetPublicNote = function()
		return publicNote;
	end

	class.SetOfficersNote = function(note)
		officersNote = note;
	end

	class.GetOfficersNote = function()
		return officersNote;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or info or {};
		if not (stype) then
			t.guid = guid;
			t.name = name;
			t.rankGuid = rankGuid;
			t.publicNote = publicNote;
			t.officersNote = officersNote;
		end
		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	guid = info.guid;
	name = info.name;
	rankGuid = info.rankGuid;
	publicNote = info.publicNote or "";
	officersNote = info.officersNote or "";

	return class;
end

