--===================================================
--
--				GHM_Logo
--  			GHM_Logo.lua
--
--	          GHM_Logo object for GHM
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local DEFAULT_WIDTH = 128;
local DEFAULT_HEIGHT = 128;
local count = 1;

function GHM_Logo(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_Logo" .. count, parent, "GHM_Logo_Template");
	count = count + 1;

	-- declaration and initialization
	local miscAPI = GHI_MiscAPI().GetAPI();
    local loc = GHI_Loc();
	
	profile = profile or {};
	local label = profile.label;

	-- setup
	local labelFrame = _G[frame:GetName() .. "TextLabel"];
	local area = _G[frame:GetName().."Area"];
	local slider = _G[area:GetName() .. "Slider"];
	local editBox = _G[area:GetName() .. "Box"];
	local logo = _G[area:GetName().."Logo"]
	
	_G[frame:GetName() .. "Text"].tooltip = profile.tooltip;
	
	labelFrame:SetText(profile.text or "");
	
	local width = profile.width or frame:GetWidth();
	
	local function ShowLogo(value)
		if value <= 9 then value = "0"..value end
		logo.left:SetTexture("Textures\\GuildEmblems\\Emblem_"..value);
		logo.right:SetTexture("Textures\\GuildEmblems\\Emblem_"..value);
	end
	
	slider:SetScript("OnValueChanged", function(self,value)
        value = math.floor(value);
		ShowLogo(value)
		editBox:SetNumber(value)
		if self.OnValueChanged then
			self.OnValueChanged(self.secs)
		end
	end
	);

	editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus(); end)
	
	editBox:SetScript("OnTextChanged",function(self, user)
		if user == true then
			slider:SetValue(self:GetNumber())
		end

		self.oldText = text;
		if type(profile.OnTextChanged) == "function" then
			profile.OnTextChanged(self, user);
		end
		
	end)

	if type(profile.startValue) == "number" then
		slider:SetValue(profile.startValue)
	else
		slider:SetValue(0)
	end

	editBox:SetTextureTheme("Tooltip")

	-- functions
	
	local varAttFrame;

	local Force1 = function(data)
		if type(data) == "number" then
			slider:SetValue(tonumber(data));
		end
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then
			slider:SetValue(0);
			varAttFrame:SetValue(inputType, inputValue);

		else -- static
			varAttFrame:Clear();
			slider:SetValue(tonumber(inputValue));
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
		slider:SetValue(0);
		editBox:SetNumber(0)
		ShowLogo(0)
	end

	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, area, editBox:GetWidth());
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
            return math.floor(tonumber(slider:GetValue()));
		end
	end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame.Clear()
	frame:Show();
	--GHM_TempBG(frame);

	return frame;
end

