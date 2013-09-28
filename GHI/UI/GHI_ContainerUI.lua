--===================================================
--
--				GHI_ContainerUI
--				GHI_ContainerUI.lua
--
--		UI controller for the container UI.
--
--		(c)2013 The Gryphonheart Team
--			  All rights reserved
--===================================================

local mainBagFrame;
local bags = {};
local menuButtons = {};
local MAIN_BACKPACK_SIZE = 24;
local api;
local miscApi;
local loc;

local ALLOWED_SIZES = {1,2,4,6,8,10,12,14,16,18,20,24,26,28,30,32,34}

local function SetUpMainBagFrame()
	mainBagFrame = CreateFrame("Frame", "GHI_ContainerFrame1", UIParent, "GHI_ContainerFrameTemplate");
	GHI_ContainerFrame_GenerateFrame(mainBagFrame, MAIN_BACKPACK_SIZE, nil, nil, nil);
	GHI_ContainerAnchorFrame(mainBagFrame);

	mainBagFrame.guid = api.GHI_GetCurrentMainBagGUID();
	tinsert(UISpecialFrames, mainBagFrame:GetName());
	table.insert(bags, mainBagFrame);
end

local function UpdateMainBagPageButtons()
	if menuButtons.next then
		if api.GHI_GotNextMainBagPage() then
			menuButtons.next:Enable();
		else
			menuButtons.next:Disable();
		end
	end
	if menuButtons.prev then
		if api.GHI_GotPrevMainBagPage() then
			menuButtons.prev:Enable();
		else
			menuButtons.prev:Disable();
		end
	end
end

local newItemMenuFrameDD

local GHI_NewItemMenu = function(self)
	local newItemDDMenu = {
		{
			text = loc.NEW_SIMP_ITEM,
			notCheckable = true,
			func = function() api.GHI_NewItem("simple") end,
		},
		{
			text = loc.NEW_STD_ITEM,
			notCheckable = true,
			func = function() api.GHI_NewItem("standard") end,
		},
		{
			text = loc.NEW_ADV_ITEM,
			notCheckable = true,
			func = function() api.GHI_NewItem("advanced")end,
		},
		{
			text = loc.NEW_MACRO,
			notCheckable = true,
			func = function() api.GHI_NewItem("macro")end,
		}
	}
    
	local dropDownMenu = GHM_DropDownMenu()
	
	if not(NewItemDDMenuFrame) then
		newItemMenuFrameDD	= CreateFrame("Frame", "NewItemDDMenuFrame", self, "GHM_DropDownMenuTemplate")
		-- Make the menu appear at the cursor:
		dropDownMenu.EasyMenu(newItemDDMenu, newItemMenuFrameDD, self, 0 ,0, "MENU", 1);
	else
		dropDownMenu.ToggleDropDownMenu(1,nil,newItemMenuFrameDD,self,0,0,newItemDDMenu,nil,2)
	end
end

