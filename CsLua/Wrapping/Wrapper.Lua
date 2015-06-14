--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.Wrapping = CsLua.Wrapping or {};

local ValidateObjAgainstInterface = function(obj, interface)
	for _, method in ipairs(interface.methods) do
		local name = method.name;
		if not(type(obj[name]) == "function") then
			CsLuaMeta.Throw(CsLua.Wrapping.WrapperException().__Cstor("Object does not implement method: " .. name));
		end
	end
end

local getMethodsByName;
getMethodsByName = function(interface, name, m)
	m = m or {};
	for _, method in ipairs(interface.methods) do
		if method.name == name then
			table.insert(m, method);
		end
	end

	for _, implementedInterface in ipairs(interface.implementedInterfaces) do
		getMethodsByName(implementedInterface, name, m);
	end

	return m;
end

local getPropertyByName
getPropertyByName = function(interface, name)
	for _, property in ipairs(interface.properties) do
		return property;
	end

	for _, implementedInterface in ipairs(interface.implementedInterfaces) do
		local property = getPropertyByName(implementedInterface, name);
		if property then
			return property;
		end
	end

	return nil;
end

local getMethodFittingSignature = function(methods, ...)
	local argSignature = CsLuaMeta.GetSignatures(...);
	local args = {...};

	local bestMethod, bestScore;

	for _, method in pairs(methods) do
		local score = CsLuaMeta.ScoreFunction(method.signature, argSignature, args, {});
		if (score and (bestScore == nil or bestScore > score)) then
			bestScore = score;
			bestMethod = method;
		end
	end

	return bestMethod;
end

CsLua.Wrapping.Wrapper = {
	WrapGlobalObject = CsLuaMeta.GenericsMethod(function(generics, name, skipValidation)
		return CsLua.Wrapping.Wrapper.WrapObject[generics](_G[name], skipValidation);
	end),
	
	WrapObject = CsLuaMeta.GenericsMethod(function(generics, obj, skipValidation)
		if not(type(generics)=="table") or not(type(generics[1]) == "table") or not(type(generics[1].name) == "string") then
			CsLuaMeta.Throw(CsLua.Wrapping.WrapperException().__Cstor("No interface provided to wrap object in."));
		end

		if obj.__wrap and obj.__wrap.__interfaceName == generics[1].name then
			return obj.__wrap;
		end

		local interface = CsLuaMeta.GetByFullName(generics[1].name)(generics[1].innerGenerics);

		if not(skipValidation == true) then
			ValidateObjAgainstInterface(obj, interface);
		end

		local signatures = {};
		interface.__AddImplementedSignatures(signatures);

		local wrap = {};
		local auxClass = {
			__obj = obj;
			__interfaceName = generics[1].name;
		};

		setmetatable(wrap, {
			__index = function(_, key)
				if auxClass[key] then
					return auxClass[key];
				end

				local methods = getMethodsByName(interface, key);
				if #(methods) > 0 then
					return function(...)
						local method = getMethodFittingSignature(methods, ...);
						if not(method) then
							CsLuaMeta.Throw(CsLua.Wrapping.WrapperException().__Cstor("No method found for key '"..key.."' matching the signature: '"..CsLuaMeta.SignatureToString(CsLuaMeta.GetSignatures(...)).."'"));
						end

						local unwrappedArgs = {};
						for i = 1,select('#', ...) do
							unwrappedArgs[i] = CsLua.Wrapping.Wrapper.TryUnwrapObject[nil](select(i, ...));
						end

						local returnArgs;
						if interface.provideSelf then
							returnArgs = {obj[key](obj, unpack(unwrappedArgs))};
						else
							returnArgs = {obj[key](unpack(unwrappedArgs))};
						end

						if #(returnArgs) > 1 then
							return CsLua.Wrapping.MultipleValues(nil).__Cstor(unpack(returnArgs));
						elseif type(returnArgs[1]) == "table" then
							local typeFunc = CsLuaMeta.GetByFullName(method.returnType, true);
							if type(typeFunc) == "function" and typeFunc(nil).isInterface then
								return CsLua.Wrapping.Wrapper.WrapObject[method.returnType](returnArgs[1]);
							end
						end

						return returnArgs[1];
					end
				end

				local property = getPropertyByName(interface, key);
				if not(property) then
					CsLuaMeta.Throw(CsLua.Wrapping.WrapperException().__Cstor("Object interface does not define a property or method matching key '" .. tostring(key) .. "'"));
				end

				local returnArg = obj[key];
				if type(returnArg == "table") then
					local typeFunc = CsLuaMeta.GetByFullName(property.type, true);
					if type(typeFunc) == "function" and typeFunc(nil).isInterface then
						return CsLua.Wrapping.Wrapper.WrapObject[method.returnType](returnArg);
					end
				end

				return returnArg;
			end,
			__newindex = function(_, key, value)
				local property = getPropertyByName(interface, key);
				if not(property) then
					CsLuaMeta.Throw(CsLua.Wrapping.WrapperException().__Cstor("Object interface does not define a property matching key '" .. tostring(key) .. "'"));
				end

				obj[key] = CsLua.Wrapping.Wrapper.TryUnwrapObject[nil](value);
			end,
		});

		CsLua.CreateSimpleClass(auxClass, wrap, interface.name, generics[1], nil, nil, nil, nil, signatures);

		obj.__wrap = wrap;
		return wrap;
	end),

	TryUnwrapObject = CsLuaMeta.GenericsMethod(function(generics, obj)
		if type(value) == "table" and obj.__obj then
			return obj.__obj;
		end

		return obj;
	end),
}