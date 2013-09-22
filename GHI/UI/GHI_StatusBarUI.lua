--===================================================
--
--				GHI_StatusBarUI
--  			GHI_StatusBarUI.lua
--
--	    Allows GHI to simulate status bars similar
--            to blizzard's  extra action bar
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================


local class;

function GHI_StatusBarUI()

	if class then
		return class;
	end
	
	class = GHClass("GHI_StatusBarUI","frame");
	
	local powerFrame = _G["GHI_StatusBarFrame"]
	
	powerFrame:SetSize(256,64)
	powerFrame:SetPoint("TOP",UIParent,"TOP",0,-100)
	powerFrame.frame.tex:SetTexture("Interface\\UNITPOWERBARALT\\Generic1Player_Horizontal_Frame")
	powerFrame.background.tex:SetTexture("Interface\\UNITPOWERBARALT\\Generic1Player_Horizontal_Bgnd")
	powerFrame.frame.statusText:SetFontObject("TextStatusBarText") 
	
	local bar = powerFrame.status
	bar:SetOrientation("HORIZONTAL")
	bar:SetMinMaxValues(1,100)
	bar:SetStatusBarTexture("Interface\\UNITPOWERBARALT\\Generic1Player_Horizontal_Fill")
	bar:SetValue(1)
	
	local meter = powerFrame.slider
	meter:Disable()
	meter:SetOrientation("HORIZONTAL")
	meter.thumb:SetTexture("Interface\\UNITPOWERBARALT\\Generic1Player_Horizontal_Spark")
	meter:SetMinMaxValues(1,100)
	meter:SetValue(1)
	
	local IsFill = true
	
	class.IsMeter = function()
		bar:Hide()
		meter:Show()
		IsFill = false
	end
	
	class.IsFill = function()
		meter:Hide()
		bar:Show()
		IsFill = true
	end
	
	class.SetOrientation = function(orient)
		bar:SetOrientation(orient)
		meter:SetOrientation(orient)
	end
	
	class.SetMinMax = function(mini, maxi)
		mini = mini * 10
		maxi = maxi * 10
		bar:SetMinMaxValues(mini,maxi)
		meter:SetMinMaxValues(mini,maxi)
	end
	
	class.SetTheme = function(theme)
		powerFrame.frame.tex:SetTexture("Interface\\UNITPOWERBARALT\\"..theme.."_Frame")
		powerFrame.background.tex:SetTexture("Interface\\UNITPOWERBARALT\\"..theme.."_Bgnd")
		bar:SetStatusBarTexture("Interface\\UNITPOWERBARALT\\"..theme.."_Fill")
		meter.thumb:SetTexture("Interface\\UNITPOWERBARALT\\"..theme.."_Spark")
	end
	
	class.SetTextures = function(frame,fill,bg,thumb)
		if frame then powerFrame.frame.tex:SetTexture(frame) end
		if bg then powerFrame.background.tex:SetTexture(bg) end
		if fill then bar:SetStatusBarTexture(fill) end
		if thumb then meter.thumb:SetTexture(thumb) end
	end
	
	class.SetFillColor = function(r,g,b,a)
		local cR, cG, cB, cA = bar:GetStatusBarColor()
		bar:SetStatusBarColor(r or cR, g or cG, b or cB, a or cA)
	end
		
	class.ChangeValue = function(value)
		local current
		value = value * 10
		if IsFill == true then
			current = bar:GetValue()
			bar:SetValue(current + value)
		else
			current = meter:GetValue()
			meter:SetValue(current + value)
		end
	end
	
	class.GetValue = function()
		if IsFill == true then
			return (bar:GetValue()) / 10
		else
			return (meter:GetValue()) / 10
		end
	end
	
	class.Toggle = function(togType)
		if togType then
			if strlower(togType) == strlower("show") then
				powerFrame:Show()
				powerFrame:SetAlpha(0.0)
				powerFrame.intro:Play()
			else
				powerFrame.outro:Play()
			end
		else
			if powerFrame:IsShown() then
				powerFrame.outro:Play()
			else
				powerFrame:Show()
				powerFrame:SetAlpha(0.0)
				powerFrame.intro:Play()
			end
		end
	end
		
	class.SetText = function(text, font, color)
		powerFrame.frame.statusText:SetText(text)
		if font then
			if GHI_FontList[font] then
				font = GHI_FontList[font]
			end
			powerFrame.frame.statusText:SetFont(font, 10)
		end
		
		if type(color) == "table" then
			powerFrame.frame.statusText:SetTextColor(color[1] or color.r, color[2] or color.g, color[3] or color.b, 1)
		end
	end
	
	class.Clear = function()
		class.ChangeValue(-(class.GetValue()))
		class.SetOrientation("HORIZONTAL")
		class.SetTheme("Generic1Player_Horizontal")
		class.SetFillColor(1,1,1,1)
		class.SetMinMax(1,100)		
	end
	
	
	return class;
end
	