local function SetUpContainerMenuButtons()
	loc = GHI_Loc();
	local buttonInfo = {
		{
			x = 45,
			y = -28,
			text = loc.NEW_ITEM_1LETTER,
			details = loc.NEW_ITEM_DETAILS,
			name = "new",
			tooltip = loc.NEW_ITEM,
			click =  GHI_NewItemMenu,
		},
		{
			x = 67,
			y = -28,
			text = loc.EDIT_ITEM_1LETTER,
			details = loc.EDIT_ITEM_DETAILS,
			tooltip = loc.EDIT_ITEM,
			click = function()
				miscApi.GHI_SetSelectItemCursor(function(guid)
					api.GHI_EditItem(guid);
				end, nil, "edit");
			end,
		},
		{
			x = 89,
			y = -28,
			text = loc.COPY_ITEM_1LETTER,
			tooltip = loc.COPY_ITEM,
			details = loc.COPY_ITEM_DETAILS,
			click = function()
				miscApi.GHI_SetSelectItemCursor(function(guid,frame)
					if (api.GHI_CanCopyItem(guid)) then
						local _,_,_,stackSize = api.GHI_GetItemInfo(guid);
						frame.SplitStack = function(button, amount)
							api.GHI_CopyContainerItem(frame.containerGuid, frame.slotID, amount);
						end
						OpenStackSplitFrame(stackSize * 10, frame, "BOTTOMRIGHT", "TOPRIGHT");
						StackSplitOkayButton:SetText(loc.COPY);
						if not(StackSplitFrame.removeCopyText) then
							local f = OpenStackSplitFrame;
							OpenStackSplitFrame = function(...)
								StackSplitOkayButton:SetText(OKAY);
								return f(...);
							end
							StackSplitFrame.removeCopyText = true;
						end
					else
						GHI_Message(loc.CANNOT_COPY);
					end
				end, nil, "copy");
			end,
		},
		{
			x = 111,
			y = -28,
			text = "?",
			details = loc.HELP_OPTIONS_DETAILS,
			tooltip = loc.HELP_OPTIONS,
			click = function()
				local omenu = GHI_MainOptionsMenu()
				omenu.Show()
			end,
		},
		{ x = 139, y = -28, text = "<", tooltip = loc.PREV_PAGE, details=loc.PREV_PAGE_DETAILS, name = "prev", click = api.GHI_PrevMainBagPage, },
		{ x = 161, y = -28, text = ">", tooltip = loc.NEXT_PAGE, details=loc.NEXT_PAGE_DETAILS, name = "next", click = api.GHI_NextMainBagPage, },
		{
			x = 79,
			y = -6,
			text = loc.EXPORT_ITEM_1LETTER,
			details = loc.EXPORT_ITEM_DETAILS,
			tooltip = loc.EXPORT_ITEM,
			click = function()
				miscApi.GHI_SetSelectItemCursor(function(guid, frame)
					local emenu = GHI_ExportMenu()
					emenu.Show(guid, frame.containerGuid, frame.slotID)
				end, nil, "export");
			end,
		},
		{
			x = 99,
			y = -6,
			text = loc.IMPORT_ITEM_1LETTER,
			details = loc.IMPORT_ITEM_DETAILS,
			tooltip = loc.IMPORT_ITEM,
			click = function()
				local imenu = GHI_ImportMenu()
				imenu.Show()
			end,
		},
		{
			x = 118,
			y = -6,
			text = loc.INSPECT_ITEM_1LETTER,
			details = loc.INSPECT_ITEM_DETAILS,
			tooltip = loc.INSPECT_ITEM,
			click = function()			
				miscApi.GHI_SetSelectItemCursor(function(guid)
					local inspectInfo = api.GHI_InspectItem(guid)
					for i,v in pairs(inspectInfo) do
						if type(v) == "table" then
							local text = miscApi.GHI_ColorString(v.text,v.r,v.g,v.b)
							print(text)
						else
						print(v)
						end
					end
				end, nil, "GHI_INSPECT");
			end,
		},
		{ x = 139, y = -6, text = loc.EQD_1LETTER, details = loc.EQD_DETAILS, tooltip = loc.EQD, click = function() GHI_Message("The GHI Equiment Display is out of order and is set to be reimplemented at a later date.") end, },
	};

	for _, info in pairs(buttonInfo) do
		local f = CreateFrame("Button", nil, mainBagFrame,"GHI_UIPanelButtonTemplate");
		f:SetWidth(20);
		f:SetHeight(20);
		f:SetPoint("TOPLEFT", info.x, info.y);
		f:SetText(info.text);
		f:SetFrameLevel(5)
		f:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			GameTooltip:ClearLines()
			GameTooltip:AddLine(info.tooltip, 1, 0.8196079, 0);
			if info.details then
				GameTooltip:AddLine(info.details, 1, 1, 1, 1);
			end
			GameTooltip:Show()
		end);
		f:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end)
		f:SetScript("OnClick", info.click);
		f:Show();
		if info.name then
			menuButtons[info.name] = f;
		end
	end
end

