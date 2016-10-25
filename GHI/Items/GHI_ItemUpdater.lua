--
--
--					GHI Item Updater
--					GHI_ItemUpdater.lua
--					<< Singleton >>
--
--		Updates part of all item data to make it be
--		executeable in the new scripting environment
--	
--				(c)2013 The Gryphonheart Team
--					All rights reserved
--

local class;
function GHI_ItemUpdater()
	local loc = GHI_Loc()
	if class then
		return class;
	end
	class = GHClass("GHI_ItemUpdater");

	local UpdateAction, UpdateProduceItem, UpdateConsumeItem;

	class.UpdateAllItems = function()
		for ID, _ in pairs(GHI_ItemData) do
			class.UpdateItem(ID);
		end
	end

	class.UpdateItem = function(ID)
		local rc = GHI_GetRightClickInfo(ID);
		if type(rc) == "table" then

			for i = 1, #(rc) do
				rc[i] = UpdateAction(rc[i]);
			end

			GHI_SetRightClickInfo(ID, rc);
		end
	end

	UpdateAction = function(action)
		if not (type(action) == "table") then
			return action;
		end

		if action.Type == "script" and action.dynamic_rc_type == "produce_item" then
			local newAction = UpdateProduceItem(action);
			if newAction then
				action = newAction;
			end
		elseif action.Type == "script" and action.dynamic_rc_type == "consume_item" then
			local newAction = UpdateConsumeItem(action);
			if newAction then
				action = newAction;
			end
		end
		return action
	end

	UpdateProduceItem = function(action)
		if (action.autoUpdateVersion or 0) < 1 then
			local recieve_text = { Loot = loc.GET_LOOT, Create = loc.GET_CREATE, Craft = loc.GET_CRAFT, Produce = loc.GET_PRODUCE, Recieve = loc.GET_RECIEVE };
			local c1 = "local ID = \"ITEM_ID\"; if not(ID) then GHI_Message(\"Could not identify source ID\"); return; end;"
			-- touble identification
			local c2 = "local info = GHI_GetRightClickInfo(ID); local t={}; if type(info) == \"table\" then for i=1,#(info) do if info[i].id == \"" .. action.id .. "\"  and info[i].dynamic_rc_type == \"produce_item\" then t=info[i]; end end end";
			-- transfer item data
			local c3 = "UpdateItemInfo(t.id,t[\"item_data\"]);";
			-- init GHP receive item function
			local c4 = ""
			-- recieve item
			local c5 = "if (GHI_ProduceItem(\"" .. action.id .. "\"," .. action.amount .. ")) then ";
			-- show recieve text
			local c6;
			if action.amount > 1 then
				c6 = "GHI_Message(\"" .. (recieve_text[action.loot_text] or "") .. " \"..(GHI_GenerateLink(\"" .. action.id .. "\") or \"unknown\")..\"x" .. action.amount .. ".\"); end";
			else
				c6 = "GHI_Message(\"" .. (recieve_text[action.loot_text] or "") .. " \"..(GHI_GenerateLink(\"" .. action.id .. "\") or \"unknown\")..\".\"); end";
			end

			action.code = { c1 .. " " .. c2 .. " " .. c3 .. " " .. c4 .. " " .. c5 .. " " .. c6 };
			action.autoUpdateVersion = 1;
			return action;
		end
	end

	UpdateConsumeItem = function(action)
		if (action.autoUpdateVersion or 0) < 1 then
			action.code = { "GHI_ConsumeItem(\"" .. action.id .. "\"," .. action.amount .. ");" };
			action.autoUpdateVersion = 1;
			return action;
		end
	end

	return class;
end