--
--
--				GHI_PlayerRequirements
--  			GHI_PlayerRequirement.lua
--
--
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--
local category = "Player Requirements";

table.insert(GHI_ProvidedDynamicActions, {
	name = "Player Name",
	guid = "player_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks players name based on input",
	icon = "Interface\\Icons\\Ability_Hunter_BeastWithin",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetName = dyn.GetInput("name")


		if targetName == UnitName("player") then
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
			name = "Player Name",
			description = "The name to check for",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "Target gender",
	guid = "player_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks players name based on input",
	icon = "Interface\\Icons\\inv_misc_food_150_cookie",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetGender = dyn.GetInput("gender")

          local gender

          if UnitSex("Player") == 1 then
               gender = "Unknown"
          elseif UnitSex("Player") == 2 then
               gender = "Male"
          elseif UnitSex("Player") == 3 then
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
			name = "Player Gender",
			description = "The Gender(male/female) to check for",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Player Level",
	guid = "player_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks if the player is a specific level",
	icon = "Interface\\Icons\\achievement_level_10",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetLevel = dyn.GetInput("level")

          local plevel = UnitLevel("Player")


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
	name = "Player Race",
	guid = "player_04",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks if the player is specific race",
	icon = "Interface\\Icons\\spell_shadow_nethercloak",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetRace = dyn.GetInput("race")

          local lRace, nlRace = UnitRace("Player") --l stands for localized, nl is not localized


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
	name = "Player Class",
	guid = "player_05",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks if the player is specific class",
	icon = "Interface\\Icons\\achievement_general_classact",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetClass = dyn.GetInput("class")

          local lClass, nlClass = UnitClass("Player") --l stands for localized, nl is not localized


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
	guid = "guild_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Checks if the player is in a specific guild",
	icon = "Interface\\Icons\\inv_shirt_guildtabard_01",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetGuild = dyn.GetInput("guild")

          local guildName, _,_ = GetGuildInfo("Player")

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
	name = "Has Profession",
	guid = "prof_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action checks for a Profession based on a provided input.",
	icon = "Interface\\Icons\\trade_tailoring",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetProf = dyn.GetInput("profession")

		local gotProfession = false;
		for _,prof in pairs({GetProfessions()}) do
			local name = GetProfessionInfo(prof)
			if name:lower() == targetProf:lower() then
				gotProfession = true;
			end
		end
		if gotProfession then
			dyn.TriggerOutPort("hasProf");
		else
			dyn.TriggerOutPort("noProf");
		end

	]],
	ports = {
		hasProf = {
			name = "HasProf",
			order = 1,
			direction = "out",
			description = "Has Profession",
		},
		noProf = {
			name = "No Profession",
			direction = "out",
			order = 2,
			description = "does not have the profession",
		},
	},
	inputs = {
		profession = {
			name = "Profession",
			description = "The Profession name to check for",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {},
});
table.insert(GHI_ProvidedDynamicActions,{
	name = "Has Profession Skill",
	guid = "prof_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action checks for a Profession based on a provided input.",
	icon = "Interface\\Icons\\trade_tailoring",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[


		local targetProf = dyn.GetInput("profession")
          local targetSkill = dyn.GetInput("skill")
		local gotProfession = false;
		local gotSkill = false;
		for _,prof in pairs({GetProfessions()}) do
			local name,_,skill = GetProfessionInfo(prof)
			if name:lower() == targetProf:lower() then
				gotProfession = true;
                      if skill >= targetSkill then
                        gotSkill = true;
                      end
			end
		end
		if gotProfession then
			dyn.TriggerOutPort("hasProf");
		else
			dyn.TriggerOutPort("noProf");
		end

	]],
	ports = {
		hasProf = {
			name = "HasProf",
			order = 1,
			direction = "out",
			description = "Has Profession Skill Level",
		},
		noProf = {
			name = "No Profession",
			direction = "out",
			order = 2,
			description = "does not have the profession skill level",
		},
	},
	inputs = {
		profession = {
			name = "Profession",
			description = "The Profession name to check for",
               order = 1,
			type = "string",
			defaultValue = "",
          },
          skill = {
			name = "skill level",
			description = "The Profession skill level to check for",
               order = 2,
			type = "number",
			defaultValue = "",
		},
	},
	outputs = {

	},


});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Is mounted",
	guid = "status_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action checks to see if the player is mounted.",
	icon = "Interface\\Icons\\ability_mount_nightmarehorse",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[



		if IsMounted() then
			dyn.TriggerOutPort("isMount");
		else
			dyn.TriggerOutPort("noMount");
		end

	]],
	ports = {
		isMount = {
			name = "is Mounted",
			order = 1,
			direction = "out",
			description = "is Mounted",
		},
		noMount = {
			name = "is Not Mounted",
			direction = "out",
			order = 2,
			description = "Is not mounted",
		},
	},
	inputs = {},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Is Swimming",
	guid = "status_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action checks to see if the player is swimming.",
	icon = "Interface\\Icons\\ability_suffocate",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[



		if IsSwimming() then
			dyn.TriggerOutPort("isSwim");
		else
			dyn.TriggerOutPort("noSwim");
		end

	]],
	ports = {
		isSwim = {
			name = "is Swimming",
			order = 1,
			direction = "out",
			description = "is Swimming",
		},
		noSwim = {
			name = "is Not Swimming",
			direction = "out",
			order = 2,
			description = "Is not Swimming",
		},
	},
	inputs = {},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Is Flying",
	guid = "status_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action checks to see if the player is Flying.",
	icon = "Interface\\Icons\\ability_eyeoftheowl",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[



		if IsFlying() then
			dyn.TriggerOutPort("isFlying");
		else
			dyn.TriggerOutPort("notFlying");
		end

	]],
	ports = {
		isFlying = {
			name = "is flying",
			order = 1,
			direction = "out",
			description = "is flying",
		},
		notFlying = {
			name = "is not flying",
			direction = "out",
			order = 2,
			description = "Is not flying",
		},
	},
	inputs = {},
	outputs = {},
});