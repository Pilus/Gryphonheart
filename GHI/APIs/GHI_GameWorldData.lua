--===================================================
--
--				GHI_GameWorldData
--  			GHI_GameWorldData.lua
--
--		Contains functions providing data about the
--		game world, such as temperature.
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;

local swimming = IsSwimming()
local outdoor = IsOutdoors()
local inside = IsIndoors()
local flying = IsFlying()
local onTaxi = UnitOnTaxi("player")

--all temperatures in Celsius, and rounded
local climates = {
	["mountain"] 	= { dayTemp = -15, 	nightTemp = -25, 	indoor = 5, 	humidity = "low", 		precipitation = "snow" 		},
	["forest"] 		= { dayTemp = 15,	nightTemp = 8, 		indoor = 20, 	humidity = "medium", 	precipitation = "rain" 		},
	["plain"] 		= { dayTemp = 10, 	nightTemp = 5, 		indoor = 15, 	humidity = "medium", 	precipitation = "rain" 		},
	["jungle"]		= { dayTemp = 40, 	nightTemp = 25, 	indoor = 30, 	humidity = "high", 		precipitation = "rain" 		},
	["highland"] 	= { dayTemp = 10, 	nightTemp = 5, 		indoor = 15, 	humidity = "low", 		precipitation = "rain" 		},
	["swamp"] 		= { dayTemp = 10, 	nightTemp = 5, 		indoor = 15, 	humidity = "high",		precipitation = "rain" 		},
	["cold_forest"] = { dayTemp = 10, 	nightTemp = 5, 		indoor = 15, 	humidity = "low", 		precipitation = "rain" 		},
	["indoor_city"] = { dayTemp = 20, 	nightTemp = 15, 	indoor = 25, 	humidity = "low", 		precipitation = "" 			},
	["wasteland"] 	= { dayTemp = 10,	nightTemp = 5, 		indoor = 15, 	humidity = "low", 		precipitation = "" 			},
	["desert"] 		= { dayTemp = 40, 	nightTemp = 5, 		indoor = 30, 	humidity = "low", 		precipitation = "sandstorm" },
}


