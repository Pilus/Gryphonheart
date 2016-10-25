--
--
--				GHI_Crypt
--  			GHI_Crypt.lua
--
--	Class for encryption and decryption of strings
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--


local AREA = 91;
function GHI_Crypt(cryptKey,swapKey)
	local class = GHClass("GHI_Crypt");



	local function GetCharSeqLen(n) -- charlen as according to http://en.wikipedia.org/wiki/UTF-8
		if n < 192 then
			return 1;
		elseif n < 224 then
			return 2;
		elseif n < 240 then
			return 3;
		else
			return 4;
		end
	end

	local LN_AREA = 61;
	local IsLetterOrNumber = function(char)
		local b = string.byte(char);
		return (b >= 48 and b <= 57) or (b >= 65 and b <= 90) or (b >= 97 and b <= 122);
	end

	local NumToChar = function(num)
		if num < 10 then
			return string.char(num+48)
		elseif num < 36 then
			return string.char(num+55)
		elseif num < LN_AREA+1 then
			return string.char(num+61)
		else
			print("Crypt. Outside of area.",num)
		end
	end

	local CharToNum = function(char)
		local b = string.byte(char);
		if b >= 48 and b <= 57 then
			return b-48;
		elseif b >= 65 and b <= 90 then
			return b-55;
		elseif b >= 97 and b <= 122 then
			return b-61;
		else
			print("Crypt. Not letter or number.",b)
		end
	end
	--[[for i=1,128 do
		local c = string.char(i);
		if IsLetterOrNumber(c) then
			if not(c == NumToChar(CharToNum(c))) then
				print("error",i);
			end
		end
	end
	print("done")  --]]

	local AreaMod = function(num)
		while (num < 0) do
			num = num + LN_AREA + 1;
		end
		while (num > LN_AREA) do
			num = num - (LN_AREA + 1);
		end
		return num
	end

	local Rotate = function(char, i)
	  	local num = CharToNum(char);
		local newNum = AreaMod(num + i);
		return NumToChar(newNum);
	end

	local EncryptLettersAndNumbers = function(msg)
		local m = "";
		local i = 1;
		while i <= msg:len() do
			local char = string.sub(msg,i,i);
			local n = string.byte(msg, i);
			if IsLetterOrNumber(char) then
				m = m .. Rotate(char, i*cryptKey)
				i = i + 1;
			elseif (n > 190) then
				local csl = GetCharSeqLen(n);
				m = m .. strsub(msg, i, i + csl - 1);
				i = i + csl;
			else
				m = m .. char;
				i = i + 1;
			end
		end
		return "cv2"..m.."xx";
	end

	local DecryptLettersAndNumbers = function(msg)
		if not(string.startsWith(msg,"cv2") and string.endsWith(msg,"xx")) then
			error("Incorrect string for decryption.")
		end
		msg = strsub(msg,4,-3);
		local m = "";
		local i = 1;
		while i <= msg:len() do
			local char = string.sub(msg,i,i);
			local n = string.byte(msg, i);
			if IsLetterOrNumber(char) then
				m = m .. Rotate(char, -i*cryptKey)
				i = i + 1;
			elseif (n > 190) then
				local csl = GetCharSeqLen(n);
				m = m .. strsub(msg, i, i + csl - 1);
				i = i + csl;
			else
				m = m .. char;
				i = i + 1;
			end
		end
		return m;
	end

	class.Encrypt = function(msg, onlyLettersAndNumbers)
		if onlyLettersAndNumbers then
			return EncryptLettersAndNumbers(msg);
		end
		-- 33 to 122
		local m = "";
		local ignore = 0;
		local i = 1;
		while i <= msg:len() do
			local n = string.byte(msg, i);
			if n == 124 then
				m = m .. strsub(msg, i, i + 1);
				i = i + 1;
			elseif (n > 190) then
				local csl = GetCharSeqLen(n);
				m = m .. strsub(msg, i, i + csl - 1);
				i = i + csl - 1;
			else
				local c = n;
				n = mod(((n - 32) + AREA) + cryptKey + i, AREA) + 32;
				m = m .. string.char(n);
			end
			i = i + 1;
		end

		return m;
	end

	class.Decrypt = function(msg)
		if string.startsWith(msg,"cv2") and string.endsWith(msg,"xx") then
			return DecryptLettersAndNumbers(msg);
		end
		local s = "";
		local ignore = 0;
		local i = 1;
		while i <= msg:len() do
			local n = string.byte(msg, i);
			if n == 124 then -- skip |
				s = s .. strsub(msg, i, i + 1);
				i = i + 1;
			elseif (n > 190) then -- skip longer chars
				local csl = GetCharSeqLen(n);
				s = s .. strsub(msg, i, i + csl - 1);
				i = i + csl - 1;
			else
				local t = n;
				local plus = AREA;
				while (plus < i + AREA) do plus = plus + AREA; end
				n = mod(((n - 32) - (cryptKey + i)) + plus, AREA) + 32;
				s = s .. string.char(n);
			end
			i = i + 1;
		end
		return s;
	end

	local MsgToTable = function(msg)
		local t = {}
		for i=1,msg:len() do
			t[i] = strsub(msg,i,i);
		end
		return t;
	end

	local Swap = function(t,i,j)
		local x = t[i];
		t[i] = t[j];
		t[j] = x;
	end

	class.Swap = function(msg)
		local t = MsgToTable(msg);
		local half = math.floor(#(t)/2);
		for i=1,half do
			local j = mod(i*swapKey ,half)+1+half;
			Swap(t,i,j);
		end
		return string.join("",unpack(t));
	end

	class.Deswap = function(msg)
		local t = MsgToTable(msg);
		local half = math.floor(#(t)/2);
		for i=half,1,-1 do
			local j = mod(i*swapKey ,half)+1+half;
			Swap(t,i,j);
		end
		return string.join("",unpack(t));
	end

	return class;
end


function GHI_CryptTest(str,k1,k2)
	local crypt = GHI_Crypt(94,78);
	local Encrypt;
	Encrypt = function(v)
		if type(v) == "string" then
			local swap = crypt.Swap(v);
			return crypt.Encrypt(swap);
		elseif type(v) == "table" then
			local t = {}
			for i,vv in pairs(v) do
				t[i] = Encrypt(vv);
			end
			return t;
		else
			return v;
		end
	end
	local Decrypt;
	Decrypt = function(v)
		if type(v) == "string" then
			local decrypted = crypt.Decrypt(v);
			return crypt.Deswap(decrypted)
		elseif type(v) == "table" then
			local t = {}
			for i,vv in pairs(v) do
				t[i] = Decrypt(vv);
			end
			return t;
		else
			return v;
		end
	end

	--local str = "This is a testing string";
	--[[local temp = Encrypt(str);
	local res = Decrypt(temp);
	print(str == res)   --]]

	local temp = crypt.Encrypt(str, true);
	local res = crypt.Decrypt(temp);
	--print(temp);
	--print(res);
	return str == res;
end
-- /script for i=1,100 do if not(GHI_CryptTest("0This is a test of something A-Zz",i,1)) then print(i) end end print("done");
