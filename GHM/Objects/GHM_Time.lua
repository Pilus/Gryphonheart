--===================================================
--
--				GHM_Time
--  			GHM_Time.lua
--
--	          GHM_Time object for GHM
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local DEFAULT_WIDTH = 128;
local DEFAULT_HEIGHT = 40;
local count = 1;

function GHM_Time(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_Time" .. count, parent, "GHM_Time_Template");
	count = count + 1;

	-- declaration and initialization
	local miscAPI = GHI_MiscAPI().GetAPI();
    local loc = GHI_Loc();
	
	profile = profile or {};
	local label = profile.label;

	-- setup
	local labelFrame = _G[frame:GetName() .. "TextLabel"];
	local elements = _G[frame:GetName().."Elements"];
	local slider = _G[elements:GetName() .. "Slider"];
	local valueLabel = _G[slider:GetName() .. "ValueLabel"];
	local editBox = _G[elements:GetName() .. "Box"];
	
	_G[frame:GetName() .. "Text"].tooltip = profile.tooltip;
	
	local SliderValues

	if profile.values then
		SliderValues = profile.values
		slider:SetMinMaxValues(1,#(SliderValues));
	else
		SliderValues = {0,1,5,10,15,30,60,120,60*5,60*10,60*15,60*30,60*60,60*60*2,60*60*5,60*60*10,60*60*20,60*60*24}
		slider:SetMinMaxValues(1,#(SliderValues));
	end

	labelFrame:SetText(profile.text or "");
	
	local width = profile.width or frame:GetWidth();
	frame:SetWidth(width);
	editBox:SetWidth(width);
	_G[editBox:GetName() .. "Left"]:SetWidth(width - 10);

	frame.SetPosition = function(xOff, yOff, width, height)
		frame:SetWidth(width);
		frame:SetHeight(height);
		frame:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, -yOff);
		editBox:SetWidth(width);
		_G[editBox:GetName() .. "Left"]:SetWidth(width - 10);
	end

	slider:SetScript("OnLoad", function(self)
		self:SetValueStep(1)
		local f = self;
		f.Force = function(data)
			if type(data) == "number" and SliderValues then
				for i=1,#(SliderValues) do
					if SliderValues[i] == data then
					f:SetValue(i);
					break;
					end
				end
			end
		end
		f.Clear = function(self)
			f:SetValue(1);
		end
		_G[self:GetName().."ValueLabel"]:SetJustifyH("Right");
	end
	);

	local SliderValueChanged = function(self,value)
		local val = math.floor(self:GetValue()+0.5)
		local secs = SliderValues[val];
		if not(self.main == nil) then
			self.main.SetLabel(self.label,secs);
		end
		if self.OnValueChanged then
			self.OnValueChanged(secs)
		end

		local labelText
		if secs == 0 then
			labelText = "0";
		else
			labelText = SecondsToTime(secs)
		end
		_G[self:GetParent():GetName().."Box"]:SetText(secs);
		_G[self:GetName().."ValueLabel"]:SetText(labelText)

	end

	slider:SetScript("OnValueChanged", SliderValueChanged);
	editBox.numbersOnly = true
	editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus(); end)
	local OnEditBoxTextChanged = function(self)
		local text = self:GetText();
		local text2 = gsub(text, "||", "|");
		if text2 ~= text then
			self:SetText(text2);
			return
		end
		if editBox.numbersOnly then
			if text ~= self.oldText and text ~= "-" and not(string.startsWith(text,"\.") or string.endsWith(text,"\.")) then
				local numberText = tonumber(text);
				if numberText ~= text then
					self:SetText(numberText or "");
					return
				end
			end
		end

		self.oldText = text;
		if type(profile.OnTextChanged) == "function" then
			profile.OnTextChanged(self);
		end
		local editData = tonumber(self:GetText())
		for i,v in pairs(SliderValues) do
			if editData == v then
				slider:SetValue(i);
				break
			else
				slider:SetValue(#(SliderValues))
			end
		end
	end
	
	editBox:SetScript("OnTextChanged", OnEditBoxTextChanged)
	
	if not (settings.lastestEditbox == nil) then
		settings.lastestEditbox.next = editBox;
		settings.lastestEditbox:SetScript("OnTabPressed", function(self) self:ClearFocus(); self.next:SetFocus(); end);
	end
	settings.lastestEditbox = editBox;

	if type(profile.startText) == "string" then
		editBox:SetText(profile.startText)
	else
		editBox:SetText("");
	end

	local t = "";
	editBox:SetScript("OnChar", function(self, arg1)
	end);

	editBox:SetTextureTheme("Tooltip")

	-- functions
	local varAttFrame;

	local Force1 = function(data)
		if type(data) == "string" or type(data) == "number" then
			editBox:SetText(data);
		end
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then
			editBox:SetText("");
			varAttFrame:SetValue(inputType, inputValue);

		else -- static
			varAttFrame:Clear();
			editBox:SetText(inputValue);
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
		editBox:SetText(0);
		slider:SetValue(1);
		SliderValueChanged(slider, 1)
	end

	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, elements, editBox:GetWidth());
			frame:SetHeight(DEFAULT_HEIGHT + 15);
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			return tonumber(editBox:GetText());
		end
	end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame.Clear();
	frame:Show();
	--GHM_TempBG(frame);

	return frame;
end

