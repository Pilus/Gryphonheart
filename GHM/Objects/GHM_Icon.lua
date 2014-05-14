--===================================================
--
--				GHM_Icon
--  			GHM_Icon.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
 --[[local loc;
local frame  = CreateFrame("Frame");
frame:RegisterEvent("VARIABLES_LOADED");
frame:SetScript("OnEvent",function()
     loc = GHI_Loc();
end)
]]--

local count = 1;

function GHM_Icon(parent, main, profile)
     local loc = GHI_Loc();
	local frame = CreateFrame("Frame", "GHM_Icon" .. count, parent, "GHM_Icon_Template");
	local button = _G[frame:GetName().."Button"];
	count = count + 1;

	profile = profile or {};
	button.main = main;
	button.iconFrameParent = profile.iconFrameParent;
	if profile.framealign then
		button.framealign = profile.framealign;
	else
		button.framealign = "c";
	end

	local label = _G[frame:GetName() .. "TextLabel"];
	label:ClearAllPoints();
	label:SetPoint("TOPLEFT")
	--label:SetWidth(1);
	
	if type(profile.text) == "string" then
		label:SetText(profile.text);
	else
		label:SetText(loc.ICON_TEXT)
	end

	local w = label:GetWidth();
	_G[frame:GetName().."Text"]:SetWidth(w+3);

	frame:SetWidth(37);
	frame:SetHeight(37);
	frame.OnChanged = profile.OnChanged;

	-- positioning
	GHM_FramePositioning(frame,profile,parent);
	
	-- functions
	local varAttFrame;
	local defaultIcon = "Interface\\Icons\\INV_Misc_QuestionMark";
	local iconPath = defaultIcon;
	SetItemButtonTexture(button, iconPath);
	
		
	button:SetScript("OnClick", function()
		if not(iconPath == defaultIcon) then
			GHM_IconPickerList().Edit(iconPath, function(selectedIcon)
				iconPath = selectedIcon
				SetItemButtonTexture(button,iconPath)
				if frame.OnChanged then
					frame.OnChanged(iconPath);
				end
			end)
		else
			GHM_IconPickerList().New(function(selectedIcon)
				iconPath = selectedIcon
				SetItemButtonTexture(button,iconPath)
				if frame.OnChanged then
					frame.OnChanged(iconPath);
				end
			end)
		end
	end)

	local Force1 = function(data)
		if type(data) == "string" or type(data) == "number" then
			iconPath = data;
			SetItemButtonTexture(button,iconPath);
		end
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then
			--editBox:SetText("");
			varAttFrame:SetValue(inputType, inputValue);

		else -- static
			varAttFrame:Clear();
			iconPath = inputValue;
			SetItemButtonTexture(button,iconPath);
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
		local iconPath = "Interface\\Icons\\INV_Misc_QuestionMark";
		SetItemButtonTexture(button, iconPath);
	end


	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		frame:SetWidth(120);
		frame:SetHeight(37);
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, button, frame:GetWidth());
			frame:SetHeight(frame:GetHeight());
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			return iconPath;
		end
     end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end
	frame:Show();

	return frame;
end