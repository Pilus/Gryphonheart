--===================================================
--
--				GHI_UpdateSequenceMenu
--  			GHI_UpdateSequenceMenu.lua
--
--		Menu for update sequences for attributes.
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local UPDATE_FREQUENCIES = {
	1,
	60,
	600,
	"login",
	"containerChange",
	"tradeRecieve",
};

local count = 1;
function GHI_UpdateSequenceMenu()
	local class = GHClass("GHI_UpdateSequenceMenu");

	local menuFrame;
	local OnOk;
	local set;
	local loc = GHI_Loc()
	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				{
					type = "Text",
					text = loc.SEQM_TEXT,
					align = "l",
					color = "white",
				},
			},
			{
				{
					align = "r",
					type = "DropDown",
					text = loc.SEQ_FREQUENCY,
					label = "frequency",
					returnIndex = true,
					dataFunc = function()
						local t = {};
						for i = 1, #(UPDATE_FREQUENCIES) do
							table.insert(t, loc["SEQ_FREQUENCY_" .. string.upper(UPDATE_FREQUENCIES[i])] or "Unknown");
						end
						return t;
					end,
				},
			},
			{
				{
					type = "DynamicActionArea",
					align = "c",
					label = "updateSequence",
					width = 360,
					height = 180,
					isUpdateSequence = true,
				},
			},
			{
				{
					type = "Dummy",
					height = 10,
					align = "l",
				},
				{
					type = "Button",
					text = OKAY,
					align = "l",
					label = "ok",
					compact = false,
					OnClick = function() if OnOk then OnOk() end end,
				},
				{
					type = "Dummy",
					height = 10,
					align = "l",
				},
				{
					type = "Button",
					text = CANCEL,
					align = "l",
					label = "cancel",
					compact = false,
					OnClick = function(obj)
						menuFrame:Hide();
					end,
				},
				{
					type = "Dummy",
					height = 10,
					align = "l",
				},
			},
		},
		title = loc.SEQM_TITLE,
		name = "GHI_UpdateSequenceMenu" .. count,
		theme = "BlankTheme",
		width = 380,
		useWindow = true,
		lineSpacing = 20,
	});
	count = count + 1;

	menuFrame:Hide();

	local SetMenu = function(item, editSeq, editFreq)

		if editSeq then
			local setData = editSeq.Serialize();
			set = GHI_DynamicActionInstanceSet(item, "OnUpdate",{name=loc.DYN_PORT_ONUPDATE_NAME,description=loc.DYN_PORT_ONUPDATE_DESCRIPTION})
			set.SetIsUpdateSequence(true);
			set.Deserialize(setData);
			for i, freqName in pairs(UPDATE_FREQUENCIES) do
				if freqName == editFreq then
					menuFrame.ForceLabel("frequency", i);
				end
			end
		else
			set = GHI_DynamicActionInstanceSet(item, "OnUpdate",{name=loc.DYN_PORT_ONUPDATE_NAME,description=loc.DYN_PORT_ONUPDATE_DESCRIPTION})
			set.SetIsUpdateSequence(true);
			menuFrame.ForceLabel("frequency", 1);
		end


		menuFrame.GetLabelFrame("updateSequence").SetDynamicActionInstanceSet(set);
	end

	class.New = function(parentItem, createdFeedbackFunc)
		menuFrame:AnimatedShow();
		OnOk = function()

			menuFrame:Hide();
			local freq = UPDATE_FREQUENCIES[menuFrame.GetLabel("frequency") or 1];
			parentItem.AddUpdateSequence(set, freq)
			if createdFeedbackFunc then
				createdFeedbackFunc(set, freq)
			end
		end
		SetMenu(parentItem);
	end

	class.Edit = function(parentItem, editSeq, editFreq, createdFeedbackFunc)
		menuFrame:AnimatedShow();
		OnOk = function()

			menuFrame:Hide();
			local freq = UPDATE_FREQUENCIES[menuFrame.GetLabel("frequency") or 1];
			parentItem.ReplaceUpdateSequence(editSeq, set, freq)
			if createdFeedbackFunc then
				createdFeedbackFunc(set, freq)
			end
		end
		SetMenu(parentItem, editSeq, editFreq);
	end

	return class;
end

