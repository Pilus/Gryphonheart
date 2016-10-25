--
--
--				GHP_ProfessionSystem
--  			GHP_ProfessionSystem.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHP_ProfessionSystem(info)
	local class = GHP_AuthorInfo(info,"GHP_ProfessionSystem");

	local name,guid,icon,markColor;
	local version;

	class.GetGuid = function()
		return guid;
	end

	class.GetDetails = function()
		return guid,name,icon,markColor;
	end

	class.GetVersion = function()
		return version;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or {};
		t.guid = guid;
		if not(stype) or stype == "nonpersonal" then
			t.name = name;
			t.icon = icon;
			t.markColor = markColor;
			t.version = version;
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
	icon = info.icon;
	markColor = info.markColor or {r=1.0,g=0.0,b=0.0};
	version = info.version or 0;

	return class;
end

