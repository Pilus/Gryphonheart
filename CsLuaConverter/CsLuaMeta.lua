CsLuaMeta = {};
CsLuaMeta.Foreach = function(obj)
	if type(obj) == 'table' and obj.GetEnumerator then
		return obj.GetEnumerator();
	end
	return pairs(obj);
end
local function SetAddMeta(f)
	local mt = { __add = function(self, b) return f(self[1], b) end }
	return setmetatable({}, { __add = function(a, _) return setmetatable({ a }, mt) end })
end
CsLuaMeta.add = SetAddMeta(function(a, b)
	assert(a and b, "Add called on a nil value.");
	if type(a) == "number" and type(b) == "number" then return a + b; end
	return tostring(a)..tostring(b);
end);

CsLuaMeta._not = setmetatable({}, { __add = function(_, value)
	return not(value);
end});

local typeBasedMethods = {
	ToString = function(obj)
		if type(obj) == "table" and obj.__fullTypeName then
			return obj.__fullTypeName;
		end
		if type(obj) == "boolean" then
			if (obj == true) then
				return "True";
			end
			return "False";
		end
		return tostring(obj);
	end,
	Equals = function(obj, otherObj)
		return obj == otherObj;
	end
}

for i,v in pairs(typeBasedMethods) do
	CsLuaMeta[i] = function(...) 
		local args = {...};
		return setmetatable({}, { 
			__add = function(obj)
				if type(obj) == "table" and obj.__fullTypeName and type(obj[i]) == "function" then
					return obj[i](unpack(args));
				end
				return v(obj, unpack(args));
			end
		});
	 end;
end

int = {
	Parse = function(value)
		return tonumber(value);
	end,
}

CsLuaMeta.GetByFullName = function(s, doNotThrow)
	local n = {string.split(".",s)};
	local o = _G[n[1]];
	
	if not(o) then
		if doNotThrow then
			return;
		else
			error("Could not find global "..s);
		end
	end

	for i=2,#(n) do
		o = o[n[i]];
		
		if not(o) then
			if doNotThrow then
				return;
			else
				error("Could not find global "..s);
			end
		end
	end
	return o;
end

CsLuaMeta.GenericsMethod = function(func)
	local t = {}
	setmetatable(t, {
		__index = function(_, generics)
			return function(...) return func(generics, ...); end;
		end,
		__call = function(_, ...)
			return func(CsLuaMeta.GenericsList(CsLuaMeta.Generic('object')), ...);
		end
	});

	return t;
end

CsLuaMeta.EnumParse = function(typeName, value, doNotThrow)
	local enumTable = CsLuaMeta.GetByFullName(typeName, doNotThrow);
	if type(enumTable) == "table" then
		for i,v in pairs(enumTable) do
			if string.lower(value) == string.lower(i) then
				return v;
			end
		end
	end

	if not(doNotThrow) then
		CsLuaMeta.Throw(CsLua.CsException("Could not parse enum value " .. tostring(value) .. " into " .. typeName));
	end
end

local defaultValues = {
	bool = false,
	int = 0,
	float = 0,
	long = 0,
	double = 0,
}

CsLuaMeta.GetDefaultValue = function(type, isNullable, generics)
	if isNullable then
		return nil;
	end

	for _,v in ipairs(generics or {}) do
		if v == type then
			return nil;
		end
	end

	if not(defaultValues[type] == nil) then
		return defaultValues[type];
	end

	--Handle eventual enum. Return nil if not an enum.
	return CsLuaMeta.EnumParse(type, "__default", true);
end

CsLuaMeta.IsType = function(obj, t)
	if t == "object" then
		return true;
	end

	if type(obj) == "table" then
		if obj.__IsType then
			return obj.__IsType(t);
		elseif type(obj.GetType) == "function" then
			return obj:GetType() == t;
		end
	end
	if type(obj) == "boolean" then
		return "bool" == t;
	elseif type(obj) == "function" then
		return "System.Action" == t;
	elseif type(obj) == "number" then
		return "double" == t or "int" == t;
	elseif type(obj) == "string" then
		return t == "string";
	elseif type(obj) == "nil" then
		return true;
	end
	return error("Unknown type handling "..type(obj));
