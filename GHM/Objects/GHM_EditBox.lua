--===================================================
--
--				GHM_Editbox
--  			GHM_EditBox.lua
--
--	          EditBox object for GHM
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local DEFAULT_WIDTH = 200;
local DEFUALT_HEIGHT = 40;

local count = 1;

function GHM_Editbox(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_EditBox" .. count, parent, "GHM_EditBox_Template");
	count = count + 1;

	-- declaration and initialization
	profile = profile or {};
	local label = profile.label;

	-- setup
	local labelFrame = _G[frame:GetName() .. "TextLabel"];
	local editBox = _G[frame:GetName() .. "Box"];



	labelFrame:SetText(profile.text or "");
	_G[frame:GetName() .. "Text"].tooltip = profile.tooltip;

	local width = profile.width or DEFAULT_WIDTH;
	frame:SetWidth(width);
	editBox:SetWidth(width);
	_G[editBox:GetName() .. "Left"]:SetWidth(width - 10);

	editBox.numbersOnly = profile.numbersOnly;
	editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus(); end)
	--editBox:SetScript("OnClick",function(self) self:SetFocus(); end)
	local OnEditBoxTextChanged = function(self)
		local text = self:GetText();
		local text2 = gsub(text, "||", "|");
		if text2 ~= text then
			self:SetText(text2);
			return
		end

		if editBox.numbersOnly then
			if text ~= self.oldText and text ~= "-" and not(string.startsWith(text,"\.") or string.endsWith(text,"\.")) then
				local numberText = tonumber(text);
				if numberText ~= text then
					self:SetText(numberText or "");
					return
				end
			end
		end --]]

		self.oldText = text;
		if type(profile.OnTextChanged) == "function" then
			profile.OnTextChanged(self);
		end
	end
	editBox:SetScript("OnTextChanged", OnEditBoxTextChanged)

	if type(profile.size) == "number" then -- 1 to 256
		editBox:SetMaxLetters(profile.size);
	end
	if profile.OnEnterPressed then
		editBox:SetScript("OnEnterPressed", function(self)
			profile.OnEnterPressed(self)
		end)
	end


	if not (settings.lastestEditbox == nil) then
		settings.lastestEditbox.next = editBox;
		settings.lastestEditbox:SetScript("OnTabPressed", function(self) self:ClearFocus(); self.next:SetFocus(); end);
	end
	settings.lastestEditbox = editBox;

	if type(profile.startText) == "string" then
		editBox:SetText(profile.startText)
	else
		editBox:SetText("");
	end


	local t = "";
	editBox:SetScript("OnChar", function(self, arg1)
	end);

	editBox:SetTextureTheme(profile.texture)

	-- positioning
	local extraX = profile.xOff or 0;
	local extraY = profile.yOff or 0;

	if profile.align == "c" then
		frame:SetPoint("CENTER", parent, "CENTER", extraX, extraY);
	elseif profile.align == "r" then
		frame:SetPoint("RIGHT", parent.lastRight or parent, "RIGHT", extraX, extraY);
		parent.lastRight = frame;
	else
		if parent.lastLeft then frame:SetPoint("LEFT", parent.lastLeft, "RIGHT", extraX, extraY); else frame:SetPoint("LEFT", parent, "LEFT", extraX, extraY); end
		parent.lastLeft = frame;
	end



	-- functions
	local varAttFrame;

	local Force1 = function(data)
		if type(data) == "string" or type(data) == "number" then
			editBox:SetText(data);
		end
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then
			editBox:SetText("");
			varAttFrame:SetValue(inputType, inputValue);

		else -- static
			varAttFrame:Clear();
			editBox:SetText(inputValue);
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
		editBox:SetText("");
	end


	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, editBox, editBox:GetWidth());
			frame:SetHeight(DEFUALT_HEIGHT + 15);
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			if editBox.numbersOnly then
				return tonumber(editBox:GetText()) or 0;
			else
				return editBox:GetText();
			end
		end
	end



	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end


	frame:Show();
	--GHM_TempBG(frame);

	return frame;
end

