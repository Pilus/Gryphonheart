--===================================================
--
--				GHM_TextField
--  			GHM_EditField.lua
--
--	          Text field object for large amounts of text
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local count = 1;
function GHM_EditField(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_EditField" .. count, parent, "GHM_EditField_Template");
	count = count + 1;

	local textFrame = _G[frame:GetName().."Text"];
	local label = _G[frame:GetName().."TextLabel"];
	if (profile.text) then
		label:SetText(profile.text or "");
		textFrame:Show();
	else
		textFrame:Hide();
	end

	local areaFrame = _G[frame:GetName().."Area"];
	local fieldFrame = _G[frame:GetName().."AreaScrollText"];

	if profile.height then
		frame:SetHeight(profile.height);
	end

	local OrigSetWidth = frame.SetWidth;
	frame.SetWidth = function(self, width)
		OrigSetWidth(self, width);
		fieldFrame:SetWidth(width-33);
	end

	if profile.width then
		frame:SetWidth(profile.width);
	end

	-- functions
	local varAttFrame;

	local Force1 = function(data)
		fieldFrame:SetText(data);
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
		fieldFrame:SetText("");
	end


	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, areaFrame, frame:GetWidth());
			frame:SetHeight(frame:GetHeight());
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			return fieldFrame:GetText();
		end
	end

	frame.GetFieldFrame = function()
		return fieldFrame
	end

	local GetLabelHeight = function()
		if textFrame:IsShown() then
			return textFrame:GetHeight();
		end
		return 0;
	end

	frame.GetPreferredDimensions = function()
		local h = profile.height;
		if h then
			h = h + GetLabelHeight();
		end
		return profile.width, h;
	end

	frame.SetPosition = function(xOff, yOff, width, height)
		frame:SetWidth(width);
		frame:SetHeight(height - GetLabelHeight());
		frame:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, - (yOff + GetLabelHeight()));
		--GHM_TempBG(obj);
	end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame.Clear();
	frame:Show();

	return frame;
end

