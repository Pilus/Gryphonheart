--
--
--				GHI_ItemInfo_Version
--  			GHI_ItemInfo_Version.lua
--
--			Version handling for item info
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHI_ItemInfo_Version(info)
	local class = GHClass("GHI_ItemInfo_Version");

	local transfer = GHI_ItemDataTransfer();

	-- Declaration and default values
	local detailsVersion = 0;
	local version = 1;

	-- Public functions
	class.GetVersions = function()
		return version, detailsVersion;
	end

	class.IsNewest = function(otherItem)
		local otherVersion, otherActionVersion = otherItem.GetVersions();
		if otherVersion < version or otherActionVersion < detailsVersion then
			return true;
		end
		return false;
	end

	class.IncreaseVersion = function(alsoIncreaseDetailsVersion)
		version = version + 1;
		if alsoIncreaseDetailsVersion then
			detailsVersion = detailsVersion + 1;
		end
	end

	class.GetItemDataArrivalTime = function()
		local t = transfer.GetAwaitingActionDataTime(class.GetGUID());
		if t then
			return t-time();
		end
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype,t)
		t = t or {};

		if not(stype) or stype == "link" or stype == "toAdvanced" then
			t.version = version;
		end
		if not(stype) or stype == "action" or stype == "oldAction" or stype == "toAdvanced" then
			t.rightClick = t.rightClick	or {};
			t.rightClick.version = detailsVersion;
		end

		if OtherSerialize then
			t = OtherSerialize(stype,t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	version = info.version or version;
	if type(info.rightClick) == "table" then
		detailsVersion = info.rightClick.version or detailsVersion;
	end

	return class;
end

