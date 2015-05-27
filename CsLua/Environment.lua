--TargetFile: CsLua.lua

CsLua = CsLua or {};

local environmentClass;
CsLua.Environment = function()
	if environmentClass then
		return environmentClass;
	end 
	
	local class = {};
	
	class.IsExecutingInGame = true;

	class.ExecuteLuaCode = function(code)
		local func, errorMessage = loadstring(code);
		if(not func) then
			CsLua.CsException.__Cstor("Lua compile error:\n" .. (errorMessage or "nil"));
		end

		local success, errorMessage = pcall(func);
		if(not success) then
			CsLua.CsException.__Cstor("Lua execution error:\n" .. (errorMessage or "nil"));
		end
	end

	CsLua.CreateSimpleClass(class, class, "Environment", "CsLua.Environment", nil, nil, nil, nil, nil)
	
	environmentClass = class;
	return class;
end;