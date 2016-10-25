--
--
--				GHQ_QuestInstance
--  			GHQ_QuestInstance.lua
--
--	  
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local class;
function GHQ_QuestInstance()
	if class then
		return class;
	end
	class = GHClass("GHQ_QuestInstance");
     
	class.GetQuestProgress = function(guid)
	
	end
	



	return class;
end