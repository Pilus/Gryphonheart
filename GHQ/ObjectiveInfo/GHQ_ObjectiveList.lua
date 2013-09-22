--===================================================
--
--				GHQ_ObjectiveList
--  			GHQ_ObjectiveList.lua
--
--	
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================


local class;
function GHQ_ObjectiveList()
	if class then
		return class;
	end
	class = GHClass("GHQ_ObjectiveList");
     
  
	class.GetObjective = function(qGuid, objGuid)
	end
	
	class.GetObjective = function(qGuid, objGuid,details)
	end

	 
	return class

end