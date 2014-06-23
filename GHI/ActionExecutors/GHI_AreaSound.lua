--===================================================
--									
--								GHI Area Sound
--								GHI_AreaSound.lua
--
--						Handling of area sounds
--	
-- 						(c)2013 The Gryphonheart Team
--								All rights reserved
--===================================================

local class;
function GHI_AreaSound()
	if class then
		return class;
	end

	class = GHClass("AreaSound");
	local position = GHI_Position();
	local comm = GHI_ChannelComm();
	local RecieveAreaSound, Send;
	local MAX_RANGE = 50;
	local ALLOWED_SOUND_PR_MIN = 5; --for spam prevention
	soundspamCount = 0;
	local log = GHI_Log();
	local loc = GHI_Loc();
	local delayedSounds = {};
	local lastDisallowedSound = 0;
	
	GHI_Timer(function()
		soundspamCount = max(0, soundspamCount - 1);
	end, 60 / ALLOWED_SOUND_PR_MIN);

	class.PlaySound = function(soundPath, range, delay)
		if type(delay) == "number" and delay > 0 then
			table.insert(delayedSounds, {
				path = soundPath,
				range = range,
				time = time() + delay
			});
			return
		end
		if type(range) == "number" and range > 0 and not (GHI_MiscData["block_area_sound"]) then
			Send(soundPath, range);
		else
			soundPath = gsub(soundPath, "\\\\", "/");
			soundPath = gsub(soundPath, "\\", "/");
			PlaySoundFile(soundPath);
		end
	end

	GHI_Timer(function()
		for i, v in pairs(delayedSounds) do
			if type(v) == "table" and (v.time or 0) <= time() then
				class.PlaySound(v.path, v.range, 0);
				delayedSounds[i] = nil;
			end
		end
	end, 1, false, "delayedSounds");

	Send = function(soundPath, range)
		local soundData = {
			soundPath = soundPath,
			delay = 0,
		};
		
		local playerPos = position.GetPlayerPos();
		playerPos.continent = playerPos.world;
		if soundspamCount == ALLOWED_SOUND_PR_MIN then
			GHI_Message(loc.ERR_SPAM_BLOCK);
			return;
		elseif soundspamCount > ALLOWED_SOUND_PR_MIN then
			return;
		else
			comm.Send(nil, "AreaSound", playerPos, range or 0, soundData)
			soundspamCount = soundspamCount+1;
		end
	end

	RecieveAreaSound = function(sender, playerPos, range, data, ...)
	
		local playSound = GHI_MiscData.soundPermission or 1;
		
		if GHI_MiscData["block_area_sound"] then
			return
		end

		if not(type(playerPos)=="table") or not(type(range)=="number")  or not(type(data)=="table") then
			return
		end
		playerPos.world = playerPos.world or playerPos.continent;
		if not(playerPos.world) or not(playerPos.x) or not(playerPos.y) then
			return
		end

		log.Add(3, "Recieved area sound from " .. sender, { playerPos, range, data, ... });
		playerPos.world = playerPos.world or playerPos.continent;

		if playerPos.world > 0 and position.IsPosWithinRange(playerPos, min(range, MAX_RANGE)) then
			
			local soundPath = gsub(data.soundPath, "\\\\", "/");
			soundPath = gsub(soundPath, "\\", "/");
			soundPath = (string.match(soundPath, "[a-zA-z0-9\\/_.%s]*"));
			if playSound == 2 then
				local sconfirm = GHI_SoundConfirm()
				sconfirm.QueueSound(soundPath,sender);
				return;
		   else
				PlaySoundFile(soundPath);
				if GHI_MiscData["show_area_sound_sender"] then
					GHI_Message("Area sound by " .. (sender or "nil"));    --todo: loc
				end
			end
		end
	end
	comm.AddRecieveFunc("AreaSound", RecieveAreaSound);

	return class;
end