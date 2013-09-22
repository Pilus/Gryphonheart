--===================================================
--
--				GHQ_ObjectiveRequirment
--  			GHQ_ObjectiveRequirment.lua
--
--	  --
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================


local class;
function GHQ_ObjectiveRequirement(guid)
	if class then
		return class;
	end
	local questList = GHQ_QuestList()
	local quest = questList.GetQuestInfo(guid)
	
	
	class = GHClass("GHQ_ObjectiveRequirement");
     
  
     --called by internal function or API--For LAter versions
	 --Obj GUID Debatable at this point save for later
     --qGUID the quest GUID
     --Obj GUID the objective GUID or Number	 
	 
	return class

end