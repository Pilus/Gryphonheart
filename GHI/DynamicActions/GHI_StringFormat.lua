--===================================================
--
--				GHI_StringFormat
--  			GHI_StringFormat.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local category = "String Formatting";


table.insert(GHI_ProvidedDynamicActions, {
	name = "String Contains",
	guid = "string_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action detects the string contains a given word or not",
	icon = "Interface\\Icons\\INV_Misc_Note_01",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  local targetString = dyn.GetInput("string");
	    local targetWord = dyn.GetInput("word");

         local gotWord = strfind(targetString,targetWord:lower())
	    if gotWord then
	          dyn.TriggerOutPort("hasWord");
	    else
		     dyn.TriggerOutPort("noWord");
	    end
	]],
	ports = {
		hasWord = {
			name = "Contains substring",
			order = 1,
			direction = "out",
			description = "if the string has the substring(s).",
		},
		noWord = {
			name = "Does Not Contain substring",
			direction = "out",
			order = 2,
			description = "If the string DOES NOT have the substring(s)",
		},
	},
	inputs = {
		word = {
			name = "Word",
			description = "The substring to check for",
			type = "string",
			defaultValue = "",
		},
		string = {
			name = "String",
			description = "The string to check for a substring(like a unit name)",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "String Equals",
	guid = "string_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action detects if a string equals something else",
	icon = "Interface\\Icons\\INV_Misc_Note_03",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  local targetString = dyn.GetInput("string");
	    local targetCheck = dyn.GetInput("check");


	    if targetString == targetCheck then
	          dyn.TriggerOutPort("equals");
	    else
		     dyn.TriggerOutPort("notequals");
	    end
	]],
	ports = {
		equals = {
			name = "Contains Word",
			order = 1,
			direction = "out",
			description = "if the string matches",
		},
		notequals = {
			name = "Does Not Contain Word",
			direction = "out",
			order = 2,
			description = "If the string DOES NOT match",
		},
	},
	inputs = {
		check = {
			name = "String",
			description = "The string to check",
			type = "string",
			defaultValue = "",
		},
		string = {
			name = "String",
			description = "The string to check",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "String Join",
	guid = "string_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 2,
	category = category,
	description = "This action joins to diffrent string together",
	icon = "Interface\\Icons\\INV_Misc_Note_02",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  local strings = {
			dyn.GetInput("string1"),
			dyn.GetInput("string2"),
			dyn.GetInput("string3"),
			dyn.GetInput("string4"),
	    };

        local newString = strjoin("",unpack(strings));

		dyn.SetOutput("joinedString",newString);
	    dyn.TriggerOutPort("joinString");
	]],
	ports = {
		joinString = {
			name = "Joined",
			order = 1,
			direction = "out",
			description = "When the string is joined",
		},
	},
	inputs = {
		string1 = {
			name = "String 1",
			description = "the first string to join to the others",
            order = 1,
			type = "string",
			defaultValue = "",
		},
		string2 = {
			name = "String 2",
			description = "the second string to join to the others",
            order = 2,
			type = "string",
			defaultValue = "",
		},
		string3 = {
			name = "String 3",
			description = "the second string to join to the others",
            order = 3,
			type = "string",
			defaultValue = "",
		},
		string4 = {
			name = "String 4",
			description = "the second string to join to the others",
            order = 4,
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {
		joinedString = {
			name = "Joined String",
			description = "The Joined String",
			type = "string",
		},
	},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "Convert number to time string",
	guid = "to_time",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Converts a number into a time string with time units on.",
	icon = "Interface\\Icons\\Spell_holy_borrowedtime",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  local number = dyn.GetInput("number");

		dyn.SetOutput("time",SecondsToTime(number));
	]],
	ports = {
	},
	inputs = {
		number = {
			name = "Number",
			description = "The number to convert to time",
			type = "number",
			defaultValue = 0,
		},
	},
	outputs = {
		time = {
			name = "Time",
			description = "The time as string",
			type = "string"
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Color string",
	guid = "color_string",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Colors a string a desired color.",
	icon = "Interface\\AddOns\\GHM\\GHI_Icons\\_Misdirection_Green",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  local text = dyn.GetInput("text");
	    local color = dyn.GetInput("color");

		dyn.SetOutput("coloredText",GHI_ColorString(text,color.r,color.g,color.b));
	]],
	ports = {
	},
	inputs = {
		text = {
			name = "Text",
			description = "The text to color",
			type = "string",
		},
		color = {
			name = "Color",
			description = "The color to color the text in",
			type = "color",
		},
	},
	outputs = {
		coloredText = {
			name = "Colored Text",
			description = "The time as string",
			type = "string"
		},
	},
});
