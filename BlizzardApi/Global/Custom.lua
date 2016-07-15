--TargetFile: BlizzardApi.lua

GetGlobal = function(index)
    return _G[index]; 
end
SetGlobal = function(index, value) 
    _G[index] = value; 
end