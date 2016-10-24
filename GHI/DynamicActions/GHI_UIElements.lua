
local category = "UI Elements";

table.insert(GHI_ProvidedDynamicActions, {
	name = "Setup Slash Command",
	guid = "slash_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Sets up a custom slash command.",
	icon = "Interface\\Icons\\INV_Misc_Note_04",
	gotOnSetupPort = true,
	setupOnlyOnce = true,
	allowedInUpdateSequence = false,
	script =
	[[  local cmdPrefix = dyn.GetInput("cmdPrefix");
		local slashCmdHandler = GHI_SlashCmd(cmdPrefix);
	    slashCmdHandler.SetDefaultFunc(function(cmd)
	    	dyn.SetOutput("cmd",cmd);
	    	dyn.TriggerOutPort("cmdEntered");
	    end)
	]],
	ports = {
		cmdEntered = {
			name = "Slash Command entered",
			direction = "out",
			order = 1,
			description = "Fired when a command is entered.",
		},
	},
	inputs = {
		cmdPrefix = {
			name = "Slash prefix",
			description = "The /prefix that should be reacted to.(Such as /test)",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {
		cmd = {
			name = "Command",
			description = "The command entered",
			type = "string",
		},
	},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "Cast bar",
	guid = "cast_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Displays the cast bar.",
	icon = "Interface\\Icons\\INV_Misc_Note_01",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = false,
	script =
	[[
		local castBar = GHI_CastBarUI();
	    castBar.Cast(
	    	dyn.GetInput("name"),
	    	dyn.GetInput("icon"),
	        dyn.GetInput("duration"),
	        function() dyn.TriggerOutPort("finished") end,
	        function() dyn.TriggerOutPort("interrupted") end
	    );
	]],
	ports = {
		finished = {
			name = "Finished",
			direction = "out",
			order = 1,
			description = "Fired when the casting is done.",
		},
		interrupted = {
			name = "Interrupted",
			direction = "out",
			order = 2,
			description = "Fired if the casting is interrupted.",
		},
	},
	inputs = {
		name = {
			name = "Spell name",
			description = "The spell or ability name.",
			type = "string",
			defaultValue = "",
			order = 1,
		},
		icon = {
			name = "Spell icon",
			description = "The spell or ability name.",
			type = "icon",
			defaultValue = "",
			order = 2,
		},
		duration = {
			name = "Cast duration",
			description = "The spell or ability duration.",
			type = "time",
			defaultValue = 1,
			order = 3,
		},
	},
	outputs = {
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "User Input: Text",
	guid = "userInput_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Allows for gathering of text for the user.",
	icon = "Interface\\Icons\\INV_Misc_Note_01",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = false,
	script =
	[[
		local userInput
		local prompt = dyn.GetInput("prompt")
		local button1text = dyn.GetInput("button1")
		local button2text = dyn.GetInput("button2")
		
		local text
		
		StaticPopupDialogs["GHI_USERINPUT"] = {
		  text = prompt,
		  button1 = button1text,
		  button2 = button2text,
		  OnAccept = function(self)
				text = self.editBox:GetText()
				if text then
					dyn.SetOutput("userString",text)
				end
				dyn.TriggerOutPort("onOK")
		  end,
		  OnCancel = function(self)
			  dyn.TriggerOutPort("onCancel")
		  end,
		  hasEditBox = 1,
		  timeout = 0,
		  whileDead = true,
		  hideOnEscape = true,
		}
		StaticPopup_Show("GHI_USERINPUT")
	]],
	ports = {
		onOK = {
			name = "On OK",
			direction = "out",
			order = 1,
			description = "Fired when the OK button is pressed.",
		},
		onCancel = {
			name = "On Cancel",
			direction = "out",
			order = 2,
			description = "Fired when the Cancel button is pressed.",
		},
	},
	inputs = {	
		prompt = {
				name = "User Prompt",
				description = "Instructiosn for the user",
				type = "string",
				order = 1,
			},
		button1 = {
			name = "Okay",
			description = "Label for button number 1 (OK Button)",
			type = "string",
			order = 2,
			defaultValue = "Okay"
		},
		button2 = {
			name = "Cancel",
			description = "Label for button number 2 (Cancel Button)",
			type = "string",
			order = 3,
			defaultValue = "Cancel"
		},
	},
	outputs = {
		userString = {
			name = "Input",
			description = "The string of text provided by the user",
			type = "string",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Extra Button",
	guid = "extraButton_1",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Adds an Extra Button style button to trigger effects when pressed.",
	icon = "Interface\\Icons\\INV_Misc_Note_01",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = false,
	script = [[
		local button = GHI_ExtraButtonUI()
		
		button.SetTheme(dyn.GetInput("theme"), dyn.GetInput("icon"))
		button.SetCooldownTime(dyn.GetInput("cooldown"))
		button.SetTooltip(dyn.GetInput("tooltipTitle"),dyn.GetInput("tooltipText"))
		button.SetOnClick(function() dyn.TriggerOutPort("clicked") end)
		button.Toggle("show")
	]],
	ports = {
		clicked = {
			name = "On Click",
			direction = "out",
			order = 1,
			description = "Fired when the button is clicked.",
		},
	},
	inputs = {
		theme = {
			name = "Style",
			description = "The Style of the button to be displayed",
			type = "string",
			defaultValue = "Default",
			specialGHM = "ghm_fromDDList",
			specialGHMScript = [[
			dataFunc = function()
			local t = {"AirStrike","BrewmoonKeg","ChampionLight","Default","Engineering","FengBarrier","FengShroud","GreenstoneKeg","HozuBar","LightningKeg","Smash","Ultraxion","Ysera"};
			return t
			end
			]],
			order = 1,
		},
		icon = {
			name = "Spell Icon",
			description = "The Action icon for the button.",
			type = "icon",
			defaultValue = "",
			order = 2,
		},
		cooldown = {
			name = "Cooldown",
			description = "The cooldown of the action",
			type = "time",
			defaultValue = 1,
			order = 3,
		},
		tooltipTitle = {
			name = "Tooltip Title",
			description = "The name of the ability the button activates.",
			type = "string",
			defaultValue = "",
			order = 4,
		},
		tooltipText = {
			name = "Tooltip Description",
			description = "The description of the ability the button activates.",
			type = "string",
			defaultValue = "",
			order = 5,
		},
	},
	outputs = {
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Talking Head",
	guid = "talkingHead_1",
	authorName = "The Gryphonheart Team, Kruithne",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Creates a Talking Head window.",
	icon = "Interface\\Icons\\INV_Misc_Note_01",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = false,
	script = [[
		local displayInfo = dyn.GetInput("displayInfo")
		local cameraID = dyn.GetInput("cameraID")
		local duration= dyn.GetInput("duration")
		local name = dyn.GetInput("talkerName")
		local text = dyn.GetInput("speechText")
		local isNewTalkingHead = dyn.GetInput("newTalkingHead")
		
		GHI_ShowTalkingHead(displayInfo, cameraID, nil, duration, name, text, isNewTalkingHead)
	]],
	ports = {
		clicked = {
			name = "On Click",
			direction = "out",
			order = 1,
			description = "Fired when the button is clicked.",
		},
	},
	inputs = {
	--displayInfo, cameraID, vo, duration, name, text, isNewTalkingHead
		displayInfo = {
			name = "Model",
			description = "id number of 3D model to be used.",
			type = "number",
			defaultValue = 10001,
			order = 1,
		},
		cameraID = {
			name = "Camera ID",
			description = "The Camera ID to be used for the model.",
			type = "number",
			defaultValue = 1,
			order = 2,
		},
		duration = {
			name = "Duration",
			description = "Amount of time the Talking Head box remains open.",
			type = "time",
			defaultValue = 1,
			order = 3,
		},
		talkerName = {
			name = "Speeaker's Name",
			description = "Name fo the talking head actor.",
			type = "string",
			defaultValue = "",
			order = 4,
		},
		speechText = {
			name = "Speach Text",
			description = "Text for the head to say.",
			type = "string",
			defaultValue = "",
			order = 5,
		},
		newTalkingHead = {
			name = "New Talking Head",
			description = "Indicate if this is a new actor for the Talking Head",
			type = "boolean",
			defaultValue = true,
			order = 6,
		},
	},
	outputs = {
	},
});