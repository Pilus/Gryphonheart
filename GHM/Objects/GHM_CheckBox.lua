local count = 1;
function GHM_CheckBox(parent, main, profile)
    local frame = CreateFrame("Frame", "GHM_CheckBox" .. count, parent, "GHM_CheckBox_Template"); -- Create the frame from the xml template
    count = count + 1; -- Increment the counter to give the next frame of this type a unique name

    -- Initialize variables and reference objects
    -- Example:
    local miscAPI = GHI_MiscAPI().GetAPI();
    local loc = GHI_Loc();

	local area = _G[frame:GetName().."Area"]; -- Get the area, in which the elements are placed

    -- Set the label
    local label = _G[area:GetName().."CheckBoxTextLabel"];
	local label2 = _G[frame:GetName().."AlternativeTextLabel"];
    label:SetText(profile.text or "");
	label2:SetText(profile.text or "");

	local checkBox = _G[area:GetName().."CheckBox"];

	frame.SetOnClick = function(f)
		checkBox:SetScript("OnClick",f);
	end

	if profile.OnClick then
		checkBox:SetScript("OnClick",profile.OnClick);
	end

	frame:SetWidth(math.min(label:GetWidth(),160)+checkBox:GetWidth()+10)
	label:GetParent():SetWidth(frame:GetWidth())
	--GHM_TempBG(label:GetParent());

    GHM_FramePositioning(frame,profile,parent);

    -- Public functions
    local varAttFrame;

    local Force1 = function(data)
        if data == true or data == 1 then
			checkBox:SetChecked(true);
        else
			checkBox:SetChecked(nil);--or it could be frame
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
		checkBox:SetChecked(nil);
    end


    frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
        if not (varAttFrame) then
            varAttFrame = GHM_VarAttInput(frame, area, frame:GetWidth());
            frame:SetHeight(frame:GetHeight());
        end
        varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
		varAttFrame.SetToggleInputTypeScript(function(_type)
			if _type == "static" then
				_G[frame:GetName().."AlternativeText"]:Hide();
			else
				_G[frame:GetName().."AlternativeText"]:Show();
			end
		end);
    end

    frame.GetValue = function(self) -- Get the current value
        if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
            return varAttFrame:GetValue();
        else
            if checkBox:GetChecked() then
				return true;
			else
				return false;
			end
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