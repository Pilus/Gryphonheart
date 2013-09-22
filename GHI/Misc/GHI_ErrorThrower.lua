--===================================================
--									
--									GHI Error Thrower 
--								GHI_ErrorThrower.lua
--
--				Handles throwing of player errors (e.g. 'Too far away')
--	
-- 						(c)2013 The Gryphonheart Team
--								All rights reserved
--===================================================

local class;
function GHI_ErrorThrower()
	if class then
		return class;
	end
	class = GHClass("GHI_ErrorThrower");

	class.TooFarAway = function()
		local race = UnitRace("player");
		local gender = UnitSex("player");
		local rand = random(1, 3);
		if gender == 2 then
			gender = "Male";
		else
			gender = "Female";
		end
		local index = { 2, 4, 5 };
		race = gsub(race, " ", "");

		if race == "BloodElf" or race == "Draenei" then
			PlaySoundFile("Sound\\Character\\" .. race .. "\\" .. race .. "" .. gender .. "_Err_OutOfRange0" .. rand .. ".wav");
		elseif race == "Human" then
			PlaySoundFile("Sound\\Character\\" .. race .. "\\" .. gender .. "ErrorMessages\\" .. race .. gender .. "_err_outofrange0" .. index[rand] .. ".wav");
		else
			PlaySoundFile("Sound\\Character\\" .. race .. "\\" .. race .. "" .. gender .. "ErrorMessages\\" .. race .. "" .. gender .. "_err_outofrange0" .. index[rand] .. ".wav");
		end
		UIErrorsFrame:AddMessage("Out of range.", 1.0, 0.0, 0.0, 53, 5);
	end

	class.CantUseItem = function(customMsg)
		local race = UnitRace("player");
		local gender = UnitSex("player");
		local rand = random(1, 3);
		if gender == 2 then
			gender = "Male";
		else
			gender = "Female";
		end

		race = gsub(race, " ", "");

		if race == "BloodElf" or race == "Draenei" then
			PlaySoundFile("Sound\\Character\\" .. race .. "\\" .. race .. "" .. gender .. "_Err_ItemCooldown0" .. rand .. ".wav");
		elseif race == "Human" then
			PlaySoundFile("Sound\\Character\\" .. race .. "\\" .. gender .. "ErrorMessages\\" .. race .. gender .. "_err_itemcooldown0" .. (rand * 2) .. ".wav")
		else
			PlaySoundFile("Sound\\Character\\" .. race .. "\\" .. race .. "" .. gender .. "ErrorMessages\\" .. race .. "" .. gender .. "_err_itemcooldown0" .. (rand * 2) .. ".wav")
		end
		UIErrorsFrame:AddMessage(customMsg or "Item is not ready yet.", 1.0, 0.0, 0.0, 53, 5);
	end

	return class;
end




