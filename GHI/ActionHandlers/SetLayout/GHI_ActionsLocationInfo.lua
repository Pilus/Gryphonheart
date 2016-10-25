--
--
--				GHI_ActionsLocationInfo
--  			GHI_ActionsLocationInfo.lua
--
--		Holds information about the location of each
--			action in the action set.
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHI_ActionsLocationInfo(actionTree)
	local class = GHClass("GHI_ActionsLocationInfo");

	local locationActionTable = {}; -- contains the action at a given location
	local actionLocationTable = {}; -- contains the location for a given action

	class.GetRaw = function()
		return locationActionTable,actionLocationTable;
	end

	class.GetNumTiers = function()
		return locationActionTable.maxTier or 0;
	end

	class.GetNumActionsInTier = function(tier)
		return (locationActionTable[tier] or {}).maxNumber or 0;
	end

	class.GetNumActionsInLargestTier = function()
		return locationActionTable.maxNumber or 0;
	end

	class.GetInstance = function(tier,number)
		return (locationActionTable[tier] or {})[number];
	end

	class.GetLocationOfAction = function(guid)
		return unpack(actionLocationTable[guid] or {});
	end

	local UpdateActionLocationTable;
	UpdateActionLocationTable = function(tree,parentNumber)
		local dept = tree.dept;
		if dept == 1 then
			locationActionTable = {};
			actionLocationTable = {};
		end

		if tree.instance then
			locationActionTable.maxTier = math.max(locationActionTable.maxTier or 0, dept);
		end

		if not (locationActionTable[dept]) then
			locationActionTable[dept] = {};
		end

		for i = 1, #(tree) do
			local subTree = tree[i];
			local instance = subTree.instance;
			if instance then
				-- determine what number to place the action
				local number = parentNumber or 1;
				while (locationActionTable[dept][number]) do
					number = number + 1;
				end

				locationActionTable[dept][number] = instance;
				locationActionTable[dept].maxNumber = number;
				locationActionTable.maxNumber = math.max(locationActionTable.maxNumber or 0,number);
				actionLocationTable[instance.GetGUID()] = { dept, number };
				UpdateActionLocationTable(subTree, number);
			end
		end
	end

	UpdateActionLocationTable(actionTree);

	return class;
end


