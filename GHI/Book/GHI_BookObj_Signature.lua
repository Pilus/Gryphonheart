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
	return 60, 20;
end

function GHI_BookObj_Signature(width, height, data)
	local class = GHClass("GHI_BookObj_Signature");

	local frame = CreateFrame("Frame")
	frame:SetWidth(width * 1.4);
	frame:SetHeight(height * 1.4);

	GHM_TempBG(frame);

	local font = frame:CreateFontString();
	font:SetParent(frame);
	font:SetPoint("TOPLEFT", frame, "TOPLEFT");
	font:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT");
	font:SetJustifyH("CENTER");
	font:SetJustifyV("CENTER");
	font:SetFont("Fonts\\FRIZQT__.TTF", 11);
	font:SetText("Test")

	class.SetPosition = function(parent, x, y)
		frame:SetParent(parent);
		frame:SetPoint("TOPLEFT", parent, "TOPLEFT", x - ((frame:GetWidth() - width) / 2), y + ((frame:GetHeight() - height) / 2));
	end
	
	class.GetSize = function()
		return width, height;
	end 

	return class;
end

