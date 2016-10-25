--
--
--				GHM_CustomDD
--  			GHM_CustomDD.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local count = 1;
local info; -- Placed here to use less memory for dd initialization
function GHM_CustomDD(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_CustomDD" .. count, parent,"GHM_CustomDD_Template"); -- Create the frame from the xml template
	count = count + 1; -- Increment the counter to give the next frame of this type a unique name

	-- Initialize variables and reference objects
	local label = _G[frame:GetName().."Label"];
	local area = _G[frame:GetName().."Area"];
	local ddFrame = _G[area:GetName().."DD"];
	local ddLabel = _G[ ddFrame:GetName().."TextLabel"];
	ddFrame:SetPoint("TOPLEFT",area,"TOPLEFT",0,0);

	local returnIndex = profile.returnIndex;
	local value,index;

	-- Set the label

	label:SetText(profile.text or "");

	local OnSelect = profile.OnSelect;

	-- Help functions and further setup
	-- All help functions and any further setup needed goes here

	local GetData = function()
		if type(profile.dataFunc) == "function" then
			return GHM_1IndexedTable(profile.dataFunc() or {});
		elseif type(profile.data) == "table" then
			return GHM_1IndexedTable(profile.data);
		elseif type(frame.dataFunc) == "function" then
			return GHM_1IndexedTable(frame.dataFunc() or {});
		elseif type(frame.data) == "table" then
			return GHM_1IndexedTable(frame.data);
		end
		return {};
	end


	-- Position the frame

	if profile.width then
		ddFrame:SetWidth(profile.width);
		frame:SetWidth(profile.width+6);
		_G[ddFrame:GetName() .. "Middle"]:SetWidth(profile.width - 40);
	else
		ddFrame:SetWidth(120);
		frame:SetWidth(120+6);
	end
	frame:SetHeight(ddFrame:GetHeight()+label:GetHeight()+5);

	-- Drop down initialize

	local Force1;

	UIDropDownMenu_Initialize(ddFrame, function(self)
		local t = GetData();
		if type(t) == "table" then
			for i = 1,#t do
				local text;
				if type(t[i]) == "table" then
					text = t[i].text;
				else
					text = t[i];
				end
				info = {};
				info.text = text;
				info.value = i;
				info.owner = self;
				info.notCheckable = true;
				info.func = function(self)
					local text;
					local returnValue;
					if type(t[self.value]) == "table" then
						text = t[self.value].text;
					returnValue = t[self.value].value;
					else
						text = t[self.value];
					end

					if returnIndex == true then
						Force1(i)
					elseif returnValue then
						Force1(returnValue)
					else
						Force1(text);
					end
				end;
				UIDropDownMenu_AddButton(info);
			end
		end
	end);

	-- Public functions
	local varAttFrame;

	Force1 = function(data)
		-- Set the value and ui to 'data', evt using help functions
		if returnIndex then
			index = data;
			value = GetData()[index];
		else
			local t = GetData();
			index = 1;
			for i=1,#(t) do
				if t[i] == data then
					index = i;
					break;
				end
			end
			value = data;
		end
		ddLabel:SetText(value);
		if OnSelect then
			OnSelect(index);
		end
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then -- Handles input to var/Att frame
			varAttFrame:SetValue(inputType, inputValue);

		else -- static
			varAttFrame:Clear();
			Force1(inputValue);
		end
	end

	frame.Force = function(self, ...) -- Calls Force1 or Force2 depending on the number of inputs. Either Force(value) or Force(Type,value)
		if self ~= frame then return frame.Force(frame, self, ...); end
		local numInput = #({ ... });

		if numInput == 1 then
			Force1(...);
		elseif numInput == 2 then
			Force2(...);
		end
	end

	frame.Clear = function(self)
		-- Clear the value / ui to a default state
		local t = GetData();
		value = t[1];
		index = 1;
		ddLabel:SetText(value);
		if OnSelect then
			OnSelect(1);
		end
	end


	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, area, frame:GetWidth());
			frame:SetHeight(frame:GetHeight());
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self) -- Get the current value
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			if returnIndex then
				return index;
			end
			return value;
		end
	end


	-- Trigger evt onLoad function
	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame.Clear();
	frame:Show();
	return frame;
end

