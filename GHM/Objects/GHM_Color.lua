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

local count = 1;

function GHM_Color(parent, main, profile)
	local frame = CreateFrame("Frame", "GHM_Color" .. count, parent, "GHM_Color_Template");
	count = count + 1;

	local miscAPI = GHI_MiscAPI().GetAPI()
	local loc = GHI_Loc();

	-- declaration and initialization
	profile = profile or {};
	local label = profile.label;

	-- setup
	local labelFrame = _G[frame:GetName() .. "TextLabel"];
	local dd = _G[frame:GetName() .. "DD"];



	labelFrame:SetText(profile.text or "");


	-- positioning
	local extraX = profile.xOff or 0;
	local extraY = profile.yOff or 0;

	if profile.align == "c" then
		frame:SetPoint("CENTER", parent, "CENTER", extraX, extraY);
	elseif profile.align == "r" then
		frame:SetPoint("RIGHT", parent.lastRight or parent, "RIGHT", extraX, extraY);
		parent.lastRight = frame;
	else
		if parent.lastLeft then frame:SetPoint("LEFT", parent.lastLeft, "RIGHT", extraX, extraY); else frame:SetPoint("LEFT", parent, "LEFT", extraX, extraY); end
		parent.lastLeft = frame;
	end


	local ColorName = function(name,rgb)
		if not(rgb.r >= 0.8 or rgb.g >= 0.4) then
			return miscAPI.GHI_ColorString(name, rgb.r, rgb.g, rgb.b).." ("..name..")";
		else
			return miscAPI.GHI_ColorString(name, rgb.r, rgb.g, rgb.b);
		end
	end

	local colors = miscAPI.GHI_GetColors();
	local colorData = {};
	for i, info in pairs(colors) do
		table.insert(colorData,{
			locName = ColorName(loc["COLOR_"..string.upper(i)],info),
			rgb =  { r = info.r, g = info.g, b = info.b, name = i },
		});
	end

	local ddLabel = _G[dd:GetName().."TextLabel"];
	local selected;
	local Select = function(color)
		ddLabel:SetText(color.locName);
		selected = color;
	end

	UIDropDownMenu_Initialize(dd, function(self)
		local info;

		if type(colorData) == "table" then
			for i, color in pairs(colorData) do
				info = {};
				info.text = color.locName;
				info.value = i;
				info.owner = self;
				info.notCheckable = true;
				info.func = function(self)
					Select(color);
				end;
				UIDropDownMenu_AddButton(info);
			end
		end
	end);

	-- functions
	local varAttFrame;

	local Force1 = function(data)
		if type(data) == "table" then
			for i, color in pairs(colorData) do
				if color.rgb.text == data.text or (color.rgb.r == data.r and color.rgb.g == data.g and color.rgb.b == data.b) then
					Select(color);
					return
				end
			end
			local color = {
				rgb = data,
				locName = miscAPI.GHI_ColorString(loc.COLOR_CUSTOM, data.r, data.g, data.b),
			};
			table.insert(colorData,color);
			Select(color);
		end
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then
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
		dd:SetText("");
	end


	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, dd, dd:GetWidth(), 6);
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			return selected.rgb;
		end
	end

	Force1(colorData[1].rgb);

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end


	frame:Show();
	--GHM_TempBG(frame);

	return frame;
end

