--===================================================
--
--				GHG_GroupRank
--  			GHG_GroupRank.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHG_GroupRank(info,isFirst)
	local class = GHClass("GHG_GroupRank");

	local guid,name;
	local canEditRanksAndPermissions;
	local canInvite,canKickMember,canPromoteDemote;
	local canEditOfficersNote,canViewOfficersNote;
	local canEditPublicNote,canViewPublicNote;
	local canTalkInChat,canHearChat;

	class.GetGuid = function()
		return guid;
	end

	class.SetName = function(_name)
		name = _name;
	end

	class.GetName = function()
		return name;
	end

	class.CanInvite = function()
		return canInvite;
	end

	class.CanPromoteDemote = function()
		return canPromoteDemote;
	end

	class.CanEditRanksAndPermissions = function()
		return canEditRanksAndPermissions;
	end

	class.CanEditOfficersNote = function()
		return canEditOfficersNote;
	end

	class.CanViewOfficersNote = function()
		return canViewOfficersNote;
	end

	class.CanEditPublicNote = function()
		return canEditPublicNote;
	end

	class.CanViewPublicNote = function()
		return canViewPublicNote;
	end

	class.CanTalkInChat = function()
		return canTalkInChat;
	end

	class.CanHearChat = function()
		return canHearChat;
	end

	class.CanKickMember = function()
		return canKickMember;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or info or {};
		if not (stype) then
			t.guid = guid;
			t.name = name;
			t.canEditRanksAndPermissions = canEditRanksAndPermissions;
			t.canInvite = canInvite;
			t.canPromoteDemote = canPromoteDemote;
			t.canEditOfficersNote = canEditOfficersNote;
			t.canViewOfficersNote = canViewOfficersNote;
			t.canEditPublicNote = canEditPublicNote;
			t.canViewPublicNote = canViewPublicNote;
			t.canTalkInChat = canTalkInChat;
			t.canHearChat = canHearChat;
			t.canKickMember = canKickMember;
		end
		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	guid = info.guid or GHI_GUID().MakeGUID();
	name = info.name;

	local f = function(v,def)
		if v == nil then
			return def;
		end
		return v;
	end

	canEditRanksAndPermissions = f(info.canEditRanksAndPermissions , isFirst or false);
	canInvite = f(info.canInvite , isFirst or false);
	canPromoteDemote = f(info.canPromoteDemote , isFirst or false);
	canEditOfficersNote = f(info.canEditOfficersNote , isFirst or false);
	canViewOfficersNote = f(info.canViewOfficersNote , isFirst or false);
	canEditPublicNote = f(info.canEditPublicNote , isFirst or false);
	canViewPublicNote = f(info.canViewPublicNote , true);
	canTalkInChat = f(info.canTalkInChat , true);
	canHearChat = f(info.canHearChat , true);
	canKickMember = f(info.canKickMember, isFirst or false)


	return class;
end

