
table.Foreach = foreach;
table.contains = tcontains;

_G.__isNamespace = true;
Lua = {
    __isNamespace = true;
    Core = _G,
    Strings = _G,
    LuaMath = _G,
	Table = table,

	NativeLuaTable = function() return {__Cstor = function() return {}; end}; end,    
};

Lua.Strings.format = function(str,...)
	-- TODO: replace {0} with %1$s
	str =  gsub(str,"{(%d)}", function(n) return "%"..(tonumber(n)+1).."$s" end);
	return string.format(str,...)
end

strsplittotable = function(d, str)
	return {strsplit(d, str)};
end
strjoinfromtable = function(d, t)
	return strjoin(d, unpack(t));
end
function strsubutf8(str, a, b) -- modified from http://wowprogramming.com/snippets/UTF-8_aware_stringsub_7
    assert(type(str) == "string" and type(a) == "number", "incorrect input strsubutf8");
    assert(not (b) or (type(b) == "number" and b <= strlenutf8(str)), "end pos larger than string lenght", b, strlenutf8(str));

    b = (b or strlenutf8(str));


    local start, _end = #str + 1, #str + 1;
    local currentIndex = 1
    local numChars = 0;
    if a <= 1 then
        start = a;
    end
    if b <= 1 then
        _end = b;
    end

    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        if char > 240 then
            currentIndex = currentIndex + 4
        elseif char > 225 then
            currentIndex = currentIndex + 3
        elseif char > 192 then
            currentIndex = currentIndex + 2
        else
            currentIndex = currentIndex + 1
        end

        numChars = numChars + 1;

        if numChars == a - 1 then
            start = currentIndex;
        end
        if numChars == b then
            _end = currentIndex - 1;
        end
    end
    return str:sub(start, _end)
end

function IsStringNullOrEmpty(str)
	return str == nil or str == "";
end