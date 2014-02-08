--===================================================
--
--				GHQ_QuestInfo
--  			GHQ_QuestInfo.lua
--
--	  API offering functions for Quest
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
-- mirroring style of GHI_ItemInfo_Standard.lua

local class;
function GHQ_QuestInfo(info)
	GHCheck("GHQ_QuestInfo()",{"table"},{info});
	
	class = GHClass("GHQ_QuestInfo");
	local guidCreator = GHI_GUID();
	
	local function AddObjectiveFromList(objectiveType, ...)
		if objectiveType == "GoToZone" then
			local zone, subZone = ...
			return {["Zone"] = zone, ["SubZone"] = subZone}
		end
	end
    	 
	 --------------------------------------------------
	 ----- GUI functions till we have a place ----------
     class.AddQuestToLog= function(name,GUID)

     end
     --Remove Quest, Remove quest from log by GUID, Maybe a DeleteQuest to remove it entirely from database
     class.RemoveQuestFromLog = function(guid)

     end
	 --------------------------------------------------
	 ----- Set Defaults  ------------------------------
	 
	 local author, authorGUID, guid -- author name, author's GUID, and quest GUID
	 local questTitle, logEntry  -- Title of quest and log entry to display
	 local questVersion = 1 -- version number
	 local completed = false -- completion flag
	 local logMat = "Parchment" -- material to display in log
	 local logFont = "Frizqt" -- font for main body text of log
	 local titleFont = "Morpheus" -- font for headings in log entry, including title
	 
	 local requirements = {}  -- table containing requirements
	 local objectives = {} -- table containing objectives
	 local rewards = {} -- table containing reward information 
	 	 
	 --------------------------------------------------
	 ----- Basic Info  --------------------------------
	 
	 class.CloneQuest = function()
		return GHQ_QuestInfo(class.Serialize());
	end
	 
	 class.IsCreatedByPlayer = function()
		return authorGUID == UnitGUID("player");
	end
	  
	 class.GetAuthor = function()
	 	return author
	 end
	 
	 class.GetAuthorGUID = function()
		return authorGUID
	 end
	 
	 class.SetGUID = function(_guid)
	 	guid = _guid
	 -- set GUID
	 end
	 
	 class.GetGUID = function()
	 	return guid
	 -- return GUID
	 end
	 
	 class.IsComplete = function()
		 return completed
	 -- return true if quest completed
	 end
	 
	 class.SetComplete = function(bool)
	 	completed = bool
	 end
	 
	 class.GetQuestVersion = function()
	 	return questVersion
	 end

	 class.IncreaseQuestVersion = function()
	 	
		if not(questVersion) then
			questVersion = 1
		else
			questVersion = questVersion + 1
		end
	 end
	 
	 --------------------------------------------------
	 ----- Quest Log ----------------------------------
	 
	 class.GetLogEntry = function()
		 return logEntry
	 end
	 	 
	 class.SetLogEntry = function(_entry)
		 logEntry = _entry
	 end
	 
	 class.GetLogMaterial = function()
		 return logMat
	 end
	 
	 class.SetLogMaterial = function(_material)
		 logMat = _material
	 end
	 
	 class.GetLogFont = function()
		 return logFont
	 end
	 
	 class.SetLogFont = function(_font)
	 	logFont = _font
	 end
	 
	 class.SetTitle = function(_title)
	 	questTitle = _title
	 end
	 	 
	 class.GetTitle = function()
		return questTitle
	 end
	 
	 class.SetTitleFont = function(_font)
	 	titleFont = _font
	 end
	 
	 class.GetTitleFont = function()
	 	return titleFont
	 end
	 
	 class.GetQuestInfo = function()
	 	return author, guid, questTitle
	 end
	 
	 class.GetLogInfo = function()
	 	return logEntry, logMat, logFont, titleFont
	 end
	 
	 --------------------------------------------------
	 ----------------------- Rewards ------------------	 
	 
	 class.GetChoosableRewards = function()
	 	local chooseRewards = {}
	 	for i, v in pairs(rewards) do
			if v["Auto"] == false then				
				table.insert(chooseRewards,v["Type"])
			end
			return #chooseRewards, unpack(chooseRewards)
		end
	 end
	 
	 class.GetAutoRewards = function()
	 	local autoRewards = {}
	 	for i, v in pairs(rewards) do
			if v["Auto"] == true then				
				table.insert(autoRewards,v["Type"])
			end
			return #autoRewards, unpack(autoRewards)
		end
	 
	 end
	 
	 class.GetQuestReward = function(_index)
	 	return rewards[_index]
	 end
	 
	 class.SetQuestReward = function(_type, automatic, details)
	 	local _reward = {}
		_reward["Type"] = _type
		_reward["Auto"] = automatic
		_reward["Details"] = details
		
		table.insert(rewards,_reward)
	 end
	 
	 --------------------------------------------------
	 ----- Objectives ---------------------------------  	 
	 class.AddObjective = function(objType, details, number)
		local obj = {}
		obj["Type"] = objType
		obj["Details"] = details
		obj["Progress"] = 0
		--TODO add total needed to save data
		obj["Complete"] = false
		if type(number) == "number" then
			table.insert(objectives, number,obj)
		else
	  		table.insert(objectives,obj)
		end
	 end
	 	 
	 class.GetNumObjectives = function()
	 	return #objectives
	 end
	 
	 class.GetObjective = function(number)
	 	return objectives[number]	 		 		 
	 end	 
	 	 	 	 
	 class.SetObjective = function(number, reqType, details, ...)
	 
		objectives[number]["Type"] = reqType
		
		if type(details) == "table" then
			objectives[number]["Details"] = details
		elseif (...) ~= nil then
			local objDetails = {details, ...}
			objectives[number]["Details"] = objDetails
		end
		
	 end
	 
	 class.GetObjectiveType = function(number)
		return objectives[number]["Type"]	 
	 end
	 
	 class.SetObjectiveType = function(number, reqType) 
	 	objectives[number]["Type"] = reqType
		
	 end
	 
	 class.GetObjectiveDetails = function(number)
			return objectives[number]["Details"]
	 end
	 
	 class.SetObjectiveDetails = function(number, details, ...)
	 	
	 	if type(details) == "table" then
			objectives[number]["Details"] = details
		elseif (...) ~= nil then
			local reqDetails AddObjectiveFromList(class.GetObjectiveType(number), details, ...)
			objectives[number]["Details"] = objDetails
		end
		
	 end
	 
	 class.GetObjectiveProgress = function(number)
		return objectives[number]["Progress"]
	 end
	 
	 class.SetObjectiveProgress = function(number, progress)
	 	objectives[number]["Progress"] = progress
	-- set progress for the indicated objective
	 end
	 
	 ----------------------------------------------------
	 ----- Requirements --------------------------------- 
	 
	 class.AddRequirement = function(reqType, details, number)
	 	local req = {}
		req["Type"] = reqType
		req["Details"]  = details
		if type(number) == "number" then
			table.insert(requirements, number,req)
		else
	  		table.insert(requirements,req)
		end
	 end
	 
	 class.GetRequirement = function(number)
	 	return requirements[number]	 		 		 
	 end
	 
	 class.GetNumRequirements = function()
	 	if requirements == nil then
	 		return 0
		else
			return #requirements
		end
	 end	 
	 class.GetRequirementType = function(number)
		return requirements[number]["Type"]	 
	 end
	 	 
	 class.GetRequirementDetails = function(number)
			return requirements[number]["Details"]
	 end
	 
	 class.SetRequirement = function(number, reqType, details, ...)
	 
		requirements[number]["Type"] = reqType
		
		if type(details) == "table" then
			requirements[number]["Details"] = details
		elseif (...) ~= nil then
			local objDetails = {details, ...}
			requirements[number]["Details"] = objDetails
		end
		
	 end
	 
	 class.SetRequirementType = function(number, reqType)
	 
	 	requirements[number]["Type"] = reqType
		
	 end
	 
	 class.SetRequirementDetails = function(number, details, ...)
	 	
	 	if type(details) == "table" then
			requirements[number]["Details"] = details
		elseif (...) ~= nil then
			local reqDetails = {details, ...}
			requirements[number]["Details"] = objDetails
		end
		
	 end
		 
	 --what else?

     --need a complete objective may need to put in objectiveAPI

    --[[ class.GetAPI = function()
		local a = {};
		for i, f in pairs(api) do
			a[i] = f;
		end
		return a;
	end    ]]--
	
	class.Serialize = function(info)
		info = info or {};
			 info.author = author
			 info.authorGUID = authorGUID
			 info.GUID = guid
			 info.Version = questVersion
			 info.Title = questTitle
			 info.Completed = completed
			 info.LogEntry = logEntry
			 info.Material = logMat
			 info.LogFont = logFont
			 info.TitleFont = titleFont
			 info.Requirements = requirements
			 info.Objectives = objectives
			 info.Rewards = rewards
		return info;
	end
	
 	--------------------------------------------------
	----- Initialize  --------------------------------
	
	 info = info or {};
	 author = info.author or UnitName("player")
	 authorGUID = info.authorGUID or UnitGUID("player")
	 guid = info.GUID or GHI_GUID().MakeGUID()
	 questVersion = info.Version or questVersion
	 completed = info.Completed or completed
	 questTitle = info.Title or questTitle
	 logEntry = info.LogEntry or logEntry
	 logMat = info.Material or logMat
	 logFont = info.LogFont or logFont
	 titleFont = info.TitleFont or titleFont
	 requirements = info.Requirements or requirements
	 objectives = info.objectives or objectives
	 rewards = info.Rewards or rewards

	return class;
end