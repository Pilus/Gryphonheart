--
--
--				GHG_LogEvent
--  			GHG_LogEvent.lua
--
--	Holds informations about a log event.
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHG_LogEvent(info)
	local class = GHClass("GHG_LogEvent");

	local eventType, timeStamp, author, args;

	class.GetInfo = function()
		return eventType, timeStamp, author, args;
	end

	class.CreateEvent = function(_eventType, _author, _args)
		eventType = _eventType;
		timeStamp = time();
		author = _author;
		args = _args;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or {};
		if not (stype) then
			t.eventType = eventType;
			t.timeStamp = timeStamp;
			t.author = author;
			t.args = args;
		end
		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	eventType = info.eventType;
	timeStamp = info.timeStamp;
	author = info.author;
	args = info.args or {};

	return class;
end

