--===================================================
--
--				GHM_ImageList
--  			GHM_ImageList.lua
--
--	          GHM_Image object for GHM
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;

--[[
	profile.scaleX
	profile.scaleY
	profile.sizeX
	profile.sizeY
	profile.data
	profile.OnSelect
]]
function GHM_ImageList(profile, parent, settings)
    local loc = GHI_Loc()
	local frame = CreateFrame("Frame", "GHM_ImageList" .. count, parent, "GHM_ImageList_Template")
	local area = _G[frame:GetName().."Area"]
	local label = _G[frame:GetName() .. "Label"]
	local list = _G[area:GetName().."Scroll"]
	local child = _G[list:GetName().."Child"]
	
	count = count + 1
	
	local selectedIndex, selectedPath, selectedX, selectedY;
	
	local scaleX = 1
	local scaleY = 1
	local sizeX = 72
	local sizeY = 72
	local selected = 0
	
	if type(profile.text) == "string" then
		label:SetText(profile.text);
	end
	
	if profile.scaleX then
		scaleX = profile.scaleX
		if not profile.scaleY then
			scaleY = profile.scaleX
		end
	end	
	if profile.scaleY then
		scaleY = profile.scaleY
		if not profile.scaleX then
			scaleX = profile.scaleY
		end
	end	
	if profile.sizeX then
		sizeX = profile.sizeX
		if not profile.sizeY then
			sizeY = profile.sizeX
		end
	end	
	if profile.sizeY then
		sizeY = profile.sizeY
		if not profile.sizeX then
			sizeX = profile.sizeY
		end
	end

	if profile.OnSelect then
		frame.OnSelect = profile.OnSelect
	elseif profile.onSelect then
		frame.OnSelect = profile.onSelect
	end
	-- positioning
	if profile.width then
		frame:SetWidth(profile.width)
	end
	if profile.height then
		frame:SetHeight(profile.height)
	end

	-- functions
	frame.images = {};
	frame.numFramesCreated = 0;
	frame.SetImages = function(imgList)

		local prevImgF
		frame.images = imgList;


		local width = floor(child:GetWidth())
		local buttonWidth = (sizeX * scaleX)
		local numPrLine = math.max(floor(width / buttonWidth), 1);

		local numLines = ceil(#(imgList)/numPrLine)
		
		child:SetWidth(list:GetWidth());
		child:SetHeight((numLines*(sizeY)));

		for i=1,#(imgList) do
			local imgF;
			local x,y,p = imgList[i].x or 256, imgList[i].y or 256, imgList[i].p or ""
			
			if i <= frame.numFramesCreated then
				imgF =_G[frame:GetName().."Img"..i]
			else
				imgF = CreateFrame("CheckButton",frame:GetName().."Img"..i,child,"GHM_ImageButton_Template")
				imgF.i = i
				imgF.f = frame
				frame.numFramesCreated = i;
			end

			imgF:SetChecked(false);
			
			imgF:SetScript("OnClick", function(self)
				if not(self:GetChecked()) then
					self.f.Clear()
				else
					self.f.Force(self.i);
					if self.f.OnSelect then
						self.f:OnSelect(self, selectedPath, selectedIndex, selectedX, selectedY);
					end
				end
			end)

			imgF:SetScript("OnEnter",function(self)
				imgF.inside = true;
			end);

			imgF:SetScript("OnLeave",function(self)
				imgF.inside = false;
			end);

			imgF:SetScript("OnUpdate",function(self)
				if imgF.inside and IsShiftKeyDown() then
					GameTooltip:ClearLines();
					GameTooltip:SetOwner(imgF, "ANCHOR_BOTTOMLEFT", 0, 0);
					GameTooltip:SetText("Path: "..p, 1, 0.8196079, 0);
					GameTooltip:Show();
				elseif GameTooltip:GetOwner() == imgF then
					GameTooltip:Hide();
				end
			end);

			local icon = _G[imgF:GetName().."IconTexture"];
			local altText = _G[imgF:GetName().."AltText"];
			local unavailable
			
			icon:SetTexture("");
			icon:SetTexture(p);
			imgF.path = p;
			
			unavailable = not(icon:GetTexture())

			--local scale = max(x,y)/128;

			imgF:SetWidth(sizeX * scaleX);
			imgF:SetHeight(sizeY * scaleY);

			imgF:ClearAllPoints()
			
			if i == 1 then
				imgF:SetPoint("TOPLEFT",child, "TOPLEFT", 0, 0);
				
			elseif mod(i,numPrLine) == 1 then
				imgF:SetPoint("TOP",_G[frame:GetName().."Img"..(i-numPrLine)], "BOTTOM", 0, 0);
				
			else
				imgF:SetPoint("LEFT",_G[frame:GetName().."Img"..(i-1)], "RIGHT", 0, 0);
				
			end
			
			if p == "" then
			
				altText:SetText(loc.NONE);
				
			elseif unavailable then
			
				altText:SetText("Unavailable");
				
			else
			
				altText:SetText("");
				
			end

			imgF:Show();
			
			prevImgF = imgF
			
		end
		
		for i = #(imgList)+1,frame.numFramesCreated do
			local pf = _G[frame:GetName().."Img"..i]
			if pf then pf:Hide() end
		end
		
	end

	local GetData = function()
		if type(profile.dataFunc) == "function" then
			return profile.dataFunc() or {};
		elseif type(profile.data) == "table" then
			return profile.data;
		elseif type(frame.dataFunc) == "function" then
			return frame.dataFunc() or {};
		elseif type(frame.data) == "table" then
			return frame.data;
		end
		return {};
	end
	
	local imageData = GetData()
	
	if profile.data then
		if type(imageData[1]) == "table" then
			frame.SetImages(imageData)
		else
			local data = {}
			local tempData
			for i,v in pairs(imageData) do
				tempData = {}
				tempData.x = 32
				tempData.y = 32
				tempData.p = v
				table.insert(data,tempData)
			end
			imageData = data
			frame.SetImages(imageData)
		end
	end
	
	-- Standard functions
	local Force1 = function(data)
		if type(data) == "string" or type(data)== "number" then
			for i,img in pairs(frame.images) do
				local imgF = _G[frame:GetName().."Img"..i];
				if imgF then
					if type(img)=="table" and (img.p == data or i==data) then
						-- select number x
						imgF:SetChecked(true);
						selectedPath = img.p;
						selectedIndex = i;
						selectedX = img.x
						selectedY = img.y
					else
						-- else hide
						imgF:SetChecked(nil);
					end
				end
			end
		elseif type(data) == "table" then
			list:SetVerticalScroll(0)
			imageData = {}
			if type(data[1]) == "table" then
				imageData = data
				frame.SetImages(imageData)
			else
				local tempData = {}
				for i,v in pairs(data) do
					tempData = {}
					tempData.x = 32
					tempData.y = 32
					tempData.p = v
					table.insert(imageData,tempData)
				end
				frame.SetImages(imageData)
			end
		end	
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then -- Handles input to var/Att frame
            varAttFrame:SetValue(inputType, inputValue);

        else -- static
            varAttFrame:Clear();
            Force1(inputValue);
        end
	end

	frame.Force = function(self, ...)
		if self ~= frame then return frame.Force(frame, self, ...); end
		local numInput = #({ ... });

		if numInput == 1 then
			Force1(...);
		elseif numInput == 2 then
			Force2(...);
		end
	end

	frame.Clear = function(self)
		frame.selected = 0;
		for i=1,frame.numFramesCreated do
			_G[frame:GetName().."Img"..i]:SetChecked(nil);
		end
		list:SetVerticalScroll(0)
	end

	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, area, frame:GetWidth());
			frame:SetHeight(frame:GetHeight());
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			return selectedPath, selectedIndex, selectedX, selectedY
		end
	end

	frame.GetPreferredDimensions = function()
		return profile.width, profile.height;
	end

	frame.SetPosition = function(xOff, yOff, width, height)
		frame:SetWidth(width);
		frame:SetHeight(height);
		frame:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, -yOff);
		frame.SetImages(frame.images);
	end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end
	frame:Show();

	return frame;
end