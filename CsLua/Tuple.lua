--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.Tuple = function(...)
    local t = {...};

    local class = {
        __type = "Tuple",
        __IsType = function(t) return t == "Tuple"; end,
        __fullTypeName = "CsLua.Tuple",
    };
    
    for i=1,#(t) do
        class["Item"..i] = t[i];        
    end

    return class;
end