--===================================================
--
--				GHI_UsageStatisticsSet
--  			GHI_UsageStatisticsSet.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_UsageStatisticsSet(info)
	local class = GHClass("GHI_UsageStatisticsSet");

	local addonVersions,totalStandardItems,totalStandardItemsByPlayer,totalAdvancedItems,totalAdvancedItemsByPlayer;
	local totalSimpleActions,totalSimpleActionsByPlayer,totalDynamicActions,totalDynamicActionsByPlayer;
	local GHI_MiscData;

	class.Serialize = function()
		return {
			addonVersions = addonVersions,
			totalStandardItems = totalStandardItems,
			totalStandardItemsByPlayer = totalStandardItemsByPlayer,
			totalAdvancedItems = totalAdvancedItems,
			totalAdvancedItemsByPlayer = totalAdvancedItemsByPlayer,

			totalSimpleActions = totalSimpleActions,
			totalSimpleActionsByPlayer = totalSimpleActionsByPlayer,
			totalDynamicActions = totalDynamicActions,
			totalDynamicActionsByPlayer = totalDynamicActionsByPlayer,

			GHI_MiscData = GHI_MiscData,
		};
	end

	class.Deserialize = function(t)
		addonVersions = t.addonVersions or {};
		totalStandardItems = t.totalStandardItems or 0;
		totalStandardItemsByPlayer = t.totalStandardItemsByPlayer or 0;
		totalAdvancedItems = t.totalAdvancedItems or 0;
		totalAdvancedItemsByPlayer = t.totalAdvancedItemsByPlayer or 0;

		totalSimpleActions = t.totalSimpleActions or 0;
		totalSimpleActionsByPlayer = t.totalSimpleActionsByPlayer or 0;
		totalDynamicActions = t.totalDynamicActions or 0;
		totalDynamicActionsByPlayer = t.totalDynamicActionsByPlayer or 0;

		GHI_MiscData = t.GHI_MiscData or {};
	end

	class.Deserialize(info or {});

	return class;
end

