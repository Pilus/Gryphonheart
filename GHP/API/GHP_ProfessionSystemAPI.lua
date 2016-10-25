--
--
--				GHP_ProfessionSystemAPI
--  			GHP_ProfessionSystemAPI.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--


function GHP_ProfessionSystemAPI(userGuid)
	local class = GHClass("GHP_ProfessionSystemAPI");

	local list = GHP_ProfessionSystemList();

	class.GetNumProfessionSystems = function()
		return #(list.GetSystemGuids());
	end

	class.GetProfessionSystemDetails = function(index)
		local guid;
		if type(index) == "string" then
			guid = index;
		elseif type(index) == "number" then
			guid = list.GetSystemGuids()[index];
		end

		if guid then
			local system = list.GetSystem(guid);
			if system then
				return system.GetDetails();
			end
		end
	end

	class.LearnProfession = function(systemGuid,...)
		local system = list.GetSystem(systemGuid);
		if system then
			if system.IsCreatedByUser(userGuid) then
				system.LearnProfession(...);
			else
				error("no access")
			end
		end
	end

	class.LearnAbility = function(systemGuid,...)
		local system = list.GetSystem(systemGuid);
		if system and system.IsCreatedByUser(userGuid) then
			system.LearnAbility(...);
		end
	end


	return class;
end

