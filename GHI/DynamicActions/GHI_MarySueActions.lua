--
--
--				GHI_MarySueActions
--  		    GHI_MarySueActions.lua
--
--	          actions for accessing
--          Mary Sue protocol data in GHI
--
-- 	       (c)2013 The Gryphonheart Team
--		    	All rights reserved
--


local category = "Mary Sue Info";

table.insert(GHI_ProvidedDynamicActions, {
	name = "MSP: Append Currently Flag",
	guid = "msp_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Appends text to the player's MSP addon profile Currently tag.",
	icon = "Interface\\Icons\\INV_Glyph_MajorDruid",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  local text = dyn.GetInput("text");
		local currently = GHI_GetPlayerStatus()
		if strfind(tostring(currently), tostring(strtrim(text))) then
			return
		else
			if currently == nil then currently = "" end
			currently = currently..text
			GHI_SetPlayerCurrently(currently)		
		end
	]],
	ports = {
	},
	inputs = {
		text = {
			name = "Text",
			description = "The text to append currently with.",
			type = "string",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "MSP: Set Currently Flag",
	guid = "msp_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Sets the text of the player's MSP addon profile Currently tag.",
	icon = "Interface\\Icons\\INV_Glyph_MajorHunter",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  local text = dyn.GetInput("text");
		
		GHI_SetPlayerCurrently(text)		
	]],
	ports = {
	},
	inputs = {
		text = {
			name = "Text",
			description = "The text to change Currently to.",
			type = "string",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "MSP: Set Currently Flag, Timed",
	guid = "msp_07",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Sets the text of the player's MSP addon profile Currently tag for a short amount of time before reverting.",
	icon = "Interface\\Icons\\INV_Glyph_MajorPriest",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  
		local current = GHI_GetPlayerStatus()
		local text = dyn.GetInput("text");
		local time = dyn.GetInput("time");
		GHI_SetPlayerCurrently(text)	
		
		GHI_Timer(function()
			if current then 
				GHI_SetPlayerCurrently(current)
			else
				GHI_RemoveBuff("Currently", "Helpful")
			end
		end, time, true)	
	]],
	ports = {
	},
	inputs = {
		text = {
			name = "Text",
			description = "The text to change Currently to.",
			type = "string",
		},
		time = {
			name = "Time",
			description = "The amount of time before current status reverts.",
			type = "time",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "MSP: Clear Currently Flag",
	guid = "msp_06",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Clear the player's MSP addon profile Currently tag.",
	icon = "Interface\\Icons\\INV_Glyph_MajorHunter",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  		
		GHI_ClearPlayerCurrently()		
	]],
	ports = {
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "MSP: Get Player Identity",
	guid = "msp_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Gets the player's Indentifying names and titles.",
	icon = "Interface\\Icons\\INV_Glyph_MajorMage",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[		
		local name, title, house, nickname = GHI_GetPlayerWho()
			
		
		dyn.SetOutput("name",name or "");
		dyn.SetOutput("title",title or "");
		dyn.SetOutput("house",house or "");
		dyn.SetOutput("nickname",nickname or "");
				
	]],
	ports = {
	},
	outputs = {
		name = {
			name = "Name",
			description = "The character's RP name.",
			type = "string"
		},
		title = {
			name = "Title",
			description = "The character's RP title.",
			type = "string"
		},
		house = {
			name = "House",
			description = "The character's RP house.",
			type = "string"
		},
		nickname = {
			name = "Nickname",
			description = "The character's RP nickname",
			type = "string"
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "MSP: Get Player Physical Info",
	guid = "msp_04",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Gets the players physical characteristics.",
	icon = "Interface\\Icons\\INV_Glyph_MajorMonk",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[		
		local race, age, height, weight, eyeColor, description = GHI_GetPlayerPhysical()
		
		dyn.SetOutput("race",race or "");
		dyn.SetOutput("age",age or "");
		dyn.SetOutput("height",height or "");
		dyn.SetOutput("weight",weight or "");
		dyn.SetOutput("eyeColor",eyeColor or "");
		dyn.SetOutput("description",description or "");
				
	]],
	ports = {
	},
	outputs = {
		race = {
			name = "Race",
			description = "The character's RP race or Game race",
			type = "string"
		},
		age = {
			name = "Age",
			description = "The character's RP age or Game level.",
			type = "string"
		},
		height = {
			name = "Height",
			description = "The character's RP height.",
			type = "string"
		},
		weight = {
			name = "Weight",
			description = "The character's RP weight",
			type = "string"
		},
		eyeColor = {
			name = "Eye Color",
			description = "The character's RP eye color",
			type = "string"
		},
		description = {
			name = "Description",
			description = "The character's RP physical description",
			type = "string"
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "MSP: Get Player History",
	guid = "msp_05",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Gets the player's history and other background information.",
	icon = "Interface\\Icons\\INV_Glyph_MajorPaladin",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[		
		local home, birthplace, history = GHI_GetPlayerHistory()
		
		dyn.SetOutput("home",home or "");
		dyn.SetOutput("birthplace",birthplace or "");
		dyn.SetOutput("history",history or "");
				
	]],
	ports = {
	},
	outputs = {
		home = {
			name = "Home",
			description = "The character's RP home.",
			type = "string"
		},
		birthplace = {
			name = "Birthplace",
			description = "The character's RP birthplace.",
			type = "string"
		},
		history = {
			name = "History",
			description = "The character's RP history.",
			type = "string"
		},
	},
});
