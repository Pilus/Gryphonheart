--===================================================
--
--				GHP_Requirement
--  			GHP_Requirement.lua
--
--	         Holds a requirement for
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHP_Requirement(info,parent)
	local class = GHClass("GHP_Requirement");

	local ownerGuid = parent.GetAuthorInfo();



	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or {};
		if not (stype) then
			-- SERIALIZE CODE
		end
		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	local code = info.code;

	return class;
end

