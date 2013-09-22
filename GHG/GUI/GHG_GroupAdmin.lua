--===================================================
--
--				GHG_GroupAdmin
--  			GHG_GroupAdmin.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

--local AdminFrame = CreateFrame("Frame","$parentAdmin",GHG_GroupFrameContent);
--AdminFrame:SetID(3);
--AdminFrame:SetAllPoints();


--GHM_TempBG(AdminFrame);

local api,OnHide,loc,rankUI,SetRank,UpdateRanksList;

local init = false;
local Initialize = function()
	init = true;

	local scroll = CreateFrame("ScrollFrame","$parentScroll",GHG_AdminFrame,"GHM_ScrollFrameTemplate")

	scroll:SetPoint("TOPLEFT",GHG_AdminFrame,"TOPLEFT",3,-62)
	scroll:SetPoint("BOTTOMRIGHT",GHG_AdminFrame,"BOTTOMRIGHT",-21,40)

	loc = GHG_Loc();
	rankUI = GHG_GroupAdmin_RankMenu();

	local menuFrame = GHM_NewFrame(scroll, {
		onOk = function(self) end,
		{
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.GROUP_NAME..":";
					label = "name";
					fontSize = 14,
					texture = "Tooltip",
					OnTextChanged = function(self)

					end,
				},
				{
					type = "Dummy",
					height = 40,
					width = 30,
					align = "l",
				},
				{
					type = "Icon",
					text = loc.GROUP_ICON..":",
					align = "l",
					label = "icon",
					framealign = "r",
					CloseOnChoosen = true,
					OnChanged = function(icon)
						--item.SetIcon(icon);
					end,
					yOff = -9,
					iconFrameParent = GHG_AdminFrame:GetParent():GetParent();
				},
			},
			{
				{
					type = "Text",
					align = "l",
					text = loc.RANKS..":",
					color = "yellow",
				},
			},
			{
				{
					type = "List",
					lines = 6,
					align = "l",
					label = "rankList",
					column = {
						{
							type = "Text",
							catagory = loc.RANK_NAME,
							width = 74,
							label = "name",
						},
						{
							type = "IconRow",
							catagory = loc.PERMISSONS,
							width = 130,
							label = "permissions",
							size = 13,
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 15,
							label = "up",
							onClick = function(selected)
								api.Admin_SwapRanks(selected.index,selected.index-1);
								UpdateRanksList();
							end,
							normalTexture = "Interface/Buttons/Arrow-Up-Up",
							normalTexCoords = {-0.2, 1.0, 0.3, 1.0},     -- lrtb
							disabledTexture = "Interface/Buttons/Arrow-Up-Disabled",
							disabledTexCoords = {-0.2, 1.0, 0.3, 1.0},
							pushedTexture = "Interface/Buttons/Arrow-Up-Down",
							pushedTexCoords = {-0.2-0.04, 1.0-0.04, 0.3-0.04, 1.0-0.04},
							tooltip = loc.MOVE_UP,
							disableOnNil = true,
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 15,
							label = "down",
							onClick = function(selected)
								api.Admin_SwapRanks(selected.index,selected.index+1);
								UpdateRanksList();
							end,
							normalTexture = "Interface/Buttons/Arrow-Down-Up",
							normalTexCoords = { -0.1, 1.0, -0.1, 0.7 },
							disabledTexture = "Interface/Buttons/Arrow-Down-Disabled",
							disabledTexCoords = { -0.1, 1.0, -0.1, 0.7 },
							pushedTexture = "Interface/Buttons/Arrow-Down-Down",
							pushedTexCoords = { -0.1-0.04, 1.0-0.04, -0.1-0.04, 0.7-0.04  },
							tooltip = loc.MOVE_DOWN,
							disableOnNil = true,
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 15,
							label = "edit",
							onClick = function(selected)
								rankUI.Show(GHClone(selected),SetRank);
							end,
							normalTexture = "Interface/GossipFrame/HealerGossipIcon",
							normalTexCoords = { -0.1, 1.1, -0.1, 1.1 },
							disabledTexture = "", -- There is no disabled version of healerGossipIcon (the cogwheel)
							disabledTexCoords = { -0.1, 1.1, -0.1, 1.1 },
							pushedTexture = "Interface/GossipFrame/HealerGossipIcon",
							pushedTexCoords = { -0.06, 1.14, -0.14, 1.06 },
							tooltip = loc.EDIT_RANK,
							disableOnNil = true,
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 15,
							label = "delete",
							onClick = function(selected)
								api.Admin_DeleteRank(selected.index);
								UpdateRanksList();
							end,
							normalTexture = "Interface/BUTTONS/UI-Panel-MinimizeButton-Up",
							normalTexCoords = { 0.1, 0.9, 0.1, 0.9 },
							disabledTexture = "Interface/BUTTONS/UI-Panel-MinimizeButton-Disabled",
							disabledTexCoords = { 0.1, 0.9, 0.1, 0.9 },
							pushedTexture = "Interface/BUTTONS/UI-Panel-MinimizeButton-Down",
							pushedTexCoords = { 0.1, 0.9, 0.1, 0.9 },
							tooltip = loc.DELETE_RANK,
							disableOnNil = true,
						},
					},
					OnLoad = function(obj)
						obj:SetBackdropColor(0, 0, 0, 0.5);
					end,
					OnMarked = function() end,
				},
			},
			{
				{
					type = "Button",
					text = "  " .. loc.NEW_RANK .. "  ",
					align = "l",
					label = "newRank",
					compact = true,
					OnClick = function()
						rankUI.Show({index = api.Admin_GetNumRanks() + 1},SetRank);
					end,
				},
			},
		},
		title = "",
		height = 295,
		name = "GHG_AdminFrameMenu",
		theme = "BlankTheme",
		width = 285,
	});
	menuFrame:Show();
	menuFrame:SetParent(GHG_AdminFrame);
	scroll:SetScrollChild(menuFrame);
	GHG_AdminFrame.menuFrame = menuFrame;

	GHG_AdminFrame:SetScript("OnHide",OnHide);
	api = GHG_AdminAPI(UnitGUID("player"));

