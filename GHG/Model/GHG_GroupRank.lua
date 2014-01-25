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
			local permissions = 0;
			permissions = bit.bor(permissions,canEditRanksAndPermissions and 2^0 or 0);
			permissions = bit.bor(permissions,canInvite and 2^1 or 0);
			permissions = bit.bor(permissions,canPromoteDemote and 2^2 or 0);
			permissions = bit.bor(permissions,canEditOfficersNote and 2^3 or 0);
			permissions = bit.bor(permissions,canViewOfficersNote and 2^4 or 0);
			permissions = bit.bor(permissions,canEditPublicNote and 2^5 or 0);
			permissions = bit.bor(permissions,canViewPublicNote and 2^6 or 0);
			permissions = bit.bor(permissions,canTalkInChat and 2^7 or 0);
			permissions = bit.bor(permissions,canHearChat and 2^8 or 0);
			permissions = bit.bor(permissions,canKickMember and 2^9 or 0);
			t.permissions = permissions;
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
	if type(info.permissions) == "number" then
		canEditRanksAndPermissions = bit.band(info.permissions,2^0) > 0;
		canInvite = bit.band(info.permissions,2^1) > 0;
		canPromoteDemote = bit.band(info.permissions,2^2) > 0;
		canEditOfficersNote = bit.band(info.permissions,2^3) > 0;
		canViewOfficersNote = bit.band(info.permissions,2^4) > 0;
		canEditPublicNote = bit.band(info.permissions,2^5) > 0;
		canViewPublicNote = bit.band(info.permissions,2^6) > 0;
		canTalkInChat = bit.band(info.permissions,2^7) > 0;
		canHearChat = bit.band(info.permissions,2^8) > 0;
		canKickMember = bit.band(info.permissions,2^9) > 0;
	else
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
	end

	return class;
end

