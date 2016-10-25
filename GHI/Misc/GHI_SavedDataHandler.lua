--
--
--			GHI_SavedDataHandler
--			GHI_SavedData.lua
--
--	Dynamic handler of saved data
--
--		(c)2013 The Gryphonheart Team
--			All rights reserved
--
local UPGRADE_DETECTED = false;
local ERROR_MSG = "GHI ERROR. PARTIAL DATA CORRUPTION!";
local VARS_LOADED;
GHI_Event("VARIABLES_LOADED", function()
	if type(GHI_ActionBarData) == "table" then
		UPGRADE_DETECTED = true;
	end
	VARS_LOADED = true;
end)

function GHI_SavedData(saveTableName,subTableName,shared)
	GHCheck("GHI_SavedData(saveTableName)", { "string" }, { saveTableName });
	local class = GHClass("GHI_SavedData")
	local data = {};
	local cs_n;
	local loaded;

	local GenerateCS;
	GenerateCS = function(v)
		local t = type(v);
		if t == "table" then
			local c = 0;
			for i, v2 in pairs(v) do
				local c2 = math.floor(GenerateCS(v2) * (GenerateCS(i) / 10));
				c = c + c2;
			end
			return mod(c, 10 ^ 9);
		elseif t == "number" then
			return math.floor(v * 1.5);
		elseif t == "string" then
			local c = 0;
			for i = 1, string.len(v) do
				c = c + string.byte(v, i) * i;
			end
			return c;
		elseif t == "function" then
			return 0;
		elseif t then
			return 2;
		else
			return 3;
		end
	end

	local UCS = function(s)
		local c = "";
		for i = 1, string.len(s) do
			local v = string.byte(s, i);
			if v > 80 then
				c = c .. string.char(v - mod(i, 5));
			else
				c = c .. string.char(v - mod(i, 5));
			end
		end
		return c;
	end

	local Load = function()
		if subTableName then
			local t = _G[saveTableName] or {};
			data = t[subTableName] or {};
			t[subTableName] = data;
			_G[saveTableName] = t;
		else
			data = _G[saveTableName] or {};
			_G[saveTableName] = data;
		end

		cs_n = GenerateCS(saveTableName) + GenerateCS(UnitName("player")) + GenerateCS(GetRealmName());
		GHI_CS = GHI_CS or {};
		GHI_CS2 = GHI_CS2 or {}
		local cr = false;

		if not (UPGRADE_DETECTED) then
			local cs;
			if shared then
				cs = GHI_CS2[cs_n] or GHI_CS[cs_n] or {};
			else
				cs = GHI_CS[cs_n] or {};
			end

			for i, v in pairs(data) do
				if not (GenerateCS(v) == cs[UCS(i)]) then
					data[i] = nil;
					cr = true;
				end
			end
		else
			local cs = {};
			for i, v in pairs(data) do
				cs[UCS(i)] = GenerateCS(v);
			end
			if shared then
				GHI_CS2[cs_n] = cs;
			else
				GHI_CS[cs_n] = cs;
			end
		end
		loaded = true;
		if cr == true then
			print(ERROR_MSG)
		end
	end

	class.GetVar = function(index)
		if not (VARS_LOADED) then error("Variables not loaded yet.") end
		if not (loaded) then Load(); end
		return data[index];
	end

	class.SetVar = function(index, var)
		if not (VARS_LOADED) then error("Variables not loaded yet.") end
		if not (loaded) then Load(); end
		data[index] = var;
		if shared then
			GHI_CS2[cs_n] = GHI_CS2[cs_n] or {};
			if var ~= nil then
				GHI_CS2[cs_n][UCS(index)] = GenerateCS(var);
			else
				GHI_CS2[cs_n][UCS(index)] = nil;
			end
		else
			GHI_CS[cs_n] = GHI_CS[cs_n] or {};
			if var ~= nil then
				GHI_CS[cs_n][UCS(index)] = GenerateCS(var);
			else
				GHI_CS[cs_n][UCS(index)] = nil;
			end
		end
	end

	class.GetAll = function()
		if not (VARS_LOADED) then error("Variables not loaded yet.") end
		if not (loaded) then Load(); end
		local t = {};
		for i, v in pairs(data) do
			t[i] = v;
		end
		return t;
	end

	return class
end
