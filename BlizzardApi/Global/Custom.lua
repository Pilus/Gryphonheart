--TargetFile: BlizzardApi.lua

GetGlobal = function(index, type, skipValidation)
	if (type) then
		return CsLua.Wrapping.Wrapper.WrapObject[{{name = type.FullName}}](_G[index], skipValidation);
	end
	return _G[index]; 
end
SetGlobal = function(index, value) _G[index] = value; end