--===================================================
--
--				GHI_ActionBarUI
--  			GHI_ActionBarUI.lua
--
--		UI for action bars for ghi items
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================


local variablesLoaded;
GHI_Event("GHI_ITEM_INFO_LOADED",function()
	variablesLoaded = true;
end)

local class;
local clickFuncs,getInfoFuncs,tooltipFuncs = {},{},{};
local buttons = {};
local SetItem;
function GHI_ActionBarUI(id,clickFunc,getInfoFunc,tooltipFunc,updateEvent)
	clickFuncs[id] = clickFunc;
	getInfoFuncs[id] = getInfoFunc;
	tooltipFuncs[id] = tooltipFunc;

	local Update = function()
		for barName,b in pairs(buttons) do
			local ghButton = b.ghButton; -- print(ghButton.id,id)
			if ghButton.guid and not(ghButton.id) or (ghButton.id == id) then
				SetItem(id,ghButton,ghButton.guid);
			end
		end
	end

	GHI_Event(updateEvent,function()
		Update()
	end);
	Update();

	if class then
		return class;
	end
	class = GHClass("GHI_ActionBarUI");

	local saved = GHI_SavedData("GHI_ActionBarData");
	local showingAllBars = false;

	local savedData;

	local ClearItem = function(button)
		local iconFrame = _G[button:GetName().."Icon"];
		local cooldownFrame = _G[button:GetName().."Cooldown"];
		iconFrame:Hide();
		cooldownFrame:Hide();
		SetItemButtonCount(button,0);
		button.guid = nil;
		saved.SetVar(button:GetName(),nil);
	end

	local ButtonScripts = function(ghButton)
		ghButton:SetScript("OnClick",function()
			ghButton:SetChecked(false);
			if ghButton.guid and ghButton.id then
				clickFuncs[ghButton.id](ghButton.guid);
			end
		end);
		ghButton:SetScript("OnDragStart",function()
			local cursor = GHI_CursorHandler();
			if ghButton.guid then
				cursor.SetCursor("ITEM", ghButton.icon, function() end, function()end, "GHI_ITEM_REF", nil, nil, nil, nil, ghButton.guid);
				ClearItem(ghButton);
			else
				error("No guid for dragging")
			end
		end);
		ghButton:SetScript("OnEnter",function()
			if ghButton.guid then
				tooltipFunc(ghButton,ghButton.guid)
			end
		end)

		ghButton:SetScript("OnLeave",function()
			GameTooltip:Hide();
		end)
	end

	SetItem = function(id,button,guid)
		local setup = (button.guid ~= guid)
		button.guid = guid;
		button.id = id;

		if setup then
			ButtonScripts(button);
		end

		if not(guid) or not(getInfoFuncs[id]) then
			return
		end
		local icon,count,total, elapsed  = getInfoFuncs[id](guid);

		local iconFrame = _G[button:GetName().."Icon"];
		local cooldownFrame = _G[button:GetName().."Cooldown"];

		iconFrame:SetTexture(icon);
		iconFrame:Show();
		SetItemButtonCount(button,count);

		if not (elapsed) then
			cooldownFrame:Hide();
		else
			CooldownFrame_SetTimer(cooldownFrame, GetTime() - (elapsed), total, 1);
		end

		button:SetChecked(false);
		button.icon = icon;

		local index = button:GetName();
		local savedGuid = savedData[index];

		local data;
		if guid then
			data = {
				guid = guid,
				id = id,
			};
		end
		if not(guid == savedGuid) then
			savedData[index] = data;
			saved.SetVar(index,data);
		end
	end

	class.ShowAll = function(id,guid,icon,clearFunc)
		if getInfoFuncs[id] then
			for barName,b in pairs(buttons) do
				local origButton = b.origButton;
				local ghButton = b.ghButton;
				ghButton:Show();
				ghButton:SetScript("OnClick",function()
					SetItem(id,ghButton,guid)
					b.guid = guid;
					class.HideEmpty();
					if clearFunc then
						clearFunc();
					end
				end)
			end
		end
	end

	class.HideEmpty = function()
		for barName,b in pairs(buttons) do
			local origButton = b.origButton;
			local ghButton = b.ghButton;
			if not(ghButton.guid) then
				ghButton:Hide();
			end
			ButtonScripts(ghButton);
		end
	end

	local GenerateGHButton = function(actionButton)
		local b = CreateFrame("CheckButton",actionButton:GetName().."GH",actionButton:GetParent(),"ActionButtonTemplate") --SecureActionButtonTemplate
		b:ClearAllPoints();
		b:SetAllPoints(actionButton);
		b:Hide();
		b:RegisterForDrag("LeftButton","RightButton");
		b:RegisterForClicks("LeftButtonUp","RightButtonUp");
		b:SetFrameStrata(actionButton:GetFrameStrata());
		b:SetFrameLevel(actionButton:GetFrameLevel() + 1);

		local t = savedData[b:GetName()];
		if type(t) == "string" then
			SetItem("GHI_ITEM",b,t);
			b:Show();
		elseif type(t) == "table" then
			SetItem(t.id,b,t.guid);
			b:Show();
		end
		return b;
	end

	GHI_Event("GHI_BAG_UPDATE_COOLDOWN",function(stackGuid,guid)
		for barName,b in pairs(buttons) do
			local ghButton = b.ghButton;
			if ghButton.guid == guid then
				local icon,count,total, elapsed  = getInfoFunc(guid);
				local cooldownFrame = _G[button:GetName().."Cooldown"];

				if not (elapsed) then
					cooldownFrame:Hide();
				else
					CooldownFrame_SetTimer(cooldownFrame, GetTime() - (elapsed), total, 1);
				end
			end
		end
	end);

	local NewButton = function(mirror)
		if not(buttons[mirror:GetName()]) then
			buttons[mirror:GetName()] = {
				origButton = mirror,
				ghButton = GenerateGHButton(mirror),
			};
		end
	end

    local Initialize = function()
		savedData = saved.GetAll();

		-- convert saved data from before v.2.0 format
		local buttonPrefixes = {
			[6] = "MultiBarBottomLeftButton%sGH",
			[5] = "MultiBarBottomRightButton%sGH",
			[4] = "MultiBarLeftButton%sGH",
			[3] = "MultiBarRightButton%sGH",
		};
		for index,data in pairs(savedData) do
			if type(index) == "number" and buttonPrefixes[index] then
				if type(data) == "table" then -- loop trough the data for the given actionbar
					for i,value in pairs(data) do
						local newIndex = string.format(buttonPrefixes[index],i);
						savedData[newIndex] = value;
					end
					saved.SetVar(index,nil);
				end
			end
		end

		local func = function(s,e)
			NewButton(s);
		end
		hooksecurefunc("ActionButton_OnEvent",func);

		GHI_Event().TriggerEventOnAllFrames("ACTIONBAR_SHOWGRID");

		-- Look for eventual bartender buttons
		for i=1,100 do
			if _G["BT4Button"..i] then
				NewButton(_G["BT4Button"..i]);
			end
		end
	end

	if variablesLoaded then
		Initialize();
	else
		GHI_Event("GHI_ITEM_INFO_LOADED",function()
			Initialize();
		end)
	end

	return class;
end
