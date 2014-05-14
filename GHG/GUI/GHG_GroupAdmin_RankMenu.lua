--===================================================
--
--				GHG_GroupAdmin_RankMenu
--  			GHG_GroupAdmin_RankMenu.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHG_GroupAdmin_RankMenu()
	if class then
		return class;
	end
	class = GHClass("GHG_GroupAdmin_RankMenu");

	local loc = GHG_Loc();


	local OnOk

	local menuFrame;
	menuFrame = GHM_NewFrame(class,{
		onOk = function(self) if OnOk then OnOk() end  end,
		{
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.NAME;
					label = "name",
					texture = "Tooltip",
					--width = 100,
				},
			},
			{
				{
					type = "CheckBox",
					text = loc.CAN_RANKS_PERM,
					align = "l",
					label = "canEditRanksAndPermissions",
					width = 150,
				},
				{
					type = "CheckBox",
					text = loc.CAN_PROMOTE_DEMOTE,
					align = "r",
					label = "canPromoteDemote",
					width = 150,
				},
			},
			{
				{
					type = "CheckBox",
					text = loc.CAN_INVITE,
					align = "l",
					label = "canInvite",
					width = 150,
				},
				{
					type = "CheckBox",
					text = loc.CAN_KICK,
					align = "r",
					label = "canKickMember",
					width = 150,
				},
			},
			{
				{
					type = "CheckBox",
					text = loc.CAN_EDIT_OFFICER_NOTE,
					align = "l",
					label = "canEditOfficersNote",
					width = 150,
				},
				{
					type = "CheckBox",
					text = loc.CAN_VIEW_OFFICER_NOTE,
					align = "r",
					label = "canViewOfficersNote",
					width = 150,
				},
			},
			{
				{
					type = "CheckBox",
					text = loc.CAN_EDIT_PUBLIC_NOTE,
					align = "l",
					label = "canEditPublicNote",
					width = 150,
				},
				{
					type = "CheckBox",
					text = loc.CAN_VIEW_PUBLIC_NOTE,
					align = "r",
					label = "canViewPublicNote",
					width = 150,
				},
			},
			{
				{
					type = "CheckBox",
					text = loc.CAN_TALK_IN_CHAT,
					align = "l",
					label = "canTalkInChat",
					width = 150,
				},
				{
					type = "CheckBox",
					text = loc.CAN_HEAR_CHAT,
					align = "r",
					label = "canHearChat",
					width = 150,
				},
			},
			{
				{
					type = "Dummy",
					height = 10,
					width = 70,
					align = "l",
				},
				{
					type = "Button",
					text = OKAY,
					align = "l",
					compact = false,
					OnClick = function()
						if OnOk then OnOk() end
					end,
				},
				{
					type = "Dummy",
					height = 10,
					width = 70,
					align = "r",
				},
				{
					type = "Button",
					text = CANCEL,
					align = "r",
					compact = false,
					OnClick = function(obj)
						menuFrame:Hide();
					end,
				},
			},
		},
		title = loc.RANK,
		name = "GHG_RankMenu",
		theme = "BlankTheme",
		width = 340,
		--height = 250,
		useWindow = true,
		lineSpacing = 0,
	});
	menuFrame:Hide();

	class.Show = function(rank,_feedbackFunc)
		menuFrame.ClearAll();

		local labels = menuFrame.GetAllLabels();
		for _,label in pairs(labels) do
			menuFrame.ForceLabel(label,rank[label]);
		end

		OnOk = function()
			local t = {index = rank.index};

			local l = menuFrame.GetAllLabels();
			for _,label in pairs(l) do
			 	t[label] = menuFrame.GetLabel(label)
			end
			menuFrame:Hide();
			_feedbackFunc(t);
		end

		menuFrame:AnimatedShow();
	end

	return class;
end

