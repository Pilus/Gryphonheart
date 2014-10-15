--===================================================
--
--				GHI_SimpleItemMenu
--				GHI_SimpleItemMenu.lua
--
--		Simple menu for creation of standard items
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local UnitName = UnitName;
local GHUnitGUID = GHUnitGUID;
local loc = GHI_Loc()

local simpleActions = {
	{ "book", loc.TITLE_TEXT, "Interface\\ICONS\\INV_Misc_Book_08", loc.BOOK },
	{ "bag", loc.BAG_TEXT, "Interface\\ICONS\\INV_Misc_Bag_08", loc.BAG },
	{ "say", loc.SM_SAY, "Interface\\ICONS\\Ability_Warrior_CommandingShout", loc.SAY },
	{ "emote", loc.SM_EMOTE, "Interface\\Icons\\Ability_Rogue_Disguise", loc.EMOTE },
	{ "sound", loc.SM_SOUND, "Interface\\ICONS\\INV_Misc_Drum_04", loc.SOUND},
	{ "message",loc.MSG_TEXT, "Interface\\ICONS\\INV_Misc_Note_04", loc.MESSAGE_TEXT_U },
	{ "buff", loc.BUFF_TEXT, "Interface\\ICONS\\Ability_Paladin_BeaconofLight", loc.BUFF },
	{ "equip_item", loc.EQUIP_ITEM_TEXT, "Interface\\ICONS\\INV_Misc_EngGizmos_swissArmy", loc.EQUIP_ITEM },
	{ "screen_effect", loc.SCREEN_EFFECT_TEXT, "Interface\\ICONS\\INV_MISC_FILM_01", loc.SCREEN_EFFECT },
	{ "none", loc.SM_NONE, "Interface\\ICONS\\INV_Misc_Dice_02", loc.NONE },
};

