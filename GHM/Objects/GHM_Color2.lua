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

function GHM_Color2(parent, main, profile)
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
	local colorPick = _G[area:GetName().."ColorPicker"]
	local colorSwatch = _G[colorPick:GetName().."ColorSwatch"]
	local dd = _G[area:GetName() .. "DD"];
	local menuFrame
	
	labelText:SetText(profile.text or "");
	-- positioning
	if profile.scale then
	frame:SetScale(profile.scale,profile.scale)
	end
	
	_G[frame:GetName() .. "Text"].tooltip = profile.tooltip;
	
	function round(num, idp)
	  local mult = 10^(idp or 0)
	  return math.floor(num * mult + 0.5) / mult
	end
	
	colorPick:SetScript("OnLoad", function(self)
		self:SetColorRGB(1,1,1)
	end)
		
	colorPick:SetScript("OnColorSelect", function(self,r,g,b)
			colorSwatch:SetTexture(r, g, b);
			if ( self.func ) then
				self.func();
			end
			boxR:SetText(round(r,3))
			boxG:SetText(round(g,3))
			boxB:SetText(round(b,3))
			if profile.onColorSelect and type(profile.onColorSelect) == "function" then
			profile.onColorSelect()
			end
			
	end)
	
	local function colorSet(frame, color)
		
		local wheelColors ={}
		wheelColors.r, wheelColors.g, wheelColors.b = colorPick:GetColorRGB()
		
		local curColor = round(tonumber(frame:GetText()),3)	
		local newColors = {r=0,g=0,b=0}
		
		if color == "r" then
			newColors.r = curColor
			newColors.g = wheelColors.g
			newColors.b = wheelColors.b
		elseif color == "g" then
			newColors.g = curColor
			newColors.r = wheelColors.r
			newColors.b = wheelColors.b
		elseif color == "b" then
			newColors.b = curColor
			newColors.g = wheelColors.g
			newColors.r = wheelColors.r
		end		
		colorPick:SetColorRGB(newColors.r, newColors.g,newColors.b)
	end
	
	boxR:SetScript("OnTextChanged", function(self, userInput)
		if userInput == true then
		colorSet(self,"r")
		end
	end)
	boxG:SetScript("OnTextChanged", function(self, userInput)
		if userInput == true then
		colorSet(self,"g")
		end
	end)
	boxB:SetScript("OnTextChanged", function(self, userInput)
		if userInput == true then
		colorSet(self,"b")
		end
	end)

	GHM_FramePositioning(frame,profile,parent)
	
	local ColorName = function(name,rgb)
		if not(rgb.r >= 0.8 or rgb.g >= 0.4) then
			return miscAPI.GHI_ColorString(name, rgb.r, rgb.g, rgb.b).." ("..name..")";
		else
			return miscAPI.GHI_ColorString(name, rgb.r, rgb.g, rgb.b);
		end
	end

	local colors = miscAPI.GHI_GetColors();
	local colorData = {};
	
	local function rgbPercentToHex(r,g,b)
		r = r <= 1 and r >= 0 and r or 0
		g = g <= 1 and g >= 0 and g or 0
		b = b <= 1 and b >= 0 and b or 0
		return string.format("%02x%02x%02x", r*255, g*255, b*255)
	end
		
	for i, info in pairs(colors) do
		local colorDat = {}
		colorDat.text = loc["COLOR_"..string.upper(i)]
		colorDat.colorCode = "\124cFF"..rgbPercentToHex(info.r,info.g,info.b)
		colorDat.func = function()
			colorPick:SetColorRGB(info.r, info.g, info.b)
		end	
		colorDat.notCheckable = true
		
		table.insert(colorData, colorDat);
	end
	
	local colorlistDD
	local dropDownMenu = GHM_DropDownMenu()	
	
	dd:SetScript("OnClick", function(self)
		if not(colorlistDD) then
			colorlistDD	= CreateFrame("Frame", frame:GetName().."ColorListDD", frame, "GHM_DropDownMenuTemplate")		
			dropDownMenu.EasyMenu(colorData, colorlistDD, self, 0 ,0, "MENU", 1);
		else
			dropDownMenu.ToggleDropDownMenu(nil,nil,colorlistDD,self:GetName(),0,0,colorData,nil,2)
		end
	end)


	-- functions
	local varAttFrame;

	local Force1 = function(data)
		if type(data) == "table" then
			colorPick:SetColorRGB(data.r or data[1], data.g or data[2], data.b or data[3])
		else
			print(tostring(data))
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
	end


	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, area, dd:GetWidth());
			frame:SetHeight(DEFAULT_HEIGHT + 15);
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			if profile.iTable == true then
				local r1,g1,b1 = colorPick:GetColorRGB()
				local rgb = {}
				table.insert(rgb,round(r1,2))
				table.insert(rgb,round(g1,2))
				table.insert(rgb,round(b1,2))		
				return rgb
			else
				local r1,g1,b1 = colorPick:GetColorRGB()
				local rgb = {
				["r"] = round(r1,2),
				["g"] = round(g1,2),
				["b"] = round(b1,2),
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
	--GHM_TempBG(frame);
	
	return frame;
end

