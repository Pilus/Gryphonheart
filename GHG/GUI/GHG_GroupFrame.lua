--===================================================
--
--				GHG_GroupFrame
--  			GHG_GroupFrame.lua
--
--	     Frame for displaying GH group information
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local groupFrame = GHG_GroupFrame;
local UpdateTabsAndDDs;

local loc = GHG_Loc();

local function Localize(frame)
	if not(frame) or frame.ghmLocIgnore then
		return
	end

	if frame:GetObjectType() == "Button" and frame:GetText() then
		frame:SetText(loc[frame:GetText():upper()]);

	elseif frame.GetNumRegions and frame:GetNumRegions() > 0 then
		local regions  = { frame:GetRegions() };

		for _, region in ipairs(regions) do
			if region:GetObjectType() == "FontString" then
				if region:GetText() then
					region:SetText(loc[region:GetText():upper()]);
				end
			end
		end
	end

	for _,child in pairs({frame:GetChildren()}) do
		Localize(child);
	end

end

local api;

local function UpdateSelectedContent()
	local name, icon, ready, loaded = api.GetGroupInfo(groupFrame.selectedSideTab);
	_G[groupFrame:GetName().."TitleText"]:SetText(name);

	local contentFrame = _G[groupFrame:GetName().."Content"];
	for _,child in pairs({contentFrame:GetChildren()}) do
		if child.GetID and child:GetID() == groupFrame.selectedTab then
			child.UpdateFunc();
		end
	end
end

local function ToggleTab(index)
	local contentFrame = _G[groupFrame:GetName().."Content"];
	PanelTemplates_SetTab(groupFrame,index);
	for _,child in pairs({contentFrame:GetChildren()}) do
		if child.GetID and child:GetID() == index then
			child:Show();
			child.UpdateFunc();
		else
			child:Hide();
		end
	end

end



local function UpdateSideButtons()
	local num = api.GetNumberOfGroups();

	for i=8,1,-1 do
		local btn = _G[groupFrame:GetName().."SideTab"..i];
		if i <= num then -- show
			local name,icon = api.GetGroupInfo(i);
			btn.text = name;
			btn:SetNormalTexture(icon);

			btn:SetChecked(nil);
			if (i == groupFrame.selectedSideTab ) then
				btn:SetChecked(1);
			end

			btn:Show();
		elseif i == num + 1 then
			btn.text = loc.CREATE_NEW_GROUP;
			btn:SetNormalTexture("Interface/ICONS/Spell_ChargePositive");
			btn:SetChecked(nil);
			btn:Show();
		else -- hide
			btn:SetChecked(nil);
			btn:Hide();
		end
	end
end

local function ToggleSideButton(index)
	--local selectedBottomTab = groupFrame.selectedTab;
	local num = api.GetNumberOfGroups();
	if index > 0 and index <= num then
		groupFrame.selectedSideTab = index;
		if GHG_AdminFrame:IsShown() then
			GHG_AdminFrame:Hide();
			GHG_AdminFrame:Show();
		end

		UpdateSelectedContent()
	elseif index == num + 1 then -- New group button
		StaticPopup_Show("GHG_CREATE_GROUP")
	end
	UpdateSideButtons()
	UpdateTabsAndDDs();
end

StaticPopupDialogs["GHG_CREATE_GROUP"] = {
	button1 = OKAY,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
	exclusive = 1,
	showAlert = nil,
	hideOnEscape = 1,
	maxLetters = 64,
	enterClicksFirstButton = true,
	text = loc.CREATE_GROUP_TEXT,
	hasEditBox = true,
	OnAccept = function(self)
		local text = self.editBox:GetText()
		api.CreateGroup(text);
	end,
	OnShow = function (self, data)
		self.button1:Disable()
	end,
	EditBoxOnTextChanged = function (self, data)
	    self:GetParent().button1:Enable()
	end,
	EditBoxOnEnterPressed = function(self)
		local text = self:GetText()
		api.CreateGroup(text);
		self:GetParent():Hide();
	end,
};

