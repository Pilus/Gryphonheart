--===================================================
--
--				GHM_Color
--  			GHM_Color.lua
--
--	          GHM_Color object for GHM
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local DEFAULT_WIDTH = 160;
local DEFAULT_HEIGHT = 180;
local count = 1;

function GHM_Color2(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_Color2" .. count, parent, "GHM_Color2_Template");
	count = count + 1;

	local miscAPI = GHI_MiscAPI().GetAPI();
    local loc = GHI_Loc();

	-- declaration and initialization
	profile = profile or {};
	local label = profile.label;

	-- setup
	local area = _G[frame:GetName().."Area"];
	local labelText = _G[frame:GetName() .. "TextLabel"];
	local boxR = _G[area:GetName().."R".."Box"]
	local boxG = _G[area:GetName().."G".."Box"]
	local boxB = _G[area:GetName().."B".."Box"]
	local boxA = _G[area:GetName().."A".."Box"]
	local colorPick = _G[area:GetName().."ColorPicker"]
	local colorSwatch = _G[colorPick:GetName().."ColorSwatch"]
	local alphaSlider = _G[area:GetName().."OpacitySlider"]
	local menuFrame
	
	labelText:SetText(profile.text or "");
	-- positioning
	if profile.scale then
		frame:SetScale(profile.scale,profile.scale)
	end
		
	function round(num, idp)
		local mult = 10^(idp or 0)
		return math.floor(num * mult + 0.5) / mult
	end
	
	colorPick:SetScript("OnLoad", function(self)
		self:SetColorRGB(1,1,1)
	end)
	
	colorPick:SetScript("OnColorSelect", function(self,r,g,b)
		colorSwatch:SetTexture(r, g, b);	
		boxR:SetText(math.floor(r * 255))
		boxG:SetText(math.floor(g * 255))
		boxB:SetText(math.floor(b * 255))
		if profile.onColorSelect and type(profile.onColorSelect) == "function" then
			profile.onColorSelect()
		end
	end)
	
	alphaSlider:SetScript("OnValueChanged", function(self, value)
		boxA:SetText(tonumber(strsub(value,1,4)) * 100)
		colorSwatch:SetAlpha(value)
		if profile.onColorSelect and type(profile.onColorSelect) == "function" then
			profile.onColorSelect()
		end
	end)
	
	local function colorSet()
		local r = boxR:GetText()
		local g = boxG:GetText()
		local b = boxB:GetText()		
		colorPick:SetColorRGB((r / 255), (g / 255),(b / 255))
	end
	
	boxR:SetScript("OnTextChanged", function(self, userInput)
		if userInput == true then
			colorSet()
		end
	end)
	
	boxG:SetScript("OnTextChanged", function(self, userInput)
		if userInput == true then
			colorSet()
		end
	end)
	
	boxB:SetScript("OnTextChanged", function(self, userInput)
		if userInput == true then
			colorSet()
		end
	end)
	
	boxA:SetScript("OnTextChanged", function(self, userInput)
		if userInput == true then
			alphaSlider:SetValue((tonumber(self:GetText()) / 100))
		end
	end)

	GHM_FramePositioning(frame,profile,parent)
	
	-- functions
	local varAttFrame;

	local Force1 = function(data)
		if type(data) == "table" then
			colorPick:SetColorRGB(data.r or data[1], data.g or data[2], data.b or data[3])
			alphaSlider:SetValue(data.a or data[4] or 1)
		end
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then
			varAttFrame:SetValue(inputType, inputValue);
		else -- static
			varAttFrame:Clear();
			Force1(inputValue)
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
		colorPick:SetColorRGB(1, 1, 1)
		alphaSlider:SetValue(100)
	end

	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, area, area:GetWidth(),0);
			frame:SetHeight(area:GetHeight() + 15);
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			if profile.returnIndexTable == true then
				local r1,g1,b1 = colorPick:GetColorRGB()
				local a1 = alphaSlider:GetValue()
				local rgb = {}
				table.insert(rgb,round(r1,3))
				table.insert(rgb,round(g1,3))
				table.insert(rgb,round(b1,3))	
				table.insert(rgb,round(a1,3))
				return rgb
			else
				local r1,g1,b1 = colorPick:GetColorRGB()
				local a1 = alphaSlider:GetValue()
				local rgb = {
					["r"] = round(r1,3),
					["g"] = round(g1,3),
					["b"] = round(b1,3),
					["a"] = round(a1,3),
					["name"] = "None",
				}			
				return rgb
			end
		end
	end
	
	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame:Show();
	
	return frame;
end

