--===================================================
--
--			GHI_Other
--			GHI_Other.lua
--
--	   Dynamic action data for the 'Other' category
--
--		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local category = "Other";

table.insert(GHI_ProvidedDynamicActions, {
	name = "Message",
	guid = "msg_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 2,
	category = category,
	description = "Prints a given text in the chat window.",
	icon = "Interface\\Icons\\INV_Misc_Note_04",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  local msg = tostring(dyn.GetInput("msg"));
		local color = dyn.GetInput("color");
	 	local outputType = dyn.GetInput("outputType");
       
	 	if outputType == 2 or outputType == "Error Frame" then
	 		UIErrorsFrame:AddMessage(msg,color.r,color.g,color.b,53,5);
	 	else
	 		DEFAULT_CHAT_FRAME:AddMessage(msg,color.r,color.g,color.b);
	 	end
	]],
	ports = {},
	inputs = {
		msg = {
			name = "Message",
			description = "The text to print.",
			type = "string",
			defaultValue = "",
		},
		outputType = {
			name = "Output type",
			description = "Frame to output in",
			type = "string",
			defaultValue = "Chat Frame",
			specialGHM = "ghm_fromDDList",
			specialGHMScript = [[
			dataFunc = function()
				return {
					{
						value = "Chat Frame",
						text = "Chat frame",
					},
					{
						value = "Error Frame",
						text = "Error frame",
					},
				};
			end]],
		},
		color = {
			name = "Color",
			description = "Color of the text",
			type = "color",
			defaultValue = {r=1,g=1,b=1},
		},
		
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Script",
	guid = "script_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 2,
	category = category,
	description = "Executes a script. When used in an update sequence function declaration and loops are not allowed.",
	icon = "Interface\\Icons\\INV_Misc_Note_04",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  local code = dyn.GetInput("code");
	 	GHI_DoScript(code);
	]],
	ports = {
		portA = {
			name = "Dynamic port A",
			order = 1,
			direction = "out",
			description = 'Can be triggered in the code with dyn.TriggerOutPort("portA");',
		},
		portB = {
			name = "Dynamic port B",
			order = 2,
			direction = "out",
			description = 'Can be triggered in the code with dyn.TriggerOutPort("portB");',
		},
	},
	inputs = {
		code = {
			name = "Code",
			description = "The code to execute.",
			type = "code",
			defaultValue = "",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Change Item Icon",
	guid = "icon_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Changes the icon one stack of the item. This can also be done by setting the attribute 'icon' manually.",
	icon = "Interface\\Icons\\INV_Misc_Note_04",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  local icon = dyn.GetInput("icon");
	    stack.SetAttribute("icon",icon);
	]],
	ports = {},
	inputs = {
		icon = {
			name = "Icon",
			description = "New icon path.",
			type = "icon",
			defaultValue = "Interface\\Icons\\INV_Misc_Note_04",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Set Tooltip Line",
	guid = "icon_05",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 2,
	category = "",
	specialActionCategory = "tooltip",
	description = "Set the tooltip line that is currently being updated.",
	icon = "Interface\\Icons\\INV_Misc_Note_04",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  local text1 = dyn.GetInput("text1");
		local text2 = dyn.GetInput("text2");
		local text3 = dyn.GetInput("text3");
		local text = string.join("",text1 or "",text2 or "",text3 or "");
	    feedback.SetTooltipText(text);
	]],
	ports = {},
	inputs = {
		text1 = {
			name = "Text 1",
			description = "Partial text of the tooltip",
			type = "string",
			defaultValue = "",
			order=1,
		},
		text2 = {
			name = "Text 2",
			description = "Partial text of the tooltip",
			type = "string",
			defaultValue = "",
			order=2,
		},
		text3 = {
			name = "Text 3",
			description = "Partial text of the tooltip",
			type = "string",
			defaultValue = "",
			order=3,
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Event",
	guid = "event_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Sets up an event handler to react on a specific WoW interface event.\nA full list of available events can be seen at http://www.wowwiki.com/Events_A-Z_(Full_List)",
	icon = "Interface\\Icons\\INV_Misc_Note_04",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = false,
	script =
	[[  local event = dyn.GetInput("event");
	    GHI_Event(event,function(event,arg1,arg2,arg3)
	    	dyn.SetOutput("arg1",arg1);
			dyn.SetOutput("arg2",arg2);
			dyn.SetOutput("arg3",arg3);
			dyn.SetOutput("arg4",arg4);
			dyn.TriggerOutPort("triggered");
	    end);
	]],
	ports = {
		triggered = {
			name = "Event triggered",
			order = 1,
			direction = "out",
			description = "After the event is triggered",
		},
	},
	inputs = {
		event = {
			name = "Event",
			description = "Event to listen to",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {
		arg1 = {
			name = "Arg 1",
			description = "First argument",
			type = "string",
			order = 1,
		},
		arg2 = {
			name = "Arg 2",
			description = "Second argument",
			type = "string",
			order = 2,
		},
		arg3 = {
			name = "Arg 3",
			description = "Third argument",
			type = "string",
			order = 3,
		},
		arg4 = {
			name = "Arg 4",
			description = "Fourth argument",
			type = "string",
			order = 4,
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Delay",
	guid = "delay_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Creates a delay",
	icon = "Interface\\Icons\\SPELL_HOLY_BORROWEDTIME",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = false,
	script =
	[[  local delay = dyn.GetInput("delay");
	 	GHI_Timer(function()
	 		dyn.TriggerOutPort("delayed");
	 	end,delay,true);
	]],
	ports = {
		delayed = {
			name = "After delay",
			order = 1,
			direction = "out",
			description = "After the delay",
		},
	},
	inputs = {
		delay = {
			name = "Delay",
			description = "Delay in seconds.",
			type = "time",
			--defaultValue = 0,
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Save data",
	guid = "data_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Saves a variable or string, making it available trough Load data even after a reload or relog",
	icon = "Interface\\Icons\\INV_Misc_Note_01",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = false,
	script =
	[[  local index = dyn.GetInput("index");
		local data = dyn.GetInput("data");
	    GHI_Save(index,data);
	]],
	ports = {
	},
	inputs = {
		index = {
			name = "Data index",
			description = "Index / name of the data",
			type = "string",
			defaultValue = "",
		},
		data = {
			name = "Data",
			description = "The data to save",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Load data",
	guid = "data_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Loads a variable or string that have been saved by 'Save data'",
	icon = "Interface\\Icons\\INV_Misc_Note_06",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = false,
	script =
	[[  local index = dyn.GetInput("index");
		local data = GHI_Load(index);
	    dyn.SetOutput("data",data);
	]],
	ports = {
	},
	inputs = {
		index = {
			name = "Data index",
			description = "Index / name of the data",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {
		data = {
			name = "Data",
			description = "The loaded data",
			type = "string",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "LUA Statement",
	guid = "lua_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 2,
	category = category,
	description = "Sets up an event handler to react on a specific WoW interface event.\nA full list of available events can be seen at http://www.wowwiki.com/Events_A-Z_(Full_List)",
	icon = "Interface\\Icons\\INV_Misc_Note_03",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[  local code = dyn.GetInput("lua");
		GHI_DoScript("RES = "..code);
		dyn.SetOutput("value",RES);
	    if RES then
	        dyn.TriggerOutPort("isTrue");
	   	else
			dyn.TriggerOutPort("isFalse");
	    end;
	]],
	ports = {
		isTrue = {
			name = "Is true",
			order = 1,
			direction = "out",
			description = "If the statement is true",
		},
		isFalse = {
			name = "Is false",
			order = 2,
			direction = "out",
			description = "If the statement is false",
		},
	},
	inputs = {
		lua = {
			name = "LUA Statement",
			description = "LUA statement to evaluate",
			type = "string",
			defaultValue = "true",
		},
	},
	outputs = {
		value = {
			name = "Value",
			description = "Value returned by the statement",
			type = "boolean",
		},
	},
});


--[[
able.insert(GHI_ProvidedDynamicActions, {
	name = "Test Oject",
	guid = "test_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Dummy test object used for unit testing of GHI",
	icon = "Interface\\Icons\\INV_Misc_Map_01",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	script = "",
	ports = {
		in1 = {
			name = "In 1",
			direction = "in",
			order = 1,
			description = "",
		},
		in2 = {
			name = "In 2",
			direction = "in",
			order = 2,
			description = "",
		},
		out1 = {
			name = "Out 1",
			direction = "out",
			order = 1,
			description = "",
		},
		out2 = {
			name = "Out 2",
			direction = "out",
			order = 2,
			description = "",
		},
	},
	inputs = {},
	outputs = {},
}); --]]


