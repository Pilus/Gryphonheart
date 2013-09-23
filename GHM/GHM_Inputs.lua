--===================================================
--
--				GHM_Inputs
--  			GHM_Inputs.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local function GetInputTypes()
local loc = GHI_Loc();
return {
	string = {
		ghm = {
			type = "Editbox",
			width = 130,
			texture = "Tooltip",
		},
		ghm_fromDDList = {
			type = "DropDown",
			width = "130",
		},
		ghm_fromRadio = {
			type = "RadioButtonSet"
		},
		validate = function(value) return type(value) == "string" end,
		default = "",
	},
	image = {
		ghm = {
			type = "Image",
		},
		validate = function(value)
			if type(value) == "string" then
				return true;
			end
		end,
		default = "Interface\\Icons\\INV_MISC_FILM_01",
	},
	time = {
		ghm = {
			type = "Time",
			size = "M",
		},
		validate = function(value) return type(value) == "number" end,
		default = 0,
		mergeRules = {
			average = {
				func = function(value1,count1,value2,count2)
					return ((value1*count1) + (value2*count2)) / (count1+count2);
				end
			},
			average_rounded = {
				func = function(value1,count1,value2,count2)
					return math.floor(((value1*count1) + (value2*count2)) / (count1+count2) + 0.5);
				end
			},
			sum = {
				func = function(value1,count1,value2,count2)
					return value1 + value2;
				end
			},
			min = {
		   		func = function(value1,count1,value2,count2)
					return math.min(value1,value2);
				end
			},
			max = {
				func = function(value1,count1,value2,count2)
					return math.max(value1,value2);
				end
			},
		},
		
	},
	number = {
		ghm = {
			type = "Editbox",
			width = 130,
			texture = "Tooltip",
			numbersOnly = true,
		},
		ghm_LogoNum = {
			type = "Logo",
		},
		validate = function(value) return type(value) == "number" end,
		default = 0,
		mergeRules = {
			average = {
				func = function(value1,count1,value2,count2)
					return ((value1*count1) + (value2*count2)) / (count1+count2);
				end
			},
			average_rounded = {
				func = function(value1,count1,value2,count2)
					return math.floor(((value1*count1) + (value2*count2)) / (count1+count2) + 0.5);
				end
			},
			sum = {
				func = function(value1,count1,value2,count2)
					return value1 + value2;
				end
			},
			min = {
		   		func = function(value1,count1,value2,count2)
					return math.min(value1,value2);
				end
			},
			max = {
				func = function(value1,count1,value2,count2)
					return math.max(value1,value2);
				end
			},
		},
	},
	code = {
		ghm = {
			type = "CodeField",
			height = 430,
			width = 380,
			size = "L",
			toolbarButtons = {
				{
					texture = "INTERFACE\\ICONS\\Ability_Rogue_Sprint",
					tooltip = loc.SCRIPT_TEST,
					func = function(f)
						local code = f:GetText();
						local env = GHI_ScriptEnvList().GetEnv(UnitGUID("player"));
						env.ExecuteScript(code)
					end,
				},
				{
					texture = "Interface\\AddOns\\GHM\\GHI_Icons\\_Reverse_Red",
					tooltip = loc.SCRIPT_RELOAD_ENV,
					func = function(f)
						local code = f:GetText();
						local env = GHI_ScriptEnvList().ReloadEnv(UnitGUID("player"));
					end,
				},
				{
					texture = "Interface\\Icons\\Spell_Holy_MagicalSentry",
					tooltip = loc.SCRIPT_OPTIONS_NL,
					func = function()
						GHI_CodeEditorOptionsMenu().Show();
					end,
				},
				{
					texture = "Interface\\Icons\\INV_Misc_Drum_02",
					tooltip = loc.SCRIPT_INSERT_SOUND,
					func = function(f)
						GHI_MenuList("GHM_SoundSelectionMenu").New(function(sound)
						local soundPath = string.gsub(sound.path,[[\]],[[\\]]);
							f:Insert(string.format([["%s"]],soundPath));
						end);
					end,
				},
				{
					texture = "INTERFACE\\ICONS\\priest_icon_chakra_blue",
					tooltip = loc.SCRIPT_INSERT_ICON,
					func = function(f)
						GHM_IconPickerList().New(function(icon)
						local iconPath = string.gsub(icon,[[\]],[[\\]]);
							f:Insert(string.format([["%s"]],iconPath));
						end);
					end,
				},
				{
					texture = "Interface\\Icons\\INV_MISC_FILM_01",
					tooltip = "Image",
					func = function(f)
						GHM_ImagePickerList().New(function(selectedImage, selectedX, selectedY)
						local imagePath = string.gsub(selectedImage,[[\]],[[\\]]);
						f:Insert(string.format([["%s"]],imagePath))
						--selectedX.." "..selectedY;
						end)
					end,
				},
				{
					texture = "Interface\\Icons\\INV_Misc_Map03",
					tooltip = "Insert current coordinates",
					func = function(f)
						local x,y,w = GHI_Position().GetCoor("player",3);
						f:Insert(string.format("{x=%s,y=%s,world=%s}",x,y,w));
					end,
				},
				{
					texture = "Interface\\Icons\\Ability_Repair",
					tooltip = "Insert Item GUID",
					func = function(f)
					local miscAPI = GHI_MiscAPI().GetAPI()           
						miscAPI.GHI_SetSelectItemCursor(function(guid)
							f:Insert(string.format([["%s"]],guid))
						end, nil, "GHI_INSPECT");
					end,
				},
			},
		},
		validate = function(value) return type(value) == "string" end,
		default = "",
		toValueString = function(value) return "..."; end,
	},
	position = {
		ghm = {
			type = "Position",
			size = "M",
		},
		validate = function(value)
			return (type(value) == "table" and type(value.x) == "number" and type(value.y) == "number" and type(value.world) == "number" );

		end,
		default = {
			x = 0,
			y = 0,
			world = 0,
		},
		toValueString = function(value) return string.format("%.2f; %.2f; %.2f",value.x,value.y,value.world); end,
	},
	boolean= {
		ghm = {
			type = "CheckBox",
		},
		validate = function(value)
			return (not(value) or type(value) == "boolean");
		end,
		default = false,
		defaultGhm = {
			type = "RadioButtonSet",
			dataFunc = function()
				return {
					{
						value = true,
						text = "true",
					},
					{
						value = false,
						text = "false",
					},
				}
			end,
		},
		toValueString = function(value) if value == true then return "true"; else return "false"; end end,
	},
	icon = {
		ghm = {
			type = "Icon",
			text = loc.ICON,
			align = "c",
			label = "icon",
			framealign = "r",
			CloseOnChoosen = true,
			OnChanged = function(icon)

			end
		},
		validate = function(value)
			if type(value) == "string" then
				return true;
			end
		end,
		default = "",
		toValueString = function(value) return "\124T"..value..":16\124t"; end,
	},
	sound = {
		ghm = {
			type = "Sound",
		},
		validate = function(value)
			return (type(value) == "table" and type(value.path) == "string" and type(value.duration) == "number");
		end,
		default = nil,

	},
	text = {
		ghm = {
			type = "EditField",
			width = 130,
		},
		validate = function(value)
			return (type(value) == "string");
		end,
		default = "",
	},
	color = {
		ghm = {
			type = "Color2",
			scale = 0.75,
		},
		validate = function(value)
			return (type(value) == "table");
		end,
		default = {r=1,g=1,b=1},
	},
	item = {
		ghm = {
			type = "Item",
			size = "M",
		},
		validate = function(value)
			return type(value) == "string";
		end,
		default = "",
	},
	book = {
		ghm = {
			type = "MultiPageEditField",
			width = 390,
			height = 200,
			HTMLtools = true,
			size = "L",
			toolbarButtons = {
					{
						texture = "Interface\\Icons\\INV_Misc_Spyglass_03",
						func = function(f)
							local main = f:GetParent():GetParent():GetParent():GetParent():GetParent():GetParent()
														
							local title = main.GetLabel("_in_bookTitle")
							local material = main.GetLabel("_in_bookMaterial")
							local font = main.GetLabel("_in_bookFont")
							local N = main.GetLabel("_in_nSize")
							local H1 = main.GetLabel("_in_h1Size")
							local H2 = main.GetLabel("_in_h2Size")
							local H2Font = main.GetLabel("_in_h2Font") or nil
							local H1Font = main.GetLabel("_in_h1Font") or nil
							local coverPage = main.GetLabel("_in_cover") or nil
							local coverColor = main.GetLabel("_in_coverColor")
							local logoColor = main.GetLabel("_in_logoColor")
							local coverLogo = main.GetLabel("_in_coverLogo")
							local text = main.GetLabel("_in_bookText")
							
							local cover
							
							if coverPage == "None" then
								cover = nil
							else
								cover = {}
								cover.logo = coverLogo
								cover.color = logoColor
								cover.bg = coverPage
								cover.bgColor = coverColor
							end
							
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
							
						local textFrame = main.GetLabelFrame("_in_bookText")
						local page = textFrame.currentPage
							
							
							GHI_ShowBook("Preview", nil, title, text[page], 0, material, font, N, H1, H2, H1Font, H2Font,extraMat,cover)
						end,
						tooltip = "Preview Page",
					},
			}
		},
		validate = function(value)
			return type(value) == "table"
		end,
	},
}
	
