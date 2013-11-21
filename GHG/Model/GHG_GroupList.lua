--===================================================
--
--				GHG_GroupList
--  			GHG_GroupList.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local DATA_SAVE_TABLE = "GHG_GroupData";
GHG_GroupKeys = GHG_GroupKeys or {};


local class;
function GHG_GroupList()
	if class then
		return class;
	end
	class = GHClass("GHG_GroupList");

	local groups = {};

	local savedGroupInfo = GHI_SavedData(DATA_SAVE_TABLE,GetRealmName());
	local event = GHI_Event();
	local comm = GH_Comm();
	local sharer;

	class.LoadFromSaved = function()
		sharer = GH_DataSharer("GHG","GHG_GroupData",class.GetGroup,class.SetGroup,class.GetAllGroupGuids,true);

		local data = savedGroupInfo.GetAll();
		groups = {};

		for index,value in pairs(data) do
			groups[index] = GHG_Group(value);
			if groups[index].IsPlayerMemberOfGuild(UnitGUID("player")) then
				groups[index].Activate();
			end
			event.TriggerEvent("GHG_GROUP_LOADED",index);
		end
	end

	class.GetGroup = function(guid)
		if groups[guid] then
			return groups[guid];
		end
	end

	class.GetAllGroupGuids = function()
		local t = {};
		for i,_ in pairs(groups) do
			table.insert(t,i);
		end
		return t;
	end

	local SetGroup = function(newGroup)
		local guid = newGroup.GetGuid();
		local existingGroup = groups[guid];
		if not(existingGroup) or newGroup.GetVersion() > existingGroup.GetVersion() then
			groups[guid] = newGroup;
			savedGroupInfo.SetVar(guid,newGroup.Serialize())

			if newGroup.IsPlayerMemberOfGuild(UnitGUID("player")) then
				if existingGroup then
					existingGroup.Deactivate();
				end
				newGroup.Activate();
			end

			if newGroup.IsPlayerMemberOfGuild(UnitGUID("player")) or (existingGroup and existingGroup.IsPlayerMemberOfGuild(UnitGUID("player"))) then
				event.TriggerEvent("GHG_GROUP_UPDATED",guid);
			end
		end
	end


	class.SetGroup = function(guid,value)
		if value == nil and type(guid) == "table" then
			value = guid;
		end
		if type(value) == "table" then
			if type(value.IsClass) == "function" then
				if value.IsClass("GHG_Group") then
					assert(value.ReadyForModification(),"Group write access error");
					SetGroup(value);
					sharer.DatasetChanged(value.GetGuid());
				end
			else
				local group = GHG_Group(value);

				SetGroup(group);
				sharer.DatasetChanged(group.GetGuid());
			end
		end
	end



	class.SendKeyTo = function(guid,player)
		if groups[guid] and GHG_GroupKeys[guid] then
			comm.Send("ALERT",player,"GroupKey",guid,GHG_GroupKeys[guid])
		end
	end

	comm.AddRecieveFunc("GroupKey",function(sender,guid,key)
		if not(GHG_GroupKeys[guid]) then
			GHG_GroupKeys[guid] = key;
			if groups[guid] then
				groups[guid].InitializeCryptatedData();
			end
		end
	end);



	return class;
end

GHI_Event("VARIABLES_LOADED",function()

	GHG_GroupList().LoadFromSaved()
end)