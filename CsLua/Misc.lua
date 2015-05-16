--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.GetType = function(obj)
    if type(obj) == "table" and obj.__type then
        return obj.__type;
    end
    return type(obj);
end

CsLua.GetFullTypeName = function(obj)
    if type(obj) == "table" and obj.__fullTypeName then
        return obj.__fullTypeName;
    end
end

CsLua.CreateSimpleClass = function(class, publicClass, name, fullName, cstor, initialize, serialize, deserialize, implements)
	class.__type = name;
	class.__fullTypeName = fullName;
	class.__IsType = function(typeName) return typeName == name or typeName == object; end
	class.__GetOverrides = function() return {}; end
	class.__GetSignature = function() 
		local t = {fullName};
		for _,v in ipairs(implements) do
			table.insert(t, v);
		end
		table.insert(t, "object");
		return t; 
	end
	class.__TableString = function() return tostring(class); end
	class.__Cstor = function(...)
		local args = {...};
		if deserialize and #(args) == 1 and type(args[1]) == "table" and args[1].GetValue then
			deserialize(...);
		elseif cstor then
			cstor(...);
		end
		return publicClass;
	end
	class.__Initialize = function(data)
		if initialize then
			initialize(data);
		end
		return publicClass;
	end
	class.__Serialize = serialize;
end

