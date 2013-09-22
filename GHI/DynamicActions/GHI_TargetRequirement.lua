--===================================================
--
--				GHI_TargetRequirement
--  			GHI_TargetRequirement.lua
--
--
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local category = "Target Requirement";

table.insert(GHI_ProvidedDynamicActions, {
	name = "Target Name",
	guid = "target_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks targets name based on input",
	icon = "Interface\\Icons\\Ability_Hunter_BeastWithin",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetName = dyn.GetInput("name")


		if targetName == UnitName("target") then
			dyn.TriggerOutPort("hasname");
		else
			dyn.TriggerOutPort("notName");
		end

	]],
	ports = {
		hasname = {
			name = "Right Name",
			order = 1,
			direction = "out",
			description = "Has same name as input",
		},
		notName = {
			name = "wrong name",
			direction = "out",
			order = 2,
			description = "does not have the same name as input",
		},
	},
	inputs = {
		name = {
			name = "Target Name",
			description = "The name to check for",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "Target gender",
	guid = "target_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks targets name based on input",
	icon = "Interface\\Icons\\inv_misc_food_150_cookie",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetGender = dyn.GetInput("gender")

          local gender

          if UnitSex("target") == 1 then
               gender = "Unknown"
          elseif UnitSex("target") == 2 then
               gender = "Male"
          elseif UnitSex("target") == 3 then
               gender = "Female"
          end

		if targetGender:lower() == gender:lower() then
			dyn.TriggerOutPort("hasGender");
		else
			dyn.TriggerOutPort("notGender");
		end

	]],
	ports = {
		hasGender = {
			name = "Right Gender",
			order = 1,
			direction = "out",
			description = "Has same gender as input",
		},
		notGender = {
			name = "wrong Gender",
			direction = "out",
			order = 2,
			description = "does not have the same gender as input",
		},
	},
	inputs = {
		gender = {
			name = "Target Gender",
			description = "The Gender(male/female) to check for",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Target Level",
	guid = "target_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks if the target is a specific level",
	icon = "Interface\\Icons\\achievement_level_10",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetLevel = dyn.GetInput("level")

          local plevel = UnitLevel("Target")


          if targetLevel >= plevel then
                dyn.TriggerOutPort("hasLevel");
          else
                dyn.TriggerOutPort("notLevel");
          end


	]],
	ports = {
		hasLevel = {
			name = "Correct Level",
			order = 1,
			direction = "out",
			description = "Has same level as input",
		},
		notLevel = {
			name = "Incorrect Level",
			direction = "out",
			order = 2,
			description = "does not have the same level as input",
		},
	},
	inputs = {
		level = {
			name = "Level",
			description = "The level to check",
			type = "number",
			defaultValue = "",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Target Race",
	guid = "target_04",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks if the target is specific race",
	icon = "Interface\\Icons\\spell_shadow_nethercloak",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetRace = dyn.GetInput("race")

          local lRace, nlRace = UnitRace("Target") --l stands for localized, nl is not localized


          if targetRace:lower() == lRace:lower() or targetRace:lower() == nlRace then
                dyn.TriggerOutPort("isRace");
          else
                dyn.TriggerOutPort("notRace");
          end


	]],
	ports = {
		isRace = {
			name = "Correct Race",
			order = 1,
			direction = "out",
			description = "Has same race as input",
		},
		notRace = {
			name = "Incorrect Race",
			direction = "out",
			order = 2,
			description = "does not have the same race as input",
		},
	},
	inputs = {
		race = {
			name = "Race",
			description = "The race to check",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Target Class",
	guid = "target_05",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks if the target is specific class",
	icon = "Interface\\Icons\\achievement_general_classact",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetClass = dyn.GetInput("class")

          local lClass, nlClass = UnitClass("Target") --l stands for localized, nl is not localized


          if targetClass:lower() == lClass:lower() or targetClass:lower() == nlClass:lower() then
                dyn.TriggerOutPort("isClass");
          else
                dyn.TriggerOutPort("notClass");
          end


	]],
	ports = {
		isClass = {
			name = "Correct Class",
			order = 1,
			direction = "out",
			description = "Has same class as input",
		},
		notClass = {
			name = "Incorrect Class",
			direction = "out",
			order = 2,
			description = "does not have the same class as input",
		},
	},
	inputs = {
		class = {
			name = "Class",
			description = "The class to check",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Guild Name",
	guid = "guild_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks if the target is in a specific guild",
	icon = "Interface\\Icons\\inv_shirt_guildtabard_01",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetGuild = dyn.GetInput("guild")

          local guildName, _,_ = GetGuildInfo("Target")

          if targetGuild == guildName then
                dyn.TriggerOutPort("hasGuild");
          else
                dyn.TriggerOutPort("noGuild");
          end


	]],
	ports = {
		hasGuild = {
			name = "has a guild",
			order = 1,
			direction = "out",
			description = "Has same guild as input",
		},
		noGuild = {
			name = "No Guild",
			direction = "out",
			order = 2,
			description = "does not have the same guild as input or is not in a guild",
		},
	},
	inputs = {
		guild = {
			name = "Guild Name",
			description = "The guild name to check",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Target friendly",
	guid = "target_06",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks if the target is friendly",
	icon = "Interface\\Icons\\priest_icon_chakra_green",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
		if UnitIsFriend("player", "target")  then
			dyn.TriggerOutPort("friendly");
		else
			dyn.TriggerOutPort("notFriendly");
		end
	]],
	ports = {
		friendly = {
			name = "Friendly",
			order = 1,
			direction = "out",
			description = "The target is friendly",
		},
		notFriendly = {
			name = "Not friendly",
			direction = "out",
			order = 2,
			description = "The target is not friendly",
		},
	},
	inputs = {},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Target dead",
	guid = "target_07",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks if the target is dead",
	icon = "Interface\\Icons\\Spell_Shadow_NightOfTheDead",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
		if UnitIsDead("target")  then
			dyn.TriggerOutPort("dead");
		else
			dyn.TriggerOutPort("notDead");
		end
	]],
	ports = {
		dead = {
			name = "Dead",
			order = 1,
			direction = "out",
			description = "The target is dead",
		},
		notDead = {
			name = "Not dead",
			direction = "out",
			order = 2,
			description = "The target is not dead",
		},
	},
	inputs = {},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Target player",
	guid = "target_08",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks if the target is player",
	icon = "Interface\\Icons\\Achievement_Character_Human_Male",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
		if UnitIsPlayer("target")  then
			dyn.TriggerOutPort("player");
		else
			dyn.TriggerOutPort("notPlayer");
		end
	]],
	ports = {
		player = {
			name = "A player",
			order = 1,
			direction = "out",
			description = "The target is a player",
		},
		notPlayer = {
			name = "Not a player",
			direction = "out",
			order = 2,
			description = "The target is not a player",
		},
	},
	inputs = {},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Target hostile",
	guid = "target_09",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks if the target is hostile",
	icon = "Interface\\Icons\\priest_icon_chakra_red",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
		if UnitIsHostile("player", "target")  then
			dyn.TriggerOutPort("hostile");
		else
			dyn.TriggerOutPort("notHostile");
		end
	]],
	ports = {
		hostile = {
			name = "Hostile",
			order = 1,
			direction = "out",
			description = "The target is hostile",
		},
		notHostile = {
			name = "Not hostile",
			direction = "out",
			order = 2,
			description = "The target is not hostile",
		},
	},
	inputs = {},
	outputs = {},
});

