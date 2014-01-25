---------------------------------------------------
--
--	Copy of UIDropDwonMenu.lua, and associated XML
--	Modified by Gryphonheart Team for use in GH Addons
--
----------------------------------------------------
local class
local GHM_DropDownMenuDelegate = CreateFrame("FRAME");

GHM_DropDownMenu = function()
	if class then
		return class;
	end
	
	class = GHClass("GHM_DropDownMenu")
	
	class.MINBUTTONS = 8;
	class.MAXBUTTONS = 8;
	class.MAXLEVELS = 2;
	class.BUTTON_HEIGHT = 16;
	class.BORDER_HEIGHT = 15;
	-- The current open menu
	class.OPEN_MENU = nil;
	-- The current menu being initialized
	class.INIT_MENU = nil;
	-- Current level shown of the open menu
	class.MENU_LEVEL = 1;
	-- Current value of the open menu
	class.MENU_VALUE = nil;
	-- Time to wait to hide the menu
	class.SHOW_TIME = 2;
	-- Default dropdown text height
	class.DEFAULT_TEXT_HEIGHT = nil;
	-- List of open menus
	class.OPEN_DROPDOWNMENUS = {};
	
	if not GHM_DropDownList1 then
		GHM_DropDownList1 = CreateFrame("Button","GHM_DropDownList1",nil,"GHM_DropDownListTemplate")
		GHM_DropDownList1:SetFrameStrata("FULLSCREEN_DIALOG")
		GHM_DropDownList1:SetID(1)
		GHM_DropDownList1:SetToplevel(true)
		GHM_DropDownList1:SetSize(180,10)
		GHM_DropDownList1:SetScript("OnLoad", function()
				local fontName, fontHeight, fontFlags = _G["GHM_DropDownList1Button1NormalText"]:GetFont();
				class.DEFAULT_TEXT_HEIGHT = fontHeight;
		end)
		GHM_DropDownList1:Hide()
	end
	if not GHM_DropDownList2 then
		GHM_DropDownList2 = CreateFrame("Button","GHM_DropDownList2",nil,"GHM_DropDownListTemplate")
		GHM_DropDownList2:SetFrameStrata("FULLSCREEN_DIALOG")
		GHM_DropDownList2:SetID(2)
		GHM_DropDownList2:SetToplevel(true)
		GHM_DropDownList2:SetSize(180,10)
		GHM_DropDownList2:Hide()
	end
	
	class.DropDownMenuDelegate_OnAttributeChanged = function(self, attribute, value)
		if ( attribute == "createframes" and value == true ) then
			class.DropDownMenu_CreateFrames(self:GetAttribute("createframes-level"), self:GetAttribute("createframes-index"));
		elseif ( attribute == "initmenu" ) then
			class.INIT_MENU = value;
		elseif ( attribute == "openmenu" ) then
			class.OPEN_MENU = value;
		end
	end

	GHM_DropDownMenuDelegate:SetScript("OnAttributeChanged", class.DropDownMenuDelegate_OnAttributeChanged);

	class.DropDownMenu_InitializeHelper = function(frame)
		-- This deals with the potentially tainted stuff!
		if ( frame ~= class.OPEN_MENU ) then
			class.MENU_LEVEL = 1;
		end

		-- Set the frame that's being intialized
		GHM_DropDownMenuDelegate:SetAttribute("initmenu", frame);
		
		-- Hide all the buttons
		local button, dropDownList;
		for i = 1, class.MAXLEVELS, 1 do
			dropDownList = _G["GHM_DropDownList"..i];
			if ( i >= class.MENU_LEVEL or frame ~= class.OPEN_MENU ) then
				dropDownList.numButtons = 0;
				dropDownList.maxWidth = 0;
				for j=1, class.MAXBUTTONS, 1 do
					button = _G["GHM_DropDownList"..i.."Button"..j];
					button:Hide();
				end
				dropDownList:Hide();
			end
		end
		
		frame:SetHeight(class.BUTTON_HEIGHT * 2);
	end

	class.DropDownMenu_Initialize = function(frame, initFunction, displayMode, level, menuList)
		frame.menuList = menuList;
		class.DropDownMenu_InitializeHelper(frame)
		
		-- Set the initialize function and call it.  The initFunction populates the dropdown list.
		if ( initFunction ) then
			frame.initialize = initFunction;
			initFunction(frame, level, frame.menuList);
		end

		--master frame
		if(level == nil) then
			level = 1;
		end
		_G["GHM_DropDownList"..level].dropdown = frame;

		-- Change appearance based on the displayMode
		if ( displayMode == "MENU" ) then
			local name = frame:GetName();
			_G[name.."Left"]:Hide();
			_G[name.."Middle"]:Hide();
			_G[name.."Right"]:Hide();
			_G[name.."ButtonNormalTexture"]:SetTexture("");
			_G[name.."ButtonDisabledTexture"]:SetTexture("");
			_G[name.."ButtonPushedTexture"]:SetTexture("");
			_G[name.."ButtonHighlightTexture"]:SetTexture("");
			_G[name.."Button"]:ClearAllPoints();
			_G[name.."Button"]:SetPoint("LEFT", name.."Text", "LEFT", -9, 0);
			_G[name.."Button"]:SetPoint("RIGHT", name.."Text", "RIGHT", 6, 0);
			frame.displayMode = "MENU";
		end
	end

	-- If dropdown is visible then see if its timer has expired, if so hide the frame
	class.DropDownMenu_OnUpdate = function(self, elapsed)
		if ( not self.showTimer or not self.isCounting ) then
			return;
		elseif ( self.showTimer < 0 ) then
			self:Hide();
			self.showTimer = nil;
			self.isCounting = nil;
		else
			self.showTimer = self.showTimer - elapsed;
		end
	end

	-- Start the countdown on a frame
	class.DropDownMenu_StartCounting = function(frame)
		if ( frame.parent ) then
			class.DropDownMenu_StartCounting(frame.parent);
		else
			frame.showTimer = class.SHOW_TIME;
			frame.isCounting = 1;
		end
	end

	-- Stop the countdown on a frame
	class.DropDownMenu_StopCounting = function(frame)
		if ( frame.parent ) then
			class.DropDownMenu_StopCounting(frame.parent);
		else
			frame.isCounting = nil;
		end
	end

	--[[
	List of button attributes
	======================================================
	info.text = [STRING]  --  The text of the button
	info.value = [ANYTHING]  --  The value that UIDROPDOWNMENU_MENU_VALUE is set to when the button is clicked
	info.func = [function()]  --  The function that is called when you click the button
	info.checked = [nil, true, function]  --  Check the button if true or function returns true
	info.isNotRadio = [nil, true]  --  Check the button uses radial image if false check box image if true
	info.isTitle = [nil, true]  --  If it's a title the button is disabled and the font color is set to yellow
	info.disabled = [nil, true]  --  Disable the button and show an invisible button that still traps the mouseover event so menu doesn't time out
	info.tooltipWhileDisabled = [nil, 1] -- Show the tooltip, even when the button is disabled.
	info.hasArrow = [nil, true]  --  Show the expand arrow for multilevel menus
	info.colorCode = [STRING] -- "|cAARRGGBB" embedded hex value of the button text color. Only used when button is enabled
	info.opacity = [0.0 - 1.0]  --  Percentatge of the opacity, 1.0 is fully shown, 0 is transparent
	info.cancelFunc = [function(previousValues)] -- Function called by the colorpicker when you click the cancel button (it takes the previous values as its argument)
	info.notClickable = [nil, 1]  --  Disable the button and color the font white
	info.notCheckable = [nil, 1]  --  Shrink the size of the buttons and don't display a check box
	info.owner = [Frame]  --  Dropdown frame that "owns" the current dropdownlist
	info.keepShownOnClick = [nil, 1]  --  Don't hide the dropdownlist after a button is clicked
	info.tooltipTitle = [nil, STRING] -- Title of the tooltip shown on mouseover
	info.tooltipText = [nil, STRING] -- Text of the tooltip shown on mouseover
	info.tooltipOnButton = [nil, 1] -- Show the tooltip attached to the button instead of as a Newbie tooltip.
	info.justifyH = [nil, "CENTER"] -- Justify button text
	info.arg1 = [ANYTHING] -- This is the first argument used by info.func
	info.arg2 = [ANYTHING] -- This is the second argument used by info.func
	info.fontObject = [FONT] -- font object replacement for Normal and Highlight
	info.menuList = [TABLE] -- This contains an array of info tables to be displayed as a child menu
	info.noClickSound = [nil, 1]  --  Set to 1 to suppress the sound when clicking the button. The sound only plays if .func is set.
	info.padding = [nil, NUMBER] -- Number of pixels to pad the text on the right side
	info.leftPadding = [nil, NUMBER] -- Number of pixels to pad the button on the left side
	info.minWidth = [nil, NUMBER] -- Minimum width for this line
	info.font = [nil, string] -- font path
	]]

	class.DropDownMenu_ButtonInfo = {};

	--Until we get around to making this betterz...
	class.DropDownMenu_SecureInfo = {};

	local wipe = table.wipe;

	class.DropDownMenu_CreateInfo = function()
		-- Reuse the same table to prevent memory churn
		
		if ( issecure() ) then
			securecall(wipe, class.DropDownMenu_SecureInfo);
			return class.DropDownMenu_SecureInfo;
		else
			return wipe(class.DropDownMenu_ButtonInfo);
		end
	end

	class.DropDownMenu_CreateFrames = function(level, index)

		while ( level > class.MAXLEVELS ) do
			class.MAXLEVELS = class.MAXLEVELS + 1;
			local newList = CreateFrame("Button", "GHM_DropDownList"..class.MAXLEVELS, nil, "GHM_DropDownListTemplate");
			newList:SetFrameStrata("FULLSCREEN_DIALOG");
			newList:SetToplevel(1);
			newList:Hide();
			newList:SetID(class.MAXLEVELS);
			newList:SetWidth(180)
			newList:SetHeight(10)
			for i=class.MINBUTTONS+1, class.MAXBUTTONS do
				local newButton = CreateFrame("Button", "GHM_DropDownList"..class.MAXLEVELS.."Button"..i, newList, "GHM_DropDownMenuButtonTemplate");
				newButton:SetID(i);
			end
		end

		while ( index > class.MAXBUTTONS ) do
			class.MAXBUTTONS = class.MAXBUTTONS + 1;
			for i=1, class.MAXLEVELS do
				local newButton = CreateFrame("Button", "GHM_DropDownList"..i.."Button"..class.MAXBUTTONS, _G["GHM_DropDownList"..i], "GHM_DropDownMenuButtonTemplate");
				newButton:SetID(class.MAXBUTTONS);
			end
		end
	end

	class.DropDownMenu_AddButton = function(info, level)
		if ( not level ) then
			level = 1;
		end
		
		local listFrame = _G["GHM_DropDownList"..level];
		local index = listFrame and (listFrame.numButtons + 1) or 1;
		local width;

		GHM_DropDownMenuDelegate:SetAttribute("createframes-level", level);
		GHM_DropDownMenuDelegate:SetAttribute("createframes-index", index);
		GHM_DropDownMenuDelegate:SetAttribute("createframes", true);
		
		listFrame = listFrame or _G["GHM_DropDownList"..level];
		local listFrameName = listFrame:GetName();
		
		-- Set the number of buttons in the listframe
		listFrame.numButtons = index;
		
		local button = _G[listFrameName.."Button"..index];
		local normalText = _G[button:GetName().."NormalText"];
		local icon = _G[button:GetName().."Icon"];
		-- This button is used to capture the mouse OnEnter/OnLeave events if the dropdown button is disabled, since a disabled button doesn't receive any events
		-- This is used specifically for drop down menu time outs
		local invisibleButton = _G[button:GetName().."InvisibleButton"];
		
		-- Default settings
		button:SetDisabledFontObject(GameFontDisableSmallLeft);
		invisibleButton:Hide();
		button:Enable();
		
		-- If not clickable then disable the button and set it white
		if ( info.notClickable ) then
			info.disabled = 1;
			button:SetDisabledFontObject(GameFontHighlightSmallLeft);
		end

		-- Set the text color and disable it if its a title
		if ( info.isTitle ) then
			info.disabled = 1;
			button:SetDisabledFontObject(GameFontNormalSmallLeft);
		end
		
		-- Disable the button if disabled and turn off the color code
		if ( info.disabled ) then
			button:Disable();
			invisibleButton:Show();
			info.colorCode = nil;
		end
		
		-- If there is a color for a disabled line, set it
		if( info.disablecolor ) then
			info.colorCode = info.disablecolor;
		end

		-- Configure button
		if ( info.text ) then
			-- look for inline color code this is only if the button is enabled
			if ( info.colorCode ) then
				button:SetText(info.colorCode..info.text.."|r");
			else
				button:SetText(info.text);
			end
			-- Determine the width of the button
			width = normalText:GetWidth() + 40;
			-- Add padding if has and expand arrow or color swatch
			if ( info.hasArrow ) then
				width = width + 10;
			end
			if ( info.notCheckable ) then
				width = width - 30;
			end
			-- Set icon
			if ( info.icon ) then
				icon:SetSize(16,16);
				icon:SetTexture(info.icon);
				icon:ClearAllPoints();
				icon:SetPoint("RIGHT");

				if ( info.tCoordLeft ) then
					icon:SetTexCoord(info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom);
				else
					icon:SetTexCoord(0, 1, 0, 1);
				end
				icon:Show();
				-- Add padding for the icon
				width = width + 10;
			else
				icon:Hide();
			end
			if ( info.padding ) then
				width = width + info.padding;
			end
			width = max(width, info.minWidth or 0);
			-- Set maximum button width
			if ( width > listFrame.maxWidth ) then
				listFrame.maxWidth = width;
			end
			-- Check to see if there is a replacement font
			if ( info.fontObject ) then
				button:SetNormalFontObject(info.fontObject);
				button:SetHighlightFontObject(info.fontObject);
			else
				button:SetNormalFontObject(GameFontHighlightSmallLeft);
				button:SetHighlightFontObject(GameFontHighlightSmallLeft);
			end
			if ( info.font and info.fontSize ) then
				local fontObject
				if not(_G[button:GetName()..info.value.."Font"]) then
					fontObject = CreateFont(button:GetName()..info.value.."Font")
				else
					fontObject = _G[button:GetName()..info.value.."Font"]
				end
				fontObject:SetFont(info.font, info.fontSize)
				button:SetNormalFontObject(fontObject);
				button:SetHighlightFontObject(fontObject)
			end
		else
			button:SetText("");
			icon:Hide();
		end
		
		button.iconOnly = nil;
		button.icon = nil;
		button.iconInfo = nil;
		if (info.iconOnly and info.icon) then
			button.iconOnly = true;
			button.icon = info.icon;
			button.iconInfo = info.iconInfo;

			class.DropDownMenu_SetIconImage(icon, info.icon, info.iconInfo);
			icon:ClearAllPoints();
			icon:SetPoint("LEFT");

			width = icon:GetWidth();
			if ( info.hasArrow) then
				width = width + 50 - 30;
			end
			if ( info.notCheckable ) then
				width = width - 30;
			end
			if ( width > listFrame.maxWidth ) then
				listFrame.maxWidth = width;
			end
		end

		-- Pass through attributes
		button.func = info.func;
		button.owner = info.owner;
		button.hasOpacity = info.hasOpacity;
		button.opacity = info.opacity;
		button.opacityFunc = info.opacityFunc;
		button.cancelFunc = info.cancelFunc;
		button.swatchFunc = info.swatchFunc;
		button.keepShownOnClick = info.keepShownOnClick;
		button.tooltipTitle = info.tooltipTitle;
		button.tooltipText = info.tooltipText;
		button.arg1 = info.arg1;
		button.arg2 = info.arg2;
		button.hasArrow = info.hasArrow;
		button.notCheckable = info.notCheckable;
		button.menuList = info.menuList;
		button.tooltipWhileDisabled = info.tooltipWhileDisabled;
		button.tooltipOnButton = info.tooltipOnButton;
		button.noClickSound = info.noClickSound;
		button.padding = info.padding;
		
		if ( info.value ) then
			button.value = info.value;
		elseif ( info.text ) then
			button.value = info.text;
		else
			button.value = nil;
		end
		
		-- Show the expand arrow if it has one
		if ( info.hasArrow ) then
			_G[listFrameName.."Button"..index.."ExpandArrow"]:Show();
		else
			_G[listFrameName.."Button"..index.."ExpandArrow"]:Hide();
		end
		button.hasArrow = info.hasArrow;
		
		-- If not checkable move everything over to the left to fill in the gap where the check would be
		local xPos = 5;
		local yPos = -((button:GetID() - 1) * class.BUTTON_HEIGHT) - class.BORDER_HEIGHT;
		local displayInfo = normalText;
		if (info.iconOnly) then
			displayInfo = icon;
		end

		displayInfo:ClearAllPoints();
		if ( info.notCheckable ) then
			if ( info.justifyH and info.justifyH == "CENTER" ) then
				displayInfo:SetPoint("CENTER", button, "CENTER", -7, 0);
			else
				displayInfo:SetPoint("LEFT", button, "LEFT", 0, 0);
			end
			xPos = xPos + 10;
			
		else
			xPos = xPos + 12;
			displayInfo:SetPoint("LEFT", button, "LEFT", 20, 0);
		end

		-- Adjust offset if displayMode is menu
		local frame = class.OPEN_MENU;
		if ( frame and frame.displayMode == "MENU" ) then
			if ( not info.notCheckable ) then
				xPos = xPos - 6;
			end
		end
		
		-- If no open frame then set the frame to the currently initialized frame
		frame = frame or class.INIT_MENU;

		if ( info.leftPadding ) then
			xPos = xPos + info.leftPadding;
		end

		button:SetPoint("TOPLEFT", button:GetParent(), "TOPLEFT", xPos, yPos);

		-- See if button is selected by id or name
		if ( frame ) then
			if ( class.DropDownMenu_GetSelectedName(frame) ) then
				if ( button:GetText() == class.DropDownMenu_GetSelectedName(frame) ) then
					info.checked = 1;
				end
			elseif ( class.DropDownMenu_GetSelectedID(frame) ) then
				if ( button:GetID() == class.DropDownMenu_GetSelectedID(frame) ) then
					info.checked = 1;
				end
			elseif ( class.DropDownMenu_GetSelectedValue(frame) ) then
				if ( button.value == class.DropDownMenu_GetSelectedValue(frame) ) then
					info.checked = 1;
				end
			end
		end

		if not info.notCheckable then 
			if info.isNotRadio then
				_G[listFrameName.."Button"..index.."Check"]:SetTexCoord(0.0, 0.5, 0.0, 0.5);
				_G[listFrameName.."Button"..index.."UnCheck"]:SetTexCoord(0.5, 1.0, 0.0, 0.5);
			else
				_G[listFrameName.."Button"..index.."Check"]:SetTexCoord(0.0, 0.5, 0.5, 1.0);
				_G[listFrameName.."Button"..index.."UnCheck"]:SetTexCoord(0.5, 1.0, 0.5, 1.0);
			end
			
			-- Checked can be a function now
			local checked = info.checked;
			if ( type(checked) == "function" ) then
				checked = checked(button);
			end

			-- Show the check if checked
			if ( checked ) then
				button:LockHighlight();
				_G[listFrameName.."Button"..index.."Check"]:Show();
				_G[listFrameName.."Button"..index.."UnCheck"]:Hide();
			else
				button:UnlockHighlight();
				_G[listFrameName.."Button"..index.."Check"]:Hide();
				_G[listFrameName.."Button"..index.."UnCheck"]:Show();
			end
		else
			_G[listFrameName.."Button"..index.."Check"]:Hide();
			_G[listFrameName.."Button"..index.."UnCheck"]:Hide();
		end	
		button.checked = info.checked;

		-- Set the height of the listframe
		listFrame:SetHeight((index * class.BUTTON_HEIGHT) + (class.BORDER_HEIGHT * 2));

		button:Show();
	end

	class.DropDownMenu_Refresh = function(frame, useValue, dropdownLevel)
		local button, checked, checkImage, uncheckImage, normalText, width;
		local maxWidth = 0;
		local somethingChecked = nil; 
		if ( not dropdownLevel ) then
			dropdownLevel = class.MENU_LEVEL;
		end

		local listFrame = _G["GHM_DropDownList"..dropdownLevel];
		listFrame.numButtons = listFrame.numButtons or 0;
		-- Just redraws the existing menu
		for i=1, class.MAXBUTTONS do
			button = _G["GHM_DropDownList"..dropdownLevel.."Button"..i];
			checked = nil;

			if(i <= listFrame.numButtons) then
				-- See if checked or not
				if ( class.DropDownMenu_GetSelectedName(frame) ) then
					if ( button:GetText() == class.DropDownMenu_GetSelectedName(frame) ) then
						checked = 1;
					end
				elseif ( class.DropDownMenu_GetSelectedID(frame) ) then
					if ( button:GetID() == class.DropDownMenu_GetSelectedID(frame) ) then
						checked = 1;
					end
				elseif ( class.DropDownMenu_GetSelectedValue(frame) ) then
					if ( button.value == class.DropDownMenu_GetSelectedValue(frame) ) then
						checked = 1;
					end
				end
			end
			if (button.checked and type(button.checked) == "function") then
				checked = button.checked(button);
			end

			if not button.notCheckable and button:IsShown() then	
				-- If checked show check image
				checkImage = _G["GHM_DropDownList"..dropdownLevel.."Button"..i.."Check"];
				uncheckImage = _G["GHM_DropDownList"..dropdownLevel.."Button"..i.."UnCheck"];
				if ( checked ) then
					somethingChecked = true;
					local icon = _G[frame:GetName().."Icon"];
					if (button.iconOnly and icon and button.icon) then
						class.DropDownMenu_SetIconImage(icon, button.icon, button.iconInfo);
					elseif ( useValue ) then
						class.DropDownMenu_SetText(frame, button.value);
						icon:Hide();
					else
						class.DropDownMenu_SetText(frame, button:GetText());
						icon:Hide();
					end
					button:LockHighlight();
					checkImage:Show();
					uncheckImage:Hide();
				else
					button:UnlockHighlight();
					checkImage:Hide();
					uncheckImage:Show();
				end
			end

			if ( button:IsShown() ) then
				if ( button.iconOnly ) then
					local icon = _G[frame:GetName().."Icon"];
					width = icon:GetWidth();
				else
					normalText = _G[button:GetName().."NormalText"];
					width = normalText:GetWidth() + 40;
				end
				-- Add padding if has and expand arrow or color swatch
				if ( button.hasArrow) then
					width = width + 10;
				end
				if ( button.notCheckable ) then
					width = width - 30;
				end
				if ( button.padding ) then
					width = width + button.padding;
				end
				if ( width > maxWidth ) then
					maxWidth = width;
				end
			end
		end
		if(somethingChecked == nil) then
			class.DropDownMenu_SetText(frame, VIDEO_QUALITY_LABEL6);
		end
		if (not frame.noResize) then
			for i=1, class.MAXBUTTONS do
				button = _G["GHM_DropDownList"..dropdownLevel.."Button"..i];
				button:SetWidth(maxWidth);
			end
			_G["GHM_DropDownList"..dropdownLevel]:SetWidth(maxWidth+15);
		end
	end

	class.DropDownMenu_RefreshAll = function(frame, useValue)
		for dropdownLevel = class.MENU_LEVEL, 2, -1 do
			local listFrame = _G["GHM_DropDownList"..dropdownLevel];
			if ( listFrame:IsShown() ) then
				class.DropDownMenu_Refresh(frame, nil, dropdownLevel);
			end
		end
		-- useValue is the text on the dropdown, only needs to be set once
		class.DropDownMenu_Refresh(frame, useValue, 1);
	end

	class.DropDownMenu_SetIconImage = function(icon, texture, info)
		icon:SetTexture(texture);
		if ( info.tCoordLeft ) then
			icon:SetTexCoord(info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom);
		else
			icon:SetTexCoord(0, 1, 0, 1);
		end
		if ( info.tSizeX ) then
			icon:SetWidth(info.tSizeX);
		else
			icon:SetWidth(16);
		end
		if ( info.tSizeY ) then
			icon:SetHeight(info.tSizeY);
		else
			icon:SetHeight(16);
		end
		icon:Show();
	end

	class.DropDownMenu_SetSelectedName = function(frame, name, useValue)
		frame.selectedName = name;
		frame.selectedID = nil;
		frame.selectedValue = nil;
		class.DropDownMenu_Refresh(frame, useValue);
	end

	class.DropDownMenu_SetSelectedValue = function(frame, value, useValue)
		-- useValue will set the value as the text, not the name
		frame.selectedName = nil;
		frame.selectedID = nil;
		frame.selectedValue = value;
		class.DropDownMenu_Refresh(frame, useValue);
	end

	class.DropDownMenu_SetSelectedID = function(frame, id, useValue)
		frame.selectedID = id;
		frame.selectedName = nil;
		frame.selectedValue = nil;
		class.DropDownMenu_Refresh(frame, useValue);
	end

	class.DropDownMenu_GetSelectedName = function(frame)
		return frame.selectedName;
	end

	class.DropDownMenu_GetSelectedID = function(frame)
		if ( frame.selectedID ) then
			return frame.selectedID;
		else
			-- If no explicit selectedID then try to send the id of a selected value or name
			local button;
			for i=1, class.MAXBUTTONS do
				button = _G["GHM_DropDownList"..class.MENU_LEVEL.."Button"..i];
				-- See if checked or not
				if ( class.DropDownMenu_GetSelectedName(frame) ) then
					if ( button:GetText() == class.DropDownMenu_GetSelectedName(frame) ) then
						return i;
					end
				elseif ( class.DropDownMenu_GetSelectedValue(frame) ) then
					if ( button.value == class.DropDownMenu_GetSelectedValue(frame) ) then
						return i;
					end
				end
			end
		end
	end

	class.DropDownMenu_GetSelectedValue = function(frame)
		return frame.selectedValue;
	end

	class.DropDownMenuButton_OnClick = function(self)
		local checked = self.checked;
		if ( type (checked) == "function" ) then
			checked = checked(self);
		end
		

		if ( self.keepShownOnClick ) then
			if not self.notCheckable then
				if ( checked ) then
					_G[self:GetName().."Check"]:Hide();
					_G[self:GetName().."UnCheck"]:Show();
					checked = false;
				else
					_G[self:GetName().."Check"]:Show();
					_G[self:GetName().."UnCheck"]:Hide();
					checked = true;
				end
			end
		else
			self:GetParent():Hide();
		end

		if ( type (self.checked) ~= "function" ) then 
			self.checked = checked;
		end

		-- saving this here because func might use a dropdown, changing this self's attributes
		local playSound = true;
		if ( self.noClickSound ) then
			playSound = false;
		end

		local func = self.func;
		if ( func ) then
			func(self, self.arg1, self.arg2, checked);
		else
			return;
		end

		if ( playSound ) then
			PlaySound("UChatScrollButton");
		end
	end

	class.HideDropDownMenu = function(level)
		local listFrame = _G["GHM_DropDownList"..level];
		listFrame:Hide();
	end

	class.ToggleDropDownMenu = function(level, value, dropDownFrame, anchorName, xOffset, yOffset, menuList, button, autoHideDelay)
		if ( not level ) then
			level = 1;
		end
		GHM_DropDownMenuDelegate:SetAttribute("createframes-level", level);
		GHM_DropDownMenuDelegate:SetAttribute("createframes-index", 0);
		GHM_DropDownMenuDelegate:SetAttribute("createframes", true);
		class.MENU_LEVEL = level;
		class.MENU_VALUE = value;
		local listFrame = _G["GHM_DropDownList"..level];
		local listFrameName = "GHM_DropDownList"..level;
		local tempFrame;
		local point, relativePoint, relativeTo;
		if ( not dropDownFrame ) then
			tempFrame = button:GetParent();
		else
			tempFrame = dropDownFrame;
		end
		if ( listFrame:IsShown() and (class.OPEN_MENU == tempFrame) ) then
			listFrame:Hide();
		else
			-- Set the dropdownframe scale
			local uiScale;
			local uiParentScale = UIParent:GetScale();
			if ( tempFrame ~= WorldMapContinentDropDown and tempFrame ~= WorldMapZoneDropDown ) then
				if ( GetCVar("useUIScale") == "1" ) then
					uiScale = tonumber(GetCVar("uiscale"));
					if ( uiParentScale < uiScale ) then
						uiScale = uiParentScale;
					end
				else
					uiScale = uiParentScale;
				end
			else
				uiScale = 1;
			end
			listFrame:SetScale(uiScale);
			
			-- Hide the listframe anyways since it is redrawn OnShow() 
			listFrame:Hide();
			
			-- Frame to anchor the dropdown menu to
			local anchorFrame;

			-- Display stuff
			-- Level specific stuff
			if ( level == 1 ) then	
				GHM_DropDownMenuDelegate:SetAttribute("openmenu", dropDownFrame);
				listFrame:ClearAllPoints();
				-- If there's no specified anchorName then use left side of the dropdown menu
				if ( not anchorName ) then
					-- See if the anchor was set manually using setanchor
					if ( dropDownFrame.xOffset ) then
						xOffset = dropDownFrame.xOffset;
					end
					if ( dropDownFrame.yOffset ) then
						yOffset = dropDownFrame.yOffset;
					end
					if ( dropDownFrame.point ) then
						point = dropDownFrame.point;
					end
					if ( dropDownFrame.relativeTo ) then
						relativeTo = dropDownFrame.relativeTo;
					else
						relativeTo = class.OPEN_MENU:GetName().."Left";
					end
					if ( dropDownFrame.relativePoint ) then
						relativePoint = dropDownFrame.relativePoint;
					end
				elseif ( anchorName == "cursor" ) then
					relativeTo = nil;
					local cursorX, cursorY = GetCursorPosition();
					cursorX = cursorX/uiScale;
					cursorY =  cursorY/uiScale;

					if ( not xOffset ) then
						xOffset = 0;
					end
					if ( not yOffset ) then
						yOffset = 0;
					end
					xOffset = cursorX + xOffset;
					yOffset = cursorY + yOffset;
				else
					-- See if the anchor was set manually using setanchor
					if ( dropDownFrame.xOffset ) then
						xOffset = dropDownFrame.xOffset;
					end
					if ( dropDownFrame.yOffset ) then
						yOffset = dropDownFrame.yOffset;
					end
					if ( dropDownFrame.point ) then
						point = dropDownFrame.point;
					end
					if ( dropDownFrame.relativeTo ) then
						relativeTo = dropDownFrame.relativeTo;
					else
						relativeTo = anchorName;
					end
					if ( dropDownFrame.relativePoint ) then
						relativePoint = dropDownFrame.relativePoint;
					end
				end
				if ( not xOffset or not yOffset ) then
					xOffset = 8;
					yOffset = 22;
				end
				if ( not point ) then
					point = "TOPLEFT";
				end
				if ( not relativePoint ) then
					relativePoint = "BOTTOMLEFT";
				end
				listFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset);
			else
				if ( not dropDownFrame ) then
					dropDownFrame = class.OPEN_MENU;
				end
				listFrame:ClearAllPoints();
				-- If this is a dropdown button, not the arrow anchor it to itself
				if ( strsub(button:GetParent():GetName(), 0,16) == "GHM_DropDownList" and strlen(button:GetParent():GetName()) == 17 ) then
					anchorFrame = button;
				else
					anchorFrame = button:GetParent();
				end
				point = "TOPLEFT";
				relativePoint = "TOPRIGHT";
				listFrame:SetPoint(point, anchorFrame, relativePoint, 0, 0);
			end
			
			-- Change list box appearance depending on display mode
			if ( dropDownFrame and dropDownFrame.displayMode == "MENU" ) then
				_G[listFrameName.."Backdrop"]:Hide();
				_G[listFrameName.."MenuBackdrop"]:Show();
			else
				_G[listFrameName.."Backdrop"]:Show();
				_G[listFrameName.."MenuBackdrop"]:Hide();
			end
			dropDownFrame.menuList = menuList;
			class.DropDownMenu_Initialize(dropDownFrame, dropDownFrame.initialize, nil, level, menuList);
			-- If no items in the drop down don't show it
			if ( listFrame.numButtons == 0 ) then
				return;
			end

			-- Check to see if the dropdownlist is off the screen, if it is anchor it to the top of the dropdown button
			listFrame:Show();
			-- Hack since GetCenter() is returning coords relative to 1024x768
			local x, y = listFrame:GetCenter();
			-- Hack will fix this in next revision of dropdowns
			if ( not x or not y ) then
				listFrame:Hide();
				return;
			end

			listFrame.onHide = dropDownFrame.onHide;

			--  We just move level 1 enough to keep it on the screen. We don't necessarily change the anchors.
			if ( level == 1 ) then
				local offLeft = listFrame:GetLeft()/uiScale;
				local offRight = (GetScreenWidth() - listFrame:GetRight())/uiScale;
				local offTop = (GetScreenHeight() - listFrame:GetTop())/uiScale;
				local offBottom = listFrame:GetBottom()/uiScale;
				
				local xAddOffset, yAddOffset = 0, 0;
				if ( offLeft < 0 ) then
					xAddOffset = -offLeft;
				elseif ( offRight < 0 ) then
					xAddOffset = offRight;
				end
				
				if ( offTop < 0 ) then
					yAddOffset = offTop;
				elseif ( offBottom < 0 ) then
					yAddOffset = -offBottom;
				end
				
				listFrame:ClearAllPoints();
				if ( anchorName == "cursor" ) then
					listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset);
				else
					listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset);
				end
			else
				-- Determine whether the menu is off the screen or not
				local offscreenY, offscreenX;
				if ( (y - listFrame:GetHeight()/2) < 0 ) then
					offscreenY = 1;
				end
				if ( listFrame:GetRight() > GetScreenWidth() ) then
					offscreenX = 1;	
				end
				if ( offscreenY and offscreenX ) then
					point = gsub(point, "TOP(.*)", "BOTTOM%1");
					point = gsub(point, "(.*)LEFT", "%1RIGHT");
					relativePoint = gsub(relativePoint, "TOP(.*)", "BOTTOM%1");
					relativePoint = gsub(relativePoint, "(.*)RIGHT", "%1LEFT");
					xOffset = -11;
					yOffset = -14;
				elseif ( offscreenY ) then
					point = gsub(point, "TOP(.*)", "BOTTOM%1");
					relativePoint = gsub(relativePoint, "TOP(.*)", "BOTTOM%1");
					xOffset = 0;
					yOffset = -14;
				elseif ( offscreenX ) then
					point = gsub(point, "(.*)LEFT", "%1RIGHT");
					relativePoint = gsub(relativePoint, "(.*)RIGHT", "%1LEFT");
					xOffset = -11;
					yOffset = 14;
				else
					xOffset = 0;
					yOffset = 14;
				end
				
				listFrame:ClearAllPoints();
				listFrame.parentLevel = tonumber(strmatch(anchorFrame:GetName(), "DropDownList(%d+)"));
				listFrame.parentID = anchorFrame:GetID();
				listFrame:SetPoint(point, anchorFrame, relativePoint, xOffset, yOffset);
			end

			if ( autoHideDelay and tonumber(autoHideDelay)) then
				listFrame.showTimer = autoHideDelay;
				listFrame.isCounting = 1;
			end
		end
	end

	class.CloseDropDownMenus = function(level)
		if ( not level ) then
			level = 1;
		end
		for i=level, class.MAXLEVELS do
			_G["GHM_DropDownList"..i]:Hide();
		end
	end

	class.DropDownMenu_OnHide = function(self)
		local id = self:GetID()
		if ( self.onHide ) then
			self.onHide(id+1);
			self.onHide = nil;
		end
		class.CloseDropDownMenus(id+1);
		class.OPEN_DROPDOWNMENUS[id] = nil;
	end

	class.DropDownMenu_SetWidth = function(frame, width, padding)
		_G[frame:GetName().."Middle"]:SetWidth(width);
		local defaultPadding = 25;
		if ( padding ) then
			frame:SetWidth(width + padding);
		else
			frame:SetWidth(width + defaultPadding + defaultPadding);
		end
		if ( padding ) then
			_G[frame:GetName().."Text"]:SetWidth(width);
		else
			_G[frame:GetName().."Text"]:SetWidth(width - defaultPadding);
		end
		frame.noResize = 1;
	end

	class.DropDownMenu_SetButtonWidth = function(frame, width)
		if ( width == "TEXT" ) then
			width = _G[frame:GetName().."Text"]:GetWidth();
		end
		
		_G[frame:GetName().."Button"]:SetWidth(width);
		frame.noResize = 1;
	end

	class.DropDownMenu_SetText = function(frame, text)
		local filterText = _G[frame:GetName().."Text"];
		filterText:SetText(text);
	end

	class.DropDownMenu_GetText = function(frame)
		local filterText = _G[frame:GetName().."Text"];
		return filterText:GetText();
	end

	class.DropDownMenu_ClearAll = function(frame)
		-- Previous code refreshed the menu quite often and was a performance bottleneck
		frame.selectedID = nil;
		frame.selectedName = nil;
		frame.selectedValue = nil;
		class.DropDownMenu_SetText(frame, "");

		local button, checkImage, uncheckImage;
		for i=1, class.MAXBUTTONS do
			button = _G["GHM_DropDownList"..class.MENU_LEVEL.."Button"..i];
			button:UnlockHighlight();

			checkImage = _G["GHM_DropDownList"..class.MENU_LEVEL.."Button"..i.."Check"];
			checkImage:Hide();
			uncheckImage = _G["GHM_DropDownList"..class.MENU_LEVEL.."Button"..i.."UnCheck"];
			uncheckImage:Hide();
		end
	end

	class.DropDownMenu_JustifyText = function(frame, justification)
		local text = _G[frame:GetName().."Text"];
		text:ClearAllPoints();
		if ( justification == "LEFT" ) then
			text:SetPoint("LEFT", frame:GetName().."Left", "LEFT", 27, 2);
			text:SetJustifyH("LEFT");
		elseif ( justification == "RIGHT" ) then
			text:SetPoint("RIGHT", frame:GetName().."Right", "RIGHT", -43, 2);
			text:SetJustifyH("RIGHT");
		elseif ( justification == "CENTER" ) then
			text:SetPoint("CENTER", frame:GetName().."Middle", "CENTER", -5, 2);
			text:SetJustifyH("CENTER");
		end
	end

	class.DropDownMenu_SetAnchor = function(dropdown, xOffset, yOffset, point, relativeTo, relativePoint)
		dropdown.xOffset = xOffset;
		dropdown.yOffset = yOffset;
		dropdown.point = point;
		dropdown.relativeTo = relativeTo;
		dropdown.relativePoint = relativePoint;
	end

	class.DropDownMenu_GetCurrentDropDown = function()
		if ( class.OPEN_MENU ) then
			return class.OPEN_MENU;
		elseif ( class.INIT_MENU ) then
			return class.INIT_MENU;
		end
	end

	class.DropDownMenuButton_GetChecked = function(self)
		return _G[self:GetName().."Check"]:IsShown();
	end

	class.DropDownMenuButton_GetName = function(self)
		return _G[self:GetName().."NormalText"]:GetText();
	end

	class.DropDownMenu_DisableButton = function(level, id)
		_G["GHM_DropDownList"..level.."Button"..id]:Disable();
	end

	class.DropDownMenu_EnableButton = function(level, id)
		_G["GHM_DropDownList"..level.."Button"..id]:Enable();
	end

	class.DropDownMenu_SetButtonText = function(level, id, text, colorCode)
		local button = _G["GHM_DropDownList"..level.."Button"..id];
		if ( colorCode) then
			button:SetText(colorCode..text.."|r");
		else
			button:SetText(text);
		end
	end

	class.DropDownMenu_DisableDropDown = function(dropDown)
		local label = _G[dropDown:GetName().."Label"];
		if ( label ) then
			label:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		end
		_G[dropDown:GetName().."Text"]:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		_G[dropDown:GetName().."Button"]:Disable();
		dropDown.isDisabled = 1;
	end

	class.DropDownMenu_EnableDropDown = function(dropDown)
		local label = _G[dropDown:GetName().."Label"];
		if ( label ) then
			label:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		end
		_G[dropDown:GetName().."Text"]:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		_G[dropDown:GetName().."Button"]:Enable();
		dropDown.isDisabled = nil;
	end

	class.DropDownMenu_IsEnabled = function(dropDown)
		return not dropDown.isDisabled;
	end

	class.DropDownMenu_GetValue = function(id)
		--Only works if the dropdown has just been initialized, lame, I know =(
		local button = _G["GHM_DropDownList1Button"..id];
		if ( button ) then
			return _G["GHM_DropDownList1Button"..id].value;
		else
			return nil;
		end
	end
	
	class.EasyMenu = function(menuList, menuFrame, anchor, x, y, displayMode, autoHideDelay )
		if ( displayMode == "MENU" ) then
			menuFrame.displayMode = displayMode;
		end
		class.DropDownMenu_Initialize(menuFrame, class.EasyMenu_Initialize, displayMode, nil, menuList);
		class.ToggleDropDownMenu(1, nil, menuFrame, anchor, x, y, menuList, nil, autoHideDelay);
	end

	class.EasyMenu_Initialize = function( frame, level, menuList )
		for index = 1, #menuList do
			local value = menuList[index]
			if (value.text) then
				value.index = index;
				class.DropDownMenu_AddButton( value, level );
			end
		end
	end
	
	return class
end
