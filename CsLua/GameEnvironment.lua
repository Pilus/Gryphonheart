--TargetFile: CsLua.lua

CsLua = CsLua or {};
	
CsLua.GameEnvironment = {
	IsExecutingInGame = true;

	ExecuteLuaCode = function(code)
		local func, errorMessage = loadstring(code);
		if not(func) then
			CsLuaMeta.Throw(CsLua.CsException().__Cstor("Lua compile error:\n" .. (errorMessage or "nil")));
		end

		local success, errorMessage = pcall(func);
		if not(success == true) then
			CsLuaMeta.Throw(CsLua.CsException().__Cstor("Lua execution error:\n" .. (errorMessage or "nil")));
		end
	end
}
