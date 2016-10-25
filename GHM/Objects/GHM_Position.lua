--
--
--				GHM_Position
--  			GHM_Position.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local count = 1;
function GHM_Position(profile, parent, settings)
	local loc = GHI_Loc();
	local frame = CreateFrame("Frame", "GHM_Position" .. count, parent, "GHM_Position_Template");
	count = count + 1;
	local area = _G[frame:GetName().."Area"];
	frame.isPosition = true;
	local label = _G[frame:GetName().."Label"];
	label:SetText(profile.text or "");

	local xFrame = _G[area:GetName().."XBox"];
	local yFrame = _G[area:GetName().."YBox"];
	local wFrame = _G[area:GetName().."World"];
	local toCurrentButton = _G[area:GetName().."ToCurrent"];

	_G[toCurrentButton:GetName().."Text"]:SetText(loc.SET_CURRENT)

	local SetPosition = function(data)
		if type(data) == "table" then
			xFrame:SetText(data.x);
			yFrame:SetText(data.y);
			wFrame.Select(data.world);
		end
	end

	toCurrentButton:SetScript("OnClick",function()
		SetPosition(GHI_Position().GetPlayerPos(2));
	end)

	-- functions
	local varAttFrame;

	local Force1 = function(data)
		SetPosition(data);
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
		xFrame:SetText(0.00);
		yFrame:SetText(0.00);
		wFrame.Select(1);
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
			return {
				x = tonumber(xFrame:GetText()),
				y = tonumber(yFrame:GetText()),
				world = wFrame.GetSelected(),
			};
		end
	end



	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame.Clear();
	frame:Show();
	_G[toCurrentButton:GetName().."Text"].SetText = error;
	return frame;
end

