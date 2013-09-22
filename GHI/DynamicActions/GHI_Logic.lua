--===================================================
--
--			GHI_Logic
--			GHI_Logic.lua
--
--	   Dynamic action data for the 'Logic' category
--
--		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local category = "Logic";

table.insert(GHI_ProvidedDynamicActions, {
	name = "Either Input (OR)",
	guid = "or_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Triggers the output when either of the inputs are triggered.",
	icon = "Interface\\Icons\\ACHIEVEMENT_GUILDPERK_FASTTRACK",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	allPortsTriggerScript = true,
	allowedInUpdateSequence = true,
	script =
	[[
		dyn.SetPortInFunction("in1",function()
			dyn.TriggerOutPort("out");
		end);
		dyn.SetPortInFunction("in2",function()
			dyn.TriggerOutPort("out");
		end);
	   	dyn.TriggerOutPort("out");
	]],
	ports = {
		in1 = {
			name = "Input Port 1",
			order = 1,
			direction = "in",
			description = "Triggers the output port, based on a Connection from another outport",
		},
		in2 = {
			name = "Input Port 2",
			order = 1,
			direction = "in",
			description = "Triggers the output port, based on a Connection from another outport",
		},
		out = {
			name = "Output Port",
			order = 1,
			direction = "out",
			description = "Triggered by either of the input ports.",
		},
	},
	inputs = {},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Random number",
	guid = "rand_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Generates a random number based on input",
	icon = "Interface\\Icons\\inv_misc_dice_01",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	allPortsTriggerScript = true,
	script =
	[[

	   local targetRand = dyn.GetInput("randommax")

	   local produceRandom = math.random(1,targetRand)

        dyn.SetOutput("randomNum",produceRandom);
	   dyn.TriggerOutPort("random1");
	]],
	ports = {
		random1 = {
			name = "Random number Generated",
			order = 1,
			direction = "out",
			description = "Port triggered after the random number is generated",
		},
	},
	inputs = {
		randommax = {
			name = "Max Interval",
			description = "The maximum of number to random by (IE 1-(input))",
			type = "number",
			defaultValue = "",
		},
	},
	outputs = {
		randomNum = {
			name = "Random Number",
			description = "The generated random number",
			type = "number",
		},
	},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "Random Port (weighted)",
	guid = "rand_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 2,
	category = category,
	description = "Triggers a port, or ports based on your weighting. Any port with weight less than or equal to the random number chosen will trigger.",
	icon = "Interface\\Icons\\inv_misc_dice_02",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allPortsTriggerScript = false,
	script =
	[[

	   local scale1 = dyn.GetInput("randomscale1")
	   local scale2 = dyn.GetInput("randomscale2")
	   local scale3 = dyn.GetInput("randomscale3")
	   local scale4 = dyn.GetInput("randomscale4")
	   local scale5 = dyn.GetInput("randomscale5")
	   local scale6 = dyn.GetInput("randomscale6")
	   
	   local weights = {scale1,scale2,scale3,scale4,scale5,scale6}
	   local num = 0
		for i,v in pairs(weights) do
			if v > num then
				num = v
			end
		end
			   
        local r = math.random(num)
          if r >= scale1 then
             dyn.TriggerOutPort("randomport1");
		 end
          if r >= scale2 then
             dyn.TriggerOutPort("randomport2");
          end
		  if r >= scale3 then
             dyn.TriggerOutPort("randomport3");
          end
		  if r >= scale4 then
             dyn.TriggerOutPort("randomport4");
          end
		  if r >= scale5 then
             dyn.TriggerOutPort("randomport5");
          end
		  if r >= scale6 then
             dyn.TriggerOutPort("randomport6");
          end

        --dyn.SetOutput("randomNum",produceRandom);
	   ;
	]],
	ports = {
		randomport1 = {
			name = "Random port 1",
			order = 1,
			direction = "out",
			description = "random port to use",
		},
		randomport2 = {
			name = "Random port 2",
			order = 2,
			direction = "out",
			description = "random port to use",
		},
		randomport3 = {
			name = "Random port 3",
			order = 3,
			direction = "out",
			description = "random port to use",
		},
		randomport4 = {
			name = "Random port 4",
			order = 4,
			direction = "out",
			description = "random port to use",
		},
		randomport5 = {
			name = "Random port 5",
			order = 5,
			direction = "out",
			description = "random port to use",
		},
		randomport6 = {
			name = "Random port 6",
			order = 6,
			direction = "out",
			description = "random port to use",
		},
	},
	inputs = {
		randomscale1 = {
			name = "Scale 1",
			description = "the weight to use for port one",
			order = 1,
			type = "number",
			defaultValue = 0,
		},
		randomscale2 = {
			name = "Scale 2",
			description = "the weight to use for port two",
			order = 2,
			type = "number",
			defaultValue = 0,
		},
		randomscale3 = {
			name = "Scale 3",
			description = "the weight to use for port three",
			order = 3,
			type = "number",
			defaultValue = 0,
		},
		randomscale4 = {
			name = "Scale 4",
			description = "the weight to use for port four",
			order = 4,
			type = "number",
			defaultValue = 0,
		},
		randomscale5 = {
			name = "Scale 5",
			description = "the weight to use for port five",
			order = 5,
			type = "number",
			defaultValue = 0,
		},
		randomscale6 = {
			name = "Scale 6",
			description = "the weight to use for port six",
			order = 6,
			type = "number",
			defaultValue = 0,
		},
	},
	outputs = {},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "Random Port (percentage)",
	guid = "rand_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Triggers a port based on a defined random percentage chance.",
	icon = "Interface\\Icons\\inv_misc_dice_02",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	allPortsTriggerScript = true,
	script =
	[[

	   local scale1 = dyn.GetInput("percentscale1")
	   local scale2 = dyn.GetInput("percentscale2")
	   local scale3 = dyn.GetInput("percentscale3")
	   local scale4 = dyn.GetInput("percentscale4")

	   local sum = scale1 + scale2 + scale3 + scale4
	   if sum ~= 100 then
		   print("invalid percentage total")
		   return
	   end
	   
       local r = math.random(1, 100)
          if r <= scale1 then
             dyn.TriggerOutPort("randomport1");
          elseif r > (scale1) and r <= (scale2 + scale1) then
             dyn.TriggerOutPort("randomport2");
          elseif r > (scale2 + scale1) and r <= (scale3 + scale2 + scale1) then
             dyn.TriggerOutPort("randomport3");
         elseif r > (scale3 + scale2 + scale1) and r <= (scale3 + scale2 + scale1 + scale4) then
             dyn.TriggerOutPort("randomport4");
          end

        --dyn.SetOutput("randomNum",produceRandom);
	   ;
	]],
	ports = {
		randomport1 = {
			name = "Random port 1",
			order = 1,
			direction = "out",
			description = "random port to use",
		},
		randomport2 = {
			name = "Random port 2",
			order = 1,
			direction = "out",
			description = "random port to use",
		},
		randomport3 = {
			name = "Random port 3",
			order = 1,
			direction = "out",
			description = "random port to use",
		},
		randomport4 = {
			name = "Random port 4",
			order = 1,
			direction = "out",
			description = "random port to use",
		},
	},
	inputs = {
		percentscale1 = {
			name = "port1",
			description = "Percent chance to trigger fist port.",
			order = 1,
			type = "number",
			defaultValue = "",
		},
		percentscale2 = {
			name = "port2",
			description = "Percent chance to trigger second port.",
			order = 2,
			type = "number",
			defaultValue = "",
		},
		percentscale3 = {
			name = "port3",
			description = "Percent chance to trigger third port.",
			order = 3,
			type = "number",
			defaultValue = "",
		},
		percentscale4 = {
			name = "port4",
			description = "Percent chance to trigger fourth port.",
			order = 4,
			type = "number",
			defaultValue = "",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Trigger several ports",
	guid = "all_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Triggers all its 4 output ports one by one. This is a handle tool to avoid long chains of actions.",
	icon = "Interface\\Icons\\ACHIEVEMENT_GUILDPERK_FASTTRACK",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	allPortsTriggerScript = true,
	allowedInUpdateSequence = true,
	script =
	[[
		for i=1,4 do
			dyn.TriggerOutPort("out"..i);
		end

	]],
	ports = {
		out1 = {
			name = "Output Port 1",
			order = 1,
			direction = "out",
			description = "1. output port triggered.",
		},
		out2 = {
			name = "Output Port 2",
			order = 2,
			direction = "out",
			description = "2. output port triggered.",
		},
		out3 = {
			name = "Output Port 3",
			order = 3,
			direction = "out",
			description = "3. output port triggered.",
		},
		out4 = {
			name = "Output Port 4",
			order = 4,
			direction = "out",
			description = "4. output port triggered.",
		},

	},
	inputs = {},
	outputs = {},
});

