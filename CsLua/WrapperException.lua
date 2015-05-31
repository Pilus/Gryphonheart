--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.WrapperException = function()
	local class = {};
	class.Message = "";
	
	local cstor = function(msg)
		class.Message = msg;
	end

	class.ToString = function()
		return class.Message;
	end

	CsLua.CreateSimpleClass(class, class, "WrapperException", "CsLua.WrapperException", cstor, nil, nil, nil, {"CsLua.CsException"})
	
	return class;
end;