local function GetFreeBagFrame()
	for _, bag in pairs(bags) do
		if not (mainBagFrame) and not (mainBagFrame:IsShown()) then
			return bag;
		end
	end
	local bag = CreateFrame("Frame", "GHI_ContainerFrame" .. (#(bags) + 1), UIParent, "GHI_ContainerFrameTemplate");
	table.insert(bags, bag);
	tinsert(UISpecialFrames, bag:GetName());
	GHI_ContainerAnchorFrame(bag);
	return bag;
end

GHI_Event("VARIABLES_LOADED", function()
	api = GHI_ContainerAPI().GetAPI();
	miscApi = GHI_MiscAPI().GetAPI();
	SetUpMainBagFrame();
	SetUpContainerMenuButtons();
	UpdateMainBagPageButtons();
end);

GHI_Event("GHI_CONTAINER_UPDATE", function(e, guid)
	if mainBagFrame then
		mainBagFrame.guid = api.GHI_GetCurrentMainBagGUID();
		UpdateMainBagPageButtons();
		for _, frame in pairs(bags) do
			if frame.guid == guid then
				GHI_ContainerFrame_Update(frame);
			end
		end
	end
end);

GHI_Event("GHI_ITEM_UPDATE", function()
	if mainBagFrame then
		mainBagFrame.guid = api.GHI_GetCurrentMainBagGUID();
		UpdateMainBagPageButtons();
		for _, frame in pairs(bags) do
			if frame:IsShown() then
				GHI_ContainerFrame_Update(frame);
			end
		end
	end
end);

GHI_Event("GHI_BAG_UPDATE_COOLDOWN", function(e, guid)
	for _, frame in pairs(bags) do
		if frame.guid == guid and frame:IsShown() then
			GHI_ContainerFrame_Update(frame);
		end
	end
end);

GHI_Event("GHI_BAG_OPEN", function(e, guid)
	for _, frame in pairs(bags) do
		if frame.guid == guid and frame:IsShown() then
			frame:Hide();
			return
		end
	end
	local bagFrame = GetFreeBagFrame();
	local size, name, icon, texture = api.GHI_GetContainerInfo(guid);

	if size == 35 then size = 34 end --fix for some bags
	if not(tContains(ALLOWED_SIZES,size)) then
		return
	end

	bagFrame.guid = guid;
	GHI_ContainerFrame_GenerateFrame(bagFrame, size, name, icon, texture);
	bagFrame:Show();
end)

function GHI_ContainerFrame_GenerateFrame(frame, size, itemname, icon, specialTexture)
	frame.size = size;

	local name = frame:GetName();
	local bgTextureTop = _G[name .. "BackgroundTop"];
	local bgTextureMiddle = _G[name .. "BackgroundMiddle1"];
	local bgTextureBottom = _G[name .. "BackgroundBottom"];
	local columns = NUM_CONTAINER_COLUMNS;
	local rows = ceil(size / columns);

	local bagTextureSuffix = specialTexture or "";
	if specialTexture == "Bank" or specialTexture == "Keyring" then
		bagTextureSuffix = "-" .. specialTexture;
	end
	bgTextureTop:SetTexture("Interface\\ContainerFrame\\UI-Bag-Components" .. bagTextureSuffix);
	for i = 1, MAX_BG_TEXTURES do
		_G[name .. "BackgroundMiddle" .. i]:SetTexture("Interface\\ContainerFrame\\UI-Bag-Components" .. bagTextureSuffix);
		_G[name .. "BackgroundMiddle" .. i]:Hide();
	end
	bgTextureBottom:SetTexture("Interface\\ContainerFrame\\UI-Bag-Components" .. bagTextureSuffix);
	_G[name .. "MoneyFrame"]:Hide();

	if size == 1 then

		local bgTextureTop = _G[name .. "BackgroundTop"];
		local bgTextureMiddle = _G[name .. "BackgroundMiddle1"];
		local bgTextureMiddle2 = _G[name .. "BackgroundMiddle2"];
		local bgTextureBottom = _G[name .. "BackgroundBottom"];
		local bgTexture1Slot = _G[name .. "Background1Slot"];

		bgTexture1Slot:Show();
		bgTextureTop:Hide();
		bgTextureMiddle:Hide();
		bgTextureMiddle2:Hide();
		bgTextureBottom:Hide();

		frame:SetHeight(70);
		frame:SetWidth(99);
		_G[frame:GetName() .. "Name"]:SetText("");
		local itemButton = _G[name .. "Item1"];
		itemButton:SetID(1);
		itemButton:SetPoint("BOTTOMRIGHT", name, "BOTTOMRIGHT", -10, 5);
		itemButton:Show();

	else
		-- non 1 slot
		local bgTextureTop = _G[name .. "BackgroundTop"];
		local bgTextureMiddle = _G[name .. "BackgroundMiddle1"];
		local bgTextureMiddle2 = _G[name .. "BackgroundMiddle2"];
		local bgTextureBottom = _G[name .. "BackgroundBottom"];
		local bgTexture1Slot = _G[name .. "Background1Slot"];

		bgTexture1Slot:Hide();
		bgTextureTop:Show();

		local bgTextureCount, height;
		local rowHeight = 41;
		-- Subtract one, since the top texture contains one row already
		local remainingRows = rows - 1;

		-- See if the bag needs the texture with two slots at the top
		local isPlusTwoBag;
		if (mod(size, columns) == 2) then
			isPlusTwoBag = 1;
		end

		-- Bag background display stuff
		if (isPlusTwoBag) then
			bgTextureTop:SetTexCoord(0, 1, 0.189453125, 0.330078125);
			bgTextureTop:SetHeight(72);
		else
			if (rows == 1) then
				-- If only one row chop off the bottom of the texture
				bgTextureTop:SetTexCoord(0, 1, 0.00390625, 0.16796875);
				bgTextureTop:SetHeight(86);
			else
				bgTextureTop:SetTexCoord(0, 1, 0.00390625, 0.18359375);
				bgTextureTop:SetHeight(94);
			end
		end
		-- Calculate the number of background textures we're going to need
		bgTextureCount = ceil(remainingRows / ROWS_IN_BG_TEXTURE);

		local middleBgHeight = 0;
		-- I f one row only special case
		if (rows == 1) then
			bgTextureBottom:SetPoint("TOP", bgTextureMiddle:GetName(), "TOP", 0, 0);
			bgTextureBottom:Show();
			-- Hide middle bg textures
			for i = 1, MAX_BG_TEXTURES do
				_G[name .. "BackgroundMiddle" .. i]:Hide();
			end
		else
			-- Try to cycle all the middle bg textures
			local firstRowPixelOffset = 9;
			local firstRowTexCoordOffset = 0.353515625;
			for i = 1, bgTextureCount do
				bgTextureMiddle = _G[name .. "BackgroundMiddle" .. i];

				if (remainingRows > ROWS_IN_BG_TEXTURE) then
					-- if more rows left to draw than can fit in a texture th en draw the max possible
					height = (ROWS_IN_BG_TEXTURE * rowHeight) + firstRowTexCoordOffset;
					bgTextureMiddle:SetHeight(height);
					bgTextureMiddle:SetTexCoord(0, 1, firstRowTexCoordOffset, (height / BG_TEXTURE_HEIGHT + firstRowTexCoordOffset));
					bgTextureMiddle:Show();
					remainingRows = remainingRows - ROWS_IN_BG_TEXTURE;
					middleBgHeight = middleBgHeight + height;
				else
					-- I f not its a huge bag
					bgTextureMiddle:Show();
					height = remainingRows * rowHeight - firstRowPixelOffset;
					bgTextureMiddle:SetHeight(height);
					bgTextureMiddle:SetTexCoord(0, 1, firstRowTexCoordOffset, (height / BG_TEXTURE_HEIGHT + firstRowTexCoordOffset));
					middleBgHeight = middleBgHeight + height;
				end
			end
			-- Position bottom texture
			bgTextureBottom:SetPoint("TOP", bgTextureMiddle:GetName(), "BOTTOM", 0, 0);
			bgTextureBottom:Show();
		end

		-- Set the frame height
		frame:SetHeight(bgTextureTop:GetHeight() + bgTextureBottom:GetHeight() + middleBgHeight);
		frame:SetWidth(CONTAINER_WIDTH);

		if itemname then
			_G[frame:GetName() .. "Name"]:SetText(itemname);
			_G[frame:GetName() .. "Name"]:SetJustifyH("CENTER");
		else
			_G[frame:GetName() .. "Name"]:SetText("GHI");
			_G[frame:GetName() .. "Name"]:SetJustifyH("LEFT");
		end
	end

	local portraitButton = _G[frame:GetName() .. "PortraitButton"];
	local portrait = frame:GetName() .. "Portrait";
	if not (frame.customIcon) then
		frame.customIcon = CreateFrame("Frame", portrait .. "custom", portraitButton, "GHM_RoundIconHalf_Template");
		frame.customIcon:SetPoint("TOPLEFT", portraitButton, "TOPLEFT", 0.5, -1.5);
	end

	if icon then
		if string.find(strlower(icon), "interface\\icons\\") then
			SetPortraitToTexture(portrait, icon);
			frame.customIcon:Hide();
		else
			--GHI_Message("Setting up unofficial icon");
			SetPortraitToTexture(portrait, nil);
			frame.customIcon.SetIcon(frame.customIcon, icon);
			frame.customIcon:Show();
		end
	else
		SetPortraitToTexture(portrait, "Interface\\Buttons\\Button-Backpack-Up");
		frame.customIcon:Hide();
	end

	for j = 1, size, 1 do
		local index = size - j + 1;
		local itemButton = _G[name .. "Item" .. j];
		itemButton:SetID(j);
		if (j == 1) then
			-- Anchor the first item differently if its the backpack frame
			if (id == 0) then
				itemButton:SetPoint("BOTTOMRIGHT", name, "BOTTOMRIGHT", -12, 30);
			else
				itemButton:SetPoint("BOTTOMRIGHT", name, "BOTTOMRIGHT", -12, 9);
			end
		else
			if (mod((j - 1), columns) == 0) then
				itemButton:SetPoint("BOTTOMRIGHT", name .. "Item" .. (j - columns), "TOPRIGHT", 0, 4);
			else
				itemButton:SetPoint("BOTTOMRIGHT", name .. "Item" .. (j - 1), "BOTTOMLEFT", -5, 0);
			end
		end

		local cooldownFrame = _G[itemButton:GetName() .. "Cooldown"];
		CooldownFrame_SetTimer(cooldownFrame, GetTime() - (1), 1, 1); -- fixes cooldown frames not initializing correctly

		itemButton:Show();
	end
	for j = size + 1, MAX_CONTAINER_ITEMS, 1 do
		_G[name .. "Item" .. j]:Hide();
	end

	-- Set up button for drag
	local btn = _G[name.."Plate"];
	btn:RegisterForDrag("LeftButton")
	btn:SetMovable();
	btn.main = frame;

	btn:SetScript("OnUpdate", function(b) if b.drag then GHI_DragContainer(b.main) end end)
	btn:SetScript("OnDragStart", function(b) b.drag = true; GHI_DragContainer(b.main,1) end)
	btn:SetScript("OnDragStop", function(b) b.drag = false; GHI_DragContainer(b.main,2) end)
end

function GHI_ToggleBackpack()
	if mainBagFrame:IsShown() then
		mainBagFrame:Hide();
	else
		mainBagFrame:Show();
	end
end

function GHI_ContainerFrame_OnShow(self)
	PlaySound("igBackPackOpen");
	GHI_UpdateContainerFrameAnchors();
	GHI_ContainerFrame_Update(self)
end

function GHI_ContainerFrame_Update(frame)
	local guid = frame.guid;
	local frameName = frame:GetName();

	for j = 1, frame.size, 1 do
		local itemButton = _G[frameName .. "Item" .. j];
		local itemGuid, texture, count, locked = api.GHI_GetContainerItemInfo(guid, j);

		SetItemButtonTexture(itemButton, texture);
		SetItemButtonCount(itemButton, count);
		SetItemButtonDesaturated(itemButton, locked, 0.5, 0.5, 0.5);
		itemButton.containerGuid = guid;
		itemButton.slotID = j;

		if (itemGuid) then
			GHI_ContainerFrame_UpdateCooldown(itemGuid, itemButton);
			itemButton.hasItem = 1;
		else
			_G[frameName .. "Item" .. j .. "Cooldown"]:Hide();
			itemButton.hasItem = nil;
		end
	end
end

function GHI_ContainerFrame_UpdateCooldown(itemGuid, button)
	local cooldownFrame = _G[button:GetName() .. "Cooldown"];
	if not (itemGuid) or not (button) then
		return
	end

	local total, elapsed = api.GHI_GetStackCooldown(button.containerGuid,button.slotID);

	if not(elapsed) or elapsed > total then
		cooldownFrame:Hide();
		return;
	end

	CooldownFrame_SetTimer(cooldownFrame, GetTime() - (elapsed), total, 1);
end

function GHI_ContainerFrameItemButton_OnLoad(self)
	self:RegisterForDrag("LeftButton", "RightButton");
	self:RegisterForClicks("AnyUp");
end

function GHI_ContainerFrameItemButton_OnEnter(self)
	if (self:GetRight() >= (GetScreenWidth() / 2)) then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT");
	else
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	end

	local showInspectionDetails = false;
	local _, _, cursorType = miscApi.GHI_GetCurrentCursor();
	if cursorType == "GHI_INSPECT" then
		showInspectionDetails = true;
	end

	api.GHI_DisplayContainerItemTooltip(self.containerGuid, self.slotID, GameTooltip, self, showInspectionDetails);
end

function GHI_ContainerFrameItemButton_OnUpdate(self, elapsed)
	if GameTooltip:GetOwner() == self then
		local showInspectionDetails = false;
		local _, _, cursorType = miscApi.GHI_GetCurrentCursor();
		if cursorType == "GHI_INSPECT" then
			showInspectionDetails = true;
		end

		api.GHI_DisplayContainerItemTooltip(self.containerGuid, self.slotID, GameTooltip, self, showInspectionDetails);
	end
end

function GHI_ContainerFrameItemButton_OnClick(self, button)
	local cursor, clickFunc = GHI_CursorHandler().GetCursor();
	if button == "LeftButton" then
		if (IsShiftKeyDown() and not (cursor)) then
			local itemGuid, texture, itemCount, locked = api.GHI_GetContainerItemInfo(self.containerGuid, self.slotID);
			local link = miscApi.GHI_GenerateLink(itemGuid,self.containerGuid, self.slotID);
			if (not (ChatEdit_InsertLink(link))) then
				if (not locked) then
					self.SplitStack = function(button, amount)
						api.GHI_SplitContainerItem(self.containerGuid, self.slotID, amount);
					end
					OpenStackSplitFrame(itemCount-1, self, "BOTTOMRIGHT", "TOPRIGHT");
				end
			end
		elseif not (cursor) or (cursor == "GHI_ITEM") then
			api.GHI_PickupContainerItem(self.containerGuid, self.slotID)
		elseif cursor == "SELECT_GHI_ITEM" then
			local guid = api.GHI_GetContainerItemInfo(self.containerGuid, self.slotID)
			if type(clickFunc) == "function" then
				clickFunc(guid,self);
			end
		end
	elseif button == "RightButton" then
		if IsControlKeyDown() then
			api.GHI_DisplayAttributeAndInstanceInfo(self.containerGuid, self.slotID);
		else
			api.GHI_UseItem(self.containerGuid, self.slotID);
		end
	end
end


