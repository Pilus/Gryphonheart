--===================================================
--
--			GHI GUID Creation
--				GHI_GUID.lua
--
--		Creation of unique guids, based on
--			character guid and timestamps
--
-- 			(c)2013 The Gryphonheart Team
--				All rights reserved
--===================================================

local class
function GHI_GUID()
	if class then
		return class;
	end
	class = GHClass("GHI_GUID");

	local lastTime;
	local guid;

	local ToHex = function(v)
		return string.format("%X", v)
	end

	class.MakeGUID = function()
		if not (guid) then
			guid = string.gsub(string.gsub(UnitGUID("player"), "0x..", ""), "00[0]*", "")
		end

		local t = time();
		if t == 0 and not(lastTime) then
			t = random(100000);
		else
			t = t - 1315000000;
		end

		if lastTime and t <= lastTime then
			t = lastTime + 1;
		end
		lastTime = t;

		local hashTime = ToHex(t)

		return guid .. "_" .. hashTime;
	end

	return class;
end


