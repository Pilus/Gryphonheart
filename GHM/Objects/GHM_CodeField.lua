--===================================================
--
--				GHM_CodeField
--  			GHM_CodeField.lua
--
--	          Text field object for large amounts of text
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local DEFAULT_WIDTH = 170;
local DEFAULT_HEIGHT = 80;
local codeFields = {};

local count = 1;
function GHM_CodeField(parent, main, profile)
	local frame = CreateFrame("Frame", "GHM_CodeField" .. count, parent, "GHM_CodeField_Template");
	count = count + 1;

	local label = _G[frame:GetName().."TextLabel"];
	label:SetText(profile.text or "");
	local areaFrame = _G[frame:GetName().."Area"];
	local fieldFrame = _G[frame:GetName().."AreaScrollText"];
	local area = _G[frame:GetName().."Area"];
	frame.field = fieldFrame;
	GHM_FramePositioning(frame,profile,parent);
	if profile.height then
		frame:SetHeight(profile.height);
	end
	if profile.width then
		frame:SetWidth(profile.width);
	end

	fieldFrame:SetWidth(frame:GetWidth()-33);

	-- toolbar buttons
	local toolbar = GHM_Toolbar(area,fieldFrame);
	toolbar:SetPoint("TOPLEFT",3,-3);
	if profile.toolbarButtons then
		for _,toolbarButton in pairs(profile.toolbarButtons) do
			toolbar.AddButton(toolbarButton.texture,toolbarButton.func,toolbarButton.tooltip);
		end
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

	frame.Insert = function(t)
		fieldFrame:Insert(t)
	end



	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame.Clear();
	frame:Show();

	return frame;
end


local updateColors = false;
function GHM_CodeField_UpdateColors()
    updateColors = true;
end
local f = CreateFrame("Frame");
f:SetScript("OnUpdate", function(...)
    if updateColors == true then
        updateColors = false;
        for _, frame in pairs(codeFields) do
            frame:GetScript("OnTextChanged")(frame);
        end
    end
end);