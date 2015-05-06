--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.GetType = function(obj)
    if type(obj) == "table" and obj.__type then
        return obj.__type;
    end
    return type(obj);
end

CsLua.GetFullTypeName = function(obj)
    if type(obj) == "table" and obj.__fullTypeName then
        return obj.__fullTypeName;
    end
end