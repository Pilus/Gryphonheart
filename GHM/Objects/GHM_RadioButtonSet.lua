--===================================================
--
--			GHM_RadioButtonSet
--  		GHM_RadioButtonSet.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;
function GHM_RadioButtonSet(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_RadioButton" .. count, parent, "GHM_RadioButtonSet_Template");
    count = count + 1;
	local loc = GHI_Loc();
	--local miscApi = GHI_MiscAPI().GetAPI();
	--local itemList = GHI_ItemInfoList();

	local returnIndex = profile.returnIndex;
	local selectedIndex = 1;

	local area = _G[frame:GetName().."Area"];

	local label = _G[frame:GetName().."Label"];
	label:SetWidth(frame:GetWidth());
	label:SetText(profile.text or "");

	local GetData = function()
		if type(profile.dataFunc) == "function" then
			return profile.dataFunc() or {};
		elseif type(profile.data) == "table" then
			return profile.data;
		elseif type(frame.dataFunc) == "function" then
			return frame.dataFunc() or {};
		elseif type(frame.data) == "table" then
			return frame.data;
		end
		return {};
	end

	local GetValue = function()
		if returnIndex then
			return selectedIndex;
		else
			local data = GetData();
			if not(data[selectedIndex].value == nil) then
				return data[selectedIndex].value;
			end
			return data[selectedIndex];
		end
	end


	local Select = function(index)
		assert(type(index)=="number")
		selectedIndex = index;
		frame.UpdateButtons();
	end

	local OnSelect;
	if type(profile.OnSelect) == "function" then
		OnSelect = profile.OnSelect;
	end

	frame.UpdateButtons = function()
		local fname = frame:GetName();
		local data = GetData();
		local prevRadio;
		local height = label:GetHeight() + 5;
		for i=1,#(data) do
			local radio = _G[fname .. "Radio"..i];
			if not(radio) then
				radio = CreateFrame("Frame",fname .. "Radio"..i,frame,"GHM_RadioButton_Template");
				radio:SetWidth(frame:GetWidth());
				if prevRadio then
					radio:SetPoint("TOP",prevRadio,"BOTTOM");
				else
					radio:SetPoint("TOPLEFT",frame,"TOPLEFT",5,-height);
				end

				local button = _G[radio:GetName().. "Button"];
				button:SetScript("OnClick",function()
					Select(i);
					if OnSelect then
						OnSelect(GetValue());
					end
				end)
			end

			local label = _G[radio:GetName().. "Label"];
			local button = _G[radio:GetName().. "Button"];

			if type(data[i]) == "table" then
				label:SetText(data[i].text);
			else
				label:SetText(data[i]);
			end

			if i == selectedIndex then
				button:SetChecked(true);
			else
				button:SetChecked(false);
			end

			height = height + radio:GetHeight();

			prevRadio = radio;
		end
		frame:SetHeight(height);
	end

	Select(1);

	-- functions
	local varAttFrame;

	local Force1 = function(data)
		if returnIndex then
			Select(data);
		else
			local options = GetData();
			for i,v in pairs(options) do
				if type(v) == "table" then
					if data == v.value then
						Select(i);
					end
				else
					if data == v then
						Select(i);
					end
				end
			end
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
		Select(1);
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
			return GetValue();
		end
	end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame.Clear();
	frame:Show();

	return frame;
end

