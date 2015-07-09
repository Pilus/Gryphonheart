--TargetFile: CsLua.lua

CsLua = CsLua or {};
	
CsLua.GameEnvironment = {
	IsExecutingInGame = true;

	ExecuteLuaCode = function(code)
		local func, errorMessage = loadstring(code);
		if(not func) then
			CsLua.CsException().__Cstor("Lua compile error:\n" .. (errorMessage or "nil"));
		end

		local success, errorMessage = pcall(func);
		if(not success) then
			CsLua.CsException().__Cstor("Lua execution error:\n" .. (errorMessage or "nil"));
		end
	end
}
