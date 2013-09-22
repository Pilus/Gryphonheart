--===================================================
--
--				GHG_ChatConfig
--  			GHG_ChatConfig.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class
function GHG_ChatConfig()
	if class then
		return class;
	end
	class = GHClass("GHG_ChatConfig");
	local loc = GHG_Loc();

	local GENERAL = {}

	local GROUP_CHATS = {};

	GHG_ChatConfigSettingsGeneral:Hide();
	ChatConfig_CreateCheckboxes(GHG_ChatConfigSettingsGeneral, GENERAL, "ChatConfigCheckBoxWithSwatchTemplate", loc.GENERAL);

	GHG_ChatConfigSettingsGroupChats:Hide();
	ChatConfig_CreateCheckboxes(GHG_ChatConfigSettingsGroupChats, GROUP_CHATS, "ChatConfigCheckBoxWithSwatchTemplate", loc.GROUP_CHATS);

	local GetChatType = function(type)
		for _,v in pairs(GENERAL) do
			if v.type == type then
				return v;
			end
		end
		for _,v in pairs(GROUP_CHATS) do
			if v.type == type then
				return v;
			end
		end
	end

	-- GetMessageTypeColor hooking
	local GetMessageTypeColorOrig = GetMessageTypeColor;
	GetMessageTypeColor = function(type)
		local t = GetChatType(type);
		if t then
			return t.getColor();
		end
		return GetMessageTypeColorOrig(type);
	end

	local swatch;
	local colorSwatch = function()
		local t = GetChatType(swatch.type);
		if t then
			t.setFunc(ColorPickerFrame:GetColorRGB());
		end
	end

	local colorCancel = function()
		local t = GetChatType(swatch.type);
		if t then
			t.setFunc(ColorPicker_GetPreviousValues());
		end
	end

	function GHG_MessageTypeColor_OpenColorPicker(self)
		local info = UIDropDownMenu_CreateInfo();
		info.r, info.g, info.b = GetMessageTypeColor(self.type);
		swatch = self;
		info.swatchFunc = colorSwatch;
		info.cancelFunc = colorCancel;
		OpenColorPicker(info);
	end


	class.AddChatType = function(category,chatType,text,tooltipText,getColor,setFunc,isShownFunc,setShownFunc)
		GHCheck("AddChatType", { "string","string","string","stringNil","function","function","function","function"}, { category,chatType,text,tooltipText,getColor,setFunc,isShownFunc,setShownFunc });
		local t = {
			text = text,
			type = chatType,
			tooltip = tooltipText,
			getColor = getColor,
			setFunc = setFunc,
			checked = function(self)
				return isShownFunc(FCF_GetCurrentChatFrame():GetID())
			end,
			func = function(self,checked)
				setShownFunc(FCF_GetCurrentChatFrame():GetID(),checked)
			end,
		};

		if category == "general" then
			table.insert(GENERAL,t)
			GHG_ChatConfigSettingsGeneral:Show();
			ChatConfig_CreateCheckboxes(GHG_ChatConfigSettingsGeneral, GENERAL, "GHG_ChatConfigCheckBoxWithSwatchTemplate", loc.GENERAL);
		elseif category == "group" then
			table.insert(GROUP_CHATS,t)
			GHG_ChatConfigSettingsGroupChats:Show();
			ChatConfig_CreateCheckboxes(GHG_ChatConfigSettingsGroupChats, GROUP_CHATS, "GHG_ChatConfigCheckBoxWithSwatchTemplate", loc.GROUP_CHATS);
		end
	end



	return class;
end



