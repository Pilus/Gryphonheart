--
--
--				GHM_Editbox
--  			GHM_EditBox.lua
--
--	 Multi number edit box object for GHM
--
-- 	  (c)2014 The Gryphonheart Team
--			All rights reserved
--

local DEFAULT_WIDTH_PR_BOX = 25;
local DEFAULT_WIDTH_PR_PR_DIGIT = 7;

local count = 1;
function GHM_MultiNumberEditBox(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_MultiNumberEditBox" .. count, parent);
	count = count + 1;

	assert(type(profile.editboxes)=="table", "profile.editboxes must be a table");

	-- declaration and initialization
	profile = profile or {};
	local label = profile.label;

	-- setup
	frame:SetHeight(38);

	local textLabel = GHM_Text({
		text = profile.text,
		color = "yellow",
		fontSize = 11,
		align = "c",
	}, frame, settings);
	textLabel:ClearAllPoints();
	textLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0);

	local editboxes = {};
	local numEditBoxes = #(profile.editboxes);

	local OnEditBoxTextChanged = function(self)
		local text = self:GetText();
		local text2 = gsub(text, "||", "|");
		if text2 ~= text then
			self:SetText(text2);
			return
		end

		if text ~= self.oldText and text ~= "-" and not(string.startsWith(text,"\.") or string.endsWith(text,"\.")) then
			local numberText = string.sub(tonumber(text) or "", 0, self.digits);
			if numberText ~= text then
				self:SetText(numberText or "");
				return
			end
		end

		self.oldText = text;
		if type(profile.OnTextChanged) == "function" then
			profile.OnTextChanged(self);
		end
	end


	local widthFromBoxes = 0;
	for i = 1, numEditBoxes do
		local info = profile.editboxes[i];

		local box = CreateFrame("EditBox", "$parentBox"..i, frame, "GHM_EditBox_Box_Template");
		box:ClearAllPoints();
		box:SetHeight(26);
		box:SetWidth(DEFAULT_WIDTH_PR_BOX + DEFAULT_WIDTH_PR_PR_DIGIT * info.digits);
		box.label = info.label;
		box.digits = info.digits;

		local text = GHM_Text({
			text = info.text,
			color = "white",
			fontSize = 11,
			align = "c",
		}, frame, settings)
		text:ClearAllPoints();
		text:SetPoint("RIGHT", box, "LEFT")

		box:SetScript("OnTextChanged", OnEditBoxTextChanged);
		box:SetScript("OnEscapePressed", function(self) self:ClearFocus(); end);

		if not (settings.lastestEditbox == nil) then
			settings.lastestEditbox.next = box;
			settings.lastestEditbox:SetScript("OnTabPressed", function(self) self:ClearFocus(); self.next:SetFocus(); end);
		end
		settings.lastestEditbox = box;

		box:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", widthFromBoxes + text:GetWidth(), 0);
		widthFromBoxes = widthFromBoxes + text:GetWidth() + box:GetWidth();

		box:SetTextureTheme("Tooltip")
		--GHM_TempBG(box);
		table.insert(editboxes, box);
	end

	frame:SetWidth(widthFromBoxes);

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

	local Force1 = function(data)
		if type(data) == "table" then
			for i=1, #(editboxes) do
				editboxes[i]:SetText(data[editboxes[i].label] or "");
			end
		end
	end

	local Force2 = function(inputType, inputValue)
		if not(inputType == "attribute" or inputType == "variable") then
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
		for i=1, #(editboxes) do
			editboxes[i]:SetText("");
		end
	end

	frame.GetValue = function(self)
		local t = {};
		for i=1, #(editboxes) do
			local value = editboxes[i]:GetText();
			table.insert(t, tonumber(value));
		end
		return t;
	end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame:Show();

	return frame;
end

