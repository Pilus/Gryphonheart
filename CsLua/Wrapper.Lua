--TargetFile: CsLua.lua

CsLua = CsLua or {};

local ValidateObjAgainstInterface = function(obj, interface)
	for _, method in ipairs(interface.methods) do
		local name = method.name;
		if not(type(obj[name]) == "function") then
			__Throw(CsLua.WrapperException().__Cstor("Object does not implement method: " .. name));
		end
	end
end

local getMethodsByName = function(interface, name, m)
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

local getPropertyByName = function(interface, name)
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
	local argSignature = __GetSignatures(...);
	local args = {...};

	local bestMethod, bestScore;

	for _, method in pairs(methods) do
		local score = __ScoreFunction(method.signature, argSignature, args, {});
		if (score and (bestScore == nil or bestScore > score)) then
			bestScore = score;
			bestMethod = method;
		end
	end

	return bestMethod;
end

CsLua.Wrapper = {
	WrapGlobalObject = __GenericsMethod(function(generics, name)
		return CsLua.Wrapper.WrapObject[generics](_G[name]);
	end),
	
	WrapObject = __GenericsMethod(function(generics, obj)
		if obj.__wrap then
			return obj.__wrap;
		end

		local interface = __GetByFullName(generics[1].name)(generics[1]);

		ValidateObjAgainstInterface(obj, interface);

		local signatures = {};
		interface.__AddImplementedSignatures(signatures);

		local wrap = {};
		local auxClass = {
			__obj = obj;
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
							__Throw(CsLua.WrapperException().__Cstor("No method found for key '"..key.."' matching the signature: '"..__SignatureToString(__GetSignatures(...)).."'"));
						end

						local unwrappedArgs = {};
						for i = 1,select('#', ...) do
							unwrappedArgs[i] = CsLua.Wrapper.TryUnwrapObject[nil](select(i, ...));
						end

						local returnArg;
						if interface.provideSelf then
							returnArg = obj[key](obj, unpack(unwrappedArgs));
						else
							returnArg = obj[key](unpack(unwrappedArgs));
						end

						if type(returnArg == "table") then
							local typeFunc = __GetByFullName(method.returnType, true);
							if type(typeFunc) == "function" and typeFunc(nil).isInterface then
								return CsLua.Wrapper.WrapObject[method.returnType](returnArg);
							end
						end

						return returnArg;
					end
				end

				local property = getPropertyByName(interface, key);
				if not(property) then
					__Throw(CsLua.WrapperException().__Cstor("Object interface does not define a property or method matching key '" .. tostring(key) .. "'"));
				end

				local returnArg = obj[key];
				if type(returnArg == "table") then
					local typeFunc = __GetByFullName(property.type, true);
					if type(typeFunc) == "function" and typeFunc(nil).isInterface then
						return CsLua.Wrapper.WrapObject[method.returnType](returnArg);
					end
				end

				return returnArg;
			end,
			__newindex = function(_, key, value)
				local property = getPropertyByName(interface, key);
				if not(property) then
					__Throw(CsLua.WrapperException().__Cstor("Object interface does not define a property matching key '" .. tostring(key) .. "'"));
				end

				obj[key] = CsLua.Wrapper.TryUnwrapObject[nil](value);
			end,
		});

		CsLua.CreateSimpleClass(auxClass, wrap, interface.name, generics[1], nil, nil, nil, nil, signatures);

		obj.__wrap = wrap;
		return wrap;
	end),

	TryUnwrapObject = __GenericsMethod(function(generics, obj)
		if type(value) == "table" and obj.__obj then
			return obj.__obj;
		end

		return obj;
	end),
}