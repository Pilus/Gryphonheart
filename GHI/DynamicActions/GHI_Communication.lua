
local category = "Communication";

table.insert(GHI_ProvidedDynamicActions, {
	name = "Send data to player",
	guid = "comm_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	order = 1,
	category = category,
	description = "Send data to a player. The data can be picked up by the 'Recieve data from player' action.",
	icon = "Interface\\Icons\\Achievement_BG_returnXflags_def_WSG",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
		local priority = dyn.GetInput("priority");
		local playerName = dyn.GetInput("playerName");
		local prefix = dyn.GetInput("prefix");
		local arg1 = dyn.GetInput("arg1");
		local arg2 = dyn.GetInput("arg2");
		local arg3 = dyn.GetInput("arg3");
		local comm = GHI_Comm();
		comm.Send(priority,playerName,prefix,arg1,arg2,arg3);
		dyn.TriggerOutPort("send");
	]],
	ports = {
		send = {
			name = "Data send",
			order = 1,
			direction = "out",
			description = "Afer sending the message",
		},
	},
	inputs = {
		playerName = {
			name = "Player Name",
			description = "The player to send the data to",
			type = "string",
			defaultValue = "",
		},
		priority = {
			name = "Priority",
			description = "Priority of the data compared to other data in queue.",
			type = "string",
			defaultValue = "NORMAL",
			specialGHM = "ghm_fromDDList",
			specialGHMScript = [[
			dataFunc = function()
				return {
					{
						value = "NORMAL",
						text = "Normal",
					},
					{
						value = "ALERT",
						text = "Alert",
					},
					{
						value = "BULK",
						text = "Bulk",
					},
				};
			end]],
		},
		prefix = {
			name = "Prefix",
			description = "Prefix or protocol for the communication",
			type = "string",
			defaultValue = "",
		},
		arg1 = {
			name = "Arg1",
			description = "First data piece",
			type = "string",
			defaultValue = "",
		},
		arg2 = {
			name = "Arg2",
			description = "Second data piece (optional)",
			type = "string",
			defaultValue = "",
		},
		arg3 = {
			name = "Arg3",
			description = "Third data piece (optional)",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Recieve data from player",
	guid = "comm_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	order = 1,
	category = category,
	description = "Recieve data from another player",
	icon = "Interface\\Icons\\Achievement_BG_returnXflags_def_WSG",
	gotOnSetupPort = true,
	setupOnlyOnce = true,
	script =
	[[
		local prefix = dyn.GetInput("prefix");
		local comm = GHI_Comm();
		comm.AddRecieveFunc(prefix,function(player,arg1,arg2,arg3)
			dyn.SetOutput("playerName",playerName);
			dyn.SetOutput("arg1",arg1);
			dyn.SetOutput("arg2",arg2);
			dyn.SetOutput("arg3",arg3);
			dyn.TriggerOutPort("recieve");
		end);
	]],
	ports = {
		recieve = {
			name = "Data recieved",
			order = 1,
			direction = "out",
			description = "After recieving the data",
		},
	},
	inputs = {
		prefix = {
			name = "Prefix",
			description = "Prefix or protocol for the communication",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {
		playerName = {
			name = "Player Name",
			description = "The player the data is send by",
			type = "string",
		},
		arg1 = {
			name = "Arg1",
			description = "First data piece",
			type = "string",
		},
		arg2 = {
			name = "Arg2",
			description = "Second data piece",
			type = "string",
		},
		arg3 = {
			name = "Arg3",
			description = "Third data piece",
			type = "string",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Send data to channel",
	guid = "comm_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	order = 1,
	category = category,
	description = "Send data to a channel. The data can be picked up by the 'Recieve data from channel' action.",
	icon = "Interface\\Icons\\Achievement_BG_returnXflags_def_WSG",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
		local priority = dyn.GetInput("priority");
		local prefix = dyn.GetInput("prefix");
		local arg1 = dyn.GetInput("arg1");
		local arg2 = dyn.GetInput("arg2");
		local arg3 = dyn.GetInput("arg3");
		local comm = GHI_ChannelComm();
		comm.Send(priority,prefix,arg1,arg2,arg3);
		dyn.TriggerOutPort("send");
	]],
	ports = {
		send = {
			name = "Data send",
			order = 1,
			direction = "out",
			description = "After sending the data",
		},
	},
	inputs = {
		priority = {
			name = "Priority",
			description = "Priority of the data compared to other data in queue.",
			type = "string",
			defaultValue = "NORMAL",
			specialGHM = "ghm_fromDDList",
			specialGHMScript = [[
			dataFunc = function()
				return {
					{
						value = "NORMAL",
						text = "Normal",
					},
					{
						value = "ALERT",
						text = "Alert",
					},
					{
						value = "BULK",
						text = "Bulk",
					},
				};
			end]],
		},
		prefix = {
			name = "Prefix",
			description = "Prefix or protocol for the communication",
			type = "string",
			defaultValue = "",
		},
		arg1 = {
			name = "Arg1",
			description = "First data piece",
			type = "string",
			defaultValue = "",
		},
		arg2 = {
			name = "Arg2",
			description = "Second data piece (optional)",
			type = "string",
			defaultValue = "",
		},
		arg3 = {
			name = "Arg3",
			description = "Third data piece (optional)",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Recieve data from channel",
	guid = "comm_04",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	order = 1,
	category = category,
	description = "Recieve data from a channel",
	icon = "Interface\\Icons\\Achievement_BG_returnXflags_def_WSG",
	gotOnSetupPort = true,
	setupOnlyOnce = true,
	script =
	[[
		local prefix = dyn.GetInput("prefix");
		local comm = GHI_Comm();
		comm.AddRecieveFunc(prefix,function(player,arg1,arg2,arg3)
			dyn.SetOutput("playerName",playerName);
			dyn.SetOutput("arg1",arg1);
			dyn.SetOutput("arg2",arg2);
			dyn.SetOutput("arg3",arg3);
			dyn.TriggerOutPort("recieve");
		end);
	]],
	ports = {
		recieve = {
			name = "Data recieved",
			order = 1,
			direction = "out",
			description = "After recieving the data",
		},
	},
	inputs = {
		prefix = {
			name = "Prefix",
			description = "Prefix or protocol for the communication",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {
		playerName = {
			name = "Player Name",
			description = "The player the data is send by",
			type = "string",
		},
		arg1 = {
			name = "Arg1",
			description = "First data piece",
			type = "string",
		},
		arg2 = {
			name = "Arg2",
			description = "Second data piece",
			type = "string",
		},
		arg3 = {
			name = "Arg3",
			description = "Third data piece",
			type = "string",
		},
	},
});