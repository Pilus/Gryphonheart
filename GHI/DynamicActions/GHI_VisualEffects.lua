--===================================================
--
--			GHI_Visual Effects
--			GHI_VisualEffects.lua
--
--	   Dynamic action data for the Special Effects category
--
--		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local category = "Visual Effects";

table.insert(GHI_ProvidedDynamicActions, {
	name = "Screen Shake",
	guid = "Screen_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Produces a screen shaking effect.",
	icon = "Interface\\Icons\\spell_Shaman_Earthquake",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
        local intensity = dyn.GetInput("intensity")
        local duration = dyn.GetInput("duration")
        local message = dyn.GetInput("message") or nil
		
		GHI_ScreenShake(duration, intensity, message)
        dyn.TriggerOutPort("effectPort")
		GHI_Timer(function() dyn.TriggerOutPort("effectDonePort") end, duration, true)
		
		
	]],
	ports = {
		effectPort = {
			name = "Effect Triggerd",
			order = 1,
			direction = "out",
			description = "when the effect happens",
		},
		effectDonePort = {
			name = "Effect finished",
			order = 2,
			direction = "out",
			description = "When the effect finishes.",
		},
	},
	inputs = {
		intensity = {
			name = "Shake Intensity",
			description = "The intensity of the shaking.",
			order = 1,
			type = "number",
			defaultValue = 8,
		},
		duration = {
			name = "Duration",
			description = "how long the effect lasts.",
			order = 2,
			type = "number",
			defaultValue = 1,
		},
		message = {
			name = "Message",
			description = "What will be displayed in a message",
			order = 3,
			type = "string",
			defaultValue = nil,
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Screen Effect: Full Screen Texture",
	guid = "Screen_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Produces a screen shaking effect.",
	icon = "Interface\\Icons\\Ability_Creature_Cursed_05",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
         local color = dyn.GetInput("inputcolor") or {1,1,1}
         local fadeIn = dyn.GetInput("fadein")
         local fadeOut = dyn.GetInput("fadeout")
         local duration = dyn.GetInput("duration")
		 local alpha = dyn.GetInput("inputalpha") or 1
		 local repeating = dyn.GetInput("inputrepeat") or 1
		 local texture = dyn.GetInput("inputtexture")
		 local blend = dyn.GetInput("inputblend") or "ADD"

         GHI_ScreenFlash(fadeIn,fadeOut,duration,color,alpha,texture,blend,repeating)
		 local totalTime = duration * repeating

         dyn.TriggerOutPort("effectPort")
		 GHI_Timer(function() dyn.TriggerOutPort("effectDonePort") end, totalTime, true)
	]],
	ports = {
		effectPort = {
			name = "effect triggerd",
			order = 1,
			direction = "out",
			description = "when the effect happens",
		},
		effectDonePort = {
			name = "Effect finished",
			order = 2,
			direction = "out",
			description = "When the effect finishes.",
		},
	},
	inputs = {
		fadein = {
			name = "Fade in",
			description = "the time (in seconds) the effect will fade in for.",
			type = "number",
			defaultValue = 1,
		},
		fadeout = {
			name = "Fade out",
			description = "the time (in seconds) the effect will fade out for.",
			type = "number",
			defaultValue = 1,
		},
		duration = {
			name = "Duration",
			description = "How long each flash lasts.",
			type = "number",
			defaultValue = 2,
		},
		inputalpha = {
			name = "Transparency",
			description = "How transparent the effect will be.",
			type = "number",
			defaultValue = 1,
		},
		inputrepeat = {
			name = "Repeating",
			description = "How many times the screen will flash.",
			type = "number",
			defaultValue = 1,
		},
		inputblend = {
			name = "Blend Mode",
			description = "The blend mode of the texture",
			type = "string",
			defaultValue = "ADD",
			specialGHM = "ghm_fromDDList",
			specialGHMScript = [[
			dataFunc = function()
				return {
					{
						value = "ADD",
						text = "ADD",
					},
					{
						value = "ALPHAKEY",
						text = "ALPHAKEY",
					},
					{
						value = "BLEND",
						text = "BLEND",
					},
					{
						value = "MOD",
						text = "MOD",
					},					
					{
						value = "DISABLE",
						text = "DISABLE",
					},
				};
			end]],
		},
		inputtexture = {
			name = "Texture",
			description = "The texture used for the effect",
			type = "image",
			--defaultValue = "Interface\\Icons\\INV_MISC_FILM_01",
		},
		inputcolor = {
			name = "Color",
			description = "The color for the effect",
			type = "color",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Texture Animation: Hover",
	guid = "texture_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Produces an animated texture above the character's head.",
	icon = "Interface\\Icons\\Ability_Hunter_MarkedForDeath",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
         local startcolor = dyn.GetInput("inputstartcolor")
		 local endcolor = dyn.GetInput("inputendcolor")
         local duration = dyn.GetInput("duration")
		 local texture = dyn.GetInput("inputtexture")
		 
		 GHI_AnimHoverTexture(texture, duration, startcolor, endcolor)
		 
         dyn.TriggerOutPort("effectPort")
		 GHI_Timer(function() dyn.TriggerOutPort("effectDonePort") end, duration, true)
	]],
	ports = {
		effectPort = {
			name = "effect triggerd",
			order = 1,
			direction = "out",
			description = "when the effect happens",
		},
		effectDonePort = {
			name = "Effect finished",
			order = 2,
			direction = "out",
			description = "When the effect finishes.",
		},
	},
	inputs = {
		duration = {
			name = "Duration",
			description = "How long the effect lasts.",
			type = "time",
			defaultValue = 2,
		},
		inputtexture = {
			name = "Texture",
			description = "The texture used for the effect.",
			type = "image",
		},
		inputstartcolor = {
			name = "Color",
			description = "The color for the effect at start. Leave white for no color change.",
			type = "color",
		},
		inputendcolor = {
			name = "Color",
			description = "The color for the effect at end. Leave white for no color change.",
			type = "color",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Texture Animation: Buff Cast",
	guid = "texture_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Produces an animated texture scales up from the character's head.",
	icon = "Interface\\Icons\\priest_icon_innewill",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
         local startcolor = dyn.GetInput("inputstartcolor")
		 local endcolor = dyn.GetInput("inputendcolor")
         local duration = dyn.GetInput("duration")
		 local texture = dyn.GetInput("inputtexture")
		 
		 GHI_AnimBuffCastTexture(texture, duration, startcolor, endcolor)
		 
         dyn.TriggerOutPort("effectPort")
		 GHI_Timer(function() dyn.TriggerOutPort("effectDonePort") end, duration, true)
	]],
	ports = {
		effectPort = {
			name = "effect triggerd",
			order = 1,
			direction = "out",
			description = "when the effect happens",
		},
		effectDonePort = {
			name = "Effect finished",
			order = 2,
			direction = "out",
			description = "When the effect finishes.",
		},
	},
	inputs = {
		duration = {
			name = "Duration",
			description = "How long the effect lasts.",
			type = "time",
			defaultValue = 2,
		},
		inputtexture = {
			name = "Texture",
			description = "The texture used for the effect.",
			type = "image",
		},
		inputstartcolor = {
			name = "Color",
			description = "The color for the effect at start. Leave white for no color change.",
			type = "color",
		},
		inputendcolor = {
			name = "Color",
			description = "The color for the effect at end. Leave white for no color change.",
			type = "color",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Texture Animation: Shield",
	guid = "texture_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Produces an animated texture shimmers over the character's body.",
	icon = "Interface\\Icons\\Spell_Holy_PowerWordShield",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
         local startcolor = dyn.GetInput("inputstartcolor")
		 local endcolor = dyn.GetInput("inputendcolor")
         local duration = dyn.GetInput("duration")
		 local texture = dyn.GetInput("inputtexture")
		 
		 GHI_AnimShield(texture, duration, startcolor, endcolor)
		 
         dyn.TriggerOutPort("effectPort")
		 GHI_Timer(function() dyn.TriggerOutPort("effectDonePort") end, duration, true)
	]],
	ports = {
		effectPort = {
			name = "effect triggerd",
			order = 1,
			direction = "out",
			description = "when the effect happens",
		},
		effectDonePort = {
			name = "Effect finished",
			order = 2,
			direction = "out",
			description = "When the effect finishes.",
		},
	},
	inputs = {
		duration = {
			name = "Duration",
			description = "How long the effect lasts.",
			type = "time",
			defaultValue = 2,
		},
		inputtexture = {
			name = "Texture",
			description = "The texture used for the effect.",
			type = "image",
		},
		inputstartcolor = {
			name = "Color",
			description = "The color for the effect at start. Leave white for no color change.",
			type = "color",
		},
		inputendcolor = {
			name = "Color",
			description = "The color for the effect at end. Leave white for no color change.",
			type = "color",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Alert Display: Level Up Style",
	guid = "Alert_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Displays an alert in the style of a Level Up announcment.",
	icon = "Interface\\Icons\\Achievement_Dungeon_GloryoftheHERO",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
         local upperText = dyn.GetInput("upperText")
         local lowerText = dyn.GetInput("lowerText")
		 local hideBG = dyn.GetInput("hideBG")
		 local hideGoldLines = dyn.GetInput("hideGoldLines")
		 local fastSpeed = dyn.GetInput("fastSpeed")
		 
		 if upperText == "" then upperText = nil end
		 if lowerText == "" then lowerText = nil end		 

         GHI_LevelUpAlert(upperText, lowerText, fastSpeed, hideBG, hideGoldLines)
		
		 dyn.TriggerOutPort("effectPort")
	]],
	ports = {
		effectPort = {
			name = "effect triggerd",
			order = 1,
			direction = "out",
			description = "When the level up display shows.",
		},
	},
	inputs = {
		upperText = {
			name = "Upper Text",
			description = "The upper text in a two line display, or the larger text of a one line display.",
			type = "string",
			order = 1,
		},
		lowerText = {
			name = "Lower Text",
			description = "The lower text in a two line display, or the smaller text of a one line display.",
			type = "string",
			order = 2,
		},
		hideBG = {
			name = "Hide Background",
			description = "If true the black background will not show.",
			type = "boolean",
			order = 3,
			specialGHM = "defaultGhm",
			defaultValue = false,
		},
		hideGoldLines = {
			name = "Hide Gold Lines",
			description = "If true the gold lines that border the display will not show.",
			type = "boolean",
			order = 4,
			specialGHM = "defaultGhm",
			defaultValue = false,
		},
		fastSpeed = {
			name = "Play Fast Speed",
			description = "If true the alert will fade in faster.",
			type = "boolean",
			order = 5,
			specialGHM = "defaultGhm",
			defaultValue = false,
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Alert Display: Scenario Style",
	guid = "Alert_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Displays an alert in the style of Scenario stage progression.",
	icon = "Interface\\Icons\\Achievement_Dungeon_GloryoftheRaider",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
         local upperText = dyn.GetInput("upperText")
         local lowerText = dyn.GetInput("lowerText")
		 local hideBG = dyn.GetInput("hideBG")
		 local hideGoldLines = dyn.GetInput("hideGoldLines")
		 local bottomText = dyn.GetInput("bottomText")
		 
         GHI_ScenarioAlert(upperText,lowerText, bottomText, hideBG, hideGoldLines)
		
		 dyn.TriggerOutPort("effectPort")
	]],
	ports = {
		effectPort = {
			name = "effect triggerd",
			order = 1,
			direction = "out",
			description = "When the level up display shows.",
		},
	},
	inputs = {
		upperText = {
			name = "Upper Text",
			description = "The upper text in a two line display.",
			type = "string",
			order = 1,
		},
		lowerText = {
			name = "Lower Text",
			description = "The lower text in a two line display.",
			type = "string",
			order = 2,
		},
		bottomText = {
			name = "Bottom Text",
			description = "The text that displays below the alert frame as seen in Scenarios.",
			type = "string",
			order = 3,
		},
		hideBG = {
			name = "Hide Background",
			description = "If true the black background will not show.",
			type = "boolean",
			order = 4,
			specialGHM = "defaultGhm",
			defaultValue = false,
		},
		hideGoldLines = {
			name = "Hide Gold Lines",
			description = "If true the gold lines that border the display will not show.",
			type = "boolean",
			order = 5,
			specialGHM = "defaultGhm",
			defaultValue = false,
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Alert Display: Challenge Mode Style",
	guid = "Alert_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Displays an alert in the style of a Challenge Mode Dungeon finish.",
	icon = "Interface\\Icons\\Achievement_Dungeon_HEROIC_GloryoftheRaider",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
         local upperText = dyn.GetInput("upperText")
         local lowerText = dyn.GetInput("lowerText")
		 local hideBG = dyn.GetInput("hideBG")
		 local hideGoldLines = dyn.GetInput("hideGoldLines")
		  
         GHI_ScenarioAlert(upperText,lowerText, hideBG, hideGoldLines)
		
		 dyn.TriggerOutPort("effectPort")
	]],
	ports = {
		effectPort = {
			name = "effect triggerd",
			order = 1,
			direction = "out",
			description = "When the level up display shows.",
		},
	},
	inputs = {
		upperText = {
			name = "Upper Text",
			description = "The upper text in a two line display.",
			type = "string",
			order = 1,
		},
		lowerText = {
			name = "Lower Text",
			description = "The lower text in a two line display.",
			type = "string",
			order = 2,
		},
		hideBG = {
			name = "Hide Background",
			description = "If true the black background will not show.",
			type = "boolean",
			order = 3,
			specialGHM = "defaultGhm",
			defaultValue = false,
		},
		hideGoldLines = {
			name = "Hide Gold Lines",
			description = "If true the gold lines that border the display will not show.",
			type = "boolean",
			order = 4,
			specialGHM = "defaultGhm",
			defaultValue = false,
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Alert Display: Spell Learned Style",
	guid = "Alert_04",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Displays an alert in the style of a Spell Learned announcment.",
	icon = "Interface\\Icons\\Achievement_Dungeon_GloryoftheHERO",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
         local upperText = dyn.GetInput("upperText")
         local lowerText = dyn.GetInput("lowerText")
		 local hideBG = dyn.GetInput("hideBG")
		 local hideGoldLines = dyn.GetInput("hideGoldLines")
		 local bigSize = dyn.GetInput("bigSize")
		 local icon = dyn.GetInput("icon")
		 local subIcon = dyn.GetInput("subIcon")
		 
		 if upperText == "" then upperText = nil end
		 if lowerText == "" then lowerText = nil end
		 if icon == "" then icon = nil end
		 if subIcon == "" then subIcon = nil end		 

         GHI_SpellAlert(upperText,lowerText, icon, subIcon, bigSize,  hideBG, hideGoldLines)
		
		 dyn.TriggerOutPort("effectPort")
	]],
	ports = {
		effectPort = {
			name = "effect triggerd",
			order = 1,
			direction = "out",
			description = "When the level up display shows.",
		},
	},
	inputs = {
		upperText = {
			name = "Upper Text",
			description = "The upper text in a two line display, or the larger text of a one line display.",
			type = "string",
			order = 1,
		},
		lowerText = {
			name = "Lower Text",
			description = "The lower text in a two line display, or the smaller text of a one line display.",
			type = "string",
			order = 2,
		},
		icon = {
			name = "Icon",
			description = "The icon that displays to the left of the text.",
			type = "icon",
			order = 3,
		},
		subIcon = {
			name = "Sub Icon",
			description = "The icon that displays to the lower left of the icon.",
			type = "icon",
			order = 4,
		},
		hideBG = {
			name = "Hide Background",
			description = "If true the black background will not show.",
			type = "boolean",
			order = 5,
			specialGHM = "defaultGhm",
			defaultValue = false,
		},
		hideGoldLines = {
			name = "Hide Gold Lines",
			description = "If true the gold lines that border the display will not show.",
			type = "boolean",
			order = 6,
			specialGHM = "defaultGhm",
			defaultValue = false,
		},
		bigSize = {
			name = "Large sized text",
			description = "If true the alert have large sized white and gold text, if false text will be smaller green and white.",
			type = "boolean",
			order = 7,
			specialGHM = "defaultGhm",
			defaultValue = false,
		},
	},
	outputs = {},
});