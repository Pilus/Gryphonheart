--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.CsException = function()
	local msg = "";
	local class = {};
	
	local cstor = function(m)
		msg = m;
	end

	class.ToString = function()
		return msg;
	end

	CsLua.CreateSimpleClass(class, class, "CsException", "CsLua.CsException", cstor, nil, nil, nil, nil)
	
	return class;
end;

CsLua.NotImplementedException = function()
	local class = {};

	class.ToString = function()
		return "Functionality not implemented.";
	end

	CsLua.CreateSimpleClass(class, class, "NotImplementedException", "CsLua.NotImplementedException", nil, nil, nil, nil, {"CsLua.CsException"})
	
	return class;
end;