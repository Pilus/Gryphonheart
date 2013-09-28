--===================================================
--
--				GHI_ChatConfirm
--				GHI_ChatConfirmUI.lua
--
--		Permission confirm for SendChatMessages.
--
-- 		(c)2013 The Gryphonheart Team
--			  All rights reserved
--===================================================

local class;

function GHI_SoundConfirm()
	if class then
		return class;
	end

	class = GHClass("GHI_SoundConfirm");
	local soundQueue = {};
	local menuFrame;
	local misc = GHI_MiscAPI().GetAPI()
	local miscAPI = GHI_MiscAPI().GetAPI();
	local containerAPI = GHI_ContainerAPI().GetAPI();
	local loc = GHI_Loc();
	class.QueueSound = function(soundPath,player)
		table.insert(soundQueue, {
			soundPath = soundPath,
			player = player,
		});
		class.ShowWindow();
	end

	class.ShowWindow = function()
		menuFrame.ForceLabel("text_sample", soundQueue[1].soundPath);
		menuFrame.ForceLabel("text_player", string.format(loc.SOUNDCONFIRM_SEND_BY,soundQueue[1].player));
		menuFrame:Show();
	end

	class.HandleQueue = function()
		table.remove(soundQueue, 1);
		if (table.getn(soundQueue) > 0) then
			--print(soundQueue[1].text);
			class.ShowWindow();
		else
			menuFrame:Hide();
		end
	end

	-- Menu setup
	menuFrame = GHM_NewFrame(class,
		{
			onOk = function(self) end,
			{
				{
					{
						height = 2,
						type = "Dummy",
						align = "c",
						width = 10,
					},
				},
				{
					{
						align = "c",
						type = "Text",
						text = loc.SOUNDCONFIRM_INSTRUCTION_TOP,
						fontSize = 11,
						color = "white",
						width = 340
					},
				},
				{
					{
						align = "c",
						type = "Text",
						label = "text_player",
						text = "",
						fontSize = 11,
						color = "orange",
						width = 290
					},
				},
				{
					{
						align = "c",
						type = "Text",
						label = "text_sample",
						text = "SAMPLE",
						fontSize = 11,
						color = "orange",
						width = 290
					},
				},
				{
					{
						height = 3,
						type = "Dummy",
						align = "c",
						width = 10,
					},
				},
				{
					{
						align = "c",
						type = "Text",
						text = loc.SOUNDCONFIRM_INSTRUCTION_BOTTOM,
						fontSize = 11,
						color = "white",
						width = 290
					},
				},
				{
					{
						height = 8,
						type = "Dummy",
						align = "c",
						width = 10,
					},
				},
				{
					{
						height = 8,
						type = "Dummy",
						align = "l",
						width = 70,
					},
					{
						align = "l",
						type = "Button",
						text = "OK",
						label = "send",
						onclick = function()
							PlaySoundFile(soundQueue[1].soundPath);
							if GHI_MiscData["show_area_sound_sender"] then
								GHI_Message("Area sound by " .. (soundQueue[1].player or "nil"));    --todo: loc
							end
							class.HandleQueue();
						end,
					},
					{
						height = 8,
						type = "Dummy",
						align = "r",
						width = 70,
					},
					{
						align = "r",
						type = "Button",
						text = "Cancel",
						label = "nosend",
						onclick = function()
							class.HandleQueue();
						end,
					},
				},
			},
			title = loc.SOUNDCONFIRM,
			name = "GHI_SoundConfirmUI",
			theme = "BlankTheme",
			width = 350,
			useWindow = true,
		});
	return class;
end

