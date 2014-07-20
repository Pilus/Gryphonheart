--===================================================
--
--				GHM_CustomDD
--  			GHM_CustomDD.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;

function GHM_DropDown(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_DropDown" .. count, parent,"GHM_DropDown_Template"); -- Create the frame from the xml template
    count = count + 1; -- Increment the counter to give the next frame of this type a unique name
	
	local dropDownMenu = GHM_DropDownMenu()
	
    -- Initialize variables and reference objects
	local label = _G[frame:GetName().."Label"];
	local area = _G[frame:GetName().."Area"];
	local ddFrame = _G[ area:GetName().."DD"]
	local button = _G[area:GetName().."DDButton"];
	local ddLabel = _G[ area:GetName().."DDTextLabel"];

	local returnIndex = profile.returnIndex;
	local value,index;

	-- Set the label

    label:SetText(profile.text or "");

	local OnSelect = profile.OnSelect;

    -- Help functions and further setup
    -- All help functions and any further setup needed goes here

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

    -- Position the frame

	if profile.width then
		frame:SetWidth(profile.width+6);
	end
	
    GHM_FramePositioning(frame,profile,parent);

	-- Drop down initialize

	local Force1;
	local menuFrame
	local menuData
	local t
		
	if not menuData then
		t = GetData()
		if type(t) == "table" then
			menuData = {}
			local info
			for i, v in pairs(t) do
				info = {}
				local text
				if type(v) == "table" then
					for key,value in pairs(v) do
						info[key] = value
					end
					if not info.value then
						value = i
					end
					text = v.text
					info.notCheckable = true
				else
					info.text = v
					info.value = i 
					info.notCheckable = true;
					text = v
				end
				
				if info.menuList then
					for i2,v2 in pairs(info.menuList) do
						info.menuList[i2].notCheckable = true
						
						if not info.menuList[i2].value then
							info.menuList[i2].value = i2
						end
						
						info.menuList[i2].func = function(self)
							
							if returnIndex == true then
								Force1(i2)
							else
								Force1(v2.text);
							end
							dropDownMenu.CloseDropDownMenus()
						end
						
						if info.menuList[i2].menuList then
							for i3, v3 in pairs(info.menuList[i2].menuList) do
								info.menuList[i2].menuList[i3].func = function(self)
									if returnIndex == true then
										Force1(i3)
									else
										Force1(v3.text);
									end
									dropDownMenu.CloseDropDownMenus()
								end
							end
						end
					end
				else
					info.func = function(self)
						
						if returnIndex == true then
							Force1(i)
						else
							Force1(v.text);
						end
						dropDownMenu.CloseDropDownMenus()
					end
				end
				info.onMouseEnter = profile.onMouseEnter;
				info.onMouseLeave = profile.onMouseLeave;
				table.insert(menuData, info)
			end
		end
	end
	
	menuFrame = CreateFrame("Frame", frame:GetName().."Menu", button, "GHM_DropDownMenuTemplate")
	dropDownMenu.EasyMenu(menuData, menuFrame, ddFrame, 0 , 5,"MENU");
	dropDownMenu.CloseDropDownMenus()
	
	button:SetScript("OnClick", function(self)
		dropDownMenu.ToggleDropDownMenu(nil,nil,menuFrame,ddFrame,0,5,menuData)
	end)
		
    -- Public functions
    local varAttFrame;

    Force1 = function(data)
		-- Set the value and ui to 'data', evt using help functions
		if returnIndex == true then
			index = data
			value = menuData[tonumber(index)].text;
			local currentButton = menuData[tonumber(index)]
			ddLabel:SetText(currentButton.text);
		else
			index = 1;
			for i,v in pairs(menuData) do
				if v.text == data then
					index = i
					break
				end
				if v.menuList then
					for i2, v2 in pairs(v.menuList) do
						if v2.text == data then
							index = i2
							break
						end
					end
				end
			end
			value = data;
			ddLabel:SetText(value);
		end			
		if OnSelect then
			OnSelect(index, value);
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
		value = menuData[1].text;
		index = 1;
		ddLabel:SetText(value);
		if OnSelect then
			OnSelect(index, value);
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
				return index
			end
				return value
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