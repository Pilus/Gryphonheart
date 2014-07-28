--===================================================
--
--				GHI_AdvancedItemMenu
--  			GHI_AdvancedItemMenu.lua
--
--	Menu for creation of advanced items
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local UnitName = UnitName;
local UnitGUID = UnitGUID;
local stackOrders = {"last","first","biggest","smallest"};

function GHI_AdvancedItemMenu()
	local class = GHClass("GHI_AdvancedItemMenu");

	local menuFrame, itemTooltip, item, edit, UpdateTooltip;
	local itemList = GHI_ItemInfoList();
	local containerList = GHI_ContainerList();
	local guidCreator = GHI_GUID();
	local miscApi = GHI_ActionAPI().GetAPI();
	local inUse = false;
	local loc = GHI_Loc()

	local attributeMenu, UpdateAttributeList, attributeList;
	local updateSequenceMenu, UpdateUpdateSequenceList, updateSequenceList;
	local tooltipMenu, UpdateTooltipList, tooltipList;

	local menuIndex = 1;
	while _G["GHI_Advanced_Item_Menu" .. menuIndex] do menuIndex = menuIndex + 1; end

	local UpdateMenu = function()
		local name, icon, quality, stackSize = item.GetItemInfo();
		local white1, white2, comment, useText = item.GetFlavorText();
		menuFrame.ForceLabel("name", name);
		menuFrame.ForceLabel("white1", white1);
		menuFrame.ForceLabel("white2", white2);
		menuFrame.ForceLabel("comment", comment);
		menuFrame.ForceLabel("quality", quality);
		menuFrame.ForceLabel("icon", icon);
		menuFrame.ForceLabel("stackSize", stackSize);
		menuFrame.ForceLabel("copyable", item.IsCopyable());
		menuFrame.ForceLabel("editable", item.IsEditable());
		menuFrame.ForceLabel("useText", useText);
		menuFrame.ForceLabel("consumed", item.IsConsumed());
		menuFrame.ForceLabel("cooldown", item.GetCooldown());

		menuFrame.GetLabelFrame("dynamicActions").SetDynamicActionInstanceSet(item.GetDynamicActionSet());

		attributeList.Clear();
		local stackOrder = item.GetStackOrder();
		for i,v in pairs(stackOrders) do
			if stackOrder == v then
				menuFrame.ForceLabel("stackOrder", i);
			end
		end

		UpdateAttributeList();
		UpdateUpdateSequenceList();
		UpdateTooltipList();
	end

	local SetupWithEditItem = function()
		inUse = true;
		edit = true;

		assert(item.GetItemComplexity() == "advanced","Editing non advanced item.",item.GetItemComplexity());

		UpdateMenu();
		UpdateTooltip();
	end

	local SetupWithNewItem = function()
		inUse = true;
		edit = false;
		if not(item) then
			item = GHI_ItemInfo({
				authorName = UnitName("player"),
				authorGuid = UnitGUID("player"),
				guid = guidCreator.MakeGUID(),
				itemComplexity = "advanced",
			});
		end

		UpdateMenu();
		UpdateTooltip();
	end

	UpdateTooltip = function()
		if item then
			local lines = item.GetTooltipLines();

			ShowUIPanel(itemTooltip);
			if (not itemTooltip:IsShown()) then
				itemTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
			end

			itemTooltip:ClearLines();
			for _, line in pairs(lines) do
				itemTooltip:AddLine(line.text, line.r, line.g, line.b, true);
			end
			itemTooltip:Show()

			itemTooltip:SetWidth(245)
			itemTooltip:SetHeight(min(itemTooltip:GetHeight(), 180));
		end
	end

	local OnOk = function()
		item.IncreaseVersion(true);
		itemList.UpdateItem(item);
		if not (edit) then
			containerList.InsertItemInMainBag(item.GetGUID());
		end
		menuFrame:Hide();
		GHI_MiscData.lastUpdateItemTime = GetTime();
	end

	local disabled = {};
	local UpdateDisabledFields = function()
		for label,_ in pairs(disabled) do
			local f = menuFrame.GetLabelFrame(label);
			f.Enable();
		end

		disabled = {};
		if item then
			local set = item.GetDynamicActionSet();
			local guids = set.GetInstanceGuids();
				for _,guid in pairs(guids) do
					local action = set.GetInstance(guid).GetAction();
				for _,v in pairs({action.RequiredDisabledMenuElements()}) do
					local f = menuFrame.GetLabelFrame(v.label);
					f.Force(v.value);
					f.Disable();
					disabled[v.label] = true;
				end

			end
		end
	end

	menuFrame = GHM_NewFrame(class, {
		{
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.NAME;
					label = "name",
					texture = "Tooltip",
					OnTextChanged = function(self)
						item.SetName(self:GetText())
						UpdateTooltip();
					end,
				},
				{
					type = "Dummy",
					height = 10,
					width = 10,
					align = "r",
					label = "itemTooltipAnchor",
				},
			},
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.WHITE_TEXT_1;
					label = "white1",
					texture = "Tooltip",
					OnTextChanged = function(self)
						item.SetWhite1(self:GetText())
						UpdateTooltip();
					end,
				},
			},
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.WHITE_TEXT_2;
					label = "white2",
					texture = "Tooltip",
					OnTextChanged = function(self)
						item.SetWhite2(self:GetText())
						UpdateTooltip();
					end,
				},
			},
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.YELLOW_QUOTE;
					label = "comment",
					texture = "Tooltip",
					OnTextChanged = function(self)
						item.SetComment(self:GetText())
						UpdateTooltip();
					end,
				},
			},
			{
				{
					type = "Dummy",
					height = 80,
					width = 10,
					align = "r",
				},
				{
					align = "r",
					type = "QualityDD",
					text = loc.QUALITY;
					tooltip = loc.QUALITY_TT;
					label = "quality",
					width = 150,
					OnValueChanged = function(newValue)
						item.SetQuality(newValue);
						UpdateTooltip();
					end,
				},
				{
					type = "Icon",
					text = loc.ICON,
					align = "c",
					label = "icon",
					framealign = "r",
					CloseOnChoosen = true,
					OnChanged = function(icon)
						item.SetIcon(icon);
					end
				},
				{
					type = "CheckBox",
					text = loc.COPYABLE,
					align = "l",
					label = "copyable",
					OnClick = function(self)
						item.SetCopyable(self:GetChecked());
					end,
				},
			},
			{
				{
					type = "Slider",
					text = loc.STACK_SIZE,
					align = "c",
					label = "stackSize",
					values = {1,5,10,20,50,100},
					width = 100,
					OnValueChanged = function(frame,size)
						if item then
							item.SetStackSize(size);
						end
					end,
				},
				{
					type = "CheckBox",
					text = loc.EDITABLE,
					align = "l",
					label = "editable",
					OnClick = function(self)
						item.SetEditable(self:GetChecked());
					end,
				},
			},
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.USE;
					label = "useText",
					texture = "Tooltip",
					OnTextChanged = function(self)
						item.SetUseText(self:GetText())
						UpdateTooltip();
					end,
				},
				{
					type = "Time",
					text = loc.ITEM_CD,
					align = "r",
					label = "cooldown",
					OnValueChanged = function(cd)
						item.SetCooldown(cd);
					end,
				},
				{
					type = "Dummy",
					height = 10,
					width = 30,
					align = "r",
				},
				{
					type = "CheckBox",
					text = loc.CONSUMED,
					align = "r",
					label = "consumed",
					OnClick = function(self)
						item.SetConsumed(self:GetChecked());
					end
				},
			},
			{
				{
					type = "Text",
					text = loc.ADV_DESCRIPTIONS,
					align = "l",
					color = "white",
					width = 500,
				},
			},
		},
		{
			--- page2
			{
				{
					type = "Text",
					fontSize = 12,
					text = loc.DYN_ACTIONS,
					align = "l",
					color = "yellow",
					width = 200,
				},
			},
			{
				{
					type = "DynamicActionArea",
					align = "c",
					label = "dynamicActions",
					OnChangeFunc = function()
						UpdateDisabledFields();
					end
				},
			},
			{
				{
					type = "Text",
					text = loc.DYN_ACTIONS_TEXT,
					align = "l",
					color = "white",
					width = 500,
				},
			},
			help = "Dynamic_Actions"
		},
		--page 3
		{
			{
				{
					type = "Text",
					fontSize = 12,
					text = loc.ITEM_ATTRI,
					align = "l",
					color = "yellow",
					width = 200,
				},
			},
			{
				{
					type = "List",
					lines = 4,
					align = "l",
					label = "attributeList",
					column = {
						{
							type = "Text",
							catagory = loc.ATTRI_NAME,
							width = 110,
							label = "attName",
						},
						{
							type = "Text",
							catagory = loc.ATTRI_TYPE,
							width = 70,
							label = "attType",
						},
						{
							type = "Text",
							catagory = loc.ATTRI_DVAL,
							width = 110,
							label = "attValue",
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 20,
							label = "edit",
							onClick = function(selected)
								attributeMenu.Edit(item, selected.attribute, UpdateAttributeList);
							end,
							normalTexture = "Interface/GossipFrame/HealerGossipIcon",
							normalTexCoords = { -0.1, 1.1, -0.1, 1.1 },
							pushedTexture = "Interface/GossipFrame/HealerGossipIcon",
							pushedTexCoords = { -0.06, 1.14, -0.14, 1.06 },
							tooltip = loc.ATTRI_EDIT_TIP,
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 20,
							label = "delete",
							onClick = function(selected)
								item.RemoveAttribute(selected.attribute);
								UpdateAttributeList();
							end,
							normalTexture = "Interface/BUTTONS/UI-Panel-MinimizeButton-Up",
							normalTexCoords = { 0.1, 0.9, 0.1, 0.9 },
							pushedTexture = "Interface/BUTTONS/UI-Panel-MinimizeButton-Down",
							pushedTexCoords = { 0.1, 0.9, 0.1, 0.9 },
							tooltip = loc.ATTRI_DELETE_TIP,
						},
					},
					OnLoad = function(obj)
						obj:SetBackdropColor(0, 0, 0, 0.5);
					end,
					OnMarked = UpdateAttributeList,
				},
				{
					type = "RadioButtonSet",
					texture = "Tooltip",
					label = "stackOrder",
					align = "r",
					text = loc.STACK_ORDER_TEXT,
					data = {loc.STACK_ORDER_LAST,loc.STACK_ORDER_FIRST,loc.STACK_ORDER_BIGGEST,loc.STACK_ORDER_SMALLEST},
					returnIndex = true,
					OnSelect = function(i)
						item.SetStackOrder(stackOrders[i]);
					end,
				},
			},
			{
				{
					type = "Button",
					text = "  " .. loc.ATTRI_ADD .. "  ",
					align = "l",
					label = "newAttrButton",
					compact = true,
					OnClick = function() attributeMenu.New(item, UpdateAttributeList); end,
				},
			},
			{
				{
					type = "List",
					lines = 5,
					align = "l",
					label = "tooltipList",
					column = {
						{
							type = "Text",
							catagory = loc.ATTRI_NAME,
							width = 80,
							label = "name",
						},
						{
							type = "Text",
							catagory = loc.TIP_ALIGN,
							width = 40,
							label = "alignLoc",
						},
						{
							type = "Text",
							catagory = loc.TIP_DETAIL,
							width = 130,
							label = "detail",
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 20,
							label = "up",
							onClick = function(selected)
								item.RaiseTooltip(selected.sequence);
								UpdateTooltipList();
							end,
							normalTexture = "Interface/BUTTONS/UI-MicroStream-Yellow",
							normalTexCoords = { 1.0, 0.0, 1.0, 0.0 },
							pushedTexture = "Interface/BUTTONS/UI-MicroStream-Yellow",
							pushedTexCoords = { 1.0, 0.0, 1.0, 0.1 },
							hideOnNil = true,
							tooltip = loc.TIP_LINE_RAISE_TEXT,
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 20,
							label = "down",
							onClick = function(selected)
								item.LowerTooltip(selected.sequence);
								UpdateTooltipList();
							end,
							normalTexture = "Interface/BUTTONS/UI-MicroStream-Yellow",
							normalTexCoords = { 0.0, 1.0, 0.0, 1.0 },
							pushedTexture = "Interface/BUTTONS/UI-MicroStream-Yellow",
							pushedTexCoords = { 0.0, 1.0, -0.1, 1.0 },
							hideOnNil = true,
							tooltip = loc.TIP_LINE_LOWER_TEXT,
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 20,
							label = "edit",
							onClick = function(selected)
								tooltipMenu.Edit(item, selected.sequence, selected.name, selected.align, selected.order, UpdateTooltipList);
							end,
							normalTexture = "Interface/GossipFrame/HealerGossipIcon",
							normalTexCoords = { -0.1, 1.1, -0.1, 1.1 },
							pushedTexture = "Interface/GossipFrame/HealerGossipIcon",
							pushedTexCoords = { -0.06, 1.14, -0.14, 1.06 },
							hideOnNil = true,
							tooltip = loc.TIP_LINE_EDIT_TEXT,
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 20,
							label = "delete",
							onClick = function(selected)
								item.RemoveTooltip(selected.sequence);
								UpdateTooltipList();
							end,
							normalTexture = "Interface/BUTTONS/UI-Panel-MinimizeButton-Up",
							normalTexCoords = { 0.1, 0.9, 0.1, 0.9 },
							pushedTexture = "Interface/BUTTONS/UI-Panel-MinimizeButton-Down",
							pushedTexCoords = { 0.1, 0.9, 0.1, 0.9 },
							hideOnNil = true,
							tooltip = loc.TIP_LINE_DELETE_TEXT,
						},
					},
					OnLoad = function(obj)
						obj:SetBackdropColor(0, 0, 0, 0.5);
					end,
					OnMarked = UpdateTooltipList,
				},
				{
					type = "List",
					lines = 5,
					align = "r",
					label = "updateSequenceList",
					column = {
						{
							type = "Text",
							catagory = loc.SEQ_FREQUENCY,
							width = 70,
							label = "updateSequenceFrequency",
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 20,
							label = "edit",
							onClick = function(selected)
								updateSequenceMenu.Edit(item, selected.sequence, selected.frequency, UpdateUpdateSequenceList);
							end,
							normalTexture = "Interface/GossipFrame/HealerGossipIcon",
							normalTexCoords = { -0.1, 1.1, -0.1, 1.1 },
							pushedTexture = "Interface/GossipFrame/HealerGossipIcon",
							pushedTexCoords = { -0.06, 1.14, -0.14, 1.06 },
							tooltip = loc.SEQ_EDIT_TIP,
						},
						{
							type = "CustomButton",
							catagory = "",
							width = 20,
							label = "delete",
							onClick = function(selected)
								item.RemoveUpdateSequence(selected.sequence);
								UpdateUpdateSequenceList();
							end,
							normalTexture = "Interface/BUTTONS/UI-Panel-MinimizeButton-Up",
							normalTexCoords = { 0.1, 0.9, 0.1, 0.9 },
							pushedTexture = "Interface/BUTTONS/UI-Panel-MinimizeButton-Down",
							pushedTexCoords = { 0.1, 0.9, 0.1, 0.9 },
							tooltip = loc.SEQ_DELETE_TIP,
						},
					},
					OnLoad = function(obj)
						obj:SetBackdropColor(0, 0, 0, 0.5);
					end,
					OnMarked = UpdateUpdateSequenceList,
				},
			},
			{
				{
					type = "Button",
					text = "  " .. loc.SEQ_ADD_TOOLTIP .. "  ",
					align = "l",
					label = "newTiptButton",
					compact = true,
					OnClick = function() tooltipMenu.New(item, UpdateTooltipList); end,
				},
				{
					type = "Button",
					text = "  " .. loc.SEQ_ADD_UPDATE .. "  ",
					align = "r",
					label = "newAttrScriptButton",
					compact = true,
					OnClick = function() updateSequenceMenu.New(item, UpdateUpdateSequenceList); end,
				},
			},
			{
				{
					type = "Text",
					text = loc.ATTRI_TEXT,
					align = "l",
					color = "white",
					width = 500,
				},
			},
			help = "Using_attributes",
		},
		title = loc.CREATE_TITLE_ADV,
		name = "GHI_Advanced_Item_Menu" .. menuIndex,
		theme = "BlankWizardTheme",
		width = 500,
		height = 440,
		useWindow = true,
		OnShow = UpdateTooltip,
		OnOk = OnOk,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	});

	---------------------------------------------------------------------------------------------------------
	-- Attribute Menu
	---------------------------------------------------------------------------------------------------------
	attributeMenu = GHI_AttributeMenu();
	attributeList = menuFrame.GetLabelFrame("attributeList");

	UpdateAttributeList = function()
		if item then
			local attributes = item.GetAllAttributes();
			for _, attribute in pairs(attributes) do
				local name = attribute.GetName();
				local attType = attribute.GetType();
				local defaultVal = attribute.GetDefaultValue();

				local typeName = loc["ATTYPE_" .. attType:upper()] or attType;

				local existsAlready = false;
				for j = 1, attributeList.GetTubleCount() do
					local t = attributeList.GetTuble(j);
					if attribute == t.attribute then
						t.attName = name;
						t.attType = typeName;
						t.attValue = GHM_Input_ToString(attType,defaultVal);
						existsAlready = true;
						attributeList.SetTuble(j, t);
						break;
					end
				end

				if existsAlready == false then
					local t = {
						attName = name,
						attType = typeName,
						attValue = GHM_Input_ToString(attType,defaultVal),
						attribute = attribute,
					};
					attributeList.SetTuble(attributeList.GetTubleCount() + 1, t)
				end
			end

			-- delete all that doesn't exist
			local total = attributeList.GetTubleCount();
			local newData = {};
			for j = 1, total do
				local t = attributeList.GetTuble(j);
				for _, attribute in pairs(attributes) do
					if t.attribute == attribute then
						table.insert(newData, t);
						break;
					end
				end
			end
			attributeList.data = newData;
			attributeList.UpdateAll()
			if attributeList.label then
				menuFrame.SetLabel(attributeList.label, attributeList.data);
			end
		end
	end

	attributeList:SetScript("OnShow", UpdateAttributeList);

	---------------------------------------------------------------------------------------------------------
	-- Update Sequence Menu
	---------------------------------------------------------------------------------------------------------
	updateSequenceMenu = GHI_UpdateSequenceMenu();
	updateSequenceList = menuFrame.GetLabelFrame("updateSequenceList");

	UpdateUpdateSequenceList = function()
		if item then
			local sequences = item.GetAllUpdateSequences();
			for _, s in pairs(sequences) do
				local sequence = s.sequence;
				local frequency = s.frequency;
				local freqName = loc["SEQ_FREQUENCY_" .. string.upper(frequency)];
				local existsAlready = false;
				for j = 1, updateSequenceList.GetTubleCount() do
					local t = updateSequenceList.GetTuble(j);
					if sequence == t.sequence then
						t.updateSequenceFrequency = freqName;
						t.frequency = frequency;
						t.sequence = sequence;
						existsAlready = true;
						updateSequenceList.SetTuble(j, t);
						break;
					end
				end

				if existsAlready == false then
					local t = {
						updateSequenceFrequency = freqName,
						sequence = sequence,
						frequency = frequency,
					};
					updateSequenceList.SetTuble(updateSequenceList.GetTubleCount() + 1, t)
				end
			end

			-- delete all that doesn't exist
			local total = updateSequenceList.GetTubleCount();
			local newData = {};
			for j = 1, total do
				local t = updateSequenceList.GetTuble(j);
				for _, s in pairs(sequences) do
					if t.sequence == s.sequence then
						table.insert(newData, t);
						break;
					end
				end
			end
			updateSequenceList.data = newData;
			updateSequenceList.UpdateAll()
			if updateSequenceList.label then
				menuFrame.SetLabel(updateSequenceList.label, updateSequenceList.data);
			end
		end
	end

	updateSequenceList:SetScript("OnShow", UpdateUpdateSequenceList);

	---------------------------------------------------------------------------------------------------------
	-- Tooltip Menu
	---------------------------------------------------------------------------------------------------------
	tooltipMenu = GHI_TooltipMenu();
	tooltipList = menuFrame.GetLabelFrame("tooltipList");

	UpdateTooltipList = function()
		if item then
			local lines = item.GetTooltipListInfo();
			for i, line in pairs(lines) do
				tooltipList.SetTuble(i, line);
			end
			for i = #(lines) + 1, tooltipList.GetTubleCount() do
				tooltipList.SetTuble(i, nil);
			end
			tooltipList.UpdateAll()
		end
	end
	tooltipList:SetScript("OnShow", UpdateTooltipList);



	---------------------------------------------------------------------------------------------------------
	-- Creation functions
	---------------------------------------------------------------------------------------------------------

	class.IsInUse = function() return inUse end

	class.GetItemGuid = function()
		return item.GetGUID();
	end

	class.New = function(itemInProgress)
		menuFrame.SetPage(1);
		menuFrame:Show();
		item = itemInProgress;

		SetupWithNewItem();
	end

	class.Edit = function(editItem)
		if type(editItem) == "string" then
			editItem = itemList.GetItemInfo(editItem);
		end

		if not (editItem.IsEditable() or editItem.IsCreatedByPlayer()) then
			GHI_Message(loc.CAN_NOT_EDIT);
			menuFrame:Hide();
			return
		end

		item = editItem.CloneItem();

		menuFrame.SetPage(1);
		menuFrame:AnimatedShow();

		edit = true;
		SetupWithEditItem();
	end

	itemTooltip = CreateFrame("GameTooltip", "GHI_AdvancedItemMenuItemTooltip" .. menuIndex, menuFrame.GetLabelFrame("itemTooltipAnchor"), "GHI_StandardItemMenuItemTooltip");
	_G["GHI_AdvancedItemMenuItemTooltip" .. menuIndex .. "TextLabel"]:SetText(loc.PREVIEW)

	itemTooltip:SetPoint("TOPRIGHT", 0, 0)
	itemTooltip:GetParent():SetScript("OnShow", function() UpdateTooltip(); end)
	menuFrame.window:AddScript("OnMinimize", function()
		if menuFrame.iconFrame then
			menuFrame.iconFrame:Hide();
		end
	end);

	return class;
end
