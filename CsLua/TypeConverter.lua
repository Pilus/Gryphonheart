--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.TypeConverter = {
    EnsureTuple = function(...)
        local t = {...};
        if #(t) == 1 and type(t[1]) == "table" and t[1].__type == 'Tuple' then
            return t[1];
        end
        return CsLua.Tuple(...);
    end,
    MultipleArguments = function(...)
        return ...;
    end
};