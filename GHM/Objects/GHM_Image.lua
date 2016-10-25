--
--
--				GHM_Image
--  			GHM_Image.lua
--
--	          GHM_Image object for GHM
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local count = 1;

function GHM_Image(profile, parent, settings)
	local loc = GHI_Loc();
	local frame = CreateFrame("Frame", "GHM_Image" .. count, parent, "GHM_Image_Template");
	local area = _G[frame:GetName().."Area"];
	local button = _G[area:GetName().."Button"];
	local buttonImage = _G[area:GetName().."PreviewTexture"]
	count = count + 1;
	local varAttFrame;
	local imagePath, imageX, imageY
	local imageMenuList = GHM_ImagePickerList()

	profile = profile or {};

	local label = _G[frame:GetName() .. "TextLabel"];
	if type(profile.text) == "string" then
		label:SetText(profile.text);
	else
		label:SetText(loc.ATTYPE_IMAGE)
	end
	frame:SetSize(128,160)
	buttonImage:SetTexture("Interface\\Icons\\INV_MISC_FILM_01")
	buttonImage:SetSize(96,96)
	
	button:SetScript("OnClick", function()
		imageMenuList.New(function(selectedImage, selectedX, selectedY)
			imagePath = selectedImage
			imageX = selectedX
			imageY = selectedY
			if selectedX > selectedY then
				local ratio = selectedY / selectedX
				buttonImage:SetSize(96,96*ratio)
			elseif selectedY > selectedX then
				local ratio = selectedX / selectedY
				buttonImage:SetSize(96*ratio,96)
			else
				buttonImage:SetSize(96,96)
			end
			buttonImage:SetTexture(selectedImage)
		end)
	end)

	-- functions
	
	local Force1 = function(data)
		if type(data) == "string" then			
			imagePath = data;
			buttonImage:SetTexture(imagePath)
			buttonImage:SetSize(96,96)
		elseif type(data) == "table" then
			local texture, x, y = unpack(data)
			if type(texture) == "string" then			
				imagePath = data;
				buttonImage:SetTexture(imagePath)
			else
				print("Invalid Texture")
				return
			end
			if type(x) and type(y) == "number" then
				imageX = x
				imageY = y				
				if imageX > imageY then
					local ratio = imageY / imageX
					buttonImage:SetSize(96,96*ratio)
				elseif imageY > imageX then
					local ratio = imageX / imageY
					buttonImage:SetSize(96*ratio,96)
				else
					buttonImage:SetSize(96,96)
				end
			end		
		end
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then
			varAttFrame:SetValue(inputType, inputValue);

		else -- static
			varAttFrame:Clear();
			imagePath = inputValue;
			buttonImage:SetTexture(imagePath)
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
		buttonImage:SetTexture("Interface\\Icons\\INV_MISC_FILM_01")
		imagePath = nil
		imageX = nil
		imageY = nil
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
			return imagePath,imageX,imageY
		end
     end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end
	frame:Show();

	return frame;
end