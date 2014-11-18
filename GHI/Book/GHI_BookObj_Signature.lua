--===================================================
--
--				GHI_BookObj_Signature
--				GHI_BookObj_Signature.lua
--
--		Signature book object
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_BookObj_Signature_GetSize(data)
	return 130, 40;
end

function GHI_BookObj_Signature(width, height, data)
	local class = GHClass("GHI_BookObj_Signature");

	local frame = CreateFrame("Frame")
	frame:SetWidth(width);
	frame:SetHeight(height);

	local font = frame:CreateFontString();
	font:SetParent(frame);
	font:SetPoint("TOPLEFT","TOPLEFT");
	font:SetPoint("BOTTOMRIGHT","BOTTOMRIGHT");
	font:SetJustifyH("CENTER");
	font:SetJustifyV("CENTER");
	font:SetFont("Fonts\\FRIZQT__.TTF", 11);
	font:SetText("Test")

	class.SetPosition = function(parent, x, y)
		frame:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y);
	end
	
	class.GetSize = function()
		return width, height;
	end 

	return class;
end

