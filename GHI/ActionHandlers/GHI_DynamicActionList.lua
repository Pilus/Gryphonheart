--===================================================
--
--				GHI_DynamicActionList
--				GHI_DynamicActionList.lua
--
--	Holds a list of dynamic action (templates).
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_DynamicActionList()
	if class then
		return class;
	end
	class = GHClass("GHI_DynamicActionList");
	local event = GHI_Event();

	local actions = {};

	class.AddAction = function(action)
		GHCheck("GHI_DynamicActionList.AddAction", { "GHI_DynamicAction" }, { action });
		for _, a in pairs(actions) do
			if action.GetGUID() == a.GetGUID() then
				if action.GetVersion() > a.GetVersion() then
					actions[action.GetGUID()] = action;
					event.TriggerEvent("GHI_DYNAMIC_ACTION_UPDATED", action.GetGUID());
				end
				return
			end
		end

		actions[action.GetGUID()] = action;
		event.TriggerEvent("GHI_DYNAMIC_ACTION_ADDED", action.GetGUID());
	end

	class.GetAction = function(guid)
		return actions[guid];
	end

	local CompareStrings = function(str1,str2)
		str1 = str1:lower();
		str2 = str2:lower();
		local len = math.min(str1:len(),str2:len());
		for i=1,len do
			if str1:byte(i) < str2:byte(i) then
				return true;
			elseif str1:byte(i) > str2:byte(i) then
				return false;
			end
		end
		return false;
	end

	class.GetCategories = function(onlyActionsAllowedAsUpdate)
		local cats = {};
		for _, action in pairs(actions) do
			if action.AllowedInUpdateSequence() or not (onlyActionsAllowedAsUpdate) then
				local cat = action.GetCategory();
				cats[cat] = true;
			end
		end
		local cats2 = {};
		for i, _ in pairs(cats) do
			table.insert(cats2, i);
		end
		table.sort(cats2,CompareStrings)
		return cats2;
	end

	class.GetActions = function(category, onlyActionsAllowedAsUpdate, specialActionCategory)
		local a1 = {};
		for _, action in pairs(actions) do
			if action.GetCategory() == category and action.GetAuthor() == "00x1" then
				if action.AllowedInUpdateSequence() or not (onlyActionsAllowedAsUpdate) then
					if not (action.GetSpecialActionCategory()) or specialActionCategory == action.GetSpecialActionCategory() then
						table.insert(a1, action);
					end
				end
			end
		end

		table.sort(a1,function(ac1,ac2) return CompareStrings(ac1.GetName(),ac2.GetName()); end)
		local a2 = {};
		for _, action in pairs(actions) do
			if category ~= "" and action.GetCategory() == category and action.GetAuthor() ~= "00x1" then
				if action.AllowedInUpdateSequence() or not (onlyActionsAllowedAsUpdate) then
					if not (action.GetSpecialActionCategory()) or specialActionCategory == action.GetSpecialActionCategory() then
						table.insert(a2, action);
					end
				end
			end
		end

		table.sort(a2,function(ac1,ac2) return CompareStrings(ac1.GetName(),ac2.GetName()); end)
		for i=1,#(a2) do
			table.insert(a1,a2[i]);
		end

		return a1;
	end

	class.LoadActions = function()
		for _, actionData in pairs(GHI_ProvidedDynamicActions) do
			local action = GHI_DynamicAction(actionData);
			class.AddAction(action);
		end
		GHI_ProvidedDynamicActions = {};
	end
	class.LoadActions();

	-- Load the dynamic actions that are saved
	local savedInfo = GHI_SavedData("GHI_SavedDynamicActions");
	class.LoadFromSaved = function()
		local loaded = savedInfo.GetAll();
		if type(loaded) == "table" then
			for index, actionData in pairs(loaded) do
				local action = GHI_DynamicAction(actionData);
				class.AddAction(action);
			end
		end
	end

	-- Transfer of dynamic actions
	local comm = GHI_Comm();
	class.SyncDynamicAction = function(player,guid)
		local action class.GetAction(guid);
		local version = 0;
		if action then
			version = action.GetVersion();
		end
	   	comm.Send("NORMAL", player, "DynamicActionVersion", guid, version);
	end

	comm.AddRecieveFunc("DynamicActionVersion",function(player,guid,version)
		local action = class.GetAction(guid);
		local version = 0;
		if action then
			if action.GetVersion() > version then
				comm.Send("BULK", player, "DynamicActionData", guid, action.Serialize());
			end
		end
	end);

	comm.AddRecieveFunc("DynamicActionData",function(player,guid,data)
		local action = GHI_DynamicAction(data);
		class.AddAction(action);
	end);

	return class;
end

