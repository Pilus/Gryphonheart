--
--
--				GHM_Book
--  			GHM_Book.lua
--
--	          GHM_Book object for GHM
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local count = 1;
function GHM_Book(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_Book" .. count, parent, "GHM_Book_Template"); -- Create the frame from the xml template
	count = count + 1; -- Increment the counter to give the next frame of this type a unique name

	-- Initialize variables and reference objects
	-- Example:
	local miscAPI = GHI_MiscAPI().GetAPI();
	local loc = GHI_Loc();

	-- Set the label
	local label = _G[frame:GetName() .. "Label"];
	label:SetText(profile.text or "");


	local area = _G[frame:GetName() .. "Area"]; -- Get the area, in which the elements are placed

	-- Public functions
	local varAttFrame;

	local Force1 = function(data)
	-- Set the value and ui to 'data', evt using help functions
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
			return value; -- Value should be what is currently the value / in the ui. Use evt help functions
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