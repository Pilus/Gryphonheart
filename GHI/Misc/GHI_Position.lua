--===================================================
--									
--					GHI Position
--					GHI_Position.lua
--
--		Information about position of the user
--	
-- 			(c)2013 The Gryphonheart Team
--				All rights reserved
--===================================================


function GHI_Position(useVersion1Coor)
	local class = GHClass("GHI_Position")

	--local variables
	local continent
	local currentContinent
	local x
	local y
	local zoneIndex
	local areaID
	local floorLevel;
	local dungeonLevel;
	local dungeonLevelDropDownShown;

	GHI_Event("GHP_LOADED",function()
		if GHP_FloorLevelDetermination then
			floorLevel = GHP_FloorLevelDetermination();
		end
	end);

	local Round = function(num,decimals)
		if decimals then
			return tonumber(string.format("%."..decimals.."f",num));
		end
		return num;
	end

	local ConvertMopToCata = function(x_mop,y_mop)
		local x_cata = 1.243338591 * x_mop - 2822.734638;
		local y_cata = 1.243339374 * y_mop - 409.9540594;
		return x_cata,y_cata;
	end

	local IsMopClient = function()
		local _, _, _, tocVersion = GetBuildInfo()
		return tocVersion >= 50000;
	end

	local DROPDOWNS = {"Level","Continent","Zone","ZoneMinimap"};
	local DD;
	local ClickDD = function(n)
		local f = _G["WorldMap"..n.."DropDownButton"];
		f:GetScript("OnClick")(f)
	end

	local ResetMap = function()
		SetMapToCurrentZone();
		if GetCurrentMapAreaID() == areaID then
			SetDungeonMapLevel(dungeonLevel);
		elseif areaID == -1 then
			if continent == -1 then -- cosmos
				SetMapZoom(-1);
			else -- Azeroth
				SetMapZoom(0);
			end
		else
			SetMapByID(areaID)
		end
		if DD then
			for i,v in pairs(DD) do
				if v then
					ClickDD(i);
				end
			end
		end
	end

	local IsDropDownShown = function(n)
		return DropDownList1:IsShown() and ({DropDownList1:GetPoint(1)})[2] == _G["WorldMap"..n.."DropDownLeft"];
	end

	--Class functions
	class.GetCoor = function(unit,decimals)
		if not (unit) then unit = "player" end

		zoneIndex = GetCurrentMapZone()
		continent = GetCurrentMapContinent()
		areaID = GetCurrentMapAreaID()
		dungeonLevel = GetCurrentMapDungeonLevel();

		-- check if drop down is shown
		DD = {
			Level = IsDropDownShown("Level"),
			Continent = IsDropDownShown("Continent"),
			Zone = IsDropDownShown("Zone"),
			ZoneMinimap = IsDropDownShown("ZoneMinimap"),
		}

		-- Move map
		SetMapToCurrentZone()
		currentContinent = GetCurrentMapContinent()
		if currentContinent < 0 or currentContinent > 7 or currentContinent == 5 then --7 is draenor,6 is pandaria, 5 is maelstrom
			ResetMap()
			return 0.0, 0.0, 0
		end

		if currentContinent == 3 then
			SetMapZoom(3)
		else
			SetMapZoom(0)
		end

		local x, y = GetPlayerMapPosition(unit)
		local level;
		if floorLevel then
			level = floorLevel.GetCurrentFloorLevel();
		end
		--print("raw", x, y)
		if currentContinent == 3 then
			x = x * 2228.61382 -- scale for Outland
			y = y * 1485.74255
			ResetMap();
			return Round(x,decimals), Round(y,decimals), 2, level
		else  -- scale for Azeroth
			if IsMopClient() and not(useVersion1Coor) then
				x = x * 14545.7650
				y = y * 9697.1767
			elseif IsMopClient() and useVersion1Coor then
				x,y = ConvertMopToCata(x * 11698.9534, y * 7799.30229);
			else
				x = x * 11698.9534
				y = y * 7799.30229
			end
			ResetMap();

			return Round(x,decimals), Round(y,decimals), 1, level
		end
	end

	class.GetPlayerPos = function(decimals)
		local x, y, world, level = class.GetCoor("player",decimals);
		return {
			x = x,
			y = y,
			world = world,
			level = level,
		};
	end

	class.IsPosWithinRange = function(position, range)
		GHCheck("GHI_Position.IsPosWithinRange", { "Table", "Number" }, { position, range })
		local playerPos = class.GetPlayerPos();
		position.world = position.world or position.continent;

		if not (playerPos.world == position.world) then
			return false;
		end
		if not(playerPos.level == position.level) then
			return false;
		end

		local xDiff = position.x - playerPos.x;
		local yDiff = position.y - playerPos.y;
		return math.abs(math.sqrt(xDiff * xDiff + yDiff * yDiff)) <= range
	end

	class.OnNextMoveCallback = function(range,func,_repeat)
		local pos = class.GetPlayerPos(3);
		GHI_Timer(function()
			if pos then
				if not(class.IsPosWithinRange(pos,range)) then
					func();
					if _repeat then
						pos = class.GetPlayerPos(3);
					else
						pos = nil;
					end
				end
			end
		end,1);
	end

	class.GetDirectionAndDistance = function(otherPos)
		local playerPos = class.GetPlayerPos();

		if not(otherPos.world == playerPos.world) then
			return 99999999
		end

		local dx = otherPos.x - playerPos.x;
		local dy = otherPos.y - playerPos.y;

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

		local directionNames = {"north","northeast","east","southeast","south","southwest","west","northwest","north"};
		local directionName = directionNames[math.floor((degreeAngle+22.5)/45)+1];

		local c = tostring(math.floor(dist)):len()-1;
		local roundDist = dist/(10^c);

		local distanceText = string.format("around %s%s meter%s",math.floor(roundDist+0.5),strrep("0",c),( roundDist >= 2 and "s") or "");

		return degreeAngle,directionName,dist,distanceText;
	end

	return class
end
