--===================================================
--
--			GHI_Attributes
--			GHI_Attributes.lua
--
--	Dynamic action data for the 'Attributes' category
--
--		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local category = "Attributes";
table.insert(GHI_ProvidedDynamicActions, {
	name = "Get attribute",
	guid = "att_get",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Gets an attribute.",
	icon = "Interface\\AddOns\\GHM\\GHI_Icons\\_MoreRed",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[
	local att = dyn.GetInput("att");
	dyn.SetOutput("att_out",att);
	]],
	ports = {},
	inputs = {
		att = {
			name = "Choose the attribute",
			description = "",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {
		att_out = {
			name = "Target output",
			description = "",
			type = "any",
		},
	},
});

local AttTypes = GHM_Input_GetAvailableTypes();
local icons = {"Purple","Red","White","Yellow","Acid","Blue","Brown","Green","LightBlue","Orange","Pink","Purple","Red","White"};

for i,attType in pairs(AttTypes) do
	table.insert(GHI_ProvidedDynamicActions, {
		name = "Set attribute - "..attType,
		guid = "att_"..attType,
		authorName = "The Gryphonheart Team",
		authorGuid = "00x1",
		version = 2,
		category = category,
		description = "Sets an attribute.",
		icon = "Interface\\AddOns\\GHM\\GHI_Icons\\_Reverse_"..icons[mod(i-1,#(icons))+1],
		gotOnSetupPort = true,
		setupOnlyOnce = false,
		allowedInUpdateSequence = true,
		script =
		[[
			local att = dyn.GetInput("att");
			dyn.SetOutput("att_out",att);
		]],
		ports = {},
		inputs = {
			att = {
				name = "Input",
				description = "",
				type = attType,
				defaultValue = "",
			},
		},
		outputs = {
			att_out = {
				name = "Target output",
				description = "",
				type = attType,
			},
		},
	});
end

table.insert(GHI_ProvidedDynamicActions, {
		name = "Set attribute - Logo Number",
		guid = "att_Logo",
		authorName = "The Gryphonheart Team",
		authorGuid = "00x1",
		version = 1,
		category = category,
		description = "Sets an attribute.",
		icon = "Interface\\Icons\\Inv_Misc_Tournaments_Symbol_Gnome",
		gotOnSetupPort = true,
		setupOnlyOnce = false,
		allowedInUpdateSequence = true,
		script =
		[[
			local att = dyn.GetInput("att");
			dyn.SetOutput("att_out",att);
		]],
		ports = {},
		inputs = {
			att = {
				name = "Input",
				description = "",
				type = "number",
				specialGHM = "ghm_LogoNum",
				defaultValue = 0,
			},
		},
		outputs = {
			att_out = {
				name = "Target output",
				description = "",
				type = "number",
			},
		},
	});