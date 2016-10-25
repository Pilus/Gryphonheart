--
--
--				GHQ_ObjectiveTypeKill
--  			GHQ_ObjectiveTypeKill.lua
--
--	
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--


local class;
function GHQ_ObjectiveTypeKill()
	if class then
		return class;
	end
	
	class = GHClass("GHQ_ObjectiveTypeKill");
     
    local killWatch = {} --can move later
	
	local function SetUpKillEvent()
		GHI_Event("COMBAT_LOG_EVENT_UNFILTERED",function(event, ...) --can modify later
			local  _, type, _,  _, sourceName, _, _, _, destName, _, _ =  ...
			if type == "PARTY_KILL"then 
				--if sourceName == UnitName("player") then
					class.CheckKillWatch(qGuid,objGuid,destName,zone,sourceName)
				--end
			end
		end)
	end
	
	
	class.GetObjective = function(qGuid, objGuid)
	end
	
	--Add a kill objective to a watch list
	--watch list will need to listen to the events UNIT_DIED and PARTY_KILL
	--connect with a questID,Objective ID
	class.AddKillWatch = function(qGuid,objGuid,name,zone,...)
		local t = {
					qGuid = {
							objGuid = {
										name = name,
										zone = zone,
									  },--doing the table wrong fix later.
							},
				   },
		tinsert(t,killWatch[qGuid])
	
	end
	
	--may not need this will need to pass args from the event registered and only under certain conditions so it doesn't spam
	class.CheckKillWatch = function(qGuid,objGuid,target,zone)
	
	 local zone = GetCurrentZone();
		if killWatch[qGuid].objGuid then
			if killWatch[qGuid].objGuid.zone == zone then--need to check for nil zone table input and set to current zone at some point
			  if killWatch[qGuid].objGuid.name == target then
				--do stuff with objective
			  end
			end
				
		end
	
	
	end

	 
	return class

end