function GHI_SimpleItemMenu()
	local class = GHClass("GHI_SimpleItemMenu");
	local menuFrame, itemTooltip, item, edit, UpdateTooltip;
    local buttonList = {}
	local menuIndex = 1;
	
	-- Pages
	local page2, bagPage, bookPage, sayPage, emotePage, soundPage, messagePage, buffPage, equipPage, screenEffPage

	-- Item Setup Stuff
	local itemList = GHI_ItemInfoList();
	local containerList = GHI_ContainerList();
	local guidCreator = GHI_GUID();
	local miscAPI = GHI_MiscAPI().GetAPI();
	local inUse = false;
	local selAct = 10

	-- Default Action Selection
	local actionSelection = {"none",loc.NONE}

	-- Color and Texture Info
	local textures = { "-Normal", "-Bank", "-Keyring" };
	local textures_loc = { loc.NORMAL, loc.BANK, loc.KEYRING };
	local fonts = {}
	local fontIndex = 1
	for i,v in pairs(GHI_FontList) do
		local newFont = {}
		newFont.value = fontIndex
		newFont.font = v
		newFont.fontSize = 14
		newFont.text = i
		tinsert(fonts, newFont)
		fontIndex = fontIndex + 1
	end
    
	while _G["GHI_Simple_Item_Menu" .. menuIndex] do menuIndex = menuIndex + 1; end
	
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
		menuFrame.ForceLabel("useText", useText);
		menuFrame.ForceLabel("consumed", item.IsConsumed());
		menuFrame.ForceLabel("cooldown", item.GetCooldown());
	end

	local SetupWithEditItem = function()
		inUse = true;
		edit = true;

		UpdateMenu();
		UpdateTooltip();
	end

	local SetupWithNewItem = function()
		inUse = true;
		edit = false;
		actionSelection = {"none",loc.NONE}
		menuFrame.ForceLabel("name", "");
		menuFrame.ForceLabel("white1", "");
		menuFrame.ForceLabel("white2", "");
		menuFrame.ForceLabel("comment", "");
		menuFrame.ForceLabel("quality", 2);
		menuFrame.ForceLabel("icon", nil);
		menuFrame.ForceLabel("stackSize", 1);
		menuFrame.ForceLabel("useText", "");
		menuFrame.ForceLabel("consumed", false);
		menuFrame.ForceLabel("cooldown", 1);
		for i,v in pairs(buttonList) do
			v.selHigh:Hide()
		end
		item = GHI_ItemInfo({
			authorName = UnitName("player"),
			authorGuid = GHUnitGUID("player"),
			guid = guidCreator.MakeGUID();
		});
		UpdateMenu();
		UpdateTooltip();
	end

	UpdateTooltip = function()
		if item then
			local lines = item.GetTooltipLines();

			if (not itemTooltip:IsShown()) then
				itemTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
			end

			itemTooltip:ClearLines();
			for _, line in pairs(lines) do
				itemTooltip:AddLine(line.text, line.r, line.g, line.b, true);
			end
			if page2:IsShown() then
				itemTooltip:Show()
			else
				itemTooltip:Hide()
			end
			itemTooltip:SetWidth(245)
			itemTooltip:SetHeight(min(itemTooltip:GetHeight(), 180));
		end
	end
	
	local stationary = {
		["Auction"] = "Parchment",
		["Orc"] = "Parchment",
		["Tauren"] = "Parchment",
		["Forsaken"] = "Parchment",
		["Illidari"] = "Stone",
		["Winter"] = "Parchment",
		["Vellum"] = "Parchment",
	}

	local actionToAdd = {}

	local actionPropertiesList = {
		{title = "bookTitle",pages = "bookText",material = "bookMaterial",font = "bookFont",n = "nSize",h1 = "h1Size",h2 = "h2Size",}, -- Book
		{size = "bag_size",texture = "bag_texture",}, -- Bag
		{text = "say_text",delay = "say_delay",}, -- Say
		{text = "emote_text",delay = "emote_delay",}, -- Emote
		{sound_path = "simple_currentSound",delay = "sound_delay",range = "sound_range",}, -- Sound
		{text = "mess_text",color = "mess_color",delay = "mess_delay",output_type = "mess_type",}, -- Message
		{buffName = "buff_name",buffDetails = "buff_details", buffDuration = "buff_duration", untilCanceled = "until_canceled", castOnSelf = "castOnSelf", filter = "filter", stackable = "stackable", buffType = "buff_type",buffIcon = "buff_icon",delay = "buff_delay",amount = "buff_amount",range = "buff_range",}, -- Buff
		{item_name = "item_name",delay = "eq_delay",}, -- Equip Item
		{color = "se_color",fade_in = "fade_in",fade_out = "fade_out",duration = "se_duration",delay = "se_delay"}, -- Screen Flash
	}
	
	local defaultFormatting = function(i, v)
		actionToAdd[i] = menuFrame.GetLabel(v)
	end
	
	local SpecialFormating = {
		function(i,v)
			if i == "pages" then
				local text = menuFrame.GetLabel(v)
				for i2,v2 in pairs(text) do
					local page = {}
					page.text1 = v2
					table.insert(actionToAdd, i2 ,page)
				end
				actionToAdd["pages"] = #text
			elseif i == "material" then
				local extraMat
				local mat = menuFrame.GetLabel(v)
				for stationary,material in pairs(stationary) do
					if mat == stationary then
						actionToAdd["material"] = material
						actionToAdd["extraMat"] = stationary
					else
						actionToAdd["material"] = mat
					end
				end
				
			else
				defaultFormatting(i,v)
			end
		end,
		function(i,v)
			if i == "texture" then
				local textures = { "-Normal", "-Bank", "-Keyring" }
				actionToAdd[i] = textures[menuFrame.GetLabel(v)]
			else
				defaultFormatting(i,v)
			end
		end,
		defaultFormatting,
		defaultFormatting,
		defaultFormatting,
		defaultFormatting,
		function(i,v)
			if i == "filter" then
				local filter = menuFrame.GetLabel(v);
				actionToAdd[i] = filter
			elseif i == "buffType" then
				local deBuffTypes = {"Magic", "Curse","Disease", "Poison", "Physical"}
				actionToAdd[i] = deBuffTypes[menuFrame.GetLabel(v)]
			else
				defaultFormatting(i,v)
			end
		end,
		defaultFormatting,
		function(i, v)
			if i == "color" then
				local color = menuFrame.GetLabel("se_color")
				actionToAdd["color"] = color
				actionToAdd["alpha"] = color.a
			else
				actionToAdd[i] = tonumber(menuFrame.GetLabel(v))
			end
		end,
	}
	
	local specialProperties = function(selected)
		actionToAdd["Type"] = simpleActions[selected][1]
		actionToAdd["type_name"] = simpleActions[selected][4]
		actionToAdd["icon"] = simpleActions[selected][3]
		actionToAdd["details"] = simpleActions[selected][4]
		
		if selected == 9 then
			actionToAdd["Type"] = "script"
			actionToAdd["dynamic_rc_type"] = "screen_effect"
			actionToAdd["dynamic_rc"] = true
		elseif selected == 6 then
			actionToAdd["Type"] = "script"
			actionToAdd["dynamic_rc_type"] = "message"
			actionToAdd["dynamic_rc"] = true
		else
			return
		end
	end
	
	local function AddSelectedAction(selected)
		for i,v in pairs(actionPropertiesList[selected]) do
			SpecialFormating[selected](i,v)
		end
		specialProperties(selected)
				
		local action = GHI_SimpleAction(actionToAdd);
		item.AddSimpleAction(action);
		
		actionToAdd = nil
		actionToAdd ={}
	end
    
	local OnOk = function()
		if selAct <= 9 then
			AddSelectedAction(selAct)
		end
		item.IncreaseVersion(true);
		itemList.UpdateItem(item);
		if not (edit) then
			containerList.InsertItemInMainBag(item.GetGUID());
		end
		menuFrame:Hide();
		GHI_MiscData.lastUpdateItemTime = GetTime();
	end

	local t = {
		{
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.NAME;
					tooltip = loc.NAME_TT;
					label = "name",
					texture = "Tooltip",
					OnTextChanged = function(self)
						item.SetName(self:GetText())
						UpdateTooltip();
					end,
					width = 200,
				},
			},
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.WHITE_TEXT_1;
					tooltip = loc.WHITE_TEXT_1_TT;
					label = "white1",
					texture = "Tooltip",
					OnTextChanged = function(self)
						item.SetWhite1(self:GetText())
						UpdateTooltip();
					end,
					width = 200,
				},
			},
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.WHITE_TEXT_2;
					tooltip = loc.WHITE_TEXT_2_TT;
					label = "white2",
					texture = "Tooltip",
					OnTextChanged = function(self)
						item.SetWhite2(self:GetText())
						UpdateTooltip();
					end,
					width = 200,
				},
			},
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.YELLOW_QUOTE;
					tooltip = loc.YELLOW_QUOTE_TT;
					label = "comment",
					texture = "Tooltip",
					OnTextChanged = function(self)
						item.SetComment(self:GetText())
						UpdateTooltip();
					end,
					width = 200,
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
					width = 200,
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
			},
			{
				{
					type = "Slider",
					text = loc.STACK_SIZE,
					tooltip = loc.STACK_SIZE_TT;
					align = "l",
					label = "stackSize",
					isStackSlider = true,
					OnValueChanged = function(_, size)
						if item then
							item.SetStackSize(size);
						end
					end,
				},
				{
					type = "CheckBox",
					text = loc.CONSUMED,
					align = "c",
					label = "consumed",
					OnClick = function(self)
						item.SetConsumed(self:GetChecked());
					end
				},
				{
					type = "Slider",
					text = loc.ITEM_CD,
					align = "r",
					label = "cooldown",
					isTimeSlider = true,
					OnValueChanged = function(_, cd)
						if item then
							item.SetCooldown(cd);
						end
					end,
				},
			},
		},
		title = loc.CREATE_TITLE,
		name = "GHI_Simple_Item_Menu" .. menuIndex,
		theme = "BlankWizardTheme",
		width = 500,
		height = 360,
		useWindow = true,
		OnShow = UpdateTooltip,
		OnPageChange = function(num)
			if itemTooltip then
				if num == 2 then
					UpdateTooltip();
				else
					itemTooltip:Hide();
				end
			end
		end,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	};
	t.OnOk = OnOk

	local editBagPage = {
		{
			{
				type = "Text",
				fontSize = 16,
				width = 490,
				text = loc.SM_BAG_SET,
				color = "Yellow",
				align = "l",
			},
		},
		{
			{
					type = "Dummy",
					height = 25,
					width = 1,
					align = "l",
				},
			},
			{
				{
					type = "Text",
					fontSize = 11,
					width = 490,
					text = loc.BAG_TEXT,
					color = "white",
					align = "l",
				},
			},
			{
				{
					type = "Slider",
					label = "bag_size",
					isSlotSlider = true,
					align = "l",
					text = loc.SLOTS..":",
					width = 150,
				},
				{
					type = "RadioButtonSet",
					texture = "Tooltip",
					label = "bag_texture",
					align = "r",
					text = loc.TEXTURE..":",
					data = textures_loc,
					returnIndex = true,
				},
			},
	}
	local editBookPage = {
		{
			{
				type = "Text",
				text = loc.SM_BOOK_SET,
				align = "l",
				fontSize = 16,
				color = "yellow",
				width = 490,
			},
		},
		{
			{
				type = "Editbox",
				text = loc.TITLE,
				align = "l",
				label = "bookTitle",
				texture = "Tooltip",
				width = 120,
			},
			{
				type = "DropDown",
				texture = "Tooltip",
				width = 105,
				label = "bookMaterial",
				align = "l",
				text = "Material:",
				data = {
					{ text = "Parchment",  index=1},
					{ text = "Bronze",  index=2},
					{ text = "Marble",  index=3},
					{ text = "Silver",  index=4},
					{ text = "Stone",  index=5},
					{ text = "Vellum",  index=6},
					{ text = "Auction",  index=7},
					{ text = "Orc",  index=8},
					{ text = "Tauren",  index=9},
					{ text = "Forsaken",  index=10},
					{ text = "Illidari",  index=11},
					{ text = "Winter",  index=12},
					{ text = "Valentine",  index=13},
				},
			},
			{
				type = "DropDown",
				width = 105,
				label = "bookFont",
				align = "l",
				text = "Font:",
				data = fonts,
			},
			{
				type = "Editbox",
				text = "N Size:",
				align = "l",
				label = "nSize",
				texture = "Tooltip",
				width = 40,
				startText = "15",
			},
			{
				type = "Editbox",
				text = loc.H1,
				align = "l",
				label = "h1Size",
				texture = "Tooltip",
				width = 40,
				startText = "24",
			},
			{
				type = "Editbox",
				text = loc.H2,
				align = "l",
				label = "h2Size",
				texture = "Tooltip",
				width = 40,
				startText = "19",
			},
		},
		{
			{
				type = "MultiPageEditField",
				align = "c",
				--width = 335,
				--height = 300,
				label = "bookText",
				HTMLtools = true,
				toolbarButtons = {
					{
						texture = "Interface\\Icons\\INV_Misc_Spyglass_03",
						func = function()
							local title = menuFrame.GetLabel("bookTitle")
							local text = menuFrame.GetLabel("bookText")
							local material = menuFrame.GetLabel("bookMaterial")
							local font = menuFrame.GetLabel("bookFont")
							local N = menuFrame.GetLabel("nSize")
							local H1 = menuFrame.GetLabel("h1Size")
							local H2 = menuFrame.GetLabel("h2Size")
							local extraMat
							for i,v in pairs(GHI_Stationeries) do
								if material == "Illidari" then
									extraMat = material
									material = "Stone"
								elseif material == i then
									extraMat = i
									material = "Parchment"
								end
							end
							local textFrame = menuFrame.GetLabelFrame("bookText")
							local page = textFrame.currentPage
							GHI_ShowBook("Preview",nil,title, text[page], 0, material, GHI_FontList[font], N, H1, H2, nil,nil,extraMat,nil)
						end,
						tooltip = "Preview Page",
					},
				},
			},
		},
	}
	local editSayPage = {
		{
			{
				type = "Text",
				text = loc.SM_SPEACH_SET,
				align = "l",
				fontSize = 16,
				color = "yellow",
				height = 20,
				--width = 490,
			},
		},
		{
			{
				type = "Text",
				fontSize = 11,
				height = 60,
				--width = 490,
				text = loc.SM_SPEACH_TEXT,
				color = "white",
				align = "l",
			},
		},
		{
			{
				align = "l",
				type = "Editbox",
				text = loc.TEXT;
				label = "say_text",
				--width = 390,
				texture = "Tooltip",
				OnTextChanged = function(self)
				end,
			},
			{
				align = "r",
				type = "Time",
				text = loc.DELAY;
				label = "say_delay",
				width = 80,
			},
		},
		{
			{
				type = "Text",
				fontSize = 11,
				--width = 490,
				text = loc.EXPRESSION_TIP,
				color = "white",
				align = "l",
			},
		},
	}
	local editEmotePage = {
		{
			{
				type = "Text",
				text = loc.SM_EMOTE_SET,
				align = "l",
				fontSize = 16,
				color = "yellow",
				width = 400,
			},
		},
		{
			{
				type = "Dummy",
				height = 25,
				width = 1,
				align = "c",
			},
		},
		{
			{
				align = "l",
				type = "Editbox",
				label = "emote_text",
				width = 300,
				text = loc.EMOTE,
				texture = "Tooltip",
				value = "",
			},
			{
				align = "l",
				type = "PlayButton",
				width = 40,
				yOff = -3,
				onclick = function()
					local selEmote = menuFrame.GetLabel("emote_text");
					local isStdEmote
					for key,value in pairs(GHIemoteList) do
						if value ==  string.upper(selEmote) then
							isStdEmote = true
						end
					end
					if isStdEmote then
						DoEmote(string.upper(selEmote));
					else
						SendChatMessage(selEmote, EMOTE)
					end
				end,
			},
			{
				align = "r",
				type = "Time",
				text = loc.DELAY;
				label = "emote_delay",
				tooltip = "",
				width = 80,
			},
		},
		{
				{
					type = "Dummy",
					height = 60,
					width = 10,
					align = "l",
				},
				{
					type = "Text",
					fontSize = 11,
					width = 450,
					text = loc.EXPRESSION_TIP,
					color = "white",
					align = "l",
				},
		},
	}
	local editSoundPage = {
		{
			{
				type = "Text",
				text = loc.SM_SOUND_SET,
				align = "l",
				fontSize = 16,
				color = "yellow",
				width = 400,
			},
		},
		{
			{
				align = "l",
				type = "SoundSelection",
				label = "simplesoundTree",
				--height = 180,
				texture = "Tooltip",
				OnSelect = function(path,duration)
					if not(menuFrame) then return end
					menuFrame.ForceLabel("simple_currentSound", path);


					local timeString = miscAPI.GHI_GetPreciseTimeString(duration);
					if duration == 0.05 or duration == 0 then
						timeString = "(Unknown)"
					end
					local coloredTimeString = miscAPI.GHI_ColorString(timeString, 0.0, 0.7, 0.5);

					menuFrame.ForceLabel("simple_soundDuration", coloredTimeString);

				end,
			},
		},
		{
			{
				type = "Text",
				fontSize = 11,
				width = 150,
				text = loc.CURRENTLY_SELECTED,
				color = "yellow",
				align = "l",
				singleLine = true,
			},
			{
				type = "PlayButton",
				xOff = 20,
				yOff = 5,
				align = "l",
				label = "simplePlaySound",
				onclick = function(self)
					local path = menuFrame.GetLabel("simple_currentSound")
					if path then
						PlaySoundFile(path)
					else
						print("You have not chosen a sound yet.")
					end
				end,
			},
			{
				type = "Editbox",
				texture = "Tooltip",
				label = "sound_range",
				align = "r",
				text = loc.RANGE,
				numbersOnly = true,
				width = 60,
				yOff = 40
			},
			{
				align = "r",
				type = "Time",
				text = loc.DELAY;
				label = "sound_delay",
				width = 80,
				yOff = 60,
			},
		},
		{
			{
				type = "Text",
				fontSize = 11,
				width = 400,
				--height = 50,
				text = loc.NONE,
				color = "white",
				align = "l",
				label = "simple_currentSound",
				singleLine = true,
				yOff = 6.
			},
			{
				type = "Text",
				fontSize = 11,
				width = 250,
				text = "",
				color = "white",
				yOff = -14,
				align = "l",
				label = "simple_soundDuration",
				singleLine = true,
			},
		},
	}
	local editMessagePage = {
		{
			{
				type = "Text",
				text = loc.SM_MESS_SET,
				align = "l",
				fontSize = 16,
				color = "yellow",
				width = 400,
			},
		},
			{
				{
					type = "Dummy",
					height = 25,
					width = 10,
					align = "c",
				},
			},
			{
				{
					type = "Text",
					fontSize = 11,
					text = loc.MSG_TEXT,
					align = "l",
					color = "white",
					width = 400,
				},
			},
		{
			{
				type = "Editbox",
				text = loc.TEXT,
				align = "l",
				label = "mess_text",
				width = 300,
				texture = "Tooltip",
			},
			{
				type = "Color",
				text = loc.COLOR,  --will need help localizing color as they are formated as a table, unsure on
				align = "r",
				label = "mess_color",
			},
		},
		{
			{
				type = "RadioButtonSet",
				text = loc.OUTPUT_TYPE,
				align = "c",
				yOff = -10,
				label = "mess_type",
				returnIndex = true,
				data = { loc.CHAT_FRAME, loc.ERROR_MSG_FRAME },
				texture = "Tooltip",
			},
			{
				align = "l",
				yOff = -10,
				type = "Time",
				label = "mess_delay",
				text = loc.DELAY,
				values = {0,0.5,1,2,3,4,5,10,15,20,25,30},
				startText = "0",
			},
		},
	}
	local editBuffPage = {
		{
			{
				type = "Text",
				text = loc.SM_BUFF_SET,
				align = "l",
				fontSize = 16,
				color = "yellow",
				width = 400,
			},
		},
		{
			{
				type = "Dummy",
				height = 40,
				width = 10,
				align = "l",
			},
			{
				type = "Text",
				fontSize = 11,
				width = 490,
				text = loc.BUFF_TEXT,
				color = "white",
				align = "l",
			},
		},
		{
			{
				align = "l",
				type = "Editbox",
				texture = "Tooltip",
				text = loc.BUFF_NAME,
				label = "buff_name",
				width = 300,
			},
			{
				type = "DropDown",
				texture = "Tooltip",
				width = 100,
				label = "buff_type",
				align = "l",
				text = loc.BUFF_TYPE,
				returnIndex = true,
				data = {
				{ text = loc.TYPE_MAGIC, colorCode = "\124c"..miscAPI.GHI_GetDebuffColor("Magic")},
				{ text = loc.TYPE_CURSE, colorCode = "\124c"..miscAPI.GHI_GetDebuffColor("Curse")},
				{ text = loc.TYPE_DISEASE, colorCode = "\124c"..miscAPI.GHI_GetDebuffColor("Disease")},
				{ text = loc.TYPE_POISON, colorCode = "\124c"..miscAPI.GHI_GetDebuffColor("Poison")},
				{ text = loc.TYPE_PHYSICAL, colorCode = "\124c"..miscAPI.GHI_GetDebuffColor("none")},
				},
			},
			{
				align = "r",
				type = "Icon",
				label = "buff_icon",
				frameAlign = "r",
				xOff = -100,
				yOff = -10,
				text = loc.ICON,
				CloseOnChoosen = true,
			},
		},
		{
			{
				align = "l",
				type = "Editbox",
				texture = "Tooltip",
				text = loc.BUFF_DETAILS,
				label = "buff_details",
				width = 300,
			},
			{
				type = "Editbox",
				texture = "Tooltip",
				label = "buff_range",
				align = "r",
				text = loc.RANGE,
				numbersOnly = true,
				width = 60,
			},
			{
				type = "Editbox",
				texture = "Tooltip",
				label = "buff_amount",
				align = "r",
				text = loc.AMOUNT,
				numbersOnly = true,
				width = 60,
			},
		},
		{
			{
				type = "RadioButtonSet",
				texture = "Tooltip",
				width = 110,
				label = "filter",
				align = "l",
				text = loc.BUFF_DEBUFF,
				data = {
					{ value = "Helpful", text = loc.HELPFUL},
					{ value = "Harmful", text = loc.HARMFUL},
				},
				--yOff = -10,
			},
			{
				align = "c",
				type = "CheckBox",
				text = loc.BUFF_ON_SELF,
				label = "castOnSelf",
				xOff = 100,
			},
			{
				align = "c",
				type = "CheckBox",
				text = loc.STACKABLE,
				label = "stackable",
				xOff = 92,
				yOff = 27,
			},
			{
				align = "c",
				type = "CheckBox",
				text = loc.BUFF_UNTIL_CANCELED,
				label = "until_canceled",
				xOff = 120,
				yOff = 20,
				frameAlign = "c",
			},
		},
		{
			{
				align = "l",
				type = "Time",
				text = loc.BUFF_DURATION,
				label = "buff_duration",
				yOff = -10,
			},
			{
				align = "r",
				type = "Time",
				text = loc.DELAY;
				label = "buff_delay",
				--width = 80,
				yOff = -10,
				xOff = -20,
			},

		},
		{

		},
	}
	local editEquipPage = {
		{
			{
				type = "Text",
				text = loc.SM_EQUIP_SET,
				align = "l",
				fontSize = 16,
				color = "yellow",
				width = 400,
			},
		},
		{
			{
				type = "Dummy",
				height = 25,
				width = 10,
				align = "l",
			},
		},
		{
			{
				type = "Text",
				fontSize = 11,
				width = 490,
				text = loc.EQUIP_ITEM_TEXT,
				color = "white",
				align = "l",
			},
		},
		{
			{
				align = "l",
				type = "Editbox",
				texture = "Tooltip",
				text = loc.ITEM_NAME,
				label = "item_name",
				width = 200,
			},
			{
				type = "Dummy",
				height = 10,
				width = 50,
				align = "r",
			},
			{
				align = "r",
				type = "Time",
				text = loc.DELAY;
				label = "eq_delay",
				width = 80,
			},
		},
	}
	local editScreenEffPage = {
		{
			{
				type = "Text",
				text = loc.SM_SCREEN_EFF_SET,
				align = "l",
				fontSize = 16,
				color = "yellow",
				width = 400,
			},
		},
		{
			{
				type = "Text",
				fontSize = 11,
				width = 490,
				text = loc.SCREEN_EFFECT_TEXT,
				color = "white",
				align = "l",
			},
		},
		{
			{
				type = "Color",
				text = loc.COLOR,
			   align = "l",
				label = "se_color",
			},
			{
				type = "Time",
				align = "c",
				label = "se_duration",
				text = loc.DURATION,
				values = {0,0.5,1,2,3,4,5,10,15,20,25,30},
				startText = "0",
			},
			{
				type = "Time",
				align = "r",
				label = "fade_in",
				text = loc.SCREEN_EFFECT_FADEIN,
				values = {0,0.5,1,2,3,4,5,10,15,20,25,30},
				startText = "0",
			},
		},
		{
			{
				type = "Time",
				align = "c",
				label = "se_delay",
				text = loc.DELAY,
				values = {0,0.5,1,2,3,4,5,10,15,20,25,30},
				startText = "0",
			},
			{
				type = "Time",
				align = "r",
				label = "fade_out",
				text = loc.SCREEN_EFFECT_FADEOUT,
				values = {0,0.5,1,2,3,4,5,10,15,20,25,30},
				startText = "0",
			},
		},
	}
	
	local actionPages = {bagPage, bookPage, sayPage, emotePage, soundPage, messagePage, buffPage, equipPage, screenEffPage}
	
	local activatePage = function(actionChosen)
		bagPage.active, bookPage.active, sayPage.active, emotePage.active, soundPage.active, messagePage.active, buffPage.active, equipPage.active, screenEffPage.active = false
		if actionChosen == 1 then
			bookPage.active = true
		elseif actionChosen == 2 then
			bagPage.active = true
		elseif actionChosen == 3 then
			sayPage.active = true
		elseif actionChosen == 4 then
			emotePage.active = true
		elseif actionChosen == 5 then
			soundPage.active = true
		elseif actionChosen == 6 then
			messagePage.active = true
		elseif actionChosen == 7 then
			buffPage.active = true
		elseif actionChosen == 8 then
			equipPage.active = true
		elseif actionChosen == 9 then
			screenEffPage.active = true
		end
		selAct = actionChosen
		menuFrame.UpdatePages()
	end
	
  	local selectActionPage = {
		{
			{
				type = "Text",
				text = loc.SM_SELECT,
				align = "l",
				fontSize = 12,
				width = 180,
				yOff = 0,
			},
			{
				type = "ItemButtonSet",
				align = "r",
				label = "actionChoice",
				returnIndex = true,
				defaultSelected = 10,
				OnSelect = activatePage,
				data = {
					{
						icon = simpleActions[1][3],
						name = simpleActions[1][4],
						tooltip = simpleActions[1][2],
					},
					{
						icon = simpleActions[2][3],
						name = simpleActions[2][4],
						tooltip = simpleActions[2][2],
					},
					{
						icon = simpleActions[3][3],
						name = simpleActions[3][4],
						tooltip = simpleActions[3][2],
					},
					{
						icon = simpleActions[4][3],
						name = simpleActions[4][4],
						tooltip = simpleActions[4][2],
					},
					{
						icon = simpleActions[5][3],
						name = simpleActions[5][4],
						tooltip = simpleActions[5][2],
					},
					{
						icon = simpleActions[6][3],
						name = simpleActions[6][4],
						tooltip = simpleActions[6][2],
					},
					{
						icon = simpleActions[7][3],
						name = simpleActions[7][4],
						tooltip = simpleActions[7][2],
					},
					{
						icon = simpleActions[8][3],
						name = simpleActions[8][4],
						tooltip = simpleActions[8][2],
					},
					{
						icon = simpleActions[9][3],
						name = simpleActions[9][4],
						tooltip = simpleActions[9][2],
					},
					{
						icon = simpleActions[10][3],
						name = simpleActions[10][4],
						tooltip = simpleActions[10][2],
					},
				}
			},
			
		}
	};
    
    
	table.insert(t,1,selectActionPage);
	table.insert(t,3,editBagPage);
	table.insert(t,4,editBookPage);
	table.insert(t,5,editSayPage);
	table.insert(t,6,editEmotePage);
	table.insert(t,7,editSoundPage);
	table.insert(t,8,editMessagePage);
	table.insert(t,9,editBuffPage);
	table.insert(t,10,editEquipPage);
	table.insert(t,11,editScreenEffPage);

	menuFrame = GHM_NewFrame(class, t);
	page2 = _G[menuFrame:GetName().."_P2"];
	bagPage = _G[menuFrame:GetName().."_P3"];
	bookPage = _G[menuFrame:GetName().."_P4"];
	sayPage = _G[menuFrame:GetName().."_P5"];
	emotePage = _G[menuFrame:GetName().."_P6"];
	soundPage = _G[menuFrame:GetName().."_P7"];
	messagePage = _G[menuFrame:GetName().."_P8"];
	buffPage = _G[menuFrame:GetName().."_P9"];
	equipPage = _G[menuFrame:GetName().."_P10"];
	screenEffPage = _G[menuFrame:GetName().."_P11"];

	activatePage(selAct)

	class.IsInUse = function() return inUse end
	
	class.GetItemGuid = function()
		return item.GetGUID();
	end
    
	class.New = function()
		menuFrame:AnimatedShow();
		menuFrame.SetPage(1);

		SetupWithNewItem();
	end

	class.Edit = function(guid)
		local editItem = itemList.GetItemInfo(guid);
		if not (editItem.IsEditable() or editItem.IsCreatedByPlayer()) then
			GHI_Message(loc.CAN_NOT_EDIT);
			menuFrame:Hide();
			return
		end

		item = editItem.CloneItem();

		if editItem.IsAdvanced() then
			edit = true;
			return ConvertToAdvItem();
		end

		menuFrame:AnimatedShow();
		menuFrame.SetPage(1);
		SetupWithEditItem();
	end

	itemTooltip = CreateFrame("GameTooltip", "GHI_SimpleItemMenuItemTooltip" .. menuIndex, menuFrame, "GHI_StandardItemMenuItemTooltip");
	_G["GHI_SimpleItemMenuItemTooltip" .. menuIndex .. "TextLabel"]:SetText(loc.PREVIEW)

	itemTooltip:SetPoint("TOPRIGHT", -10, -15)

	menuFrame.OnPageChange = function(page)
		UpdateTooltip();
	end

	return class;
end

