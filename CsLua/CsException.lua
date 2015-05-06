--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.CsException = function()
	local msg = "";
    local c;
	c = {
        __type = "CsException",
        __IsType = function(t) return t == "CsException"; end,
        __fullTypeName = "CsLua.CsException",
		__Cstor = function(m) msg = m; return c; end,
        ToString = function() return msg; end,
    };
	return c;
end;

CsLua.NotImplementedException = function()
    local c;
	c = {
        __type = "NotImplementedException",
        __IsType = function(t) return t == "NotImplementedException"; end,
        __fullTypeName = "CsLua.NotImplementedException",
        ToString = function() return "Functionality not implemented."; end,
		__Cstor = function() return c; end,
    };
	return c;
end;