local GHZoneData = {
	["default"] = { climate = "forest", lvlmin = 1, lvlmax = 85 },
	["gilneas city"] = { climate = "cold_forest", lvlmin = 1, lvlmax = 5 }, --(rain possible)
	["dun morogh"] = { climate = "mountain", lvlmin = 1, lvlmax = 10 }, --(snowstorm,wind)
	["elywnn forest"] = { climate = "forest", lvlmin = 1, lvlmax = 10 }, --(rain)
	["eversong woods"] = { climate = "forest", lvlmin = 1, lvlmax = 10 },
	["trisfal glades"] = { climate = "cold_forest", lvlmin = 1, lvlmax = 10 }, --(rain wind)
	["city of ironforge"] = { climate = "indoor_city", lvlmin = 1, lvlmax = 85 }, --(its a city with lava)
	["silvermoon city"] = { climate = "forest", lvlmin = 1, lvlmax = 85 },
	["undercity"] = { climate = "indoor_city", lvlmin = 1, lvlmax = 85 },
	["westfall"] = { climate = "plain", lvlmin = 10, lvlmax = 15 },
	["ghostlands"] = { climate = "cold_forest", lvlmin = 10, lvlmax = 20 },
	["loch modan"] = { climate = "highland", lvlmin = 10, lvlmax = 20 }, --(rain)
	["silverpine forest"] = { climate = "cold_forest", lvlmin = 10, lvlmax = 20 }, --(rain)
	["ruins of gilneas"] = { climate = "cold_forest", lvlmin = 14, lvlmax = 20 }, --(rain wind)
	["redridge mountains"] = { climate = "highland", lvlmin = 15, lvlmax = 20 },
	["blackrock mountain"] = { climate = "wasteland", lvlmin = 50, lvlmax = 60 },
	["badlands"] = { climate = "plain", lvlmin = 44, lvlmax = 48 },
	["searing gorge"] = { climate = "wasteland", lvlmin = 47, lvlmax = 51 },
	["burning steppes"] = { climate = "wasteland", lvlmin = 49, lvlmax = 52 },
	["deadwind pass"] = { climate = "wasteland", lvlmin = 50, lvlmax = 60 }, --(rain,wind)
	["swamp of sorrows"] = { climate = "swamp", lvlmin = 51, lvlmax = 55 }, --(rain)
	["blasted lands"] = { climate = "wasteland", lvlmin = 55, lvlmax = 60 },
	["isle of quel'danas"] = { climate = "forest", lvlmin = 70, lvlmax = 79 },
	["twilight highlands"] = { climate = "highland", lvlmin = 84, lvlmax = 85 },
	["wetlands"] = { climate = "swamp", lvlmin = 20, lvlmax = 25 }, --(rain)
	["arathi highlands"] = { climate = "highland", lvlmin = 25, lvlmax = 30 }, --(rain)
	["northern stranglethorn"] = { climate = "jungle", lvlmin = 25, lvlmax = 30 }, --rain
	["the cape of stranglethorn"] = { climate = "jungle", lvlmin = 30, lvlmax = 35 }, --rain
	["western plaugelands"] = { climate = "forest", lvlmin = 35, lvlmax = 40 },
	["eastern plaugelands"] = { climate = "cold_forest", lvlmin = 40, lvlmax = 45 },
	["duskwood"] = { climate = "forest", lvlmin = 20, lvlmax = 25 }, --(rain)
	["hillsbrad foothills"] = { climate = "highland", lvlmin = 20, lvlmax = 25 }, --(rain)
	["stormwind city"] = { climate = "forest", lvlmin = 1, lvlmax = 85 },
	["darnassus"] = { climate = "forest", lvlmin = 1, lvlmax = 85 }, --rain
	["teldrassil"] = { climate = "forest", lvlmin = 1, lvlmax = 10 },
	["orgrimmar"] = { climate = "plain", lvlmin = 1, lvlmax = 85 },
	["the exodar"] = { climate = "cold_forest", lvlmin = 1, lvlmax = 85 },
	["thunder bluff"] = { climate = "plain", lvlmin = 1, lvlmax = 85 },
	["mount hyjal"] = { climate = "cold_forest", lvlmin = 80, lvlmax = 82 },
	["silithus"] = { climate = "desert", lvlmin = 55, lvlmax = 60 }, --sand,wind
	["un'goro crater"] = { climate = "jungle", lvlmin = 50, lvlmax = 55 }, --rain
	["dustwallow marsh"] = { climate = "swamp", lvlmin = 35, lvlmax = 40 },
	["feralas"] = { climate = "jungle", lvlmin = 35, lvlmax = 40 }, --rain
	["desolace"] = { climate = "plain", lvlmin = 30, lvlmax = 40 }, --rain,wind (before cata it would have been "hot" i am sure)
	["southern barrans"] = { climate = "jungle", lvlmin = 30, lvlmax = 35 },
	["stonetalon mountains"] = { climate = "highland", lvlmin = 25, lvlmax = 30 }, --wind
	["ashenvale"] = { climate = "forest", lvlmin = 20, lvlmax = 25 }, --rain
	["azshara"] = { climate = "plain", lvlmin = 10, lvlmax = 20 },
	["thousand needles"] = { climate = "plain", lvlmin = 40, lvlmax = 45 },
	["tanaris"] = { climate = "desert", lvlmin = 45, lvlmax = 50 }, --wind sand
	["uldum"] = { climate = "desert", lvlmin = 83, lvlmax = 84 }, --wind, sand
	["durotar"] = { climate = "plain", lvlmin = 1, lvlmax = 10 },
	["mulgore"] = { climate = "plain", lvlmin = 1, lvlmax = 10 },
	["the steam pools"] = { climate = "swamp", lvlmin = 1, lvlmax = 85 },
	["northern barrens"] = { climate = "plain", lvlmin = 10, lvlmax = 20 },
	["winterspring"] = { climate = "mountain", lvlmin = 50, lvlmax = 55 }, --snow
	["darkshore"] = { climate = "cold_forest", lvlmin = 10, lvlmax = 20 }, --rain
	["moonglade"] = { climate = "highland", lvlmin = 1, lvlmax = 85 },
	["bloodmyst isle"] = { climate = "cold_forest", lvlmin = 1, lvlmax = 10 },
	["azuremyst isle"] = { climate = "cold_forest", lvlmin = 10, lvlmax = 20 },
	["deepholm"] = { climate = "wasteland", lvlmin = 82, lvlmax = 83 },
	["hellfire peninsula"] = { climate = "plain", lvlmin = 58, lvlmax = 70 },
	["Zangermarsh"] = { climate = "swamp", lvlmin = 60, lvlmax = 63 },
	["nagrand"] = { climate = "plain", lvlmin = 64, lvlmax = 70 },
	["terokkar Forest"] = { climate = "forest", lvlmin = 62, lvlmax = 70 },
	["shadowmoon valley"] = { climate = "wasteland", lvlmin = 67, lvlmax = 70 },
	["blade's edge mountains"] = { climate = "wasteland", lvlmin = 65, lvlmax = 70 },
	["netherstorm"] = { climate = "wasteland", lvlmin = 66, lvlmax = 70 },
	["icecrown"] = { climate = "mountain", lvlmin = 77, lvlmax = 80 },
	["the storm peaks"] = { climate = "mountain", lvlmin = 77, lvlmax = 80 },
	["crystalsong forest"] = { climate = "cold_forest", lvlmin = 70, lvlmax = 80 },
	["wintergrasp"] = { climate = "mountain", lvlmin = 77, lvlmax = 80 },
	["dragonblight"] = { climate = "mountain", lvlmin = 71, lvlmax = 80 },
	["borean tundra"] = { climate = "plain", lvlmin = 68, lvlmax = 72 },
	["sholazar basin"] = { climate = "jungle", lvlmin = 75, lvlmax = 80 },
	["zul'drak"] = { climate = "cold_forest", lvlmin = 73, lvlmax = 77 },
	["grizzly hills"] = { climate = "cold_forest", lvlmin = 73, lvlmax = 75 },
	["howling fjord"] = { climate = "cold_forest", lvlmin = 68, lvlmax = 72 },
	["dread wastes"] = { climate = "wasteland", lvlmin = 89, lvlmax = 90 },
	["krasarang wilds"] = { climate = "jungle", lvlmin = 86, lvlmax = 87 },
	["kun-lai summit"] = { climate = "plain", lvlmin = 87, lvlmax = 88 },
	["shrine of seven stars"] = { climate = "city", lvlmin = 1, lvlmax = 90 },
	["shrine of two moons"] = { climate = "city", lvlmin = 1, lvlmax = 90 },
	["the jade forest"] = { climate = "forest", lvlmin = 85, lvlmax = 86 },
	["the veiled stair"] = { climate = "highland", lvlmin = 1, lvlmax = 90	 },
	["townlong steppes"] = { climate = "plain", lvlmin = 88, lvlmax = 89 },
	["vale of eternal blossoms"] = { climate = "plain", lvlmin = 90, lvlmax = 90 },
	["valley of the four winds"] = { climate = "plain", lvlmin = 86, lvlmax = 87 },

}


