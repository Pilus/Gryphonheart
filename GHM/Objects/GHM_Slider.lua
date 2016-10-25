--
--
--                GHM_Slider
--              GHM_Slider.lua
--
--              GHM_Slider object for GHM
--
--       (c)2013 The Gryphonheart Team
--            All rights reserved
--

local count = 1;

function GHM_Slider(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_Slider" .. count, parent, "GHM_Slider_Template");
	count = count + 1;

	-- declaration and initialization
	profile = profile or {};
	local label = profile.label;

	local miscAPI = GHI_MiscAPI().GetAPI();
	local loc = GHI_Loc();

	-- setup
	local labelFrame = _G[frame:GetName() .. "TextLabel"];
	local slider = _G[frame:GetName() .. "Slider"];
	local valueLabel = _G[slider:GetName() .. "ValueLabel"];
	local sliderValues;

	if profile.isStackSlider then
		labelFrame:SetText("Stack size:")
		sliderValues = profile.values or {1,5,10,20,50,100}
	elseif profile.isSlotSlider then
		local text = profile.text or "Slots:"
		labelFrame:SetText(text)
		sliderValues = {1,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36}
	elseif profile.isTimeSlider then
		sliderValues = profile.values or {1,5,10,15,30,60,120,60*5,60*10,60*15,60*30,60*60,60*60*2,60*60*5,60*60*10,60*60*20,60*60*24}
		local text = profile.text or profile.label or ""
		labelFrame:SetText(text);
	else
		local text = profile.text or profile.label or ""
		labelFrame:SetText(text);
		sliderValues = profile.values or {1,2,3}
	end

	slider:SetValueStep(1)
	slider:SetMinMaxValues(1,#sliderValues)

	local width = profile.width or frame:GetWidth();
	frame:SetWidth(width);

	local OnValueChanged = function(self,value)
		local val = sliderValues[math.floor(self:GetValue())];

		if profile.isTimeSlider then
			valueLabel:SetText(SecondsToTime(val));
		elseif profile.isSlotSlider then
			valueLabel:SetText(val..loc.SLOTS)
		else
			valueLabel:SetText(val);
		end

		if profile.OnValueChanged then
			profile.OnValueChanged(self,val)
		end
	end
	slider:SetScript("OnValueChanged",OnValueChanged)

	-- functions
	local varAttFrame;

	local Force1 = function(data)
		if type(data) == "number" and sliderValues then
			for i=1,#(sliderValues) do
				if sliderValues[i] == data then
					slider:SetValue(tonumber(i));
					break;
				end
			end
		end
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then
			slider:SetValue(1);
			varAttFrame:SetValue(inputType, inputValue);
		else -- static
			varAttFrame:Clear();
			slider:SetValue(inputValue);
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
		slider:SetValue(1);
		OnValueChanged(slider,1)
	end


	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
	if not (varAttFrame) then
		varAttFrame = GHM_VarAttInput(frame, slider, slider:GetWidth());
		frame:SetHeight(frame:GetHeight() + 15);
	end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			local sliderIndex = slider:GetValue();
			local value = sliderValues[sliderIndex]
			return value
		end
	end

	frame.Disable = function()
	slider:Disable();
	valueLabel:SetTextColor(0.5,0.5,0.5);
	labelFrame:SetTextColor(0.5,0.5,0.5);
	end

	local originalColor = {valueLabel:GetTextColor()};
		frame.Enable = function()
		slider:Enable();
		valueLabel:SetTextColor(unpack(originalColor));
		labelFrame:SetTextColor(unpack(originalColor));
	end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame.Clear();
	frame:Show();
	--GHM_TempBG(frame)
	return frame;
end
