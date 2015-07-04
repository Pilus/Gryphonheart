--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.Collection = CsLua.Collection or {};
CsLua.Collection.CsLuaDictionary = function(generics)
	local class = {};
	local getters = {};
	local publicClass = {};

	local t = {};

	local Cstor = function(...)
		local args = {...};
		if #(args) == 1 and type(args[1]) == "table" then
			t = {};
			for i,v in pairs(args[1]) do
				t[i] = v;
			end
		end
	end

	local Initialize = function(initTable)
		local i = 0;
		while (initTable[i]) do
			t[initTable[i][0]] = initTable[i][1];
			i = i + 1;
		end
	end

	CsLua.CreateSimpleClass(class, publicClass, "CsLuaDictionary", "CsLua.Collection.CsLuaDictionary", Cstor, Initialize, nil, nil, {
		"System.Collection.Generic.Dictionary", "System.Collection.Generic.IDictionary"
	});

	class.Count = function()
		local c = 0;
		for i,v in pairs(t) do
			c = c + 1;
		end
		return c;
	end

	getters.Keys = function()
		local keys = CsLua.Collection.CsLuaList();
		for i,v in pairs(t) do
			keys.Add(i);
		end
		return keys;
	end

	class.Values = function()
		local values = CsLua.Collection.CsLuaList();
		for i,v in pairs(t) do
			values.Add(v);
		end
		return values;
	end

	class.GetEnumerator = function()
		local keys = publicClass.Keys;
		return function(_, prevKey) 
			local i = 0;
			if not(prevKey == nil) then
				i = prevKey + 1;
			end
			if keys[i] then
				return i, { Key = keys[i], Value = publicClass[keys[i]]; }
			end 
		end;
	end

	class.ContainsKey = function(key)
		for i,v in pairs(t) do
			if (i == key) then
				return true;
			end
		end
		return false;
	end

	class.ToNativeLuaTable = function()
		local t2 = {};
		for i,v in pairs(t) do
			if type(v) == "table" and type(v.ToNativeLuaTable) == "function" then
				t2[i] = v.ToNativeLuaTable();
			else
				t2[i] = v;
			end
		end
		return t2;
	end

	class.Add = function(key, value)
		t[key] = value;
	end

	setmetatable(publicClass, {
		__index = function(_, key)
			if getters[key] then
				return getters[key]();
			end
			if class[key] then
				return class[key]
			end
			return t[key];
		end,
		__newindex = function(_, key, value)
			t[key] = value;
		end,
	});
	
	return publicClass;
end