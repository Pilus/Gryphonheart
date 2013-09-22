--===================================================
--
--		GHM Variables and attribute input
--  			GHM_VarAttInput.lua
--
--	     Variable and attribute tabs and input
--               for all ghm frames
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;

function GHM_VarAttInput(parent, anchor, width, yOff)
	local frame = CreateFrame("Frame", "GHM_VarAttInput" .. count, parent);
	count = count + 1;
     local loc = GHI_Loc()
	local variableEditBox;
	local attributeDropDown;

	local tabNormal, tabVariable, tabAttribute;
	local ToggleInputType;

	frame:SetWidth(130);
	frame:SetHeight(15);
	frame:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 3, yOff or 0)

	local CreateTabFrame = function(name)
		local tab = CreateFrame("Button", name, frame, "GHM_TabTemplate");
		tab:SetScript("OnClick", ToggleInputType)
		tab.Select = function(self, selected)
			if (selected) then
				self.leftSelectedTexture:Show();
				self.middleSelectedTexture:Show();
				self.rightSelectedTexture:Show();
			else
				self.leftSelectedTexture:Hide();
				self.middleSelectedTexture:Hide();
				self.rightSelectedTexture:Hide();
			end
		end
		tab:Select(false);
		local tooltip;
		tab:SetScript("OnEnter", function(self)
			if tooltip then
				GameTooltip:SetOwner(self, "ANCHOR_LEFT");
				GameTooltip:ClearLines()
				GameTooltip:AddLine(tooltip, 1.0, 1.0, 1.0);
				GameTooltip:Show();
			end
		end);
		tab:SetScript("OnLeave", function(self) GameTooltip:Hide(); end)
		tab.SetTooltip = function(self, _tooltip) tooltip = _tooltip; end

		return tab;
	end

	local hideStatic = false;
	local gotVariable = false;
	local gotAttribute = false;
	local currentToggledInputType;
	local attributeItem;

	local toggleInputTypeScript;
	frame.SetToggleInputTypeScript = function(f)  toggleInputTypeScript = f; end

	ToggleInputType = function(tab)
		if currentToggledInputType == tab then
			return;
		end
		if currentToggledInputType then
			currentToggledInputType:Select(false);
		end
		tab:Select(true);


		if tab == tabNormal then
			anchor:Show();
		else
			anchor:Hide();
		end

		local tabName = "static";
		if tab == tabVariable then
			variableEditBox:Show();
			tabName = "var";
		else
			variableEditBox:Hide();
		end --]]

		if tab == tabAttribute then
			attributeDropDown:Show();
			tabName = "att";
		elseif attributeDropDown then
			attributeDropDown:Hide();
		end

		currentToggledInputType = tab;
		if toggleInputTypeScript then
			toggleInputTypeScript(tabName);
		end
	end



	local UpdateNormalTab = function()
		if (gotVariable == true or gotAttribute == true) and hideStatic == false then
			if not (tabNormal) then
				tabNormal = CreateTabFrame("$parentNormalTab");
				tabNormal:SetPoint("LEFT", frame, "LEFT", 0, 0);
				tabNormal:SetText(loc.TAB_STAT);
				tabNormal:SetTooltip(loc.STATIC_TIP)
			end

			tabNormal:Show();
		else
			if (tabNormal) then
				tabNormal:Hide();
			end
		end
	end

	local UpdateVariableEditBox = function()
		if variableEditBox then
			return
		end

		variableEditBox = CreateFrame("EditBox", "$parentVariableEditBox", frame, "GHM_EditBox_Box_Template")
		variableEditBox:SetWidth(width);
		variableEditBox:SetTextureTheme("Tooltip")
		variableEditBox:ClearAllPoints();
		variableEditBox:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", 0, yOff or 0);
		variableEditBox.variablesOnly = true;
		variableEditBox:Hide();
	end


	local UpdateVariableTab = function()
		if gotVariable == true then
			if not (tabVariable) then
				tabVariable = CreateTabFrame("$parentVariableTab");
				UpdateVariableEditBox()
				if hideStatic == false then
					tabVariable:SetPoint("LEFT", tabNormal, "RIGHT", 2, 0);
				else
					tabVariable:SetPoint("LEFT", frame, "LEFT", 0, 0);
				end
				tabVariable:SetText(loc.TAB_VAR);
				tabVariable:SetTooltip(loc.VAR_TIP)
			end
			tabVariable:Show();
		else
			if (tabVariable) then
				tabVariable:Hide();
			end
		end
	end



	local UpdateAttributeDropdown = function()
		if attributeDropDown then
			return;
		end

		attributeDropDown = CreateFrame("Frame", "$parentAttributeDropdown", frame, "GHM_DD_Template");

		attributeDropDown:SetWidth(width);

		attributeDropDown:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", 0, (yOff or 0)-6);
		attributeDropDown:Hide();

		attributeDropDown.SelectAttribute = function(self, attribute)
			if attribute then
				_G[(attributeDropDown):GetName() .. "TextLabel"]:SetText(attribute.GetName());
				attributeDropDown.selectedAttribute = attribute;
			else
				_G[(attributeDropDown):GetName() .. "TextLabel"]:SetText("");
				attributeDropDown.selectedAttribute = nil;
			end
		end

		local attributeMenu;

		UIDropDownMenu_Initialize(attributeDropDown, function(self)
			if attributeItem then
				attributeDropDown.GetAttribute = attributeItem.GetAttribute;
				local info;
				local t = attributeItem.GetAllAttributes();
				if type(t) == "table" then
					-- todo: only display the attributes that fits the dynamic action
					for i, attribute in pairs(t) do
						info = {};
						info.text = attribute.GetName();
						info.value = attribute;
						info.owner = self;
						info.notCheckable = true;
						info.func = function(self)
							attributeDropDown:SelectAttribute(self.value);
						end;
						UIDropDownMenu_AddButton(info);
					end
				end
				info = {};
				info.text = loc.ADD_NEW_ATT;
				info.value = "new";
				info.owner = self;
				info.notCheckable = true;
				info.func = function(self)
					if not(attributeMenu) then
						attributeMenu = GHI_AttributeMenu()
					end
					attributeMenu.New(attributeItem, function(attribute)
						_G[(self.owner):GetName() .. "TextLabel"]:SetText(attribute.GetName());
						self.owner.selectedAttribute = attribute;
					end);
				end;
				UIDropDownMenu_AddButton(info);
			end
		end);
	end

	local UpdateAttributeTab = function()
		if gotAttribute == true then
			if not (tabAttribute) then
				tabAttribute = CreateTabFrame("$parentAttributeTab");
				UpdateAttributeDropdown();
				tabAttribute:SetText(loc.TAB_ATT);
				tabAttribute:SetTooltip(loc.ATT_TIP)
			end
			tabAttribute:SetPoint("LEFT", tabVariable or tabNormal, "RIGHT", 2, 0);
			tabAttribute:Show();
		else
			if (tabAttribute) then
				tabAttribute:Hide();
			end
		end
	end




	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item, _hideStatic)
		hideStatic = _hideStatic or false;
		gotVariable = true;
		gotAttribute = true;
		attributeItem = item;
		UpdateNormalTab();
		UpdateVariableTab();
		UpdateAttributeTab();

		if hideStatic == false then
			ToggleInputType(tabNormal);
		else
			ToggleInputType(tabVariable);
		end
	end

	frame.IsStaticTabShown = function(self)
		return (currentToggledInputType == tabNormal);
	end

	frame.GetValue = function(self)
		if currentToggledInputType == tabVariable then
			return {
				type = "variable",
				value = variableEditBox:GetText(),
			};
		elseif currentToggledInputType == tabAttribute and attributeDropDown.selectedAttribute then
			return {
				type = "attribute",
				value = attributeDropDown.selectedAttribute.GetName(),
			};
		end
	end

	frame.Clear = function(self)
		attributeDropDown:SelectAttribute(nil);
		variableEditBox:SetText("");
	end

	frame.SetValue = function(self, valueType, value)
		self:Clear();
		if valueType == "variable" then
			variableEditBox:SetText(value);
			ToggleInputType(tabVariable);
		elseif valueType == "attribute" then
			local att = attributeDropDown.GetAttribute(value);
			attributeDropDown:SelectAttribute(att);
			ToggleInputType(tabAttribute);
		end
	end

	return frame;
end


local count = 1;

function GHM_OutputBox(parent, main, profile)
	local frame = CreateFrame("Frame", "GHM_OutputBox" .. count, parent);
	count = count + 1;
	frame:SetWidth(100);
	frame:SetHeight(30);

	local text = CreateFrame("Frame", "$parentText", frame, "GHM_TextLabel_Template");
	text.label:SetText(profile.text or "");

	local varAttFrame;

	GHM_FramePositioning(frame,profile,parent);

	frame.Force = function(self, data)
	--error("Not implemented")
	end

	frame.Clear = function(self)
		error("Not implemented")
	end

	frame.GetValue = function(self)
		if varAttFrame then
			return varAttFrame:GetValue();
		end
	end

	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, frame, 100);
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, true)
	end

	GHM_TempBG(frame);
	frame:Show();


	return frame;
end