local DisableAllTabs = function()
	local i = 0;
	while (_G[groupFrame:GetName().."Tab"..(i+1)]) do
		i=i+1;
	end
	for index=1,i do
		_G[groupFrame:GetName().."Tab"..index].isDisabled = 1;
	end
	PanelTemplates_UpdateTabs(groupFrame);
end

local EnableAllTabs = function()
	local i = 0;
	while (_G[groupFrame:GetName().."Tab"..(i+1)]) do
		i=i+1;
	end

	local adminIndex = GHG_AdminFrame:GetID();
	for index=1,i do
		if index == adminIndex then
			if api.CanAdministrateGroup(groupFrame.selectedSideTab) then
				_G[groupFrame:GetName().."Tab"..index].isDisabled = nil;
			else
				_G[groupFrame:GetName().."Tab"..index].isDisabled = true;
			end
		else
			_G[groupFrame:GetName().."Tab"..index].isDisabled = nil;
		end
	end
	PanelTemplates_UpdateTabs(groupFrame);
end

UpdateTabsAndDDs = function()
	if api.GetNumberOfGroups() > 0 then
		EnableAllTabs();
		GHG_GroupRosterFrameViewDropdownButton:Enable();
		GHG_GroupRosterFrameShowOfflineButton:Enable();
	else
		ToggleTab(1);
		DisableAllTabs();
		GHG_GroupRosterFrameViewDropdownButton:Disable();
		GHG_GroupRosterFrameShowOfflineButton:Disable();
	end
end

local function Initialize(self)
	self.initialized = true;
	tinsert(UISpecialFrames, self:GetName());
	Localize(groupFrame);
	api = GHG_GroupAPI(UnitGUID("player"));




	-- setup side tabs
	groupFrame.selectedSideTab = 1;
	local name = api.GetGroupInfo(1);
	if name then
		_G[groupFrame:GetName().."TitleText"]:SetText(name);
	end

	for i=1,8 do
		local btn = _G[groupFrame:GetName().."SideTab"..i];
		btn:SetScript("OnClick",function(self)
			local index = self:GetID();
			ToggleSideButton(index);
		end);
	end
	UpdateSideButtons();

	-- setup tabs
	local i = 0;
	while (_G[groupFrame:GetName().."Tab"..(i+1)]) do
		i=i+1;
	end
	PanelTemplates_SetNumTabs(groupFrame,i);

	groupFrame.ToggleTab = ToggleTab;
	ToggleTab(1);




	GHI_Event("GHG_GROUP_UPDATED",function()
		UpdateSideButtons()
		UpdateSelectedContent()
		UpdateTabsAndDDs();
	end);

	GHI_Event("GHP_PLAYER_UPDATED",function()
		UpdateSelectedContent()
		UpdateTabsAndDDs();
	end);
end

local OnShow = function(self)
	if not(self.initialized) then
		Initialize(self);
	end


	if api.GetNumberOfGroups() > 0 then
		EnableAllTabs();
		if not(groupFrame.selectedSideTab) then
			ToggleSideButton(1);
		end
	else
		ToggleTab(1);
		DisableAllTabs();
		GHG_GroupRosterFrameViewDropdownButton:Disable();
		GHG_GroupRosterFrameShowOfflineButton:Disable();

		-- todo: display a frame with info about "how to create or join group" and "if you are using a new computer ... "
	end


end

-- Left sliding frame
groupFrame:SetAttribute("UIPanelLayout-defined", true)
groupFrame:SetAttribute("UIPanelLayout-enabled", true)
groupFrame:SetAttribute("UIPanelLayout-area", "left")
groupFrame:SetAttribute("UIPanelLayout-pushable", 5)
groupFrame:SetAttribute("UIPanelLayout-whileDead", true)


GHI_Event("VARIABLES_LOADED",function(e,addon)
	GHI_ButtonUI().AddSubButton(
		"Interface/ICONS/INV_Misc_GroupNeedMore",
		loc.GHG,
		function()
			ShowUIPanel(groupFrame);
		end
	);

	groupFrame:SetScript("OnShow",OnShow);
end	)