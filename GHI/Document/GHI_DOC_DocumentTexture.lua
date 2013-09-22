--===================================================
--
--				GHI_DOC_DocumentTexture
--  			GHI_DOC_DocumentTexture.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_DOC_DocumentTexture(_parent,_width,_height,_xOff,_yOff,_level)
	local class = GHClass("GHI_DOC_DocumentTexture");

	local parent,width,height,xOff,yOff,level = _parent,_width,_height,_xOff,_yOff,_level;
	local textures = {};

	local mainFrame;

	local texFrames = {};


	local getTextures = function(texType) -- get all available textures of a given type

	end

	class.SetTextures = function(...)
		assert(#({...}) > 0,"No textures given");
		for _,tex in pairs({...}) do
			local Type = tex:GetTexType();
			textures[Type] = textures[Type] or {};
			table.insert(textures[Type],tex);
		end

		class.Update();
	end



	class.Show = function()
		mainFrame:Show();
	end
	class.Hide = function()
		mainFrame:Hide();
	end



	class.Update = function()
		if #(textures["center"] or {}) == 0 then return end

		-- determine the smallest texture size
		local minX,minY,minXY;
		for _,cat in pairs(textures) do
			for _,tex in pairs(cat or {}) do
				minX = min(minX or tex:GetWidth(),tex:GetWidth());
				minY = min(minY or tex:GetHeight(),tex:GetHeight());
			end
		end
		minXY = min(minX,minY);

		-- calculate the used size of each texture and the amount of textures
		local cX = max(math.floor((width/minXY)+0.5),3);
		local cY = max(math.floor((height/minXY)+0.5),3);

		local xSize,ySize = math.floor(width/cX),math.floor(height/cY);


		-- calculate the needed frames
		local framesNeeded = cX*cY;

		-- create evt missing frames
		while (#(texFrames) < framesNeeded) do
			local f = CreateFrame("Frame",mainFrame);
			f:SetFrameStrata("BACKGROUND");
			f:SetFrameLevel(level);
			table.insert(texFrames,f);
		end

		-- place frames
		for iX = 1,cX do
			for iY = 1,cY do
				local f = texFrames[(iX-1)*cY + iY];
				f:SetWidth(xSize);
				f:SetHeight(ySize);
				-- evt clear all points?
				f:ClearAllPoints();
				f:SetPoint("TOPLEFT",mainFrame,"TOPLEFT",(iX-1)*xSize,-(iY-1)*ySize);

				-- decide and set texture
				local texType;
				if iX == 1 and iY == 1 then -- topleft
					texType = "topleft";
				elseif iX == cX and iY == 1 then -- topright
					texType = "topright";
				elseif iX == 1 and iY == cY then -- bottomleft
					texType = "bottomleft";
				elseif iX == cX and iY == cY then -- bottomright
					texType = "bottomright";
				elseif iX == 1 then -- left
					texType = "left";
				elseif iX == cX then -- right
					texType = "right";
				elseif iY == 1 then -- top
					texType = "top";
				elseif iY == cY then -- bottom
					texType = "bottom";
				end

				if not(texType) or not(textures[texType]) then
					texType = "center";
				end

				local tex = textures[texType][random(#( textures[texType]))]; -- use a random of the fitting textures
				tex:ApplyTexture(f);
				f:Show();
			end
		end

		-- hide eventual unused frames
		for i=framesNeeded+1,#(texFrames) do
			if texFrames[i] then
				texFrames[i]:Hide();
			end
		end


	end

	mainFrame = CreateFrame("Frame",parent);
	mainFrame:SetHeight(height);
	mainFrame:SetWidth(width);
	mainFrame:SetPoint("TOPLEFT",parent,"TOPLEFT",xOff,yOff)

	return class;
end

