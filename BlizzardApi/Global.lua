GetGlobal = function(index) return _G[index]; end
SetGlobal = function(index, value) _G[index] = value; end


local returnGlobal = {};
setmetatable(returnGlobal, {
	__index = function(_, key)
		if type(_G[key]) == "function" then
			return function(...)
				local ret = {_G[key](...)};
				if #(ret) <= 1 then
					return ret[1];
				end
				local tuple = {};
				for i = 1, #(ret) do
					tuple["Item"..i] = ret[i];
				end
				return tuple;
			end
		elseif type(_G[key]) and type(_G[key].GetParent) then
			return SetSelf(_G[key]);
		end
		return _G[key];
	end,
	__newindex = function(_, key, value)
	end,
});
BlizzardApi.Global = { 
	Global = {
		Api = returnGlobal,
		Frames = returnGlobal,
	}
}