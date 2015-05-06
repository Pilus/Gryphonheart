
local Enum = function()
  local c = {};
	setmetatable(c, {
		__index = function(_, key)
      return key;
    end
  });
  return c;
end

local EnumTable = function()
  local c = {};
	setmetatable(c, {
		__index = function(_, key)
      return Enum();
    end
  });
  return c;
end

BlizzardApi = {
  WidgetEnums = EnumTable(),
  Events = EnumTable(),
  MiscEnums = EnumTable(),
}
