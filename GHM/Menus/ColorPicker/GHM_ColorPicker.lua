--===================================================
--					GHM_ColorPicker
--				  GHM_ColorPicker.lua
--
--		Window for choosing an icon in a GHM window
--
-- 			(c)2013 The Gryphonheart Team
--				  All rights reserved
--===================================================
local menuIndex = 1

function GHM_ColorPicker()
	local class = GHClass("GHM_ColorPicker");
	
	local miscAPI = GHI_MiscAPI().GetAPI();
	local loc = GHI_Loc()

	local selectedColor, selectedAlpha
	local OnOkCallback
	local returnHex
	
	local inUse = false;
	
	while _G["GHM_Color_Picker" .. menuIndex] do
		menuIndex = menuIndex + 1
	end
	
	local colorMenuFrame
	local colorT = {
		{
			{
				{
					type = "Color2",
					text = GetText("COLOR"),
					align = "c",
					label = "color",              
				},
			},
			{
				{
					type = "Button",
					text = GetText("OKAY"),
					align = "l",
					label = "ok",
					OnClick = function(self)
						local color = colorMenuFrame.GetLabel("color")
						if returnHex == true then
							local colorHex = miscAPI.RGBAPercToHex(color.r,color.g,color.b,color.a or 1)
							OnOkCallback(colorHex)
						else
							OnOkCallback(color)
						end						
						inUse = false
						colorMenuFrame:Hide();
					end,
				},
				{
					type = "Button",
					text = GetText("CANCEL"),
					align = "r",
					label = "cancel",
					OnClick = function(obj)
						colorMenuFrame:Hide();
						inUse = false
					end,
				},
			},
		},
		title = GetText("COLOR_PICKER"),
		name = "GHM_Color_Picker"..menuIndex,
		theme = "BlankTheme",
		width = 280,
		height = 240,
		useWindow = true,
	}
	
	colorMenuFrame = GHM_NewFrame(class, colorT);
	colorMenuFrame:SetToplevel(true)
	colorMenuFrame:Hide()
	
	
	class.New = function(_OnOkCallback, hex)
		OnOkCallback = _OnOkCallback;
		colorMenuFrame.ForceLabel("color", {1,1,1,1})
		if hex then
			returnHex = hex
		else
			returnHex = nil
		end
		colorMenuFrame:Show();
		colorMenuFrame:GetParent():GetParent():SetFrameStrata("FULLSCREEN_DIALOG")
		inUse = true;
	end
	
	class.Edit = function(_color, _OnOkCallback, hex)
		OnOkCallback = _OnOkCallback;
		if hex then
			local colorTab = miscAPI.HexToRGBAPerc(_color)
			colorMenuFrame.ForceLabel("color", colorTab)
			returnHex = true
		else
			returnHex = nil
			colorMenuFrame.ForceLabel("color", _color)
		end
		colorMenuFrame:Show()
		colorMenuFrame:GetParent():GetParent():SetFrameStrata("FULLSCREEN_DIALOG")
		inUse = true;
	end
		
	class.IsInUse = function()
		 return inUse;
	end
	
	return class;
end