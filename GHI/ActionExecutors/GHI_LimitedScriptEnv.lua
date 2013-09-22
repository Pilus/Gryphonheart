--===================================================
--
--				GHI_LimitedScriptEnv
--  			GHI_LimitedScriptEnv.lua
--
--		Extra limited scripting environment
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local patterns = {
	"%-%-%[%[[^%]]*%]%]",
	"%[%[[^%]]*%]%]",
	"%-%-[^\n]*\n",
	"\"[^\"]*\"",
	"'[^']*'",
};

local CleanCode = function(code)
	for _,p in pairs(patterns) do
		code = string.gsub(code,p,"");
	end
	return code;
end
local s = "abc[[def]]ghi--[[aaa\n\"bbb--dd]]ccc--abc]]def\nddd\"egef\"eee'test'fff";
local r = "abcghicccdddeeefff";
assert(CleanCode(s) == r,	"Clean code unittest",CleanCode(s),r)

local disallowedWords = {"function","for","while","do", }
local function CheckCode(code)
	code = " "..CleanCode(code).." ";
	for _,w in pairs(disallowedWords) do
		if string.match(code,"%s"..w.."%s") then
			return false;
		end
	end
	return true;
end

function GHI_LimitedScriptEnv(ownerGuid)
	local class = GHClass("GHI_LimitedScriptEnv");

	local environment = {
		assert = assert,
		collectgarbage = collectgarbage,
		date = date,
		error = error,
		--getmetatable=getmetatable,
		--next=next,
		--newproxy=newproxy,
		--pcall=pcall,
		select = select,
		--setmetatable=setmetatable,
		time = time,
		type = type,
		unpack = unpack,
		print = print,

		-- Math functions
		abs = abs,
		acos = acos,
		asin = asin,
		atan = atan,
		atan2 = atan2,
		ceil = ceil,
		cos = cos,
		deg = deg,
		exp = exp,
		floor = floor,
		frexp = frexp,
		ldexp = ldexp,
		log = log,
		log10 = log10,
		max = max,
		min = min,
		mod = mod,
		rad = rad,
		random = random,
		sin = sin,
		sqrt = sqrt,
		tan = tan,
		math = math,

		-- string functions
		format = format,
		gsub = gsub,
		strbyte = strbyte,
		strchar = strchar,
		strfind = strfind,
		strlen = strlen,
		strlower = strlower,
		strmatch = strmatch,
		strrep = strrep,
		strrev = strrev,
		strsub = strsub,
		strupper = strupper,
		tonumber = tonumber,
		tostring = tostring,
		strlenutf8 = strlenutf8,
		strtrim = strtrim,
		strsplit = strsplit,
		strjoin = strjoin,
		strconcat = strconcat,
		tostringall = tostringall,
		string = string,

		-- table functions
		getn = getn,
		sort = sort,
		tContains = tContains,
		tinsert = tinsert,
		tremove = tremove,
		wipe = wipe,
		["#"] = table.getn,
		table = table,

		-- bit functions
		bit = bit,

		SetCVar = SetCVar,
		GetCVar = GetCVar,
		_SetActionAPIItemGuid = function() end, -- temp replacement

		GHI_DoScript = function(code,delay,guid) return class.ExecuteScript(code,delay,guid,true); end,
		DEFAULT_CHAT_FRAME = { AddMessage = function(self, ...) DEFAULT_CHAT_FRAME:AddMessage(...); end },
		UIErrorsFrame = { AddMessage = function(self, ...) UIErrorsFrame:AddMessage(...); end },
		SecondsToTime = SecondsToTime,
		GetZoneText = GetZoneText,
		GetRealZoneText = GetRealZoneText,
		GetSubZoneText = GetSubZoneText,
	};

	--- functions
	local headers = {};
	local count = 0;
	local suspendedWarningPrinted = false;
	local codeWarningPrinted = false;
	local Execute = function(code, headerGuid, skipEndHeader)
		if count > 100 then
			if not(suspendedWarningPrinted) then
				print("Script suspended")
				suspendedWarningPrinted = true;
			end
			return;
		end

		count = count + 1;

		if headers[headerGuid] then
			code = (headers[headerGuid].start or "") .. code;
			if not(skipEndHeader) then
				code = code.. (headers[headerGuid]._end or "");
			end
		end

		-- check the code does not contain any functions or loops.
		if not(CheckCode(code)) then
			if not(codeWarningPrinted) then
				print("One or more pieces of code have been blocked")
				codeWarningPrinted = true;
			end
			return;
		end

		local codeFunc, err = loadstring(code);
		if not (codeFunc) then
			print("Error in GHI update sequence");
			error(err);
		end

		setfenv(codeFunc, environment);
		local ok,ret1,ret2,ret3,ret4,ret5 =  pcall(codeFunc);
		if ok then
			count = count - 1;
			return ret1,ret2,ret3,ret4,ret5;
		else
			local startHeader = "";
			if headerGuid then
				startHeader = headers[headerGuid].start;
			end
			local area,line,errMsg = string.match(ret1,"^%[string \"(.*)\"%]:(%d*):(.*)$");
			local _,hLineCount = string.gsub(startHeader,"\n","\n")
			print("Error in GHI update sequence. Line.",(line or 0)-hLineCount,ret1);
		end
		count = count - 1;

		return;
	end
	GHI_Timer(function() count = 0; end, 1)

	class.ExecuteScript = function(code, _, headerGuid, skipEndHeader)
		return Execute(code, headerGuid, skipEndHeader);
	end

	class.SetValue = function(name, val)
		GHCheck("GHI_LimitedScriptEnviroment.SetValue", { "string", "any" }, { name, val });
		local codeFunc = function() _G[name] = val end;
		setfenv(codeFunc, environment);
		return codeFunc();
	end

	class.GetValue = function(name)
		GHCheck("GHI_LimitedScriptEnviroment.GetValue", { "string" }, { name });
		local codeFunc = function() return _G[name]; end;
		setfenv(codeFunc, environment);
		return codeFunc();
	end
	environment._G = environment;


	local apiHandlers = {
		GHI_GameWorldData(),
		GHI_MiscAPI(),
		GHI_ClassAPI(),
		GHI_ContainerAPI(),
	}
	for _, handler in pairs(apiHandlers) do
		local api = handler.GetAPI(class);
		for i, v in pairs(api) do
			class.SetValue(i, v);
		end
	end
	environment.DoScript = environment.GHI_DoScript;

	class.SetHeaderApi = function(guid, headerCode, endCode)
		headers[guid] = { start = headerCode, _end = endCode };
	end

	class.GotHeaderApi = function(guid)
		if headers[guid] then return true; end
	end

	class.GetOwner = function()
		return ownerGuid;
	end

	return class;
end

