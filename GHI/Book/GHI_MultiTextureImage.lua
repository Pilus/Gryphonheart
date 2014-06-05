--===================================================
--
--				GHI_MultiTextureImage
--  			GHI_MultiTextureImage.lua
--
--	Dataset for multiple textures to use in one image.
--
-- 		(c)2014 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_MultiTextureImage()
	local class = GHClass("GHI_MultiTextureImage");

	local textures = {};

	class.AddTexture = function(texturePath, height, width, xoff, yoff, texCoord)
		GHCheck("AddTexture", {"string", "number", "number", "number", "number", "tableNil"}, {texturePath, height, width, xoff, yoff, texCoord});
		table.insert(textures,{
			texturePath = texturePath,
			height = height,
			width = width,
			xoff = xoff,
			yoff = yoff,
			texCoord = texCoord,
		});
	end

	local GetNativeImageSize = function()
		local width, height = 0,0;
		for _,texture in pairs(textures) do
			width = math.max(width, texture.xoff + texture.width);
			height = math.max(height, texture.yoff + texture.height);
		end
		return width, height;
	end

	class.GenerateImageFrame = function()
		local frame = CreateFrame("frame");
		local nativeWidth, nativeHeight = GetNativeImageSize();

		frame:SetWidth(nativeWidth);
		frame:SetHeight(nativeHeight);

		local textureObjects = {};
		for id, texture in pairs(textures) do
			local t = frame:CreateTexture();
			t:SetTexture(texture.texturePath);
			t:SetWidth(texture.width);
			t:SetHeight(texture.height);
			t:SetPoghcheckint("TOPLEFT", frame, "TOPLEFT", texture.xoff, texture.yoff);
			textureObjects[id] = t;
		end

		local OnSizeChange = function(self, width, height)
			local xScale = width/nativeWidth;
			local yScale = height/nativeHeight;
			for id, t in pairs(textureObjects) do
				local texture = textures[id];
				t:SetWidth(texture.width * xScale);
				t:SetHeight(texture.height * yScale);
				t:SetPoint("TOPLEFT", frame, "TOPLEFT", texture.xoff * xScale, texture.yoff * yScale);
			end
		end
		frame:SetScript("OnSizeChange", OnSizeChange);

		return frame;
	end

	return class;
end

AA = function()
	local tex = GHI_MultiTextureImage();
	tex.AddTexture("Interface\\EncounterJournal\\UI-EJ-BOSS-Hogger", 128, 64, 0, 0);
	local f = tex.GenerateImageFrame();
	f:SetParent(UIParent);
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
end