end

CsLuaMeta.GetSignatures = function(...)
	local args = {...};
	local signatures = {};
	for i = 1,select('#', ...) do
		signatures[i] = {"object"};
		local obj = args[i]

		if type(obj) == "table" then
			if (obj.__GetSignature) then
				signatures[i] = obj.__GetSignature();
			elseif type(obj.GetObjectType) == "function" then
				table.insert(signatures[i], 1, "Lua.NativeLuaTable");
				table.insert(signatures[i], 1, "BlizzardApi.WidgetInterfaces.INativeUIObject");
			else
				table.insert(signatures[i], 1, "Lua.NativeLuaTable");
			end
		elseif type(obj) == "boolean" then
			table.insert(signatures[i], 1, "bool");
		elseif type(obj) == "function" then
			table.insert(signatures[i], 1, "System.Action");
			table.insert(signatures[i], 1, "System.Func");
		elseif type(obj) == "number" then
			table.insert(signatures[i], 1, "double");
			table.insert(signatures[i], 1, "int");
			table.insert(signatures[i], 1, "long");
		elseif type(obj) == "string" then
			table.insert(signatures[i], 1, "string");
		elseif type(obj) == "nil" then
			table.insert(signatures[i], 1, "null");
		end
	end

	return signatures;
end

CsLuaMeta.IsMatchingEnum = function(enumType, obj)
	if type(obj) == "string" then
		return not(CsLuaMeta.EnumParse(enumType, obj, true) == nil)
	end
	return false;
end

CsLuaMeta.ScoreFunction = function(types, signature, args, generic)
	if #(types) == #(signature) then
		local functionScore = 0;
		for i, typeName in ipairs(types) do
			typeName = (generic or {})[typeName] or typeName;

			local argScore;
			for j, argSignature in ipairs(signature[i]) do
				if typeName == argSignature or argSignature == "null" or (argSignature == "string" and CsLuaMeta.IsMatchingEnum(typeName, args[i], true)) then
					argScore = j - 1;
					break;
				end
			end

			if argScore == nil then
				return;
			end
			functionScore = functionScore + argScore;
		end
		return functionScore;
	end
	return nil;
end

CsLuaMeta.GetMatchingFunction = function(functions, generics, ...)
	local argSignature = CsLuaMeta.GetSignatures(...);
	local args = {...};

	local bestFunc, bestScore;
	for _, funcMeta in pairs(functions) do
		local score = CsLuaMeta.ScoreFunction(funcMeta.types, argSignature, args, generics);
		if (score and (bestScore == nil or bestScore > score)) then
			bestScore = score;
			bestFunc = funcMeta.func;
		end
	end

	return bestFunc;
end

CsLuaMeta.Throw = function(exception)
	__CurrentException = exception;
	error(exception.ToString(), 2);
end

CsLuaMeta.GenericsList = function(...)
	local list = {...};

	return list;
end

CsLuaMeta.Generic = function(name, innerGenerics)
	local class = {};

	class.innerGenerics = innerGenerics;

	class.name = name;

	return class;
end

CsLuaMeta.Try = function(try, catch, finally)
	__CurrentException = nil;
	local success, err = pcall(try)
	local exception = __CurrentException;
	__CurrentException = nil;

	if not(success) then
		exception = exception or CsLua.CsException().__Cstor("Lua error:\n" .. (err or "nil"));
		
		local matchFound = false;
		for _, catchCase in ipairs(catch or {}) do
			if catchCase.type == nil or exception.__IsType(catchCase.type) then
				catchCase.func(exception)
				matchFound = true;
				break;
			end
		end

		if (matchFound == false) then -- rethrow
			if finally then
				finally();
			end

			__CurrentException = exception;
			error(err, 2);
		end
	end

	if finally then
		finally();
	end
end

