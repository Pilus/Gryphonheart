--===================================================
--
--				GHP_MainUI
--  			GHP_MainUI.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHP_MainUI()
	if class then
		return class;
	end
	class = GHClass("GHP_MainUI");

	local api = GHP_ProfessionSystemAPI();
	local abilityApi = GHP_AbilityAPI();

	local frame = GHP_MainUIFrame;

	local selectedTab = 1;
	local selectedSystemGuid;

	--------------------------------------------------------
	--------------------- Ability frame --------------------
	--------------------------------------------------------
	local currentAbilityPage = 1;
	local UpdateAbilities = function()
		local num = abilityApi.GetNumSpellbookAbilities(selectedSystemGuid);
		for i=1,12  do
			local btn = _G["GHP_MainUIFrameAbilitiesButton"..i];
			if i <= num then
				btn:Show();

				local _,abilityName,icon,abilitySubName = abilityApi.GetSpellbookAbilityInfo(selectedSystemGuid,i);

				local name = btn:GetName();
				local iconTexture = _G[name.."IconTexture"];
				local spellString = _G[name.."SpellName"];
				local subSpellString = _G[name.."SubSpellName"];
				local cooldown = _G[name.."Cooldown"];
				local autoCastableTexture = _G[name.."AutoCastable"];
				local slotFrame = _G[name.."SlotFrame"];

				btn:Enable();

				iconTexture:Show();
				spellString:Show();

				iconTexture:SetTexture(icon);
				spellString:SetText(abilityName);

				subSpellString:SetText(abilitySubName);
				if ( abilitySubName == "" ) then
					subSpellString:SetHeight(6);
				else
					subSpellString:SetHeight(18);
				end
				subSpellString:Show();

				local total,elapsed = abilityApi.GetAbilityCooldown(selectedSystemGuid,i);
				if elapsed then
					CooldownFrame_SetTimer(cooldown, GetTime() - (elapsed), total, 1);
				else
					cooldown:Hide();
				end

			else
				btn:Hide();
			end
		end
	end
	GHI_Event("GHP_ABILITY_UPDATED",UpdateAbilities)

	local ClickAbility = function(frame,button)
		local index = frame.id;
		if button == "LeftButton" then
			abilityApi.PickupAbility(selectedSystemGuid,index);
		else
			abilityApi.ExecuteAbility(selectedSystemGuid,index);
		end
	end

	for i=1,12 do
		local btn = _G["GHP_MainUIFrameAbilitiesButton"..i];
		btn.id = i;
		btn:SetScript("OnClick",ClickAbility)
		btn:SetScript("OnDragStart",ClickAbility);
	end

	--------------------------------------------------------
	--------------------- Content shown --------------------
	--------------------------------------------------------


	local UpdateContent = function(changedTab,changedSystem)
		if changedTab then
			-- hide all
			_G["GHP_MainUIFrameAbilities"]:Hide();
		end

		if changedSystem then
			currentAbilityPage = 1;

			local _,name,_,color = api.GetProfessionSystemDetails(selectedSystemGuid);
			if color then
				GHP_MainUIFramePageTextureMark:SetVertexColor(color.r,color.g,color.b);
			else
				GHP_MainUIFramePageTextureMark:SetVertexColor(1,0,0);
			end
		end

		if selectedTab == 1 then -- Profession
		elseif selectedTab == 2 then -- Abilities
			if changedTab then
				_G["GHP_MainUIFrameAbilities"]:Show();
			end
			UpdateAbilities();
		elseif selectedTab == 3 then -- Custom profession
		end
	end

	-------------------------------------------------------------
	--------------------- Bottom Tab Buttons --------------------
	-------------------------------------------------------------


	local UpdateBottomTabs = function()
		for i=1,3 do
			local tab = _G["GHP_MainUIFrameTabButton"..i];
			PanelTemplates_TabResize(tab, 0);
			if i == selectedTab then
				PanelTemplates_SelectTab(tab);
			else
				PanelTemplates_DeselectTab(tab);
			end
		end
	end

	for i=1,3 do
		local tab = _G["GHP_MainUIFrameTabButton"..i];
		tab:SetScript("OnClick",function()
			if not(selectedTab == i) then
				selectedTab = i;
				UpdateBottomTabs();
				UpdateContent(true,false);
			end
		end);
	end


	-----------------------------------------------------------
	--------------------- Side Tab Buttons --------------------
	-----------------------------------------------------------
	local UpdateSideButton;
	for i=1,8 do
		local btn = _G["GHP_MainUIFrameSideTab"..i];
		btn:SetScript("OnClick",function(self)
			selectedSystemGuid = self.guid;
			UpdateSideButton();
			UpdateContent(false,true);
		end);
	end

	UpdateSideButton = function()
		local num = api.GetNumProfessionSystems();
		local selectedFound = false;

		for i=8,1,-1 do
			local btn = _G["GHP_MainUIFrameSideTab"..i];
			if i <= num then -- show
				local guid,name,icon,color = api.GetProfessionSystemDetails(i);
				btn.guid = guid;
				btn.text = name;
				btn:SetNormalTexture(icon);

				btn:SetChecked(nil);
				if (btn.guid == selectedSystemGuid) or (i==1 and selectedFound == false ) then
					btn:SetChecked(1);
					selectedFound = true;

					if not(selectedSystemGuid == btn.guid) then -- if reset to default
						selectedSystemGuid = btn.guid;
						UpdateContent(false,true);
					end
				end

				btn:Show();
			else -- hide
				btn:SetChecked(nil);
				btn:Hide();
			end
		end
	end
	frame:SetScript("OnShow",function()
		UpdateBottomTabs();
		UpdateSideButton();
	end)
	GHI_Event("GHP_PROFESSION_SYSTEM_UPDATED",UpdateSideButton)


	--GHP_MainUIFrameSideTab1:SetNormalTexture("Interface\\Icons\\trade_archaeology_orc_artifactfragment");
	--GHP_MainUIFrameSideTab1:Show();





	GHP_MainUIFrameInset:Hide();


	--GHP_MainUIFramePageTextureMark:SetVertexColor(1.0,0.0,1.0);
	SetPortraitToTexture(GHP_MainUIFramePortrait, "Interface\\Spellbook\\Spellbook-Icon");

	--GHM_TempBG(GHP_MainUIFramePageTexture);

	--frame:SetPoint("CENTER",0,0);
	frame:SetAttribute("UIPanelLayout-defined", true)
	frame:SetAttribute("UIPanelLayout-enabled", true)
	frame:SetAttribute("UIPanelLayout-area", "left")
	frame:SetAttribute("UIPanelLayout-pushable", 5)
	frame:SetAttribute("UIPanelLayout-width", frame:GetWidth()+20)
	frame:SetAttribute("UIPanelLayout-whileDead", true)

	class.Toggle = function()
		if frame:IsShown() then
			HideUIPanel(frame);
		else
			ShowUIPanel(frame);
		end
	end


	class.frame = frame;
	return class;
end
