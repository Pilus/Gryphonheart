

GHClass = function(n)
	return {
		IsClass = function(n2)
			return n == n2;
		end,
	};
end;

time = function()
	return os.time();
end

wait = function(secs)
	local t = time() + secs;
	while (time() < t) do end
end

reload = function(mod)
	package.loaded[ mod ] = nil;
	require(mod);
end

GHP_Loc = function() return {}; end

GHI_DynamicActionInstanceSet = function() return spy.new() end;

function GHInherit(class,inhClass)
	for i,v in pairs(inhClass) do
		if not(class[i]) then
			class[i] = v;
		end
	end
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