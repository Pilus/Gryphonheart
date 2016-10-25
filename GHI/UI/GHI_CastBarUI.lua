--
--
--				GHI_CastBarUI
--				GHI_CastBarUI.lua
--
--			UI for cast bar
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--
local currentCasting = {};
local orig_UnitCastingInfo = UnitCastingInfo;
UnitCastingInfo = function(unit)
	local current = currentCasting[unit];
	if current and current.castTime + current.duration >= GetTime() then
		return current.name, nil, current.name, current.icon, current.castTime*1000, current.castTime*1000 + current.duration*1000, true, current.num, false;
	end
	return orig_UnitCastingInfo(unit);
end

local function UpdateNonBlizzardCast()

---function to force update qurtz or other addons as needed
if IsAddOnLoaded("Quartz") then

	Quartz3CastBarPlayer:UNIT_SPELLCAST_STOP("Player","player")
	Quartz3CastBarPlayer:UpdateUnit()
end


end

local class;
function GHI_CastBarUI()
	if class then
		return class;
	end
	class = GHClass("GHI_CastBarUI");

	local event = GHI_Event();

	local num = 0;
	local pos = GHI_Position();

	class.Cast = function(unit,name,icon,duration,doneFunction,interruptedFunction)
		num = num-1;
		currentCasting[unit] = {
			name = name,
			icon = icon,
			duration = duration,
			castTime = GetTime(),
			num = num,
			interruptedFunction = interruptedFunction,
		};
		--print(num)
		pos.OnNextMoveCallback(0.1,function()
			if currentCasting[unit] and currentCasting[unit].num == num then
				class.Interrupt(unit);
			end
		end);

		if doneFunction then
			local number = num;
			GHI_Timer(function()
				if currentCasting[unit] and currentCasting[unit].num == number then
					UpdateNonBlizzardCast()
					doneFunction();
				end
			end,duration,true);
		end

		event.TriggerEventOnAllFrames("UNIT_SPELLCAST_START",unit,name,nil,num)
	end

	class.Interrupt = function(unit)
		local current = currentCasting[unit];
		if current then
			currentCasting[unit] = nil;
			UpdateNonBlizzardCast()
			event.TriggerEventOnAllFrames("UNIT_SPELLCAST_INTERRUPTED",unit,current.name,nil,current.num);
			if current.interruptedFunction then
				current.interruptedFunction();
			end
		end
	end

	return class;
end

