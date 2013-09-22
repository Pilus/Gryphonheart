--===================================================
--
--				GHQ_QuestAPI
--  			GHQ_QuestAPI.lua
--
--	  API offering functions for Quest
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHQ_QuestAPI()
	if class then
		return class;
	end
	
	
	`class = GHClass("GHQ_QuestAPI");

   

      ---AddQuest, take a name and GUID and add it to the quest log
     class.GHQ_AddQuest= function(name,GUID)

     end


     --Remove Quest, Remove quest from by GUID, Maybe a DeleteQuest to remove it entirely from database
     class.GHQ_RemoveQuest = function(guid)

     end

  


	return class;
end