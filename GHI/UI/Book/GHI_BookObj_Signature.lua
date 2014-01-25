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

function GHI_BookObj_Signature(width, height, attributeName)
	local class = GHClass("GHI_BookObj_Signature");

	local frame,currentStack;

	if type(width) == "table" then
		class = width;
	else
		class = GHI_BookObj(width, height,"Signature");
	end

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

