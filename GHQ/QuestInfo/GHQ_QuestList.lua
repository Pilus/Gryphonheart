--===================================================
--
--				GHQ_QuestList
--  			GHQ_QuestList.lua
--
--	  API offering functions for Quest
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

-- should probably look like GHI_ItemInfoList.lua

local QUEST_DATA_SAVED_TABLE = "GHQ_QuestData"
GHQ_SAVED_DATA_LOADED = false
local class;
function GHQ_QuestList()
	if class then
		return class;
	end
	
	class = GHClass("GHQ_QuestList");
    
	local savedQuestData = GHI_SavedData(QUEST_DATA_SAVED_TABLE);--as declared in Toc
	local allQuests = {}
	local activeQuests = {}
		
	class.LoadFromSaved = function()
		if GHQ_SAVED_DATA_LOADED == false then
			local data = savedQuestData.GetAll()
			for i,v in pairs(data) do
				allQuests[v.GUID] = data[i];
			end
			GHQ_SAVED_DATA_LOADED = true
		end
	end
		
	class.AddQuest = function(questInfo,dontSave)
		allQuests[questInfo.GetGUID()] = questInfo;	
		if not(dontSave) then
			class.SaveQuest(questInfo.GetGUID());
		end
	end
	
	local questsSchedueledForSaving = {};
	
	class.SaveQuest = function(guid)
		if guid and allQuests[guid] then
			questsSchedueledForSaving[guid] = true;
		end
	end

	GHI_Timer(function()
		for guid, _ in pairs(questsSchedueledForSaving) do
			local quest = allQuests[guid];
			if (quest) then
				local info = quest.Serialize();
				savedQuestData.SetVar(guid, info);
			end
			questsSchedueledForSaving[guid] = nil;
		end
	end, 2)
	
	class.DumpQuestData = function()
		for i,v in pairs(allQuests) do
			if type(v) == "table" then
				print(i)
				for i2,v2 in pairs(v) do
					print(i2, v2)
				end
			else
				print(i,v)
			end
		end	
	end

	class.GetQuestInfo = function(guid)
		if (allQuests[guid]) then
			local quest = GHQ_QuestInfo(allQuests[guid])
			return quest
		end
	end

	class.LoadQuestFromTable = function(questTable)
		local quest = GHQ_QuestInfo(questTable);
		return quest;
	end
	
	
	class.GetActiveQuest = function(value)
		--return activeQuests[value]
	end
	
	class.SetActiveQuest = function()
	end
	
	class.GetActiveQuestList = function()--return list of active quests and GUIDS
		--do a for loop and check for quests set to active = true, put in table, return
		--return activeQuests --==TABLE RETURN
		local questListing = {}
		for guid, data in pairs(allQuests) do
			local questInfo = {}
			questInfo.GUID = allQuests[guid].GUID or allQuests[guid].GetGUID()
			questInfo.Title = allQuests[guid].Title or allQuests[guid].GetTitle()
			table.insert(questListing,questInfo)
		end
		return questListing
	end

	return class;
end