--
--
--				GHQ_ObjectiveTypeCollect
--  			GHQ_ObjectiveTypeCollect.lua
--
--	
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--


local class;
function GHQ_GHQ_ObjectiveTypeCollect()
	if class then
		return class;
	end
	class = GHClass("GHQ_ObjectiveTypeCollect");
     local collectWatch = {} 

	local function SetUpLootEvent()
	--note can used the LOOT_OPEND,LOOT_CLOSED events later and this http://wowprogramming.com/docs/api_categories#loot
	--WE had a loot window in the old GHU subaddon but i DONOT have that code anymore
	
		GHI_Event("CHAT_MSG_LOOT",function(...)
			local event, message = ...
			message = strlower(message)
			--if string.find(message,"thunder ale") then
				class.CheckCollectWatch(qGuid,objGuid,message,"LootFromMsg")
			--end
		end)
	end
  
	class.GetObjective = function(qGuid, objGuid)
	end
	
	--Add a collect objective to a watch list
	--watch list will need to listen to the loot events, need to look up later
	--connect with a questID,Objective ID
	class.AddCollectWatch = function(qGuid,objGuid,name,zone,...)
	end
	
	--may not need this will need to pass args from the event registered and only under certain conditions so it doesn't spam
	class.CheckCollectWatch = function(qGuid,objGuid,...)
	
		local loot,lootType = ... ---lootype being "LootFromMsg",LootFromCorpse,etc
		
		if lootType == "LootFromCorpse" then
		elseif lootType = "LootFromMsg" then
		
		end
		--need to do things Akin to how i did in the TypeKill.lua file but too early for me to think it out.
	
	end

	 
	return class

end