end

local INPUT_TYPES;

function GHM_Input_GetAvailableTypes()
	if not(INPUT_TYPES) then INPUT_TYPES = GetInputTypes() end

	local t = {};
	for type, _ in pairs(INPUT_TYPES) do
		table.insert(t, type);
	end
	return t;
end

function GHM_Input_Validate(typeName, value)
	if not(INPUT_TYPES) then INPUT_TYPES = GetInputTypes() end

	if INPUT_TYPES[typeName] and INPUT_TYPES[typeName].validate then
		if INPUT_TYPES[typeName].validate(value) then
			return true;
		else
			return false,"Validation false for type: "..tostring(typeName).." with value "..tostring(value).." ("..type(value)..")";
		end
	end
	return false,"Validation not found for type: "..tostring(typeName);
end

function GHM_Input_GenerateMenuObject(typeName, name, label, defaultGHM)
	if not(INPUT_TYPES) then INPUT_TYPES = GetInputTypes() end
	local ghmType = "ghm";
	if defaultGHM == true then
		ghmType = "defaultGhm";
	elseif defaultGHM then
		ghmType = defaultGHM;
	end
	if INPUT_TYPES[typeName] and (INPUT_TYPES[typeName][ghmType] or INPUT_TYPES[typeName].ghm)  then
		local t = {};
		for i, v in pairs(INPUT_TYPES[typeName][ghmType] or INPUT_TYPES[typeName].ghm ) do
			t[i] = v;
		end
		t.text = name;
		t.label = label;
		return t;
	end
