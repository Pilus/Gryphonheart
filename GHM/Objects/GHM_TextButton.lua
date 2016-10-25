--
--
--				GHM_TextButton
--  			GHM_TextButton.lua
--
--	          (A button that appears as only text.)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local count = 1;
function GHM_TextButton(profile, parent, settings)
	local frame = CreateFrame("Button","GHM_TextButton" .. count, parent);
	count = count + 1;
	local miscApi = GHI_MiscAPI().GetAPI()
	local font = "Fonts\\FRIZQT__.TTF"
	local fontColor = {r=1, g=1, b=1}
	local fontSize = profile.fontSize or 11
	
	if profile.font then
		font = GHI_FontList[profile.font] 
	end	
	if profile.color then
		if type(profile.color) == "table" then
			local color = profile.color
			fontColor.r = color.r or color[1]
			fontColor.g = color.g or color[2]
			fontColor.b = color.b or color[3]
		elseif type(profile.color) == "string" then
			local colorList = miscApi.GHI_GetColors()
			local color = profile.color
			fontColor.r = colorList[color].r
			fontColor.g = colorList[color].g
			fontColor.b = colorList[color].b
		end
	end
			
	local label = frame:CreateFontString(frame:GetName().."Label", "ARTWORK")
	label:SetPoint("LEFT",frame,"LEFT",0,0)
	label:SetFontObject("ChatFontNormal")
	label:SetFont(font,fontSize)
	label:SetTextColor(fontColor.r, fontColor.g, fontColor.b)
	label:SetText(profile.text)
	label:SetHeight(label:GetStringHeight() + 4)
	label:SetWidth(label:GetStringWidth() + 4)
	
	local highlight = frame:CreateTexture()
	highlight:SetTexture("Interface\\questframe\\UI-QuestTitleHighlight")
	highlight:SetBlendMode("ADD")
	highlight:SetDrawLayer("HIGHLIGHT")
	highlight:SetAlpha(0.75)
	highlight:SetAllPoints(frame)
		
	frame:SetHeight(profile.height or label:GetHeight());
	frame:SetWidth(profile.width or label:GetWidth());
	
	if profile.value then
		frame.value = profile.value
	end
	
	if profile.index then
		frame.index = profile.index
	end
	
	-- Click handler
	if profile.OnClick then
		frame:SetScript("OnClick",profile.OnClick)
	end
	if profile.onClick then
		frame:SetScript("OnClick",profile.onClick)
	end

	-- Tooltip
	frame:SetScript("OnEnter", function()
		if profile.tooltip then
			GameTooltip:SetOwner(frame, "ANCHOR_RIGHT");
			GameTooltip:ClearLines()
			GameTooltip:AddLine(profile.tooltip, 1, 0.8196079, 0);
			GameTooltip:Show()
		end
	end);
	frame:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end);

	frame:Show()
	
	return frame;
end

