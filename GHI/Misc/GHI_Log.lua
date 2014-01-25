--===================================================
--									
--					GHI Event Logger
--					GHI_Log.lua
--
--	Logging of events in GHI to aid the debugging process
--	
-- 			(c)2013 The Gryphonheart Team
--					All rights reserved
--===================================================

local class;
function GHI_Log()

	if class then
		return class;
	end
	class = GHClass("GHI_Log");

	local tostring;
	local events = {};
	local number = 1;

	class.Add = function(degree, message, details)
		GHCheck("GHI_Log.Add", { "Number", "String", "TableNil" }, { degree, message, details })
		table.insert(events, { degree = degree, message = message, details = details, time = date("%m/%d/%y %H:%M:%S"), number = number });
		number = number + 1;
		while #(events) > 100 do
			table.remove(events, 1);
		end
	end

	tostring = function(o)
		if type(o) == "string" then
			return "\"" .. o .. "\"";
		elseif type(o) == "number" then
			return o .. "";
		elseif type(o) == "boolean" then
			if o == true then
				return "true";
			else
				return "false";
			end
		end
		return type(o);
	end

	class.ToText = function()
		local s;
		local types = { "Error", "Warning", "Notification" }

		s = format("Event Log: Gryphonheart Items v. %s\n", GetAddOnMetadata("GHI", "Version"));
		s = format("%s%i entries\n\n", s, #(events));

		for i, event in pairs(events) do
			s = format("%s%s - %s %s: %s\n", s, event.number, event.time, types[event.degree] or "Other", event.message);
			if event.details then
				for index, data in pairs(event.details) do
					if not (data == "") then
						s = format("%s   %s = %s,\n", s, index, tostring(data));
					end
				end
			end
			s = format("%s\n", s);
		end
		return s;
	end

	class.GetRaw = function()
		return events;
	end

	return class;
end