--===================================================
--
--				GHI_ScriptEnvList
--  			GHI_ScriptEnvList.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_ScriptEnvList()
	if class then
		return class;
	end
	class = GHClass("GHI_ScriptEnvList");

	local envs = {};
	local limitedEnvs = {};

	class.GetEnv = function(guid, limited)    assert(not(guid=="00x1"),"Incorrect environment lookup");
		if limited == true then
			if limitedEnvs[guid] then
				return limitedEnvs[guid];
			end
			limitedEnvs[guid] = GHI_LimitedScriptEnv(guid);
			return limitedEnvs[guid];
		end
		if envs[guid] then
			return envs[guid];
		end
		envs[guid] = GHI_ScriptEnviroment(guid);
		return envs[guid];
	end

	class.ReloadEnv = function(guid)
		envs[guid] = GHI_ScriptEnviroment(guid);
		return envs[guid];
	end

	return class;
end

