--===================================================
--
--				GHM_Color
--  			GHM_Color.lua
--
--	          GHM_Color object for GHM
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;
local GHM_COLOR_MENU_DATA;

function GHM_BuildColorDD(dropDownMenu, GetValue, Force)
	local miscAPI = GHI_MiscAPI().GetAPI()
	local loc = GHI_Loc();

	local colors = miscAPI.GHI_GetColors()
	
	local classes = {}
	FillLocalizedClassList(classes)
	
	local dmgTypes = {
		["PHYSICAL"]  = {a=1.0,r=1.00,g=1.00,b=0.00},
		["HOLY"]  = {a=1.0,r=1.00,g=0.90,b=0.50},
		["FIRE"]  = {a=1.0,r=1.00,g=0.50,b=0.00},
		["NATURE"]    = {a=1.0,r=0.30,g=1.00,b=0.30},
		["FROST"]     = {a=1.0,r=0.50,g=1.00,b=1.00},
		["SHADOW"]    = {a=1.0,r=0.50,g=0.50,b=1.00},
		["ARCANE"]    = {a=1.0,r=1.00,g=0.50,b=1.00},
	}
	
	local debuffColors = {
		["STRING_SCHOOL_PHYSICAL"] = DebuffTypeColor["none"],
		["ENCOUNTER_JOURNAL_SECTION_FLAG7"] = DebuffTypeColor["Magic"],
		["ENCOUNTER_JOURNAL_SECTION_FLAG8"] = DebuffTypeColor["Curse"],
		["ENCOUNTER_JOURNAL_SECTION_FLAG9"] = DebuffTypeColor["Poison"],
		["ENCOUNTER_JOURNAL_SECTION_FLAG10"] = DebuffTypeColor["Disease"],
	}
	
	local tempData = {}
	
	if not GHM_COLOR_MENU_DATA then
		GHM_COLOR_MENU_DATA = {}
	end
	
	GHM_COLOR_MENU_DATA[1] = {
		text = GetText("COLOR"),
		notCheckable = true,
		hasArrow = true,
		menuList = {}
	}
	
	for i,v in pairs(colors) do
		tempData = {}
		tempData.text = loc["COLOR_"..string.upper(i)]
		tempData.colorCode = "\124c"..miscAPI.RGBAPercToHex(v.r,v.g,v.b)
		tempData.notCheckable = true
		tempData.func = function()
			Force({v.r,v.g,v.b,1})
			dropDownMenu.CloseDropDownMenus()
		end
		tinsert(GHM_COLOR_MENU_DATA[1].menuList, tempData)
	end
	
	GHM_COLOR_MENU_DATA[2] = {
		text = GetText("CLASS_COLORS"),
		notCheckable = true,
		hasArrow = true,
		menuList = {}
	}
		
	for token, localizedName in pairs(classes) do
		local color = RAID_CLASS_COLORS[token];
		tempData = {}
		tempData.text = localizedName
		tempData.colorCode = "\124c"..miscAPI.RGBAPercToHex(color.r,color.g,color.b)
		tempData.notCheckable = true
		tempData.func = function()
			Force({color.r,color.g,color.b,1})
			dropDownMenu.CloseDropDownMenus()
		end
		tinsert(GHM_COLOR_MENU_DATA[2].menuList, tempData)
	end
		
	GHM_COLOR_MENU_DATA[3] = {
		text = GetText("QUALITY"),
		notCheckable = true,
		hasArrow = true,
		menuList = {}
	}
	
	for i = 0, 6 do
		tempData = {}
		local color = ITEM_QUALITY_COLORS[i]
		tempData.text = GetText("ITEM_QUALITY"..i.."_DESC")
		tempData.colorCode = "\124c"..miscAPI.RGBAPercToHex(color.r,color.g,color.b)
		tempData.notCheckable = true
		tempData.func = function()
			Force({color.r,color.g,color.b,1})
			dropDownMenu.CloseDropDownMenus()
		end
		tinsert(GHM_COLOR_MENU_DATA[3].menuList, tempData)
	end
		
	GHM_COLOR_MENU_DATA[4] = {
		text = GetText("COLOR_BY_SCHOOL"),
		notCheckable = true,
		hasArrow = true,
		menuList = {}
	}
	
	for i,v in pairs(dmgTypes) do
		tempData = {}
		tempData.text = GetText("STRING_SCHOOL_"..i)
		tempData.colorCode = "\124c"..miscAPI.RGBAPercToHex(v.r,v.g,v.b)
		tempData.notCheckable = true
		tempData.func = function()
			Force({v.r,v.g,v.b,1})
			dropDownMenu.CloseDropDownMenus()
		end
		tinsert(GHM_COLOR_MENU_DATA[4].menuList, tempData)
	end
	
	GHM_COLOR_MENU_DATA[5] = {
		text = GetText("BUFFOPTIONS_LABEL"),
		notCheckable = true,
		hasArrow = true,
		menuList = {}
	}
	
	for i,v in pairs(debuffColors) do
		tempData = {}
		tempData.text = GetText(tostring(i))
		tempData.colorCode = "\124c"..miscAPI.RGBAPercToHex(v.r,v.g,v.b)
		tempData.notCheckable = true
		tempData.func = function()
			Force({v.r,v.g,v.b,1})
			dropDownMenu.CloseDropDownMenus()
		end
		tinsert(GHM_COLOR_MENU_DATA[5].menuList, tempData)
	end
	
	GHM_COLOR_MENU_DATA[6] = {
		text = loc.COLOR_CUSTOM,
		notCheckable = true,
		func = function()
			local currColor = GetValue()
			GHM_ColorPickerList().Edit(currColor, function(_color)
				Force(_color)
			end
			)
			dropDownMenu.CloseDropDownMenus()
		end,
	}
	return GHM_COLOR_MENU_DATA
