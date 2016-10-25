--
--
--				GHI_Packer
--				GHI_Packer.lua
--
--	Packing of serialized information into a string.
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--
local btype = function(s)
	if s == true then
		return "true";
	elseif s == false then
		return "false";
	else
		return type(s);
	end
end

local class;
function GHI_Packer()
	if class then
		return class;
	end
	class = GHClass("GHI_Packer");

	local function CheckSum(s)
		local c = 0;
		for i = 0, s:len() do
			c = bit.bxor(c, string.byte(s, i));
		end
		return c;
	end

	local escC = "|"
	local shortWords = { escC, "\n", "{", "}", "~", "\r", "=", "Interface\\\\Icons\\\\", "<HTML><BODY><P>", "</P></BODY></HTML>", "\"text1\"", "\"rightClicktext\"", "\"version\"", "\"type_name\"", "\"scriptBefore", "\\n        ", "\"exportID\"", "IMPORT_REQ", "GHI_MiscData.Import", "ration_size", "\"rightClick\"", "\"requireTarget\"", "\"scriptAfter\"", "\"creater\"", "\"amount\"", "\"copyable\"", "\"quality\"", "\"white1\"", "\"white2\"", "\"locked\"", "\"stackSize\"", "\"item\"", "\"details\"", "\"code\"", "\"icon\"", "\"consumed\"", "\"multible\"", "\"Type\"", "Interface\\\\\\\\Icons\\\\", } -- "\"\""

	local EscIndex = function(n)
		if n < 15 then
			return escC .. string.char(n + 48);
		elseif n < 29 then
			return escC .. string.char(n + 49);
		elseif n < 32 then
			return escC .. string.char(n + 50);
		else
			return escC .. string.char(n + 51);
		end
	end

	local ApplyEscapeCodes = function(s)
		for i = 1, #(shortWords) do
			s = gsub(s, shortWords[i], EscIndex(i));
		end
		return s;
	end
	local RemoveEscapeCodes = function(s)
		for i = #(shortWords), 1, -1 do
			s = gsub(s, EscIndex(i), shortWords[i]);
		end
		return s;
	end

	class.TableToString = function(t, addCheck, skipNumberIndexes)
		local s = "{";
		for index, value in pairs(t) do
			if value == "!first" then
				index = format("\"%s\"", index);
			end
			if type(index) == "string" then
				index = format("\"%s\"", index);
			end
			if type(value) == "table" then
				if skipNumberIndexes and type(index) == "number" then
					s = format("%s%s,", s, class.TableToString(value, false, skipNumberIndexes));
				else
					s = format("%s[%s]=%s,", s, index, class.TableToString(value, false, skipNumberIndexes));
				end
			elseif type(value) == "number" then
				s = format("%s[%s]=%s,", s, index, value);
			elseif type(value) == "nil" then
				s = format("%s[%s]=%s,", s, index, "nil");
			elseif type(value) == "boolean" then
				s = format("%s[%s]=%s,", s, index, btype(value));
			elseif type(value) == "string" then
				value = gsub(value, "\\", "\\\\");
				value = gsub(value, "\n", "\\n");
				value = gsub(value, "\r", "\\r");
				value = gsub(value, "\"", "\\\"");
				s = format("%s[%s]=\"%s\",", s, index, value);
			end
		end
		s = format("%s}", s);


		if not (addCheck == false) then --print(s)
			s = ApplyEscapeCodes(s)
			s = s:len() .. "," .. CheckSum(s) .. s;
		end
		return s;
	end

	class.StringToTable = function(s)
	-- remove and validate the checksum
		local a = string.find(s, EscIndex(3));
		if not (a) then return { "Corrupt Item Data. Err01. Start: " .. strsub(s, 0, 20) } end
		local meta = string.sub(s, 0, a - 1);
		if not (meta) then return { "Corrupt Item Data. Err02." } end
		local sum, csum = string.split(",", meta);
		s = string.sub(s, a);
		sum = tonumber(sum);
		csum = tonumber(csum);
		if not (sum) or not (sum == s:len()) then return { "Corrupt Item Data. Err03." }; end
		if not (csum) or not (csum == CheckSum(s)) then return { "Corrupt Item Data. Err04." }; end

		s = RemoveEscapeCodes(s);

		s = (s or "{\"Corrupt Item Data. Err05.\"}");


		T = nil;
		RunScript("T=" .. s);
		return T or { "Corrupt Item Data. Err06." };
	end

	return class;
end

