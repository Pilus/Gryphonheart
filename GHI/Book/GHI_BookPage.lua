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

function GHI_BookPage(materials)
	local class = GHClass("GHI_BookPage");
	local useSpecialSize = false;
	local useSpecialBackground = false;
	local pageText = "";
	local margin = 20;

	local textFrame = CreateFrame("SimpleHTML", nil, class);
	textFrame:SetPoint("TOPLEFT", class, "TOPLEFT", margin, -margin);

	class.SetText = function(text, format)
		pageText = text;
		textFrame:SetText(pageText);
		return class;
	end

	class.SetFont = function(font, size)
		textFrame:SetFont(font, size);
		return class;
	end

	class.SetTextColor = function(r, g, b, a)
		textFrame:SetTextColor(r, g, b, a);
		return class;
	end

	class.SetSize = function(width, height, isSpecial)
		if (isSpecial == true or useSpecialSize == isSpecial) then
			class:SetWidth(width);
			class:SetHeight(height);
			textFrame:SetWidth(width - margin*2);
			textFrame:SetHeight(height - margin*2);
			textFrame:SetText(pageText); -- Set the text again to get correct line breaks.

			useSpecialSize = isSpecial;
		end
		return class;
	end

	class.SetBackground = function(pathOrColor, isSpecial, texCoord)
		if (isSpecial == true or useSpecialBackground == false) then
			if (class.bgImage) then
				class.bgImage:Hide();
			end

			if (class.texture) then
				class.texture:Hide();
			end

			if not(string.find(pathOrColor,"/")) and not(string.find(pathOrColor,"\\")) then
				class.bgImage = materials.GetImage(pathOrColor, textFrame);
				class.bgImage:SetAllPoints(class);
				--class.bgImage:SetParent(textFrame);
			else
				if not(class.texture) then
					class.texture = class:CreateTexture(nil,"BACKGROUND");
					class.texture:SetAllPoints(class);
				end

				class.texture:Show();
				if type(pathOrColor) == "string" then
					class.texture:SetTexture(pathOrColor);
					if texCoord then
						class.texture:SetTexCoord(unpack(texCoord));
					end
				elseif type(pathOrColor) == "table" and type(pathOrColor.r) == "number" and type(pathOrColor.g) == "number" and type(pathOrColor.b) == "number" then
					class.texture:SetTexture(pathOrColor.r, pathOrColor.g, pathOrColor.b);
				end
			end

			useSpecialBackground = isSpecial;
		end
		return class;
	end

	return class;
end

