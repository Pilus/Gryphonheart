--
--
--				GHI_ItemInfo_Standard
--  			GHI_ItemInfo_Standard.lua
--
--		Item information for standard itemss
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--
local COMPLEXITY = "standard";

function GHI_ItemInfo_Standard(info)
	local class = GHClass("GHI_ItemInfo_Standard");
	GHInheritNext("GHI_ItemInfo_Basic",class);
	GHI_ItemInfo_Basic(info);

	-- Declaration and default values
	local simpleActions = {};
	local errorThrower = GHI_ErrorThrower();
	local event = GHI_Event();
	local envList = GHI_ScriptEnvList();
	local loc = GHI_Loc();

	-- Public functions
	class.AddSimpleAction = function(_action)
		if not (tContains(simpleActions, _action)) then
			table.insert(simpleActions, _action);
		end
	end

	class.CloneItem = function()
		return GHI_ItemInfo_Standard(class.Serialize());
	end

	class.GetActionData = function()
		return class.Serialize();
	end

	class.GetDependingItems = function(_,depending)
		depending = depending or {};

		local itemInfoList = GHI_ItemInfoList();
		for _, action in pairs(simpleActions) do
			local itemsDependingOnAction = action.GetDependingItems();

			for _, itemGuid in pairs(itemsDependingOnAction) do
				if not (tContains(depending, itemGuid)) then
					tinsert(depending, itemGuid);

					local otherItem = itemInfoList.GetItemInfo(itemGuid);
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
		end

		return depending;
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
			text = string.format("%s simple actions.", #(simpleActions)),
			r = 0.4,
			g = 0.8,
			b = 1.0,
		});

		local differentActions = {};
		for _, action in pairs(simpleActions) do
			local n = action.GetActionInfo();
			differentActions[n] = (differentActions[n] or 0) + 1;
		end

		local i = 122;
		for name, count in pairs(differentActions) do
			table.insert(lines, {
				order = i,
				text = string.format("   %s: %s", name, count),
				r = 0.4,
				g = 0.8,
				b = 1.0,
			});
			i = i + 1;
		end
		return lines;
     end

	class.GetItemComplexity = function()
		return COMPLEXITY;
	end

	class.GetSimpleAction = function(index)
		return simpleActions[index]
	end

	class.GetSimpleActionCount = function()
		return #(simpleActions)
	end

	class.RemoveSimpleAction = function(_action)
		for i, action in pairs(simpleActions) do
			if action == _action then
				table.remove(simpleActions, i)
				return;
			end
		end
	end

	class.UseItem = function(stack)
		if (stack.IsOnCooldown()) then
			errorThrower.CantUseItem();
			return
		end

		local authorGuid = class.GetAuthorInfo();
		local env = envList.GetEnv(authorGuid);

		-- Execute all actions to run before requirement
		for i, action in pairs(simpleActions) do
			if action.GetExecutionOrder() == 4 and not(action.GetActionType() == "requirement") then
				action.Execute(env, stack)
			end
		end

		-- Execute all requirements
		local fulfilled = true;
		for i, action in pairs(simpleActions) do
			if action.GetActionType() == "requirement" then
				fulfilled = fulfilled and action.Execute(env, stack)
			end
		end

		for i, action in pairs(simpleActions) do
			if action.GetExecutionOrder() == 1 or (action.GetExecutionOrder() == 2 and fulfilled) or  (action.GetExecutionOrder() == 3 and not(fulfilled)) then
				if not(action.GetActionType() == "requirement") then
					action.Execute(env, stack)
				end
			end
		end

		local parentContainerGuid = stack.GetParentContainer().GetGUID();
		if class.IsConsumed() then
			stack.DeleteItem(1);
		end

		class.SetLastCastTime(time());
		event.TriggerEvent("GHI_BAG_UPDATE_COOLDOWN",parentContainerGuid , class.GetGUID());
	end;

	class.GotBookAction = function()
		for i, action in pairs(simpleActions) do
			if (action.GetActionType() == "book") then
			   return true;
			end
		end
		return false;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype,t)
		t = t or {};
		if not(stype) or stype == "link" then
			t.itemComplexity = COMPLEXITY;
		end
		if not(stype) or stype == "action" or stype == "oldAction" then
			t.rightClick = t.rightClick or {};
			t.rightClick.Type = "multible";

			local bagIndex;
			for i, action in pairs(simpleActions) do
				t.rightClick[i] = action.Serialize(stype);
				if action.GetActionType() == "bag" then
					bagIndex = i;
				end
			end
			if bagIndex and stype == "oldAction" then
				t.rightClick.bag_index = bagIndex;
			end
		elseif stype == "toAdvanced" then -- convert the item to an advanced item

			local dynActions = {};
			-- Create the dynamic actions
			local set = GHI_DynamicActionInstanceSet(class,"onclick",{name=loc.DYN_PORT_ONCLICK_NAME,description=loc.DYN_PORT_ONCLICK_DESCRIPTION});
			for i, action in pairs(simpleActions) do
				local dynamicActions = action.Serialize(stype)
				for j=1,#(dynamicActions) do
					local dynActionInfo = dynamicActions[j];
					local instance = GHI_DynamicActionInstance(dynActionInfo.actionGuid,dynActionInfo.guid,class.GetAuthorInfo());
					dynActionInfo.portConnectionsOut = {};
					dynActionInfo.portConnectionsIn = {};
					instance.Deserialize(dynActionInfo);

					table.insert(dynActions,{
						info = dynActionInfo,
						instance = instance,
					});
					set.AddInstance(instance);
				end
			end

			for i,action in pairs(dynActions) do
				local prev = dynActions[i-1];
				if not(prev) then
					set.SetInstanceAtPort("onclick",action.instance,"setup")
				else

					if action.info.portConnection then
						for _,conn in pairs(action.info.portConnection) do
							local otherInstance = dynActions[i+conn.instanceIndexDiff];
							otherInstance.instance.SetPortConnection(conn.port,action.instance,"setup");
						end
					elseif prev.info.nextPort then
						local conn = prev.info.nextPort;
						local otherInstance = dynActions[i+conn.instanceIndexDiff];
						otherInstance.instance.SetPortConnection(conn.port,action.instance,"setup");
					else
						prev.instance.SetPortConnection("onsetup",action.instance,"setup");
					end

				end
				prev = action;
			end

			t.dynamicActionSet = set.Serialize();
			if not(t.rightClick) then
				t.rightClick = {};
			end
			t.rightClick.AddonReqName = "GHI";
			t.rightClick.AddonReqData = "2.0.0";
			t.rightClick.Type = true;
			t.updateSequences = {};
			t.itemComplexity = "advanced";
		end

		if OtherSerialize then
			t = OtherSerialize(stype,t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	info.rightClick = info.rightClick or {};
	if type(info.rightClick)=="table" then
		for i, simpleActionInfo in pairs(info.rightClick) do
			if type(simpleActionInfo) == "table" and type(i) == "number" then
				local simpleAction = GHI_SimpleAction(simpleActionInfo);
				table.insert(simpleActions, simpleAction);

				local actionType = simpleAction.GetActionType();
				GHI_SaveStatistic("totalSimpleActions",actionType);
				if class.IsCreatedByPlayer() then
					GHI_SaveStatistic("totalSimpleActionsByPlayer",actionType);
				end
			end
		end
	end
	GHI_SaveStatistic("totalStandardItems");
	if class.IsCreatedByPlayer() then
		GHI_SaveStatistic("totalStandardItemsByPlayer");
	end

	return class;
end

