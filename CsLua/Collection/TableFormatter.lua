--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.Collection = CsLua.Collection or {};
CsLua.Collection.TableFormatter = function()
    local class = {
        __type = "TableFormatter",
        __IsType = function(t) return t == "TableFormatter"; end,
        __fullTypeName = "CsLua.Collection.TableFormatter",
    }
    
	local useCompact = false;

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

	local Decompact = function(c)
		local s = tostring(c);
		local t = {root = s};
		t[s] = {}
		for i,value in pairs(c) do
			t[s][i] = value;
			-- TODO: Handle multiple objects
		end
		return t;
	end

    class.Serialize = function(graph)
        assert(type(graph) == "table" and type(graph.serialize) == "function", "Argument must be a serializable class.");
            
        local serInfo = CsLua.Collection.SerializedInfo().__Cstor();
            
        local obj = graph;
        while (obj) do
            obj.serialize(serInfo);
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

	class.__Cstor = function(_useCompact)
		useCompact = _useCompact;
		return class;
	end
        
    return class;
end
    
CsLua.Collection.SerializedInfo = function()
    local class = {
        __type = "SerializedInfo",
        __IsType = function(t) return t == "SerializedInfo"; end,
        __fullTypeName = "CsLua.Collection.SerializedInfo",
    }
    local info;	   
        
    local pending = {};
        
    class.Take = function()
        for i, v in pairs(pending) do
            pending[i] = nil;
            return v;
        end
    end
        
    class.AddValue = function(obj, name, value, _)
        if (type(value) == "table" and type(value.serialize) == "function") then
            local subObj = value;
            value = tostring(subObj);
            if not(info[value]) then
                pending[value] = subObj;
            end
        end
        
        local n = tostring(obj);
        info[n] = info[n] or { __type = CsLua.GetFullTypeName(obj) };
        info[n][name] = value;

		if not(info.root) then
			info.root = n;
		end			
    end
        
	class.GetInfo = function()
		return info;
	end

	local objs;

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
        assert(type(classFunc) == "table", "Could not find class definition for: "..targetType);
		objs[name] = classFunc(class);
	end

	local GetNameOfObj = function(obj)
		for name, o in pairs(objs) do
			if o == obj then
				return name;
			end
		end
		error("Name for object not found.")
	end

    class.GetValue = function(obj, name, _)
		local objName = GetNameOfObj(obj);
		local objInfo = info[objName];
		local value = objInfo[name];

		if (type(value) == "string" and string.startsWith(value,"Table: ") and info[value]) then
			if not(objs[value])	then
				CreateObj(value, info[value]);
			end
			return objs[value];
		end
		return value;
    end

		
        
    class.GetGraph = function()
		objs = {};

		CreateObj(info.root, info[info.root]);

        return objs[info.root];
    end

	class.__Cstor = function(_info)
		info = _info or {};
		return class;
	end
        
    return class;
end