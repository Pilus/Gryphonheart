--===================================================
--
--				GHQ_QuestLoot
--  			GHQ_QuestLoot.lua
--
--	  API offering functions for Quest
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHQ_QuestLoot()
	if class then
		return class;
	end
	class = GHClass("GHQ_QuestLoot");
  



	return class;
end