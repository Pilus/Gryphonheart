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

GHI_BookObj_Signature_Width = 130;
GHI_BookObj_Signature_Height = 40;

function GHI_BookObj_Signature(data)
	local class = GHClass("GHI_BookObj_Signature");

	local frame;

	class.GetData = function()
		return attributeName;
	end

	frame = CreateFrame("Frame")
	local w,h = class.GetSize();
	frame:SetWidth(w);
	frame:SetHeight(h);

	local font = frame:CreateFontString();
	font:SetParent(frame);
	font:SetPoint("TOPLEFT","TOPLEFT");
	font:SetPoint("BOTTOMRIGHT","BOTTOMRIGHT");
	font:SetJustifyH("CENTER");
	font:SetJustifyV("CENTER");
	font:SetFont("Fonts\\FRIZQT__.TTF", 11);
	font:SetText("Test")

	class.GetFrame = function()
		return frame;
	end

	class.SetCurrentStack = function(stack)
		currentStack = stack;
	end

	return class;
end