CsLuaMeta.SignatureToString = function(signature)
	local args = {};
	for i, argSig in ipairs(signature) do
		args[i] = string.join("|", unpack(argSig));
	end
	return string.join(", ", unpack(args));
end

CsLuaMeta.CreateClass = function(info)
	local staticValues;
	local namespaceElement = {};
	local staticOverride;
	local loadStaticOverride = function()
		if info.inherits then
			staticOverride = CsLuaMeta.GetByFullName(info.inherits);
		end
	end

	local GenerateAmbigiousFunc = function(element, inheritiedClass, generics, methodGenerics)
		local value = element.value(methodGenerics);
		return function(...)
			local matchingFunc = CsLuaMeta.GetMatchingFunction(value, generics, ...);
			if matchingFunc then
				return matchingFunc(...);
			elseif inheritiedClass then
				local f = inheritiedClass[element.name];
				if f then
					return f(...);
				end
			end

			error("No method found for key '"..element.name.."' matching the signature: '"..CsLuaMeta.SignatureToString(CsLuaMeta.GetSignatures(...)).."'");
		end, value;
	end

	local initializeStaticElements = function()
		if staticValues then
			return;
		end

		staticValues = {};
		local elements = info.getElements(namespaceElement, {});

		for _, element in pairs(elements) do
			if (element.static) then
				if (element.type == "Method") then
					staticValues[element.name] = GenerateAmbigiousFunc(element, nil, nil);
				else
					staticValues[element.name] = element.value;
				end
			end
		end
	end

	local setStaticValue = function(key, value)
		local elements = info.getElements(staticValues);

		for _, element in pairs(elements) do
			if (element.type == "PropertySet") then
				element.value(value);
				return;
			elseif (element.static and element.name == key and not(element.type == "PropertyGet")) then
				staticValues[element.name] = value;
				return;
			end
		end

		loadStaticOverride();
		if (not(staticOverride == nil)) then
			 staticOverride[key] = value;
		else
			error("Could not set static value " + key);
		end
	end

	local getStaticValue = function(key)
		local elements = info.getElements(staticValues);

		for _, element in pairs(elements) do
			if (element.name == key and element.type == "PropertyGet") then
				return element.value();
			elseif (element.static and element.name == key and not(element.type == "PropertySet")) then
				return staticValues[element.name];
			end
		end

		loadStaticOverride();

		return not(staticOverride == nil) and staticOverride[key] or nil;
	end

	local initializeClass = function(generics, overridingClass)
		local class = {};
		local _, inheritiedClass, populateOverride;
		if info.inherits then
			_, inheritiedClass, populateOverride = CsLuaMeta.GetByFullName(info.inherits)(generics);
			if _ and not(inheritiedClass) then -- Adjust for objects returning only one variable. E.g. CsLuaList;
			   inheritiedClass = _;
			end
		end

		local indexerValues, dictionaryValues;
		if info.isIndexer then indexerValues = {}; end
		if info.isDictionary then dictionaryValues = {}; end
		local nonStaticValues = {};

		local elements = info.getElements(overridingClass or class, generics or {});
		
		local methods, nonStaticVariables, staticVariables, staticGetters, nonStaticGetters, staticSetters, nonStaticSetters = {}, {}, {}, {}, {}, {}, {};
		local staticMethods = {};
		local constructor, serialize, deserialize;
		local overrides = {};
		local interfaces = {};

		local appliedGenerics = {};
		if info.generics then
			for i, appliedGenericVar in ipairs(generics) do
				appliedGenerics[info.generics[i]] = appliedGenericVar;
			end
		end

		
		for _, element in pairs(elements) do
			if (element.type == "Interface") then
				table.insert(interfaces, element.value);
			elseif (element.type == "Method") then
				local func, methodValue = GenerateAmbigiousFunc(element, inheritiedClass, appliedGenerics);

				if (methodValue[1].generics) then
					func = CsLuaMeta.GenericsMethod(function(generics,...)
						local methodGenerics = {};
						for i,v in ipairs(generics) do
							methodGenerics[methodValue[1].generics[i]] = { name = v.name };
						end
						local innerFunc = GenerateAmbigiousFunc(element, inheritiedClass, appliedGenerics, methodGenerics);
						return innerFunc(...);
					end);
				end

				methods[element.name] = func;

				if (element.static == true) then
					staticMethods[element.name] = func;
				end

				if (element.override == true) and inheritiedClass then
					overrides[element.name] = func;
				end
			elseif (element.type == "Variable") then
				if (element.static) then
					staticVariables[element.name] = element;
				else
					nonStaticVariables[element.name] = element;
				end
			elseif (element.type == "PropertyGet") then
				if (element.static) then
					staticGetters[element.name] = element;
				else
					nonStaticGetters[element.name] = element;
				end
			elseif (element.type == "PropertySet") then
				if (element.static) then
					staticSetters[element.name] = element;
				else
					nonStaticSetters[element.name] = element;
				end
			elseif (element.type == "PropertyAuto") then
				if (element.static) then
					staticVariables[element.name] = element;
				else
					nonStaticVariables[element.name] = element;
				end
			elseif (element.type == "Serialization") then
				if (element.name == "serialize") then
					serialize = element;
				elseif (element.name == "deserialize") then
					deserialize = element;
				else
					error("Unknown Serialization element: "..tostring(element.name));
				end
			elseif (element.type == "Constructor") then
				constructor = function(...)
					local matchingFunc = CsLuaMeta.GetMatchingFunction(element.value(), appliedGenerics, ...);
					if matchingFunc then
						return matchingFunc(...);
					else
						error("No constructor matching the signature: '"..CsLuaMeta.SignatureToString(CsLuaMeta.GetSignatures(...)).."'");
					end
				end
			else
				error("Unhandled element type: "..tostring(element.type));
			end
		end

		if not(staticValues) then
			staticValues = {}
			for i, v in pairs(staticVariables) do
				staticValues[i] = v.value;
			end

			for i, v in pairs(staticMethods) do
				staticValues[i] = v;
			end
		end
		
		local meta = {};
		meta.__Initialize = function(t) for i, v in pairs(t) do class[i] = v; end  return class; end
		meta.__type = info.name;
		if (serialize) then
			meta.__Serialize = serialize.value;
		end
		meta.__fullTypeName = info.fullName;
		meta.__TableString = function()
			return tostring(class);
		end
		meta.__IsType = function(t) 
			return tContains(meta.__GetSignature(), t);
		end;
		meta.__GetSignature = function()
			local signature = {"object"};
			if (inheritiedClass) then
				signature = inheritiedClass.__GetSignature();
			end

			for _, interface in pairs(interfaces) do
				interface.__AddImplementedSignatures(signature);
			end

			table.insert(signature, 1, info.fullName);
			return signature;
		end
		meta.__GetOverrides = function()
			return overrides;
		end

		
		for i,v in pairs(nonStaticVariables) do
			nonStaticValues[i] = v.value;
		end
		for i,v in pairs(nonStaticGetters) do
			if not(type(v.value) == "function") then
				nonStaticValues[i] = v.value;
			end
		end

		meta.__Cstor = function(...)
			local args = {...};
			if #(args) == 1 and type(args[1]) == "table" and args[1].GetValue then
				if (inheritiedClass) then
					inheritiedClass.__Cstor(args[1]);
				end
				deserialize.value(args[1]);
			else	
				if constructor then
					constructor(...);
				elseif inheritiedClass then
					inheritiedClass.__Cstor(...);
				end
			end
			return class;
		end

		setmetatable(class, {
			__index = function(_, key)
				if type(key) == "number" and info.isIndexer then
					return indexerValues[key];
				elseif meta[key] then
					return meta[key];
				elseif key == "__base" then
					return inheritiedClass;
				elseif methods[key] then 
					return methods[key];
				elseif nonStaticVariables[key] then 
					return nonStaticValues[key];
				elseif staticVariables[key] then 
					return staticValues[key];
				elseif staticGetters[key] then 
					if type(staticGetters[key].value) == "function" then
						return staticGetters[key].value();
					end
					return staticValues[key];
				elseif nonStaticGetters[key] then 
					if type(nonStaticGetters[key].value) == "function" then
						return nonStaticGetters[key].value();
					end
					return nonStaticValues[key];
				elseif not(inheritiedClass) and (nonStaticSetters[key] or staticSetters[key]) then
					error("Cannot get value for setter that is defined without a getter");
				elseif info.isDictionary then
					return dictionaryValues[key];
				elseif inheritiedClass then
					return inheritiedClass[key];
				end
			end,
			__newindex = function(_, key, value)
				if type(key) == "number" and info.isIndexer then
					indexerValues[key] = value;
				elseif meta[key] then
					error("Cannot assign value to "..tostring(key));
				elseif methods[key] then 
					error("Cannot assign value to method field "..tostring(key));
				elseif nonStaticVariables[key] then 
					nonStaticValues[key] = value;
				elseif staticVariables[key] then 
					staticValues[key] = value;
				elseif staticSetters[key] then 
					if type(staticSetters[key].value) == "function" then
						staticSetters[key].value(value);
					else
						staticValues[key] = value;
					end
				elseif nonStaticSetters[key] then 
					if type(nonStaticGetters[key].value) == "function" then
						nonStaticGetters[key].value(value);
					else
						nonStaticValues[key] = value;
					end
				elseif not(inheritiedClass) and (nonStaticGetters[key] or staticGetters[key]) then
					error("Cannot set value for getter that is defined without a setter");
				elseif info.isDictionary then
					dictionaryValues[key] = value;
				elseif inheritiedClass then
					inheritiedClass[key] = value;
				end
			end,
		});      

		return class, populateOverride;
	end

	local ClassWithOverride = function(generics)
		local overriddenClass = {};
		local class, populateParentOverrides = initializeClass(generics, overriddenClass);

		local overrides;

		local populateOverrides = function()
			if populateParentOverrides then
				overrides = populateParentOverrides();
			else
				overrides = {};
			end

			local ownOverrides = class.__GetOverrides();
			for i,v in pairs(ownOverrides) do
				overrides[i] = v;
			end

			return overrides;
		end

		setmetatable(overriddenClass, {
			__index = function(_, key)
				if overrides == null then
					populateOverrides();
				end
				if overrides[key] then
					return overrides[key];
				end
				return class[key];
			end,
			__newindex = function(_, key, value)
				class[key] = value;
			end,
		});

		return overriddenClass, class, populateOverrides;
	end

	if (info.isStatic) then
		local staticClass = nil;
		local Init = function()
			if staticClass == nil then
				staticClass = initializeClass().__Cstor();
			end
		end

		setmetatable(namespaceElement, {
			__index = function(_, key)
				Init();
				return getStaticValue(key);
			end,
			__newindex = function(_, key, value)
				Init();
				setStaticValue(key, value);
			end,
		});
	else
		setmetatable(namespaceElement, {
			__call = function(_, ...)
				return ClassWithOverride(...);
			end,
			__index = function(_, key)
				initializeStaticElements();
				return getStaticValue(key);
			end,
			__newindex = function(_, key, value)
				initializeStaticElements();
				setStaticValue(key, value);
			end,
		});
	end

	return namespaceElement;
end

System = System or {};
System.Action = function() 
	return {
		__Cstor = function(func) return func; end,
	};
end
System.Enum = {
	Parse = CsLuaMeta.EnumParse,
}
System.NotImplementedException = function(...) return CsLua.NotImplementedException(...) end;
System.Exception = function(...) return CsLua.CsException(...) end;
System.Type = function(name)
	local class = { FullName = name };
	CsLua.CreateSimpleClass(class, class, "Type", "System.Type");
	return class;
end

System.Collections = {
	Generic = {
		IDictionary = function()
			return {
				isInterface = true,
				name = "IDictionary",
				__AddImplementedSignatures = function() end,
			}
		end
	}
}


CsLuaAttributes = { 
	ICsLuaAddOn = function() return null; end
}