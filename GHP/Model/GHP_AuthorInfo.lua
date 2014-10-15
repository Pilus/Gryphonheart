--===================================================
--
--				GHP_AuthorInfo
--  			GHP_AuthorInfo.lua
--
--	         Class holding author information
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHP_AuthorInfo(info,className)
	local class = GHClass(className or "GHP_AuthorInfo");
	local guid,name;

	class.GetAuthorInfo = function()
		return guid,name;
	end

	class.IsCreatedByPlayer = function()
		return GHUnitGUID("player") == guid;
	end

	class.IsCreatedByUser = function(otherGuid)
		return guid == otherGuid;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or {};
		if not (stype) or stype == "nonpersonal" then
			t.authorGuid = guid;
			t.authorName = name;
		end
		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	guid = info.authorGuid;
	name = info.authorName;

	return class;
end

