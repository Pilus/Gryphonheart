--TargetFile: CsLua.lua

CsLua = CsLua or {};

CsLua.CreateSimpleClass = function(class, publicClass, name, fullName, cstor, initialize, serialize, deserialize, implements)
	assert(type(class)=="table", "class argument must be a table");
	assert(type(publicClass)=="table", "publicClass argument must be a table");
	assert(type(name)=="string", "name argument must be a string");
	assert(type(fullName)=="string", "fullName argument must be a string");
	
	class.__type = name;
	class.__fullTypeName = fullName;
	class.__IsType = function(typeName) 
		for _,type in ipairs(class.__GetSignature()) do
			if type == typeName then
				return true;
			end
		end
		return false
	end
	class.__GetOverrides = function() return {}; end
	class.__GetSignature = function() 
		local t = {fullName};
		for _,v in ipairs(implements or {}) do
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