function GHI_GameWorldData()
	if class then
		return class;
	end
	class = GHClass("GHI_GameWorldData");

	class.GHI_GetZoneLevel = function(zoneName)
		zoneName = zoneName or GetRealZoneText();
		zoneName = zoneName:lower();
		local zoneData = GHZoneData[zoneName] or GHZoneData["default"];
		return zoneData.lvlmin, zoneData.lvlmax;
	end

	class.GHI_GetZoneClimate = function(zoneName)
		zoneName = zoneName or GetRealZoneText();
		zoneName = zoneName:lower();
		local zoneData = GHZoneData[zoneName] or GHZoneData["default"];
		local climate = climates[zoneData.climate] or climates["forest"];
		return zoneData.climate, climate.dayTemp, climate.nightTemp, climate.indoor, climate.humidity, climate.precipitation;
	end

	class.GHI_GetCurrentZoneLevel = function()
		return class.GHI_GetZoneLevel(GetRealZoneText())
	end

	class.GHI_GetCurrentZoneClimate = function()
		return class.GHI_GetZoneClimate(GetRealZoneText())
	end

	class.GHI_GetCurrentTemperature = function()
		local _, dayTemp, nightTemp, indoor = class.GHI_GetCurrentZoneClimate();
		if IsIndoors() then
			return indoor;
		end

		local h,m = GetGameTime();
		local t = mod((h + m/60)-3,24);

		local temp;
		if t < 12 then
			temp = t*((dayTemp-nightTemp)/12)+ nightTemp;
		else
			temp = (t-12)*(-(dayTemp-nightTemp)/12)+ dayTemp;
		end

		if IsSwimming() then
			return temp-5;
		end

		return temp;
	end

	class.GetAPI = function()
		return {
			GHI_GetZoneLevel = class.GHI_GetZoneLevel,
			GHI_GetZoneClimate = class.GHI_GetZoneClimate,
			GHI_GetCurrentZoneLevel = class.GHI_GetCurrentZoneLevel,
			GHI_GetCurrentZoneClimate = class.GHI_GetCurrentZoneClimate,
			GHI_GetCurrentTemperature = class.GHI_GetCurrentTemperature,
		};
	end

	return class;
end

