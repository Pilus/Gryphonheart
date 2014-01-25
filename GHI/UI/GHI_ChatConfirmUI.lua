--===================================================
--
--				GHI_ChatConfirm
--				GHI_ChatConfirmUI.lua
--
--		Permission confirm for SendChatMessages.
--
--		(c)2013 The Gryphonheart Team
--			  All rights reserved
--===================================================

local class;

function GHI_ChatConfirm()
	if class then
		return class;
	end

	class = GHClass("GHI_ChatConfirm");
	local messageQueue = {};
	local menuFrame;
	local miscAPI = GHI_MiscAPI().GetAPI();
	local containerAPI = GHI_ContainerAPI().GetAPI();
	local loc = GHI_Loc();
	class.QueueMessage = function(text, chatType, language, channel)
		table.insert(messageQueue, {
			text = text,
			chatType = chatType,
			language = language,
			channel = channel
		});
		class.ShowWindow();
	end

	class.ShowWindow = function()
		menuFrame.ForceLabel("text_sample", messageQueue[1].text);
		menuFrame.ForceLabel("text_type", "|CFFFFFFFF" .. loc.CHATCONFIRM_TYPE .. ":|R " .. messageQueue[1].chatType);
		menuFrame:Show();
	end

	class.HandleQueue = function()
		table.remove(messageQueue, 1);
		if (table.getn(messageQueue) > 0) then
			--print(messageQueue[1].text);
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
						text = loc.CHATCONFIRM_INSTRUCTION_TOP,
						fontSize = 11,
						color = "white",
						width = 340
					},
				},
				{
					{
						height = 10,
						type = "Dummy",
						align = "c",
						width = 10,
					},
				},
				{
					{
						align = "c",
						type = "Text",
						label = "text_type",
						text = "MESSAGE TYPE",
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
						text = "MESSAGE SAMPLE",
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
						text = loc.CHATCONFIRM_INSTRUCTION_BOTTOM,
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
							GHI_ExpressionHandler().ExecuteSendMessage(messageQueue[1].text, messageQueue[1].chatType, messageQueue[1].language, messageQueue[1].channel);
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
			title = loc.CHATCONFIRM,
			name = "GHI_ChatConfirmUI",
			theme = "BlankTheme",
			width = 350,
			useWindow = true,
		});
	return class;
end

