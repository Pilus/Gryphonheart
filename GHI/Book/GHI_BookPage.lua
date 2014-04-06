--===================================================
--
--				GHI_BookPage
--  			GHI_BookPage.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_BookPage()
	local class = GHClass("GHI_BookPage");
	local useSpecialSize = false;
	local useSpecialBackground = false;

	local textFrame = CreateFrame("SimpleHTML");
	textFrame:SetParent(class);
	textFrame:SetPoint("TOPLEFT", 10, -10);
	textFrame:SetPoint("BOTTOMRIGHT", -10, 10);

	class.SetText = function(text, format)
		textFrame:SetText(text);
		return class;
	end

	class.SetFont = function(font, size)
		textFrame:SetFont(font, size);
		return class;
	end

	class.SetSize = function(width, height, isSpecial)
		if (isSpecial == true or useSpecialSize == isSpecial) then
			class:SetWidth(width);
			class:SetHeight(height);
			useSpecialSize = isSpecial;
		end
		return class;
	end

	class.SetBackground = function(pathOrColor, isSpecial)
		if (isSpecial == true or useSpecialBackground == isSpecial) then
			if not(class.texture) then
				class.texture = class:CreateTexture(nil,"BACKGROUND");
				class.texture:SetAllPoints(class);
			end

			if type(pathOrColor) == "string" then
				class.texture:SetTexture(pathOrColor);
			elseif type(pathOrColor) == "table" and type(pathOrColor.r) == "number" and type(pathOrColor.g) == "number" and type(pathOrColor.b) == "number" then
				class.texture:SetTexture(pathOrColor.r, pathOrColor.g, pathOrColor.b);
			end
			useSpecialBackground = isSpecial;
		end
		return class;
	end

	GHM_TempBG(class);
	return class;
end

