--===================================================
--									
--					GHClass
--					ghclass.lua
--	
-- 			(c)2013 The Gryphonheart Team
--				All rights reserved
--===================================================


local inherit;
function GHClass(_className, nonFrame, ...)
	local obj, className;

	if inherit and inherit.className == _className then
		obj = inherit.object;
		inherit = nil;
	elseif nonFrame and not(nonFrame == "frame") then
		obj = {}; --
	else
		obj = CreateFrame("Frame"); --
	end

	if not(obj.AddInherits) then
		local inherits = {};
		obj.AddInherits = function(inh)
			table.insert(inherits,inh)
		end
		obj.Inherits = function(inh)
			for _, int in pairs(inherits) do
				if (int == inh) then
					return true;
				end
			end
			return false;
		end
	else
		obj.AddInherits(_className);
	end

	className = _className;

	obj.GetType = function()
		return className;
	end

	obj.IsClass = function(str)
		assert(type(str) == "string", "Useage: IsClass(str)");
		return obj.GetType() == str;
	end;

	obj.IsSameClass = function(other)
		assert(type(other) == "table", "IsSameClass. Other class is not a table");
		if other.GetType then
			return obj.GetType() == other.GetType()
		end
	end

	obj.Dispose = function() -- Standard dispose func. This can be overwritten
		wipe(obj);
	end

	return obj;
end

function GHInheritNext(className,object)
	inherit = {
		className = className,
		object = object,
	};
end

function GHCheck(name, expected, acual)
	if not (type(name) == "string" and type(expected) == "table" and type(acual) == "table") then
		error("GHCheck used incorrectly in code. Useage: GHCheck(string,table,table) got " ..type(name) .." " .. type(expected) .. " " .. type(acual), 2)
	end

	local passed = true;
	local acualRes = {};
	for i, expType in pairs(expected) do
		--expType = expType:lower();
		local acualType = type(acual[i]):lower();
		if not (expType:lower() == "any") and not (string.find(expType:lower(), acualType:lower())) then
			if not (type(acual[i]) == "table" and ((acual[i].IsClass and acual[i].IsClass(expType)) or (acual[i].Inherits and acual[i].Inherits(expType)))) then
				passed = false;
			end
		end
		acualRes[i] = acualType;
	end

	if not (passed) then
		error(name .. " Usage: " .. string.join(",", unpack(expected)) .. " got " .. string.join(" ", unpack(acualRes)), 2)
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


function GHStruct(variables)
	local struct = {};
	local values = {};
	setmetatable(struct, {
		__index = function(self, index)
			return values[index];
		end,
		__newindex = function(self, index, val)
			if variables[index] and string.find(variables[index], type(val)) then
				values[index] = val;
			else
				error("Incorect struct index or value type", 2, index)
			end
		end
	});
	return struct;
end

function GHClone(var)
	if type(var) == "table" then
		local t = {};
		for i,v in pairs(var) do
			t[i] = GHClone(v);
		end
		return t;
	else
		return var;
	end
end

function GHNYI(s)
	error("Not yet implemented. One or more functionalities that are not yet implemented were called: "..(s or ""),2)
end

string.startsWith = function(str,pattern)
	if string.sub(str,0,string.len(pattern)) == pattern then
		return true;
	end
	return false;
end

string.endsWith = function(str,pattern)
	if string.sub(str,string.len(str)-string.len(pattern)+1) == pattern then
		return true;
	end
	return false;
end

string.count = function(str,pattern)
	local last = 0;
	local count;
	local _;
	while (last) do
		_,last = string.find(str,pattern,last);
		count = (count or -1) + 1;
	end
	return count;
end

local _,_,_,tocNum = GetBuildInfo();
if tocNum >= 30000 and tocNum < 40000 then
	local orig = PlaySoundFile;
	PlaySoundFile = function(path,...)
		if type(path) == "string" and string.endsWith(path,".ogg") then
			orig(string.sub(path,0,-5)..".wav",...);
		else
			orig(path,...)
		end
	end

	InterfaceOptionsFrame:SetWidth(1000);
	DisableAddOn("GHU")
end

function GHInherit(class,inhClass)
	for i,v in pairs(inhClass) do
		if not(class[i]) then
			class[i] = v;
		end
	end
end

function GHTimeBasedVersion()
	return time() -1370000000;
end

if not(Ambiguate) then
	Ambiguate = function(name,...)
		return name;
	end
end

function GH_TestFeature()
	return strlower(GetAddOnMetadata("GHI", "X-DevVersion")) == "true" and IsShiftKeyDown();
end

function GHTry(try, catch)
	local noError, details = pcall(try);
	if not(noError) then
		catch(details);
	end
end


function GHTemp()
	local statusbar = GHI_StatusBarUI()
	statusbar.ChangeValue(100)
	statusbar.SetTextures("","INTERFACE/UNITPOWERBARALT/Murozond_Horizontal_Fill","INTERFACE/UNITPOWERBARALT/Murozond_Horizontal_Bgnd","")
	statusvalue = statusbar.GetValue()
	statusbar.SetText(date("!%X",1))
	statusbar.Toggle("show")
end