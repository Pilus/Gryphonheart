--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.Wrapping = CsLua.Wrapping or {};

CsLua.Wrapping.WrapperException = function()
	local class = {};
	class.Message = "";
	
	local cstor = function(msg)
		class.Message = msg;
	end

	class.ToString = function()
		return class.Message;
	end

	CsLua.CreateSimpleClass(class, class, "WrapperException", "CsLua.Wrapping.WrapperException", cstor, nil, nil, nil, {{"CsLua.CsException"}})
	
	return class;
end;