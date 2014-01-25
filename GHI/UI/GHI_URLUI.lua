--===================================================
--
--				GHI_URLUI
--  			GHI_URLUI.lua
--
--		UI for displaying urls in a practical ui
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local menuIndex = 1;
function GHI_URLUI()
	local frame = CreateFrame("Frame","GHI_URLUI_"..menuIndex,UIParent);
	menuIndex = menuIndex + 1;
	local inUse = false;

	frame:SetWidth(300);
	frame:SetHeight(20);
	frame:SetPoint("CENTER")

	local textBox = CreateFrame("EditBox","$parentEditbox",frame,"GHM_EditBox_Box_Template")
	textBox:SetPoint("TOPLEFT");
	textBox:SetPoint("BOTTOMRIGHT",0,0);
	textBox:SetTextureTheme("Tooltip");
	textBox:SetMaxLetters(128);

	local closeButton = CreateFrame("Button",nil,textBox,"UIPanelCloseButton");
	closeButton:SetHeight(24);
	closeButton:SetWidth(24);
	closeButton:SetPoint("RIGHT",2,0);

	closeButton:SetScript("OnClick",function()
		frame:Hide();
		inUse = false;
	end);

	textBox:SetScript("OnEscapePressed",function()
		textBox:ClearFocus();
	end)

	frame.New = function(url)
		frame:Show();
		textBox:SetText(url);
		textBox:HighlightText();
		textBox:SetFocus();
		textBox:SetCursorPosition(0);
		GHM_LayerHandle(frame);
		inUse = true;
	end

	frame.Edit = function(...)
		error("Edit menu for viewing instance is not relevant.")
	end

	frame.IsInUse = function()
		return inUse;
	end

	return frame;
end

