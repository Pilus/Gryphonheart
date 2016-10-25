--
--
--				GHI_BBCodeDeserializer
--  			GHI_BBCodeDeserializer.lua
--
--	Converts simple BBCode to tables.
--
-- 		(c)2014 The Gryphonheart Team
--			All rights reserved
--

local class;
function GHI_BBCodeDeserializer()
	if class then
		return class;
	end
	class = GHClass("GHI_BBCodeDeserializer");

	local ConvertNumberInStringToNumber = function(str)
		local num = tonumber(str);
		if tostring(num) == str then
			return num;
		end
		return str;
	end

	local States = {
		element = 1,
		isolateArgs = 2,
		inner = 3,
	};

	local TransitionTable = {
		{
			States.element,
			"%[(%a[%a%d]*)[ ]*/%]",
			States.element,
			function(str, pointer, t, tag)
				table.insert(t, { tag = tag, args = {}});
				return pointer;
			end,
		},
		{
			States.element,
			"%[(%a[%a%d]*)[ ]*%]",
			States.inner,
			function(str, pointer, t, tag)
				table.insert(t, { tag = tag, args = {}});
				return pointer;
			end,
		},
		{
			States.element,
			"%[(%a[%a%d]*)[ ]+%a",
			States.isolateArgs,
			function(str, pointer, t, tag)
				table.insert(t, { tag = tag, args = {}});
				return pointer - 1;
			end,
		},
		{
			States.element,
			"%[/",
			nil,
			function(str, pointer, t)
				return pointer - 3;
			end,
		},
		{
			States.element,
			"([^%[\124]+)",
			States.element,
			function(str, pointer, t, arg1)
				table.insert(t, arg1);
				return pointer;
			end,
		}, -- 5
		{
			States.isolateArgs,
			'[ ]*(%a[%a%d]*)="([^"]*)"',
			States.isolateArgs,
			function(str, pointer, t, argName, argValue)
				t[#(t)].args[argName] = ConvertNumberInStringToNumber(argValue);
				return pointer;
			end,
		},
		{
			States.isolateArgs,
			'[ ]*(%a[%a%d]*)=([^ ^/^%]]*)[ /%]]',
			States.isolateArgs,
			function(str, pointer, t, argName, argValue)
				t[#(t)].args[argName] = ConvertNumberInStringToNumber(argValue);
				return pointer - 1;
			end,
		},
		{
			States.isolateArgs,
			"[ ]*%]",
			States.inner,
			function(str, pointer, t)
				return pointer;
			end,
		},
		{
			States.isolateArgs,
			"[ ]*/%]",
			States.element,
			function(str, pointer, t)
				return pointer;
			end,
		},
		{
			States.inner,
			"%[",
			States.element,
			function(str, pointer, t)
				local elements, subLen = class.BBCodeToTable(string.sub(str, pointer - 1));
				for _, element in pairs(elements) do
					table.insert(t[#(t)], element);
				end

				local a, b = strfind(str, "%[/" .. t[#(t)].tag .. "%]", pointer - 1 + subLen)
				--if a ~= pointer - 1 + subLen then print("Malformed bbcode", a, "~=", pointer, "-", 1, "+", subLen); end

				return b + 1;
			end,
		},
		{
			States.inner,
			"([^%[]+)",
			States.inner,
			function(str, pointer, t, text)
				table.insert(t[#(t)], text);
				return pointer;
			end,
		}, -- 10
	};

	class.BBCodeToTable = function(html)
		local t = {};
		local state = States.element;
		local pointer = 1;

		while (pointer <= string.len(html)) do
			local noAction = true;
			for i, transition in pairs(TransitionTable) do
				if transition[1] == state then
					local a, b = strfind(html, transition[2], pointer);
					if a == pointer then
						local arg1, arg2, arg3, arg4 = strmatch(html, transition[2], pointer);
						pointer = transition[4](html, pointer + (b - a) + 1, t, arg1, arg2, arg3, arg4);
						if transition[3] then
							state = transition[3];
						else
							return t, pointer;
						end

						noAction = false;
						break;
					end
				end
			end

			if noAction then
				error("Could not find action for html to table deserialization. "..(strsub(html, pointer, pointer + 2) or ""));
			end
		end

		return t, pointer;
	end

	return class;
end
