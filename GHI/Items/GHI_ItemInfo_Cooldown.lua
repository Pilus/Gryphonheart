--===================================================
--
--				GHI_ItemInfo_Cooldown
--  			GHI_ItemInfo_Cooldown.lua
--
--		Cooldown handler for GHI Item Info
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_ItemInfo_Cooldown(info)
	local class = GHClass("GHI_ItemInfo_Cooldown");

	-- Declaration and default values
	local cooldown = 0;
	local lastCastTime = 0;

	-- Public functions
	class.GetCooldown = function()
		if time() - lastCastTime < cooldown then
			return cooldown, time() - lastCastTime;
		end
		return cooldown;
	end

	class.GetLastCastTime = function()
		return lastCastTime;
	end

	class.IsOnCooldown = function()
		if time() - lastCastTime < cooldown then
			return true;
		end
		return false;
	end

	class.SetCooldown = function(cd)
		cooldown = cd;
	end

	class.SetLastCastTime = function(lastCast)
		lastCastTime = lastCast;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype,t)
		t = t or {};
		if not(stype) or stype == "link" then

		end
		if not(stype) or stype == "action" or stype == "oldAction" or stype == "toAdvanced" then
			t.rightClick = t.rightClick or {};

			t.rightClick.cooldown = cooldown;
			t.rightClick.CD = cooldown;
		end

		if OtherSerialize then
			t = OtherSerialize(stype,t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
   	cooldown = max(info.cooldown or (info.rightClick or {}).CD or 0, 1);
	lastCastTime = info.lastCastTime or lastCastTime;

	return class;
end

