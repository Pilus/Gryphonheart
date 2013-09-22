--===================================================
--
--				GHG_GroupRoster
--  			GHG_GroupRoster.lua
--
--	     Frame for displaying GH group members
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local initialized = false;
local frame;

local loc = GHG_Loc();
local api;
local currentView = "status";

local selection;

local VIEWS = {
	status = {
		text = "STATUS",
		columnText = "LAST_ONLINE",
	},
	zone = {
		text = "ZONE",
	},
	race = {
		text = "RACE",
	},
	guild = {
		text = "GUILD",
	},
	rank = {
		text = "RANK",
	},
	mspName = {
		text = "MSP_NAME",
	},
	mspTitle = {
		text = "MSP_TITLE",
	},
}
local VIEWS_ORDER = {
	"status",
	"rank",
	"zone",
	"race",
	"guild",
	"mspName",
	"mspTitle",
}

local SetStringText = function(buttonString, text, isOnline, class)
	buttonString:SetText(text);
	if ( isOnline ) then
		if ( class ) then
			local classColor = RAID_CLASS_COLORS[class];
			buttonString:SetTextColor(classColor.r, classColor.g, classColor.b);
		else
			buttonString:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		end
	else
		buttonString:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
end

local GetGroupIndex = function()
	return frame:GetParent():GetParent().selectedSideTab
end

local CompareString = function(s1,s2)
	assert(type(s1)=="string" and type(s2)=="string")
	s1 = s1:lower();
	s2 = s2:lower();

	local i = 1;
	while (i <= math.min(s1:len(),s2:len())) do
		if string.byte(s1,i) < string.byte(s2,i) then
			return true;
		elseif string.byte(s1,i) > string.byte(s2,i) then
			return false;
		end
		i = i + 1;
	end
	if s1:len() < s2:len() then
		return true;
	elseif s1:len() > s2:len() then
		return false;
	end
	return nil;
end

local NumberComparer = function(value,otherValue)
	if value > otherValue then
		return true;
	elseif value < otherValue then
		return false;
	end
end
local ONLINE = {};

local GetGroupInfoTable = function()
	local groupIndex = GetGroupIndex();
	local t = {};
	while (true) do
		local index = #(t)+1;
		local name, rank, rankIndex, level, class, zone, online, race,guild = api.GetGroupMemberInfo(groupIndex,index);
		local mspName,mspTitle = api.GetGroupMemberMSPInfo(groupIndex,index);
		if not(name) then
			return t;
		end

		local ts = {};
		ts.online = online;
		ts.groupMemberIndex = index;
		ts.name = {
			value = name,
			toString = tostring,
			compare = CompareString,
		};
		ts.class = {
			value = class or "WARRIOR",
			toString = tostring,
			compare = CompareString,
		};
		ts.level = {
			value = level or 0,
			toString = tostring,
			compare = NumberComparer,
		};

		ts.status = {
			value = (online and ONLINE) or {api.GetGroupMemberLastOnline(groupIndex,index)},
			toString = function(value)
				if value == ONLINE then return loc.ONLINE; end
				return RecentTimeDate(unpack(value));
			end,
			compare = function(value,otherValue)
				if value == ONLINE then
					return false;
				end
				if otherValue == ONLINE then
					return true;
				end

				local tv = time({
					year=1970+(value[1] or 0),
					month=1+(value[2] or 0),
					day=1+(value[3] or 0),
					hour=1+(value[4] or 0),
				})
				local tov = time({
					year=1970+(otherValue[1] or 0),
					month=1+(otherValue[2] or 0),
					day=1+(otherValue[3] or 0),
					hour=1+(otherValue[4] or 0),
				})

				return NumberComparer(tv,tov);
			end,
		};

		ts.rank = {
			value = {rankIndex,rank},
			toString = function(value) return value[2]; end,
			compare = function(value,otherValue) return NumberComparer(value[1],otherValue[1]) end,
		};

		ts.zone = {
			value = zone or loc.UNKNOWN,
			toString = tostring,
			compare = CompareString,
		};
		ts.race = {
			value = race or loc.UNKNOWN,
			toString = tostring,
			compare = CompareString,
		};
		ts.guild = {
			value = guild or "",
			toString = tostring,
			compare = CompareString,
		};
		ts.mspName = {
			value = mspName or "",
			toString = tostring,
			compare = CompareString,
		};
		ts.mspTitle = {
			value = mspTitle or "",
			toString = tostring,
			compare = CompareString,
		};

		table.insert(t,ts);
	end