end

function GHM_Color(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_Color" .. count, parent, "GHM_Color_Template");
	count = count + 1;

	local miscAPI = GHI_MiscAPI().GetAPI()
	local loc = GHI_Loc();
	local dropDownMenu = GHM_DropDownMenu()	
	local OnChange
	local Force1
	-- declaration and initialization
	local label = profile.label;
	
	-- setup
	local labelFrame = _G[frame:GetName() .. "TextLabel"];
	local area = _G[frame:GetName() .. "Area"];
	local button = _G[area:GetName().."Button"]
	local colorTexture = _G[button:GetName().."Color"]
	
	_G[labelFrame:GetParent():GetName()].tooltip = profile.tooltip;
	
	if profile.OnChange then
		OnChange = profile.OnChange
	end
	
	labelFrame:SetText(profile.text or "");
	
	if profile.width then
		frame:SetWidth(profile.width)
	end

	-- positioning
	GHM_FramePositioning(frame,profile,parent);
			
	local ddMenuFrame

	button:SetScript("OnClick", function()		
		if not (ddMenuFrame) then
			ddMenuFrame	= CreateFrame("Frame", frame:GetName().."ColorMenu", frame, "GHM_DropDownMenuTemplate")
			dropDownMenu.EasyMenu(GHM_BuildColorDD(dropDownMenu,frame.GetValue, Force1), ddMenuFrame, button:GetName(), 0 ,0, "MENU", 1);
		else
			dropDownMenu.ToggleDropDownMenu(nil,nil,ddMenuFrame,button:GetName(),0,0,GHM_BuildColorDD(dropDownMenu,frame.GetValue,Force1),nil,2)
		end
	end)
		
	-- functions
	local varAttFrame;

	Force1 = function(data)
		if type(data) == "table" then
			colorTexture:SetVertexColor(data.r or data[1], data.g or data[2], data.b or data[3], data.a or data[4])
			if OnChange then
				OnChange(data.r or data[1], data.g or data[2], data.b or data[3], data.a or data[4])
			end
		end
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then
			varAttFrame:SetValue(inputType, inputValue);
		else -- static
			varAttFrame:Clear();
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
		colorTexture:SetVertexColor(1, 1, 1, 1)
	end

	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, area, area:GetWidth(), 0);
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end
	
	local function round(num, idp)
	  local mult = 10^(idp or 0)
	  return math.floor(num * mult + 0.5) / mult
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			if profile.returnIndexTable == true then
				local r1,g1,b1, a1 = colorTexture:GetVertexColor()
				local rgb = {}
				table.insert(rgb,round(r1,3))
				table.insert(rgb,round(g1,3))
				table.insert(rgb,round(b1,3))
				table.insert(rgb,round(a1,3))
				return rgb
			else
				local r1,g1,b1, a1 = colorTexture:GetVertexColor()
				local rgb = {
				["r"] = round(r1,3),
				["g"] = round(g1,3),
				["b"] = round(b1,3),
				["a"] = round(a1,3),
				}
				return rgb
			end
		end
	end

	frame.GetPreferredDimensions = function()
		return profile.width, profile.height or frame:GetHeight();
	end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame:Show();
	frame.Clear()
	
	return frame;
end

