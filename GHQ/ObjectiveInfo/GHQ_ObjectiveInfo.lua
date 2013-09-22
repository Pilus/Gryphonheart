--===================================================
--
--				GHQ_ObjectiveInfo
--  			GHQ_ObjectiveInfo.lua
--
--	  --
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================


local class;
function GHQ_ObjectiveInfo()
	if class then
		return class;
	end
	class = GHClass("GHQ_ObjectiveInfo");
     
  
     --called by internal function or API--For LAter versions
	 --Obj GUID Debatable at this point save for later
     --qGUID the quest GUID
     --Obj GUID the objective GUID or Number
     class.CheckObjective = function(qGUID,objGUID)
     end
	 
	 class.ObjectiveInfo = function(qGUID, objGUID)
	 
	   return objGUID,type,details
	 end

     class.AddObjective = function (qGUID,type,text,details)
     end

     class.RemoveObjective = function(qGuid,objGUID)

     end
	 
	return class

end