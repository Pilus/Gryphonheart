--
--
--				GHI_Event
--  			GHI_Event.lua
--
--	Event handler for both blizzard events and internal events
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--
local PRINT_HIGH_MEMORY_MSG = false;

local class;
local registered = {};
local RegisterEvent;

function GHI_Event(event, func, priority)
	if class then
		if event and func then
			RegisterEvent(event, func, priority);
		end
		return class;
	end
	class = GHClass("GHI_Event","frame");

	RegisterEvent = function(e, f, priority)
		assert(type(e)=="string","Event must be a string");
		assert(type(f)=="function","Func must be a function")
		if e and f then
			if not (registered[e]) then
				registered[e] = {};
				class:RegisterEvent(e);
			end
			table.insert(registered[e], {priority = priority, func = f});
		end
	end

	local eventsToTrigger = {};

	class.TriggerEvent = function(event, ...)
		for _, otherEvent in pairs(eventsToTrigger) do
			if otherEvent[1] == event then
				local identical = true;
				local args = { ... };
				for i = 1, #(args) do
					if not (args[i] == otherEvent[i + 1]) then
						identical = false;
					end
				end
				if identical == true and not(class.allowIdentical == true) then
					return;
				end
			end
		end
		table.insert(eventsToTrigger, { event, ... })
	end

	class.TriggerEventOnAllFrames = function(event, ...)
		for _, otherEvent in pairs(eventsToTrigger) do
			if otherEvent[1] == event then
				local identical = true;
				local args = { ... };
				for i = 1, #(args) do
					if not (args[i] == otherEvent[i + 1]) then
						identical = false;
					end
				end
				if identical == true then
					return;
				end
			end
		end
		table.insert(eventsToTrigger, { onAll=true, event, ... })
	end

	class:SetScript("OnUpdate", function(self)
		for i, eventTable in pairs(eventsToTrigger) do
			local event = eventTable[1];
			for j=1,2 do
				for _, data in pairs(registered[event] or {}) do
					local func = data.func;
					if func then
						local priority = data.priority;
						if (j==1 and priority == true) or (j==2 and not(priority)) then
							func(unpack(eventTable));
							if PRINT_HIGH_MEMORY_MSG then
								UpdateAddOnMemoryUsage()
								local memoryBefore = GetAddOnMemoryUsage("GHI");
								func(unpack(eventTable));
								UpdateAddOnMemoryUsage()
								local memoryDiff = GetAddOnMemoryUsage("GHI") - memoryBefore;
								if (memoryDiff) > 0 then
									print(memoryDiff,"event",event)
								end
							end
						end
					end
				end
			end
			if eventTable.onAll then
				local t = {GetFramesRegisteredForEvent(event)};
				for _,frame in pairs(t) do
					local s = frame:GetScript("OnEvent");
					if s then
						s(frame, unpack(eventTable));
					end
				end
			end
		end
		eventsToTrigger = {};
	end);

	class:SetScript("OnEvent", function(self, ...) class.TriggerEvent(...) end);

	registered = {};
	if event and func then
		RegisterEvent(event, func, priority);
	end

	return class;
end

