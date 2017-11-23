--
--
--				GHI Backpack Button
--					ghi_buttonUI.lua
--
--	Moveable button for opening of the main GHI bag
--
-- 			(c)2013 The Gryphonheart Team
--				All rights reserved
--
 local class;
function GHI_ButtonUI()
	if class then
		return class;
	end
	class = GHClass("GHI_Button");

	local loc = GHI_Loc();

	local OnMove, OnEnter, OnClick, OnLeave, PositionChangeCallbackFunc;
	local sideFrames = {};
	local sideButtons = {};
	local UpdateSubButtons;
	local HideSubButtons;
	local squaredButton = CreateFrame("CheckButton", "GHI_ButtonSquared", UIParent, "ItemButtonTemplate");
	squaredButton:Hide();

	squaredButton:SetScript("OnUpdate", function(b) if b.iconDrag then OnMove(b) end end)
	squaredButton:SetScript("OnDragStart", function(b) b.iconDrag = true end)
	squaredButton:SetScript("OnDragStop", function(b) b.iconDrag = false end)
	squaredButton:SetScript("OnEnter", function(b) OnEnter(b) end)
	squaredButton:SetScript("OnLeave", function(b) OnLeave(b) end)
	squaredButton:SetScript("OnClick", function(b) OnClick(b) end)
	squaredButton:RegisterForDrag("LeftButton")
	squaredButton:SetMovable();
	squaredButton:SetFrameStrata("MEDIUM");
	squaredButton:SetFrameLevel(8);
	squaredButton:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight");

	local roundButton = CreateFrame("Button", "GHI_ButtonRound", UIParent)
	roundButton:SetHeight(33);
	roundButton:SetWidth(33);

	local overlay = roundButton:CreateTexture(nil, "OVERLAY");
	overlay:SetWidth(56);
	overlay:SetHeight(56);
	overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder");
	overlay:SetPoint("TOPLEFT", 0, 0);
	roundButton.overlay = overlay;

	local icon = roundButton:CreateTexture(nil, "BACKGROUND");
	icon:SetWidth(18);
	icon:SetHeight(18);
	icon:SetTexture("Interface\\AddOns\\GHI\\Textures\\GH_RoundIcon")
	icon:SetPoint("TOPLEFT", 8, -8);
	icon:SetTexCoord(.075, .925, .075, .925)
	roundButton.icon = icon;

	roundButton:SetScript("PreClick", function() PlaySound(856) end);

	roundButton:SetFrameStrata("MEDIUM");
	roundButton:SetFrameLevel(8);
	roundButton:Hide();
	roundButton:RegisterForClicks("AnyUp")

	roundButton:Hide();

	roundButton:SetScript("OnUpdate", function(b) if b.iconDrag then OnMove(b) end end)
	roundButton:SetScript("OnDragStart", function(b) b.iconDrag = true end)
	roundButton:SetScript("OnDragStop", function(b) b.iconDrag = false end)
	roundButton:RegisterForDrag("LeftButton")
	roundButton:SetMovable();
	roundButton:SetScript("OnEnter", function(b) OnEnter(b) end)
	roundButton:SetScript("OnLeave", function(b) OnLeave(b) end)
	roundButton:SetScript("OnClick", function(b) OnClick(b) end)

	OnMove = function(b)
		if IsShiftKeyDown() then
			local _x, _y = GetCursorPosition();
			local s = b:GetEffectiveScale();

			local x, y = _x / s, _y / s;
			roundButton:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
			squaredButton:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
			PositionChangeCallbackFunc(x, y);
		end
	end

	OnEnter = function(b)
		GameTooltip:SetOwner(b, "ANCHOR_LEFT");
		GameTooltip:ClearLines()
		GameTooltip:AddLine(loc.BAG_BNT, 1.0, 1.0, 1.0);
		GameTooltip:AddLine(loc.BAG_DRAG);

		GameTooltip:Show();

		for _,frame in pairs(sideButtons) do
			frame:Show();
		end

		UpdateSubButtons();
	end

	OnClick = function(b)
		GHI_ToggleBackpack();
	end

	OnLeave = function(b)
		GameTooltip:Hide()
		for _,frame in pairs(sideButtons) do
			if not(frame.frame:IsShown()) then
				frame:Hide();
			end
		end
		HideSubButtons();
	end

	local currentButton;
	class.UseSquared = function()
		roundButton:Hide();
		squaredButton:Show();
		currentButton = squaredButton;
	end
	class.UseRound = function()
		squaredButton:Hide();
		roundButton:Show();
		currentButton = roundButton;
	end

	class.ResetPosition = function()
		local x, y = UIParent:GetWidth() / 2, UIParent:GetHeight() / 2;
		roundButton:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
		squaredButton:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
		PositionChangeCallbackFunc(x, y);
	end

	class.SetPosition = function(x, y)
		roundButton:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
		squaredButton:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
		PositionChangeCallbackFunc(x, y);
	end

	class.SetChangePositionCallbackFunction = function(func)
		PositionChangeCallbackFunc = func;
	end

	class.SetScale = function(scale)
		squaredButton:SetWidth(scale * 37);
		squaredButton:SetHeight(scale * 37);
		_G[squaredButton:GetName() .. "NormalTexture"]:SetHeight(64 * scale);
		_G[squaredButton:GetName() .. "NormalTexture"]:SetWidth(64 * scale);

		roundButton:SetWidth(scale * 33);
		roundButton:SetHeight(scale * 33);
		roundButton.icon:SetWidth(scale * 18);
		roundButton.icon:SetHeight(scale * 18);
		roundButton.overlay:SetWidth(scale * 56);
		roundButton.overlay:SetHeight(scale * 56);
		roundButton.icon:SetPoint("TOPLEFT", scale * 8, scale * (-7));
		local s = (.075 * scale);
		roundButton.texCoor = s;
		roundButton.icon:SetTexCoord(s, 1 - s, s, 1 - s)
	end

	class.SetTexture = function(texture)
		SetItemButtonTexture(squaredButton, texture);
		roundButton.icon:SetTexture(texture);
	end

	local GenerateSideButton = function(placement,parent,frame)
		local btn = CreateFrame("Button",nil,parent);
		btn:SetWidth(18);
		btn:SetHeight(52);

		btn:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight","ADD");
		if placement == "LEFT" then
			btn:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-PrevPage-Up");
			btn:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-PrevPage-Down");
			btn:SetPoint("RIGHT",parent,"LEFT",0,0);
		elseif placement == "RIGHT" then
			btn:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up");
			btn:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down");
			btn:SetPoint("LEFT",parent,"RIGHT",0,0);
		end
		btn.frame = frame;
		btn:Hide();
		btn:SetScript("OnEnter",function()
			btn:Show();
		end);
		btn:SetScript("OnLeave",function()
			if not(frame:IsShown()) then
				btn:Hide();
			end
		end);
		btn:SetScript("OnClick",function()
			if frame:IsShown() then
				frame:Hide();
			else
				frame:Show();
			end
		end);

		return btn;
	end

	local PLACEMENT = {"LEFT","RIGHT"}
	class.AddSideFrame = function(frame)
		table.insert(sideFrames,frame);
		local num = #(sideFrames);

		if PLACEMENT[num] and not(sideButtons[num]) then
			sideButtons[num] = GenerateSideButton(PLACEMENT[num],currentButton,frame);
			return sideButtons[num];
		end
	end

	--  Sub buttons 
	local subButtons = {};
	local subButtonScroll;
	local subButtonFrame;

	class.AddSubButton = function(texture,tooltip,callbackFunc)
		table.insert(subButtons,{
			texture = texture,
			tooltip = tooltip,
			callbackFunc = callbackFunc,
		})
	end

	local BUTTON_SIZE = 24;
	UpdateSubButtons = function()
		if not(subButtonScroll) then
			subButtonScroll = CreateFrame("ScrollFrame");
			subButtonScroll:SetWidth(BUTTON_SIZE)

			subButtonScroll.RollOut = function()
				local startPos,endPos = subButtonScroll:GetVerticalScroll(),BUTTON_SIZE*#(subButtons);
				local lastPos = startPos;
				subButtonScroll:SetScript("OnUpdate",function(this,dt)
					if (GetMouseFocus():GetParent() == subButtonFrame) or GetMouseFocus()==currentButton then
						if lastPos < endPos then
							local p = lastPos + math.max(4*dt*math.abs(endPos-lastPos),0.5);
							subButtonScroll:SetVerticalScroll(p);
							lastPos = p;
						end
					else
						subButtonScroll.RollIn();
					end
				end);
			end

			subButtonScroll.RollIn = function()
				local startPos,endPos = subButtonScroll:GetVerticalScroll(),0;
				local lastPos = startPos;
				local startTime = time() + 2;
				subButtonScroll:SetScript("OnUpdate",function(this,dt)
					if time() < startTime then
						return
					end
					if not(GetMouseFocus() and GetMouseFocus():GetParent() == subButtonFrame) then
						local p = lastPos - math.max(4*dt*math.abs(endPos-lastPos),0.5);
						subButtonScroll:SetVerticalScroll(p);
						lastPos = p;
						if lastPos <= endPos then
							subButtonScroll:SetScript("OnUpdate",function() end);
						end
					else
						subButtonScroll.RollOut();
					end
				end);
			end
		end

		if not(subButtonFrame) then
			subButtonFrame = CreateFrame("Frame",nil,currentButton);
			subButtonFrame:SetWidth(BUTTON_SIZE);
			subButtonScroll:SetScrollChild(subButtonFrame);
		end
		subButtonScroll:SetPoint("BOTTOM",currentButton,"TOP");

		local num = #(subButtons);
		for i = 1,num do
			if not(subButtonFrame[i]) then
				local info = subButtons[i];
				local f = CreateFrame("Button","GHI_SubButton"..i,subButtonFrame,"ItemButtonTemplate");
				f:SetHeight(BUTTON_SIZE);
				f:SetWidth(BUTTON_SIZE);
				if i==1 then
					f:SetPoint("BOTTOM",subButtonFrame,"BOTTOM");
				else
					f:SetPoint("BOTTOM",subButtonFrame[i-1],"TOP");
				end

				local t = f:GetNormalTexture();
				t:SetWidth(BUTTON_SIZE+14);
				t:SetHeight(BUTTON_SIZE+14);

				SetItemButtonTexture(f,info.texture);
				f:SetScript("OnEnter",function()
					GameTooltip:SetOwner(f, "ANCHOR_LEFT");
					GameTooltip:ClearLines()
					GameTooltip:AddLine(info.tooltip);

					GameTooltip:Show();
				end);

				f:SetScript("OnLeave",function()
					GameTooltip:Hide();
				end);

				f:SetScript("OnClick",function()
					info.callbackFunc();
				end);

				f:Show();

				subButtonFrame[i] = f;
				subButtonFrame:SetHeight(i*BUTTON_SIZE*2);
				subButtonScroll:SetHeight(i*BUTTON_SIZE)
			end
		end

		-- Do animation
		subButtonScroll.RollOut();
	end

	HideSubButtons = function()
		subButtonScroll.RollIn();
	end

	class.SetScale(1);
	class.UseSquared();

	return class;
end