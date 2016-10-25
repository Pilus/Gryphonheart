--
--
--				GHI_MultiTextureImage
--  			GHI_MultiTextureImage.lua
--
--	Dataset for multiple textures to use in one image.
--
-- 		(c)2014 The Gryphonheart Team
--			All rights reserved
--

function GHI_MultiTextureImage()
	local class = GHClass("GHI_MultiTextureImage");

	local textures = {};

	class.AddTexture = function(texturePath, width, height, xoff, yoff, texCoord)
		GHCheck("AddTexture", {"string", "number", "number", "number", "number", "tableNil"}, {texturePath, width, height, xoff, yoff, texCoord});
		table.insert(textures,{
			texturePath = texturePath,
			height = height,
			width = width,
			xoff = xoff,
			yoff = yoff,
			texCoord = texCoord,
		});
		return class;
	end

	local GetNativeImageSize = function()
		local width, height = 0,0;
		for _,texture in pairs(textures) do
			width = math.max(width, texture.xoff + texture.width);
			height = math.max(height, texture.yoff + texture.height);
		end
		return width, height;
	end

	class.GenerateImageFrame = function(parent)
		local frame = CreateFrame("frame");
		local nativeWidth, nativeHeight = GetNativeImageSize();

		frame:SetWidth(nativeWidth);
		frame:SetHeight(nativeHeight);

		frame.textureObjects = {};
		for id, texture in pairs(textures) do
			local t = frame:CreateTexture(nil, "BACKGROUND");
			t:SetTexture(texture.texturePath);
			if texture.texCoord then
				t:SetTexCoord(unpack(texture.texCoord));
			end
			t:SetWidth(texture.width);
			t:SetHeight(texture.height);
			t:SetPoint("TOPLEFT", frame, "TOPLEFT", texture.xoff, texture.yoff);
			t:SetParent(parent);
			frame.textureObjects[id] = t;
		end

		local OnSizeChange = function(self, width, height)
			local xScale = width/nativeWidth;
			local yScale = height/nativeHeight;
			for id, t in pairs(frame.textureObjects) do
				local texture = textures[id];
				t:SetWidth(texture.width * xScale);
				t:SetHeight(texture.height * yScale);
				t:SetPoint("TOPLEFT", frame, "TOPLEFT", texture.xoff * xScale, -texture.yoff * yScale);
			end
		end
		frame:SetScript("OnSizeChanged", OnSizeChange);

		return frame;
	end

	return class;
end

