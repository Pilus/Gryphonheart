--
--
--				GHQ_QuestChain
--  			GHQ_QuestChain.lua
--
--	  
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local class;
function GHQ_QuestChain()
	if class then
		return class;
	end
	class = GHClass("GHQ_QuestChain");
    
	class.GetNextQuest = function()
	end
	
	class.SetNextQuest = function(guid)
	
	class.IsChainedQuest = function(guid)
	
	end
	
	class.SetQuest = function(guid)
	
	end
	
	clase.GetQuest = function()
	
	end
	
	
	class.GetQuestInfo = function(guid)
	
	end
	
	

	return class;
end