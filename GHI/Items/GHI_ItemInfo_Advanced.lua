--
--
--				GHI_ItemInfo_Advanced
--				GHI_ItemInfo_Advanced.lua
--
--	Holds general item information for advanced items
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--
local COMPLEXITY = "advanced";

function GHI_ItemInfo_Advanced(info)
	local class = GHClass("GHI_ItemInfo_Advanced");
	GHInheritNext("GHI_ItemInfo_Basic",class);
	GHI_ItemInfo_Basic(info);
	GHInheritNext("GHI_ItemInfo_Attributes",class);
	GHI_ItemInfo_Attributes(info);
	GHInheritNext("GHI_ItemInfo_AdvTooltip",class);
	GHI_ItemInfo_AdvTooltip(info);

	-- Declaration and default values
	local updateSequences = {};
	local dynamicActionSet;
	local loc = GHI_Loc();

	local errorThrower = GHI_ErrorThrower();
	local event = GHI_Event();
	local envList = GHI_ScriptEnvList();

	-- Public functions
	class.AddUpdateSequence = function(sequence, frequency)
		table.insert(updateSequences, {
			sequence = sequence,
			frequency = frequency,
		});
	end

	class.CloneItem = function()
		return GHI_ItemInfo_Advanced(class.Serialize());
	end

	class.GetAllUpdateSequences = function()
		return updateSequences;
	end

	class.GetDependingItems = function(stack,depending)
		depending = depending or {};
		local itemList = GHI_ItemInfoList();
		local thisDepending = dynamicActionSet.GetDependingItems(stack);

		for _, itemGuid in pairs(thisDepending) do
			if not (tContains(depending, itemGuid)) then
				table.insert(depending,itemGuid);

				local otherItem = itemList.GetItemInfo(itemGuid);
				if otherItem then
					local otherDepending = otherItem.GetDependingItems(_,depending);

					for _, otherGuid in pairs(otherDepending) do
						if not (tContains(depending, otherGuid)) and not(otherGuid == class.GetGUID()) then
							tinsert(depending, otherGuid)
						end
					end
				end
			end
		end
		return depending;
	end

	class.GetDynamicActionSet = function()
		return dynamicActionSet;
	end

	class.GetInspectionLines = function()
		local lines = {};

		table.insert(lines, {
			order = 120,
			text = string.format("ID: %s", class.GetGUID()),
			r = 0.4,
			g = 0.8,
			b = 1.0,
		});

		table.insert(lines, {
			order = 121,
			text = string.format("%s dynamic actions.", #(dynamicActionSet.GetInstanceGuids())),
			r = 0.4,
			g = 0.8,
			b = 1.0,
		});

		--todo: inspection lines for the dynamic actions

		return lines;
	end

	class.GetItemComplexity = function()
		return COMPLEXITY;
	end

	class.RemoveUpdateSequence = function(sequence)
		for i, seq in pairs(updateSequences) do
			if seq.sequence == sequence then
				table.remove(updateSequences, i);
			end
		end
	end

	class.ReplaceUpdateSequence = function(sequence,newSequence,frequency)
		for i, seq in pairs(updateSequences) do
			if seq.sequence == sequence then
				updateSequences[i] = {
					sequence = newSequence,
					frequency = frequency,
				}
				return;
			end
		end
		class.AddUpdateSequence(newSequence,frequency);
	end

	class.UseItem = function(stack)
   		if (stack.IsOnCooldown()) then
			errorThrower.CantUseItem();
			return
		end

		local authorGuid = class.GetAuthorInfo();
		local env = envList.GetEnv(authorGuid);

		if dynamicActionSet then
			dynamicActionSet.Execute("onclick", stack, stack.GetFirstItemInstanceByOrder(class.GetStackOrder()),false,nil,{stack.GetGUID()});
		end


		local parentContainerGuid = stack.GetParentContainer().GetGUID();
		if class.IsConsumed() then
			stack.DeleteItem(1);
		end

		class.SetLastCastTime(time());
		event.TriggerEvent("GHI_BAG_UPDATE_COOLDOWN", parentContainerGuid, class.GetGUID());
	end


	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype,t)
		t = t or {};
		if not(stype) or stype == "link" then
			t.itemComplexity = COMPLEXITY;
		end
		if not(stype) or stype == "action" or stype == "oldAction" then
			t.dynamicActionSet = dynamicActionSet.Serialize();
			t.updateSequences = {};
			for i, seq in pairs(updateSequences) do
				t.updateSequences[i] = {
					frequency = seq.frequency,
					sequence = seq.sequence.Serialize(),
				}
			end

			if not(t.rightClick) then
				t.rightClick = {};
			end
			t.rightClick.AddonReqName = "GHI";
			t.rightClick.AddonReqData = "2.0.0";
			t.rightClick.Type = true;
		end

		if OtherSerialize then
			t = OtherSerialize(stype,t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	dynamicActionSet = GHI_DynamicActionInstanceSet(class,"onclick",{name=loc.DYN_PORT_ONCLICK_NAME,description=loc.DYN_PORT_ONCLICK_DESCRIPTION});
	if info.dynamicActionSet then
		dynamicActionSet.Deserialize(info.dynamicActionSet);
	end

	if info.updateSequences then
		for i, seq in pairs(info.updateSequences) do
			local sequenceObj = GHI_DynamicActionInstanceSet(class, "onupdate");
			sequenceObj.Deserialize(seq.sequence);
			updateSequences[i] = {
				frequency = seq.frequency,
				sequence = sequenceObj,
			};
		end
	end

	GHI_SaveStatistic("totalAdvancedItems");
	if class.IsCreatedByPlayer() then
		GHI_SaveStatistic("totalAdvancedItemsByPlayer");
	end

	return class;
end

