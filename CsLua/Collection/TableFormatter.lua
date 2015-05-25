--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.Collection = CsLua.Collection or {};
CsLua.Collection.TableFormatter = function()
	local class = {}

	local useCompact = false;

	local Cstor = function(_useCompact)
		useCompact = _useCompact;
		return class;
	end

	CsLua.CreateSimpleClass(class, class, "TableFormatter", "CsLua.Collection.CsLuaList", Cstor, nil, nil, nil, {"CsLua.Collection.ITableFormatter"});

	local Compact;
	Compact = function(t, target)
		target = target or t.root;
		local c = {};
		for i,value in pairs(t[target]) do
			if type(value) == "string" and string.startsWith(value,"Table: ") and t[value] then
				c[i] = Compact(t, value)
			else
				c[i] = value;
			end
		end
		return c;
	end

	local Decompact;
	Decompact = function(c, t)
		local s = tostring(c);
		t = t or {root = s};
		
		if t[s] then -- The table have already been decompressed.
			return;
		end

		t[s] = {}
		for i,value in pairs(c) do
			if type(value) == "table" then
				Decompact(value, t);
				t[s][i] = tostring(value); 
			else
				t[s][i] = value;
			end
		end
		return t;
	end

	class.Serialize = function(graph)
		assert(type(graph) == "table" and type(graph.__Serialize) == "function", "Argument must be a serializable class.");
			
		local serInfo = CsLua.Collection.SerializedInfo().__Cstor();
			
		local obj = graph;
		while (obj) do
			obj.__Serialize(serInfo);
			obj = serInfo.Take();
		end
		local info = serInfo.GetInfo();
		if (useCompact) then
			return Compact(info);
		end
		return info;
	end
		
	class.Deserialize = function(info)
		if (useCompact) then
			info = Decompact(info);
		end
		local serInfo = CsLua.Collection.SerializedInfo().__Cstor(info);
		return serInfo.GetGraph();
	end
		
	return class;
end
	
CsLua.Collection.SerializedInfo = function()
	local class = {}

	local info;
	local objs;
	local pending = {};

	local Cstor = function(_info)
		info = _info or {};
		return class;
	end

	CsLua.CreateSimpleClass(class, class, "SerializedInfo", "CsLua.Collection.SerializedInfo", Cstor);

	
		
	class.Take = function()
		for i, v in pairs(pending) do
			pending[i] = nil;
			return v;
		end
	end
		
	class.AddValue = function(obj, name, value, _)
		if (type(value) == "table" and type(value.__Serialize) == "function") then
			local subObj = value;
			value = subObj.__TableString();
			if not(info[value]) then
				pending[value] = subObj;
			end
		elseif type(value) == "table" and value.__fullTypeName then
			error("Unserializeable object: " .. value.__fullTypeName);
		end
		
		local n = obj.__TableString();
		info[n] = info[n] or { __type = obj.__fullTypeName, };
		
		if name then
			info[n][name] = value;
		end

		if not(info.root) then
			info.root = n;
		end
	end
		
	class.GetInfo = function()
		return info;
	end

	local GetGlobalByName = function(name)
		local nameTable = {strsplit(".", name)};
		local o = _G;
		for _, namePart in pairs(nameTable) do
			o = o[namePart];
		end
		return o;
	end

	local CreateObj = function(name, objInfo)
		local targetType = objInfo.__type;
		assert(type(targetType) == "string", "No target type found for element: "..name);
		local classFunc = GetGlobalByName(targetType);
		assert(type(classFunc) == "table" or type(classFunc) == "function", "Could not find class definition for: "..targetType);
		objs[name] = classFunc(nil);
		objs[name].__Cstor(class);
	end

	local GetNameOfObj = function(obj)
		for name, o in pairs(objs) do
			if o == obj then
				return name;
			end
		end
		error("Name for object not found.")
	end

	class.GetValueKeys = function(obj)
		local objName = GetNameOfObj(obj);
		local objInfo = info[objName];

		local keys = {};
		for i,_ in pairs(objInfo) do
			table.insert(keys, i);
		end
		return keys;
	end

	class.GetValue = function(obj, name, _)
		local objName = GetNameOfObj(obj);
		local objInfo = info[objName];
		local value = objInfo[name];

		if (type(value) == "string" and string.sub(value,0,7) == "table: " and info[value]) then
			if not(objs[value])	then
				CreateObj(value, info[value]);
			end
			return objs[value];
		end
		return value;
	end
		
	class.GetGraph = function()
		objs = {};
		
		if not(info.root) or not(info[info.root]) then
			error("Invalid serialized data set. Could not find root object");
		end

		CreateObj(info.root, info[info.root]);

		return objs[info.root];
	end
		
	return class;
end