end

function GHM_Input_GetDefaultValue(typeName)
	if not(INPUT_TYPES) then INPUT_TYPES = GetInputTypes() end
	if INPUT_TYPES[typeName] and INPUT_TYPES[typeName].default then
		return INPUT_TYPES[typeName].default;
	end
end

function GHM_Input_Merge(typeName,mergeRule,value1,count1,value2,count2)
	if not(INPUT_TYPES) then INPUT_TYPES = GetInputTypes() end
	if INPUT_TYPES[typeName] and INPUT_TYPES[typeName].mergeRules and INPUT_TYPES[typeName].mergeRules[mergeRule] then
		return INPUT_TYPES[typeName].mergeRules[mergeRule].func(value1,count1,value2,count2);
	end
	return value1;
end

function GHM_Input_GetAvailableMergeRules()
	if not(INPUT_TYPES) then INPUT_TYPES = GetInputTypes() end
	local t = {};
	for typeName, d in pairs(INPUT_TYPES) do
		local m = {"none"};
		if d.mergeRules then
			for ruleName,_ in pairs(d.mergeRules) do
				table.insert(m,ruleName);
			end
		end
		t[typeName] = m;
	end
	return t;
end

function GHM_Input_ToString(typeName,value)
	if not(INPUT_TYPES) then INPUT_TYPES = GetInputTypes() end
	if INPUT_TYPES[typeName] then
		if INPUT_TYPES[typeName].toValueString then
			return INPUT_TYPES[typeName].toValueString(value);
		else
			return tostring(value);
		end
	end
	return "..."
end