end


local TYPES = {"level","class","name"}
local sortBy = {{"name",true}};
function GHG_GroupRoster_SortByColumn(self)
	local id = self:GetID();
	local sort = "";
	if id == 4 then
		sort = currentView;
	else
		sort = TYPES[id];
	end

	local dir = true;
	-- remove any of the same
	for i,v in pairs(sortBy) do
		if v[1] == sort then
			local otherDir = v[2];
			table.remove(sortBy,i);
			if i == 1 then
				dir = not(otherDir);
			end
			break;
		end
	end

	table.insert(sortBy,1,{sort,dir});
	sortBy[4] = nil; -- limit to max 3 sort params

	GHG_UpdateGroupRoster()
end



local data;

local SortData = function()
	table.sort(data,function(t1,t2)
		if t1 and t2 then
			for i=1,4 do
				if sortBy[i] then
					local sortByAddr,dir = unpack(sortBy[i])
					local res = t1[sortByAddr].compare(t1[sortByAddr].value,t2[sortByAddr].value);

					if not(res == nil) then
						if dir == true then
							return res;
						else
							return not(res);
						end
					end
				end
			end
		end
		return false;
	end)
end
local promoteLimit,currentRankIndex,currentPlayerIndex;

function GHG_GroupMemberDetailFrameRankDropdown_OnLoad(self)
	UIDropDownMenu_Initialize(self, GHG_GroupMemberDetailFrameRankDropdown_Initialize);
	--UIDropDownMenu_SetWidth(self, 135);
end

function GHG_GroupMemberDetailFrameRankDropdown_Initialize(self)
	local info = UIDropDownMenu_CreateInfo();
	info.func = GHG_GroupMemberDetailFrameRankDropdown_OnClick;
	if api then
		for i=promoteLimit,api.GetNumberOfRanks(GetGroupIndex()) do

			info.text = api.GetRankName(GetGroupIndex(),i);
			info.value = i;
			UIDropDownMenu_AddButton(info);
		end
	end



	UIDropDownMenu_SetSelectedValue(GHG_GroupMemberDetailFrameRankDropdown, currentRankIndex);
end

function GHG_GroupMemberDetailFrameRankDropdown_OnClick(self)
	if not(self.value == currentRankIndex) then
		api.ChangeRank(GetGroupIndex(),currentPlayerIndex,self.value)
	end

	UIDropDownMenu_SetSelectedValue(GHG_GroupMemberDetailFrameRankDropdown, currentView);
end

local DetailsFrame_Update = function(data)
	local f = GHG_GroupMemberDetailFrame;
	local fn = f:GetName();

	local Get = function(index)
		return data[index].toString(data[index].value);
	end
	local groupIndex = GetGroupIndex();
	_G[fn.."Name"]:SetText(Get("name"));
	_G[fn.."Level"]:SetFormattedText(FRIENDS_LEVEL_TEMPLATE, Get("level"), Get("class"));
	_G[fn.."ZoneText"]:SetText(Get("zone"));
	_G[fn.."OnlineText"]:SetText(Get("status"));


	currentPlayerIndex = data.groupMemberIndex;
	local _,rankName;
	_,rankName,currentRankIndex = api.GetGroupMemberInfo(groupIndex,data.groupMemberIndex)
	promoteLimit = api.GetPromoteDemoteLimit(groupIndex);

	GHG_GroupMemberDetailFrameRankDropdownText:SetText(rankName);

	if promoteLimit == 1 and Get("name") == UnitName("player") then
		promoteLimit = nil;
	end

	if promoteLimit then
		_G[fn.."RankText"]:SetText("");
		_G[fn.."RankDropdown"]:Show();

	else
		_G[fn.."RankText"]:SetText(Get("rank"));
		_G[fn.."RankDropdown"]:Hide();

	end

	if promoteLimit and not(Get("name") == UnitName("player")) then
		_G[fn.."RemoveButton"]:Enable();
	else
		_G[fn.."RemoveButton"]:Disable();
	end


	local baseHeight = 150; -- +53

	_G[fn.."NoteLabel"]:Hide();
	_G[fn.."NoteBackground"]:Hide();
	if api.CanViewPublicNote(groupIndex) then
		GHG_PersonalNoteText:SetText(api.GetPublicNote(groupIndex,currentPlayerIndex));
		baseHeight = baseHeight + 55;
		_G[fn.."NoteLabel"]:Show();
		_G[fn.."NoteBackground"]:Show();
	end

	_G[fn.."OfficerNoteLabel"]:Hide();
	_G[fn.."OfficerNoteBackground"]:Hide();
	if api.CanViewOfficersNote(groupIndex) then
		GHG_OfficerNoteText:SetText(api.GetOfficersNote(groupIndex,currentPlayerIndex));
		baseHeight = baseHeight + 55;
		_G[fn.."OfficerNoteLabel"]:Show();
		_G[fn.."OfficerNoteBackground"]:Show();
	end

	f:SetHeight(baseHeight);
