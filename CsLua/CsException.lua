--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.CsException = function()
	
	local class = {};
	class.Message = "";
	
	local cstor = function(msg)
		class.Message = msg;
	end

	class.ToString = function()
		return class.Message;
	end

	CsLua.CreateSimpleClass(class, class, "CsException", "CsLua.CsException", cstor, nil, nil, nil, nil)
	
	return class;
end;

CsLua.NotImplementedException = function()
	local class = {};
	class.Message = "Functionality not implemented.";

	class.ToString = function()
		return class.Message;
	end

	CsLua.CreateSimpleClass(class, class, "NotImplementedException", "CsLua.NotImplementedException", nil, nil, nil, nil, {"CsLua.CsException"})
	
	return class;
end;