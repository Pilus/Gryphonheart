--
--
--			GHI_Location
--			GHI_Location.lua
--
--	   Dynamic action data for the location category
--
--		(c)2013 The Gryphonheart Team
--			All rights reserved
--
local category = "Location";


table.insert(GHI_ProvidedDynamicActions, {
	name = "Zone",
	guid = "zone_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action detects if the player is inside a zone with the given name or not.",
	icon = "Interface\\Icons\\INV_Misc_Map02",
	allowedInUpdateSequence = true,
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[  local targetZone = dyn.GetInput("zone");
	 	local currentZone = GetRealZoneText();
	 	dyn.SetOutput("currentZone",currentZone);
	    if currentZone:lower() == targetZone:lower() then
	          dyn.TriggerOutPort("inside");
	    else
		     dyn.TriggerOutPort("outside");
	    end
	]],
	ports = {
		inside = {
			name = "In Zone",
			order = 1,
			direction = "out",
			description = "If the player is located in the zone with the given name",
		},
		outside = {
			name = "Elsewhere",
			direction = "out",
			order = 2,
			description = "If the player is not located in the zone with the given name",
		},
	},
	inputs = {
		zone = {
			name = "Zone",
			description = "The zone the player must be located in",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {
		currentZone = {
			name = "Current Zone",
			description = "The zone the player is acually located in",
			type = "string",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Subzone",
	guid = "zone_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action detects if the player is inside a subzone with the given name or not.",
	icon = "Interface\\Icons\\INV_Misc_Map_01",
	gotOnSetupPort = false,
	allowedInUpdateSequence = true,
	setupOnlyOnce = false,
	script =
	[[  local targetSubZone = dyn.GetInput("subzone");
	 	local currentSubZone = GetSubZoneText();
	 	dyn.SetOutput("currentSubZone",currentSubZone);
	    if currentSubZone:lower() == targetSubZone:lower() then
	          dyn.TriggerOutPort("inside");
	    else
			dyn.TriggerOutPort("outside");
	    end
	]],
	ports = {
		inside = {
			name = "In Zone",
			direction = "out",
			order = 1,
			description = "If the player is located in the zone with the given name",
		},
		outside = {
			name = "Elsewhere",
			direction = "out",
			order = 2,
			description = "If the player is not located in the zone with the given name",
		},
	},
	inputs = {
		subzone = {
			name = "Subzone",
			description = "The subzone the player must be located in",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {
		currentSubZone = {
			name = "Current Zone",
			description = "The zone the player is acually located in",
			type = "string",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Zone Level",
	guid = "zone_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action detects if the player in a zone of the specific level",
	icon = "Interface\\Icons\\INV_Misc_Map_01",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[  local targetLevel = dyn.GetInput("levelrange");
	 	local currentLevel = UnitLevel("player");

	 	local lvlmin,lvlmax = GetCurrentZoneLevel();
	 	--dyn.SetOutput("currentLevel",currentLevel);
	    if currentLevel >= targetLevel then
	     if currentLevel > lvlmin or currentLevel >= lvlmax then
	          dyn.TriggerOutPort("inside");
	     else
	          dyn.TriggerOutPort("outside");
	     end
	    else
			dyn.TriggerOutPort("outside");
	    end
	]],
	ports = {
		inside = {
			name = "In Level Range",
			direction = "out",
			order = 1,
			description = "If the player is the right level",
		},
		outside = {
			name = "Elsewhere",
			direction = "out",
			order = 2,
			description = "If the player is not the right level",
		},
	},
	inputs = {
		levelrange = {
			name = "Level Range Min",
			description = "The level the player must be",
			type = "number",
			defaultValue = "",
		},
	},
	outputs = {},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "Can Fly in Zone",
	guid = "zone_04",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action detects if the player can fly in the zone or has the skill to fly at all",
	icon = "Interface\\Icons\\INV_Misc_Map_01",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[

	    local currentZone = GetZoneText()
         local flyable = IsFlyableArea()
         local FML = GetSpellInfo("Flight Master's License")
         local AMR = GetSpellInfo("Artisan Riding") or GetSpellInfo("Master Riding")
         local Cor = GHI_Position();

	    dyn.SetOutput("currentZone",currentZone);
	    if flyable == 1 and AMR ~= nil then
	          dyn.TriggerOutPort("canfly");
	    else
		     dyn.TriggerOutPort("nofly");
	    end
	]],
	ports = {
		canfly = {
			name = "Can Fly",
			direction = "out",
			order = 1,
			description = "If the player can fly",
		},
		nofly = {
			name = "Can Not Fly",
			direction = "out",
			order = 2,
			description = "If the player cannot fly",
		},
	},
	inputs = {},
	outputs = {
		currentZone = {
			name = "Current Zone",
			description = "The zone the player is acually located in",
			type = "string",
		},
	},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "Coordinate(Circle)",
	guid = "cord_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Check coordinates in a circle",
	icon = "Interface\\Icons\\inv_misc_idol_05",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[

        local Cor = GHI_Position();

	 	local targetPos = dyn.GetInput("position")
        local range = dyn.GetInput("range");

        local inRange = Cor.IsPosWithinRange(targetPos,range)

	    if inRange then
	          dyn.TriggerOutPort("inside");
	    else
		     dyn.TriggerOutPort("outside");
	    end
	]],
	ports = {
		inside = {
			name = "Inside area",
			direction = "out",
			order = 1,
			description = "If the player is in the coordinate area",
		},
		outside = {
			name = "Outside area",
			direction = "out",
			order = 2,
			description = "If the player is outside Coordinate area",
		},
	},
	inputs = {
		position = {
			name = "Position",
			description = "Position to check",
			type = "position",
			order = 1,
		},
		range = {
			name = "Range",
			description = "Range to check",
            order = 2,
			type = "number",
			defaultValue = "",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Coordinate(Square)",
	guid = "cord_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Check coordinates in a Square",
	icon = "Interface\\Icons\\inv_misc_idol_05",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[

          local Cor = GHI_Position();

          local targetPos = dyn.GetInput("position")
          local range = dyn.GetInput("range");


          local inRange = Cor.IsPosWithinRange(targetPos,range)

          --dyn.SetOutput("currentPos",currentPos);

           --square coordinate math to check for if steatment

	    if inRange then
	          dyn.TriggerOutPort("inside");
	    else
		     dyn.TriggerOutPort("outside");
	    end
	]],
	ports = {
		inside = {
			name = "Inside coordinate area",
			direction = "out",
			order = 1,
			description = "If the player is in the coordinate area",
		},
		outside = {
			name = "Outside Coordinate Area",
			direction = "out",
			order = 2,
			description = "If the player is outside Coordinate area",
		},
	},
	inputs = {
		position = {
			name = "Position",
			description = "Position to check",
			type = "position",
			order = 1,
		},
		range = {
			name = "Range",
			description = "Range to check",
            order = 2,
			type = "number",
			defaultValue = "",
		},
	},
	outputs = {
		currentPos = {
			name = "Current Player Postion",
			description = "The current coordinates of the player",
			type = "string",
		},
	},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "Is Indoors",
	guid = "indoor_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action checks to see if the player is indoors.",
	icon = "Interface\\Icons\\inv_misc_plant_02",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[



		if IsIndoors() == 1 then
			dyn.TriggerOutPort("isInside");
		elseif IsIndoors() == nil then
			dyn.TriggerOutPort("isOutside");
		end

	]],
	ports = {
		isInside = {
			name = "is Inside",
			order = 1,
			direction = "out",
			description = "is Inside",
		},
		isOutside = {
			name = "is Outside",
			direction = "out",
			order = 2,
			description = "Is Outside",
		},
	},
	inputs = {},
	outputs = {},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "Current Temperature",
	guid = "climate_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "This action gives information about the current temperature.",
	icon = "Interface\\Icons\\Achievement_Zone_ElwynnForest",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[
		dyn.SetOutput("temperature",GHI_GetCurrentTemperature());
	]],
	ports = {},
	inputs = {},
	outputs = {
		temperature = {
			name = "Temperature",
			description = "The current temperature",
			type = "number",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Distance to coordinate",
	guid = "distance",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Get the distance from the player to a coordinate",
	icon = "Interface\\Icons\\inv_misc_idol_05",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[

		local Cor = GHI_Position();

		local targetPos = dyn.GetInput("position");
		local playerPos = Cor.GetPlayerPos();

		if not(targetPos.world == playerPos.world) then
			dyn.SetOutput("distance",99999999);
			return
		end

		local dx = targetPos.x - playerPos.x;
		local dy = targetPos.y - playerPos.y;

		local dist = sqrt(dx^2+dy^2);

		local degreeAngle
		if dx >= 0 and dy >= 0 then
			degreeAngle = atan(dy/dx)+90;
		elseif dy >= 0 then
			degreeAngle = atan(-dx/dy)+180;
		elseif dx >= 0 then
			degreeAngle = atan(dx/-dy);
		else
			degreeAngle = atan(-dy/-dx)+270;
		end

		dyn.SetOutput("distance",dist);
		dyn.SetOutput("direction",degreeAngle);

		local directionNames = {"north","northeast","east","southeast","south","southwest","west","northwest","north"};
	    local directionName = directionNames[math.floor((degreeAngle+22.5)/45)+1];

	    local c = tostring(math.floor(dist)):len()-1;
	    local roundDist = dist/(10^c);

	    local distanceText = string.format("around %s%s meter%s",math.floor(roundDist),strrep("0",c),( roundDist >= 2 and "s") or "");

	    dyn.SetOutput("distanceInWords",distanceText);
	    dyn.SetOutput("directionInWords",directionName);


	]],
	ports = {
	},
	inputs = {
		position = {
			name = "Position",
			description = "Position to check",
			type = "position",
			order = 1,
		},
	},
	outputs = {
		distance = {
			name = "Precise distance",
			description = "The precise distance from the player to the coordinate",
			type = "number",
			order = 1,
		},
		direction = {
			name = "Precise direction",
			description = "The precise direction from the player to the coordinate",
			type = "number",
			order = 2,
		},
		distanceInWords = {
			name = "Distance described in words",
			description = "The rounded distance described in words",
			type = "string",
			order = 3,
		},
		directionInWords = {
			name = "Direction described in words",
			description = "The ca. direction described in words",
			type = "string",
			order = 4,
		},
	},
});