end

local Roster_Update = function(change)
	local scrollFrame = _G[frame:GetName().."Container"];
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local button, index, class;
	local totalMembers = api.GetNumberOfGroupMembers(GetGroupIndex());
	local onlineMembers = api.GetNumberOfGroupMembersOnline(GetGroupIndex());


	-- Column title
	local text = "";
	if VIEWS[currentView] then
		text = loc[VIEWS[currentView].columnText or VIEWS[currentView].text];
	end

	_G[frame:GetName().."ColumnButton4"]:SetText(text);

	-- numVisible
	local visibleMembers = onlineMembers;
	if ( _G[frame:GetName().."ShowOfflineButton"]:GetChecked() ) then
		visibleMembers = totalMembers;
	end

	if not(data) or change then
		data = GetGroupInfoTable();
	end

	SortData();
	local selectedData;
	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i;

		if (data[index] and index <= visibleMembers ) then
		   	local d = data[index];

			local online = d.online;
			SetStringText(button.string1, d.level.toString(d.level.value), online)

			local classFileName = gsub(string.upper(d.class.toString(d.class.value))," ","");
			button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]));
			SetStringText(button.string2, d.name.toString(d.name.value), online, classFileName)

			local text = d[currentView].toString(d[currentView].value);
			SetStringText(button.string3, text, online)

			button.data = d;
			button.groupMemberIndex = d.groupMemberIndex;
			button:Show();

			if ( mod(index, 2) == 0 ) then
				button.stripe:SetTexCoord(0.36230469, 0.38183594, 0.95898438, 0.99804688);
			else
				button.stripe:SetTexCoord(0.51660156, 0.53613281, 0.88281250, 0.92187500);
			end
			if ( selection == d.groupMemberIndex ) then
				button:LockHighlight();
				selectedData = d;
			else
				button:UnlockHighlight();
			end
		else
			button:Hide();
		end
	end
	local totalHeight = visibleMembers * (24 + 0);
	local displayedHeight = numButtons * (24 + 0);
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);

	if GHG_GroupMemberDetailFrame:IsShown() and selectedData then
		DetailsFrame_Update(selectedData);
	end
end

