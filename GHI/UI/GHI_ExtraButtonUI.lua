--===================================================
--
--			     	GHI_ExtraButtonUI
--  			  GHI_ExtraButtonUI.lua
--
--	      Allows GHI to to simulate Blizzard's
--               Extra Action Button
--
-- 	        (c)2013 The Gryphonheart Team
--		        	All rights reserved
--===================================================


local class;

function GHI_ExtraButtonUI()

	if class then
		return class;
	end
	
	class = GHClass("ExtraButtonUI","frame");
	
	local frame = _G["GHI_ExtraButtonFrame"]
	
	frame.button.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
	frame.button.style:SetTexture("Interface\\ExtraButton\\Default")
	frame.button.charges:SetText(frame.currentCharges)
	frame.cd = 1
	
	local function ButtonClick()
		frame.button.cooldown:SetCooldown(GetTime(), frame.cd, frame.currentCharges, frame.maxCharges)
		if frame.currentCharges then
			frame.currentCharges = frame.currentCharges -1
			if frame.currentCharges == 0 then
				frame.button.charges:Hide()
			else
				if not (frame.button.charges:IsShown()) then
					frame.button.charges:Show()
				else
					frame.button.charges:SetText(frame.currentCharges)
				end
			end
		end
		if type(frame.OnClick) == "function" then
			frame.OnClick(frame.currentCharges, frame.maxCharges)
		end
	end
	
	frame.button:SetScript("OnClick", function(self)
		if frame.currentCharges == 1 then
			frame.button:Disable()
			ButtonClick()
		elseif frame.currentCharges == nil then
			frame.button:Disable()
			ButtonClick()
			GHI_Timer(function() frame.button:Enable() end, frame.cd,true)
		else
			frame.button:Disable()
			ButtonClick()
			GHI_Timer(function() frame.button:Enable() end, frame.cd,true)
		end
	end)
	
	frame.button:SetScript("OnEnter", function(self)
		if frame.TooltipTitle then
			GameTooltip:SetOwner(self,"ANCHOR_TOPLEFT")
			GameTooltip:SetText(frame.TooltipTitle, 1,1,1,1,true)
			GameTooltip:AddLine(frame.TooltipText, nil,nil,nil,true)
			GameTooltip:Show()
		end
	
	end)

	frame.button:SetScript("OnLeave", function(self)
		if GameTooltip:GetOwner() == self and GameTooltip:IsShown() then
			GameTooltip:Hide();
		end
	end)
	
	class.SetIcon = function(icon)
		frame.button.icon:SetTexture(icon)
	end
		
	class.SetTheme = function(theme, icon)
		if strfind(theme,"GHI") then
			frame.button.style:SetTexture("Interface\\Addons\\GHI\\texture\\ExtraButton\\"..theme)
		else
			frame.button.style:SetTexture("Interface\\ExtraButton\\"..theme)
		end
		
		if icon then
			class.SetIcon(icon)
		end
	end
	
	class.SetCooldownTime = function(cd)
		frame.cd = cd
	end
	
	class.SetMaxCharges = function(maxi, curr)
		frame.maxCharges = maxi
		if curr then
			frame.currentCharges = curr
		else
			frame.currentCharges = maxi
		end
		frame.button.charges:SetText(frame.currentCharges)
	end
	
	class.SetTooltip = function(tooltipTitle, tooltipText)
		frame.TooltipTitle = tooltipTitle
		frame.TooltipText = tooltipText
	end
	
	class.ChangeCharges = function(charges)
		if frame.currentCharges then
			frame.currentCharges = frame.currentCharges + charges
			frame.button:Enable()
			if frame:IsShown() == false then
				frame:Show()
			end
			if not (frame.button.charges:IsShown()) then
				frame.button.charges:Show()
				frame.button.charges:SetText(frame.currentCharges)
			else
				frame.button.charges:SetText(frame.currentCharges)
			end
		else
			class.SetMaxCharges(charges,charges)
		end
		
	end
	
	class.GetCharges = function()
		return frame.currentCharges, frame.maxCharges
	end
	
	class.SetOnClick = function(func)
		frame.OnClick = func
	end
	
	class.Toggle = function(togType)
		if togType then
			if strlower(togType) == strlower("show") then
				frame:Show()
				frame:SetAlpha(0.0)
				frame.intro:Play()
			else
				frame.outro:Play()
			end
		else
			if frame:IsShown() then
				frame.outro:Play()
			else
				frame:Show()
				frame:SetAlpha(0.0)
				frame.intro:Play()
			end
		end
	end
	
	
	class.Clear = function()
			class.SetOnClick(nil)
			class.SetMaxCharges(nil,nil)
			class.SetCooldownTime(1)
			class.SetTheme("Default")
			class.SetIcon("Interface\\Icons\\INV_Misc_QuestionMark")			
	end
		
	return class;
end
	