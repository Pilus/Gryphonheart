--TargetFile: BlizzardApi.lua

GetGlobal = function(index, type)
	if (type) then
		return CsLua.Wrapping.Wrapper.WrapObject[{{name = type.FullName}}](_G[index]);
	end
	return _G[index]; 
end
SetGlobal = function(index, value) _G[index] = value; end