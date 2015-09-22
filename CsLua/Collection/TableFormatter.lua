--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.Collection = CsLua.Collection or {};
CsLua.Collection.TableFormatter = function()
	local class = {}

	local useCompact = false;

	local Cstor = function()
	end

	CsLua.CreateSimpleClass(class, class, "TableFormatter", "CsLua.Collection.TableFormatter", Cstor, nil, nil, nil, {{"CsLua.Collection.ITableFormatter"}});

	local serializeValue;
	serializeValue = function(value)
		if (type(value) == "table" and value.__fullTypeName) then
			if (value.__Serialize) then
				return value.__Serialize(serializeValue);
			else
				error("Cannot serialize " .. value.__fullTypeName)
			end
		elseif (type(value) == "function") then
			return nil;
		end

		return value;
	end

	local deserializeValue;
	deserializeValue = function(value)
		if type(value) == "table" and value.__type then
			local classMeta = CsLuaMeta.GetByFullName(value.__type);
			local class;
			if (value.__type == "System.Array") then
				class = classMeta(value.__generic).__Cstor(value.__size);
			else
				class = classMeta(value.__generic).__Cstor();
			end

			if class.__Deserialize then
				class.__Deserialize(deserializeValue, value);
			else
				error("Cannot deserialize " .. value.__type)
			end
			return class;
		end
		return value;
	end

	class.Serialize = function(graph)
		assert(type(graph) == "table" and type(graph.__Serialize) == "function", "Argument must be a serializable class.");
		return serializeValue(graph);
	end
		
	class.Deserialize = function(info)
		return deserializeValue(info);
	end
		
	return class;
end
	
