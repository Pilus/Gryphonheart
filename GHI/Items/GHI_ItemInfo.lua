 --===================================================
--
--					GHI Item Info
--					ghi_itemInfo.lua
--
--		Item information storage and display
--
-- 			(c)2013 The Gryphonheart Team
--					All rights reserved
--===================================================
local itemFunctions;

function GHI_ItemInfo(info)
	GHCheck("GHI_ItemInfo()",{"table"},{info});

	if not(itemFunctions) then
		itemFunctions = {
			standard = GHI_ItemInfo_Standard,
			advanced = GHI_ItemInfo_Advanced,
		};
	end

	local itemComplexity;
	if type(info) == "table" then
		itemComplexity = info.itemComplexity;
	elseif type(info) == "string" then
		itemComplexity = info;
		info = nil;
	end

	if not(itemComplexity) then
		if info.isAdvancedItem then
			itemComplexity = "advanced";
		else
			itemComplexity = "standard";
		end
	end

	if itemFunctions[itemComplexity] then
		return itemFunctions[itemComplexity](info);
	else
		GHI_Log().Add(1,"Foreign item complexity. Item not loaded",{complexity=itemComplexity,guid = info.guid})
	end

end
