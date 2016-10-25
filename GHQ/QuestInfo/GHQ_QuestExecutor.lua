--
--
--				GHQ_QuestExecutor
--  			GHQ_QuestExecutors.lua
--
--	  API for quest actions executing.
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--


local class;
function GHQ_QuestExecutor()
	if class then
		return class;
	end
	class = GHClass("GHQ_QuestExecutor");
    
	
	class.AcceptQuest = function(guid)--execute accepting a quest
	end
	
	class.DeclineQuest = function(guid)
	end
	
	class.CheckQuest = function()
	end
	




	return class;
end