end


OnHide = function()
	local menuFrame = GHG_AdminFrame.menuFrame;

	api.Admin_SetGroupName(menuFrame.GetLabel("name"));
	api.Admin_SetGroupIcon(menuFrame.GetLabel("icon"));

	api.SaveGroupAdministration();
end

local FormPermissionIcons = function(i)
	local _,canEditRanksAndPermissions,canInvite,canKickMember,canPromoteDemote,canEditOfficersNote,canViewOfficersNote,
	canEditPublicNote,canViewPublicNote,canTalkInChat,canHearChat = api.Admin_GetRankInfo(i);

	local t = {};

	if canHearChat then
		table.insert(t,{
			texture = "Interface\\Icons\\Ability_CheapShot",
			tooltip = loc.CAN_HEAR_CHAT,
		})
	end

	if canTalkInChat then
		table.insert(t,{
			texture = "Interface\\Icons\\ability_priest_heavanlyvoice",
			tooltip = loc.CAN_TALK_IN_CHAT,
		})
	end

	if canViewPublicNote then
		table.insert(t,{
			texture = "Interface\\Icons\\Inv_Misc_Note_04",
			tooltip = loc.CAN_VIEW_PUBLIC_NOTE,
		})
	end

	if canEditPublicNote then
		table.insert(t,{
			texture = "Interface\\Icons\\Inv_Misc_Note_03",
			tooltip = loc.CAN_EDIT_PUBLIC_NOTE,
		})
	end

	if canViewOfficersNote then
		table.insert(t,{
			texture = "Interface\\addons\\ghm\\ghi_icons\\_note_01_red",
			tooltip = loc.CAN_VIEW_OFFICER_NOTE,
		})
	end

	if canEditOfficersNote then
		table.insert(t,{
			texture = "Interface\\addons\\ghm\\ghi_icons\\_scroll2_fire",
			tooltip = loc.CAN_EDIT_OFFICER_NOTE,
		})
	end

	if canPromoteDemote then
		table.insert(t,{
			texture = "Interface\\Icons\\Achievement_bg_tophealer_ab",
			tooltip = loc.CAN_PROMOTE_DEMOTE,
		})
	end

	if canKickMember then
		table.insert(t,{
			texture = "Interface\\Icons\\INV_Gizmo_RocketBoot_01",
			tooltip = loc.CAN_KICK,
		})
	end

	if canInvite then
		table.insert(t,{
			texture = "Interface\\Icons\\Inv_Misc_GroupNeedMore",
			tooltip = loc.CAN_INVITE,
		})
	end

	if canEditRanksAndPermissions then
		table.insert(t,{
			texture = "Interface\\addons\\ghm\\ghi_icons\\_ldaCogs",
			tooltip = loc.CAN_RANKS_PERM,
		})
	end

	return t;
