--===================================================
--
--				GHM_Toolbar
--  			GHM_Toolbar.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local BORDER_SIZE = 1;
local BUTTON_SIZE = 32;
local count = 1;
function GHM_Toolbar(parent,f)
	local frame = CreateFrame("Frame", "GHM_Toolbar" .. count, parent);
	count = count + 1;

	local buttons = {};

	frame.AddButton = function(texture,func,tooltip)
		local b = CreateFrame("Button",frame:GetName().."B"..#(buttons)+1,frame,"GHM_Button_Template");
		b:SetHeight(BUTTON_SIZE);
		b:SetWidth(BUTTON_SIZE);
		b:SetPoint("LEFT",(BUTTON_SIZE + BORDER_SIZE)*#(buttons)+BORDER_SIZE,0)
		local t = b:CreateTexture(b:GetName().."Texture","OVERLAY");
		t:SetPoint("CENTER");
		t:SetHeight(BUTTON_SIZE-4);
		t:SetWidth(BUTTON_SIZE-4);
		t:SetTexture(texture);
		b:SetScript("OnClick",function() func(f) end);
		b:SetScript("OnEnter",function()
			GameTooltip:SetOwner(b, "ANCHOR_LEFT");
			GameTooltip:ClearLines();
			GameTooltip:AddLine(tooltip,1,1,1);
			GameTooltip:Show();
		end);
		b:SetScript("OnLeave",function()
			GameTooltip:Hide();
		end);
		table.insert(buttons,b);
		frame:SetWidth((BUTTON_SIZE + BORDER_SIZE)*#(buttons)+BORDER_SIZE)
	end

	frame:SetHeight(BUTTON_SIZE + BORDER_SIZE*2);
	frame:SetWidth(0)


	return frame;
end