local Initialize = function()
	frame = GHG_GroupRosterFrame;
	api = GHG_GroupAPI(UnitGUID("player"));

	-- column headers size
	local containerFrame = _G[frame:GetName().."Container"]
	containerFrame.update = Roster_Update;
	HybridScrollFrame_CreateButtons(containerFrame, "GHG_GroupRosterButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -2, "TOP", "BOTTOM");
	_G[containerFrame:GetName().."ScrollBar"].doNotHide = true;


	local scrollFrame = _G[frame:GetName().."Container"];
	local buttons = scrollFrame.buttons;

	for buttonIndex = 1, #buttons do
		local button = buttons[buttonIndex];

		local fontString = button["string1"];
		fontString:SetPoint("LEFT", 6, 0);
		fontString:SetWidth(18);
		fontString:SetJustifyH("CENTER");
		fontString:Show();

		local fontString = button["string2"];
		fontString:SetPoint("LEFT", 67, 0);
		fontString:SetWidth(67);
		fontString:SetJustifyH("LEFT");
		fontString:Show();

		local fontString = button["string3"];
		fontString:SetPoint("LEFT", 146, 0);
		fontString:SetWidth(145);
		fontString:SetJustifyH("LEFT");
		fontString:Show();

	end

	GHI_Event("GHG_GROUP_UPDATED",function()
		Roster_Update(true);
	end);

	frame:SetScript("OnHide",function()
		GHG_GroupMemberDetailFrame:Hide();
	end);

	GHG_GroupMemberDetailFrameNoteBackground:SetScript("OnMouseUp",function()
		if api.CanEditPublicNote(GetGroupIndex()) then
			StaticPopup_Show("GHG_SET_PLAYERNOTE");
		end
	end);

	GHG_GroupMemberDetailFrameOfficerNoteBackground:SetScript("OnMouseUp",function()
		if api.CanEditOfficersNote(GetGroupIndex()) then
			StaticPopup_Show("GHG_SET_OFFICERNOTE");
		end
	end);


	initialized = true;
end


function GHG_GroupRosterButton_OnClick(self,button)
	if ( button == "LeftButton" ) then
		if ( GHG_GroupMemberDetailFrame:IsShown() and self.groupMemberIndex == selection ) then
			selection = nil;
			GHG_GroupMemberDetailFrame:Hide();
		else
			selection = self.groupMemberIndex;
			GHG_GroupMemberDetailFrame:Show();
		end
		Roster_Update();
	else
		local name = self.data.name.toString(self.data.name.value);
		local online = self.data.online;
		FriendsFrame_ShowDropdown(name, online, nil, nil, nil, nil, nil);
	end
end

function GHG_RosterViewDropdown_OnLoad(self)
	UIDropDownMenu_Initialize(self, GHG_RosterViewDropdown_Initialize);
	UIDropDownMenu_SetWidth(GHG_GroupRosterFrameViewDropdown, 135);
end

function GHG_RosterViewDropdown_Initialize()
	local info = UIDropDownMenu_CreateInfo();
	info.func = GHG_RosterViewDropdown_OnClick;

	for _,id in pairs(VIEWS_ORDER) do
	    if VIEWS[id] then
			info.text = loc[VIEWS[id].text];
			info.value = id;
			UIDropDownMenu_AddButton(info);
		end
	end



	UIDropDownMenu_SetSelectedValue(GHG_GroupRosterFrameViewDropdown, currentView);
end

function GHG_RosterViewDropdown_OnClick(self)
	currentView = self.value;
	Roster_Update();
	UIDropDownMenu_SetSelectedValue(GHG_GroupRosterFrameViewDropdown, currentView);
end

GHG_UpdateGroupRoster = function()
	if not(initialized) then
		Initialize();
	end

	Roster_Update(true);
end


StaticPopupDialogs["GHG_SET_PLAYERNOTE"] = {
	text = SET_GUILDPLAYERNOTE_LABEL,
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	maxLetters = 31,
	editBoxWidth = 260,
	OnAccept = function(self)
		api.SetPublicNote(GetGroupIndex(),currentPlayerIndex,self.editBox:GetText())
	end,
	OnShow = function(self)

		self.editBox:SetText(api.GetPublicNote(GetGroupIndex(),currentPlayerIndex));
		self.editBox:SetFocus();
	end,
	OnHide = function(self)
		ChatEdit_FocusActiveWindow();
		self.editBox:SetText("");
	end,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent();
		api.SetPublicNote(GetGroupIndex(),currentPlayerIndex,parent.editBox:GetText())
		parent:Hide();
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide();
	end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
};
StaticPopupDialogs["GHG_SET_OFFICERNOTE"] = {
	text = SET_GUILDOFFICERNOTE_LABEL,
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	maxLetters = 31,
	editBoxWidth = 260,
	OnAccept = function(self)
		api.SetOfficersNote(GetGroupIndex(),currentPlayerIndex,self.editBox:GetText())
	end,
	OnShow = function(self)

		self.editBox:SetText(api.GetOfficersNote(GetGroupIndex(),currentPlayerIndex));
		self.editBox:SetFocus();
	end,
	OnHide = function(self)
		ChatEdit_FocusActiveWindow();
		self.editBox:SetText("");
	end,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent();
		api.SetOfficersNote(GetGroupIndex(),currentPlayerIndex,parent.editBox:GetText())
		parent:Hide();
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide();
	end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
};

local kickGroupIndex,kickPlayerIndex;
StaticPopupDialogs["GHG_REMOVE_MEMBER"] = {
	text = format(loc.REMOVE_MEMBER, "XXX","YYY"),
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		api.KickMemberFromGroup(kickGroupIndex,kickPlayerIndex);
		GHG_GroupMemberDetailFrame:Hide();
	end,
	OnShow = function(self)
		kickGroupIndex = GetGroupIndex();
		kickPlayerIndex = currentPlayerIndex;
		local groupName = api.GetGroupInfo(kickGroupIndex);
		local name = api.GetGroupMemberInfo(kickGroupIndex,kickPlayerIndex);
		self.text:SetFormattedText(loc.REMOVE_MEMBER, name, groupName);
	end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
};