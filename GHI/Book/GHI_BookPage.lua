--
--
--				GHI_BookPage
--  			GHI_BookPage.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHI_BookPage(materials)
	local class = GHClass("GHI_BookPage");
	local useSpecialSize = false;
	local useSpecialBackground = false;
	local pageText = "";
	local margin = 20;
	local positionCalculator;
	local textFrame = CreateFrame("SimpleHTML", nil, class);
	textFrame:SetPoint("TOPLEFT", class, "TOPLEFT", margin, -margin);

	local function HandleObjectsInPage(text)
		local ptrn = "\124T:[^\124]*\124t";
		local i = string.find(text,ptrn);
		while i do

			local match = string.match(strsub(text,i), ptrn)
			local obj = GHI_BookObjGenerator().FromTextCode(match);

			if obj then
				local w, h = obj.GetSize();
				positionCalculator.CalculatePos(strsub(text,0,i-1),w,h,function(x,y)
					obj.SetPosition(textFrame, x, -y);
				end);
			end
			-- Find next
			i = string.find(text,ptrn,i+1);
		end
	end

	class.SetText = function(text, format)
		pageText = text;
		textFrame:SetText(pageText);
		return class;
	end

	local origShow = class.Show
	class.Show = function()
		if not(positionCalculator) then
			error("Font not set for page.");
		end
		HandleObjectsInPage(pageText);
		origShow(class);
	end

	local origHide = class.Hide
	class.Hide = function()
		origHide(class);
	end

	class.SetFont = function(font, sizeN, sizeH1, sizeH2, sizeH3)
		local fontPath = GHI_FontList[font] or font;
		textFrame:SetFont(fontPath, sizeN);
		textFrame:SetFont("H1", "Interface\\Addons\\GHI\\Fonts\\bdrenais.TTF", sizeH1);
		textFrame:SetFont("H2", fontPath, sizeH2);
		textFrame:SetFont("H3", fontPath, sizeH3);

		positionCalculator = GHI_TextPositionCalculator(textFrame:GetWidth(), font, sizeN, font, sizeH1, font, sizeH2);

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
				if class.bgImage.textureObjects then
					for _,v in pairs(class.bgImage.textureObjects) do
						v:Hide();
					end
				end
			end

			if (class.texture) then
				class.texture:Hide();
			end

			if not(string.find(pathOrColor,"/")) and not(string.find(pathOrColor,"\\")) then
				class.bgImage = materials.GetImage(pathOrColor, textFrame);
				class.bgImage:SetAllPoints(class);
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
					class.texture:SetColorTexture(pathOrColor.r, pathOrColor.g, pathOrColor.b);
				end
			end

			useSpecialBackground = isSpecial;
		end
		return class;
	end

	return class;
end