end

SetRank = function(t)
	api.Admin_SetRankInfo(t.index,t.name,t.canEditRanksAndPermissions,t.canInvite,t.canKickMember,t.canPromoteDemote,t.canEditOfficersNote,t.canViewOfficersNote,t.canEditPublicNote,t.canViewPublicNote,t.canTalkInChat,t.canHearChat);
	UpdateRanksList();
end


local SetRankToTuble = function(i,t)
	t = t or {};
	t.name,t.canEditRanksAndPermissions,t.canInvite,t.canKickMember,t.canPromoteDemote,t.canEditOfficersNote,t.canViewOfficersNote,
	t.canEditPublicNote,t.canViewPublicNote,t.canTalkInChat,t.canHearChat = api.Admin_GetRankInfo(i);

	t.permissions = FormPermissionIcons(i);
	t.index = i;

	-- button enables
	local own = api.Admin_GetOwnRankIndex();
	local total = api.Admin_GetNumRanks();

	t.up,t.down,t.edit,t.delete = nil,nil,nil,nil;
	if own < i-1 then
		t.up = true;
	end
	if own < i and i < total then
		t.down = true;
	end
	if own == 1 or own < 1 then
		t.edit = true;
	end
	if own < i and (i < total or own < i-1) then
		t.delete = true;
	end

	return t;
end

UpdateRanksList = function()
	local menuFrame = GHG_AdminFrame.menuFrame;
	local rankList = menuFrame.GetLabelFrame("rankList");

	local needed = {};
	for i = 1,api.Admin_GetNumRanks() do
		local existsAlready = false;
		for j = 1, rankList.GetTubleCount() do
			local t = rankList.GetTuble(j);
			if i == t.index then
				t = SetRankToTuble(i,t);
				existsAlready = true;
				rankList.SetTuble(j, t);
				needed[j] = true;
				break;
			end
		end

		if existsAlready == false then
			local t = SetRankToTuble(i);
			rankList.SetTuble(rankList.GetTubleCount() + 1, t)
			needed[rankList.GetTubleCount()] = true;
		end
	end
	local i = 1;
	while i <= rankList.GetTubleCount() do
		if not(needed[i]) then
			rankList.DeleteTuble(i);
		else
			i = i + 1;
		end
	end

end

GHG_UpdateAdminFrame = function()
	if not(init) then
		Initialize();
	end

	local menuFrame = GHG_AdminFrame.menuFrame;

	local selectedSideTab = GHG_AdminFrame:GetParent():GetParent().selectedSideTab;

	menuFrame.GetLabelFrame("rankList").Clear();
	api.BeginGroupAdministration(selectedSideTab);
	local name,icon = api.Admin_GetGroupInfo();
	menuFrame.ForceLabel("name",name);
	menuFrame.ForceLabel("icon",icon);

	UpdateRanksList();

end
