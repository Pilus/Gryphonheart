--===================================================
--
--				GHI_DOC_Input
--  			GHI_DOC_Input.lua
--
--	          Input system for documents
--		Supports key input, as well as copy-paste
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local STATES = {
	idle = 0,
	keyInput = 1,
	editBoxInput = 2,
	markAll = 3,
	alt = 4,
	keyInput2 = 5,
}

local KEYSPEED = 0.05;

function GHI_DOC_Input(GetCurrentTextFunc, CmdFunc)
	local class = GHClass("GHI_DOC_Input");

	local currentState = STATES.keyInput;
	local editBox, UpdateState;
	local keySet = GHI_DOC_KeySet();

	local SetUpEditBox = function()
		if not (editBox) then
			editBox = CreateFrame("EditBox");
			editBox:SetMultiLine(true);
			editBox:SetScript("OnTextChanged", function()
				if not (editBox:GetText() == editBox.text) then
					UpdateState("textChanged")
				end
			end);
		end
		editBox:Show();
		local text, markStart, markEnd = GetCurrentTextFunc();
		editBox:SetText(text);
		editBox.text = text;
		editBox:HighlightText(markStart, markEnd);
	end

	local GetCharFromKey = function(key)
		if strlenutf8(key) == 1 then
			local keyFromSet = keySet.GetKey(key);
			if keyFromSet then
				return keyFromSet;
			end
			if IsShiftKeyDown() then
				return string.upper(key);
			else
				return string.lower(key);
			end
		elseif string.startsWith(key,"KEYPAD") then
		elseif key == "SPACE" then
			return " ";
		elseif key == "ESCAPE" then
			return "\n";
		else
		end
	end

	local updateFrame;
	UpdateState = function(event, _, key)
		local newState;
		if currentState == STATES.keyInput then
			if IsAltKeyDown() then
				newState = STATES.alt;
			elseif IsControlKeyDown() then
				newState = STATES.editBoxInput;
				SetUpEditBox();
			elseif event == "key" then
				if key == "ESCAPE" then
					newState = STATES.idle;
					CmdFunc("clear");
				else
					CmdFunc("insert", key,GetCharFromKey(key));
				end
			end
		elseif currentState == STATES.editBoxInput then
			if event == "textChanged" then
				local text, markStart, markEnd = GetCurrentTextFunc();
				if markStart and markEnd then
					CmdFunc("cut");
				else
					local newText = editBox:GetText();
					CmdFunc("paste", newText)
				end
				newState = STATES.keyInput;
			elseif not (IsControlKeyDown()) then
				editBox:Insert("MARK_ALL");
				newState = STATES.markAll;
			elseif IsAltKeyDown() then
				newState = STATES.alt;
			end
		elseif currentState == STATES.markAll then
			if event == "textChanged" then
				local text = editBox:GetText();
				if text == "MARK_ALL" then
					CmdFunc("markAll")
				end
				newState = STATES.keyInput;
			end
		elseif currentState == STATES.alt then
			if not (IsAltKeyDown()) then
				newState = STATES.keyInput;
			elseif IsControlKeyDown() then
				newState = STATES.keyInput2;
			end
		elseif currentState == STATES.keyInput2 then
			if not (IsAltKeyDown()) then
				newState = STATES.keyInput;
			elseif not (IsControlKeyDown()) then
				newState = STATES.alt;
			elseif event == "key" then
				CmdFunc("shortcut", key)
				newState = STATES.keyInput
			end
		end

		if not (newState) or (currentState == newState) then
			return
		end

		if newState == STATES.idle then
			updateFrame:Hide();
		end

		if (currentState == STATES.keyInput or currentState == STATES.keyInput2) then
			if not (newState == STATES.keyInput or newState == STATES.keyInput2) then
				--class:EnableKeyboard(false);
				class:Hide();
				--print("disabling keyboard")
			end
		else
			if (newState == STATES.keyInput or newState == STATES.keyInput2) then
				--class:EnableKeyboard(true);
				if editBox then
					editBox:Hide();
				end
				class:Show();
				--print("enabling keyboard")
			end
		end
		assert(type(newState) == "number", "Incorrect new state. " .. type(newState));
		--print("change to",newState)
		currentState = newState;
	end

	updateFrame = CreateFrame("Frame");

	local keyDown;

	updateFrame:SetScript("OnUpdate", function()
		UpdateState("update")

		if keyDown and (GetTime() - keyDown.time) >= KEYSPEED then
			UpdateState("key",nil,keyDown.key);
			keyDown.time = GetTime();
		end
	end);
	class:SetScript("OnKeyDown", function(frame,key,...)
		UpdateState("key",frame,key, ...);
		keyDown = {
			key = key,
			time = GetTime() + KEYSPEED*5,
		};
	end);
	class:SetScript("OnKeyUp", function(frame,key,...)
		if keyDown and keyDown.key == key then
			keyDown = nil;
		end
	end)
	class:EnableKeyboard(true);
	--class:Hide();

	class.IsEnabled = function()
		return class:IsShown();
	end

	class.Enable = function()
		currentState = STATES.keyInput;
		keyDown = false;
		updateFrame:Show();
		class:Show();
	end

	class.Disable = function()
		updateFrame:Hide();
		currentState = STATES.idle;
		class:Hide();
	end

	return class;
end

-- /script GHI_DOC_Input(function() return "Testing text",2,4; end,print);