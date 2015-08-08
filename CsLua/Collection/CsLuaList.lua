--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.Collection = CsLua.Collection or {};
CsLua.Collection.CsLuaList = function(generics)
	local class = {};
	local getters = {};
	local publicClass = {};

	local t = {};

	local Cstor = function(...)
		local args = {...};
		if type(args[1]) == "table" then
			for _,v in ipairs(args[1]) do
				publicClass.Add(v);
			end
		end
	end

	local Initialize = function(nativeTable)
		t[0] = nativeTable[0];
		for i, v in ipairs(nativeTable) do
			t[i] = v;   
		end
	end

	local Serialize = function(info)
		for i, v in pairs(t) do
			info.AddValue(publicClass, i, v, generics);
		end
	end

	local Deserialize = function(info)
		for _, key in ipairs(info.GetValueKeys(publicClass)) do
			t[key] = info.GetValue(publicClass, key, generics);
		end
	end

	CsLua.CreateSimpleClass(class, publicClass, "CsLuaList", "CsLua.Collection.CsLuaList", Cstor, Initialize, Serialize, Deserialize,  {{"System.Collection.Generic.IList"}});

	getters.Count = function()
		local c = #(t);
		if t[0] then
			c = c + 1;
		end
		return c;
	end

	class.GetEnumerator = function()
		return function(_, prevKey) 
			if prevKey == nil then
				if t[0] then
					return 0, t[0];
				end
				if t[1] then
					return 1, t[1];
				end
				return nil, nil;
			end
			local k = prevKey + 1;
			if t[k] then
				return k, t[k];
			end
			return nil, nil;
		end;
	end

	class.Add = function(value)
		local c = publicClass.Count;
		publicClass[c] = value;
		return c;
	end

	class.Clear = function()
		t = {};
	end

	class.Contains = function(value)
		for i = 0, publicClass.Count - 1 do
			if publicClass[i] == value then
				return true;
			end
		end
		return false;
	end

	class.IndexOf = function(value)
		for i = 0, publicClass.Count - 1 do
			if publicClass[i] == value then
				return i;
			end
		end
		return -1;
	end

	class.Insert = function(index, value)
		if (index == 0) then
			table.insert(t, 1, t[0]);
			t[0] = value;
		else
			table.insert(t, index, value);
		end
	end

	class.RemoveAt = function(index)
		if index > 0 then
			table.remove(t, index);
		elseif index == 0 then
			t[0] = table.remove(t, 1)
		end
	end

	class.Remove = function(value)
		publicClass.RemoveAt(publicClass.IndexOf(value));
	end

	class.ToNativeLuaTable = function()
		local native = {};
		for i = 0, publicClass.Count - 1 do
			native[i+1] = publicClass[i];
		end
		return native;
	end

	-- Linq support
	class.Where = function(f)
		local t = CsLua.Collection.CsLuaList();
		for i = 0, publicClass.Count - 1 do
			if f(publicClass[i]) then
				t.Add(publicClass[i]);
			end
		end
		return t;
	end

	class.Select = function(f)
		local t = CsLua.Collection.CsLuaList();
		for i = 0, publicClass.Count - 1 do
			t.Add(f(publicClass[i]));
		end
		return t;
	end

	class.Any = function(f)
		if f then
			return publicClass.Where(f).Count > 0;
		else
			return publicClass.Count > 0;
		end
	end

	class.FirstOrDefault = function(f)
		if f then
			return publicClass.Where(f)[0];
		else
			return publicClass[0];
		end
	end

	class.First = function(f)
		local res = publicClass.FirstOrDefault(f);
		if res then
			return res;
		end
		CsLuaMeta.Throw(CsLua.CsException().__Cstor("The source sequence is empty."));
	end

	class.Single = function(f)
		if publicClass.Count == 1 then
			return publicClass[0];
		end
		CsLuaMeta.Throw(CsLua.CsException().__Cstor("The source sequence did not hold precisely one element."));
	end

	class.SingleOrDefault = function(f)
		if publicClass.Count == 1 then
			return publicClass[0];
		elseif publicClass.Count == 0 then
			return nil;
		end
		CsLuaMeta.Throw(CsLua.CsException().__Cstor("The source sequence did not hold one or none elements."));
	end

	class.LastOrDefault = function(f)
		if f then
			local t = publicClass.Where(f);
			return t[t.Count - 1];
		else
			return publicClass[publicClass.Count - 1];
		end
	end

	class.Last = function(f)
		local res = publicClass.LastOrDefault(f);
		if res then
			return res;
		end
		CsLuaMeta.Throw(CsLua.CsException().__Cstor("The source sequence is empty."));
	end

	class.Union = function(otherList)
		local res = CsLua.Collection.CsLuaList();
		for i = 0, publicClass.Count - 1 do
			res.Add(publicClass[i]);
		end
		for i = 0, otherList.Count - 1 do
			res.Add(otherList[i]);
		end
		return res;
	end

	class.Distinct = function()
		local res = CsLua.Collection.CsLuaList();
		for i = 0, publicClass.Count - 1 do
			local v1 = publicClass[i]
			local found = false;
			for j = 0, res.Count - 1 do
				local v2 = publicClass[j];
				if v1 == v2 then
					found = true;
					break;
				end
			end
			if found == false then
				res.Add(v1);
			end
		end
	end

	class.ToList = function()
		return publicClass.Where(function() return true; end);
	end

	class.OrderBy = function(f)
		local t = publicClass.ToNativeLuaTable();
		table.sort(t, function(a,b) return f(a) < f(b) end);
		return CsLua.Collection.CsLuaList().__Cstor(t);
	end

	class.Skip = function(n)
		local l = CsLua.Collection.CsLuaList();
		for i = n, publicClass.Count - 1 do
			l.Add(publicClass[i]);
		end
		return l;
	end

	class.Take = function(n)
		local l = CsLua.Collection.CsLuaList();
		for i = 0, n - 1 do
			l.Add(publicClass[i]);
		end
		return l;
	end

	class.Foreach = function(action)
		for i = 0, publicClass.Count - 1 do
			action(publicClass[i]);
		end
	end

	class.Max = function(selector)
		local c = nil;
		for i = 0, publicClass.Count - 1 do
			local v = selector(publicClass[i]);
			c = math.max(c or v, v);
		end
		return c;
	end

	class.Min = function(selector)
		local c = 0;
		for i = 0, publicClass.Count - 1 do
			local v = selector(publicClass[i]);
			c = math.min(c or v, v);
		end
		return c;
	end

	class.Sum = function(selector)
		local c = 0;
		for i = 0, publicClass.Count - 1 do
			c = c + selector(publicClass[i]);
		end
		return c;
	end

	setmetatable(publicClass, {
		__index = function(_, key)
			if type(key) == "number" then
				return t[key];
			end
			if getters[key] then
				return getters[key]();
			end
			if class[key] then
				return class[key]
			end
		end,
		__newindex = function(_, key, value)
			if type(key) == "number" then
				t[key] = value;
			end
		end,
	});

	return publicClass;    
end


