--TargetFile: CsLua.lua

CsLua = CsLua or {};
CsLua.Wrapping = CsLua.Wrapping or {};

CsLua.Wrapping.MultipleValues = function(generics)
	local class = {};
		
	local cstor = function(...)
		for i=1, select("#", ...) do
			class["Value"..i] = select(i, ...);
		end
	end

	CsLua.CreateSimpleClass(class, class, "MultipleValues", "CsLua.Wrapping.MultipleValues", cstor, nil, nil, nil, {"CsLua.Wrapping.IMultipleValues"})
	
	return class;
end

