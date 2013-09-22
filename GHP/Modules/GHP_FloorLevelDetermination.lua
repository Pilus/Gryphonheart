--===================================================
--
--				GHP_FloorLevelDetermination
--  			GHP_FloorLevelDetermination.lua
--
--	  State machine with logic for determining floor level
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local class;
function GHP_FloorLevelDetermination()
	if class then
		return class;
	end

	class = GHClass("GHP_FloorLevelDetermination");

	local stateGuid,stateName;
	local lastIndoor = -1;
	local lastPos;
	local floorData = {};

	local pos = GHI_Position();

	class.GetCurrentFloorLevel = function()
		local native = (IsIndoors() and "INDOORS") or "OUTDOORS";
		return stateGuid or native,stateName;
	end

	local Update;
	Update = function()
		local pos = pos.GetPlayerPos();
		if not(lastPos) then
			lastPos = pos;
			return
		end

		local inside = IsIndoors();
		if (inside == 1) then
			local currentGuid = stateGuid or GetRealZoneText();
			local current = floorData[currentGuid]; -- print(currentGuid,#(current or {}) )
			for i = 1,#(current or {}) do  -- look trough all transition segments in the current state

				local intersects,intersectionPos,_,_,dir = GetLineSegmentIntersection(pos,lastPos,current[i].startPoint,current[i].endPoint);
				--[[assert.are.same(string.format("Intersection: %s intersection %s to %s %.2f,%.2f,%s to %.2f,%.2f,%s || Movement: %.2f,%.2f,%s to %.2f,%.2f,%s",
					currentGuid,i,current[i].target,
					current[i].startPoint.x,current[i].startPoint.y,current[i].startPoint.world,
					current[i].endPoint.x,current[i].endPoint.y,current[i].endPoint.world,
					lastPos.x,lastPos.y,lastPos.world,
					pos.x,pos.y,pos.world
				),intersects)                 --]]
				--assert.are.same("Intersection:"..dir.." == "..tostring(current[i].direction),intersects);
				if intersects and dir == current[i].direction then
					stateGuid = current[i].target;
					stateName = (floorData[stateGuid] or {}).name;

					GHP_MiscData.floorLevel = {
						guid = stateGuid,
						name = stateName,
					};
					lastPos = intersectionPos;

					-- Call update with the new info
					Update();
					return
				end
			end
		else
			stateGuid = nil;
			stateName = nil;
			GHP_MiscData.floorLevel = nil;
		end
		lastPos = pos;
	end

	GHI_Position().OnNextMoveCallback(0.01,Update,true);

	-- Load last position from saved
	GHP_MiscData = GHP_MiscData or {};
	local data = GHP_MiscData.floorLevel or {};
	stateGuid = data.guid;
	stateName = data.name;

	local InsertBuilding = function(zone,info)
		local templateInfo = GHP_BUILDING_DATA[info.type];

		local rot = math.rad(info.rotation);
		local rotationMatrix = {
			{ math.cos(rot),	-math.sin(rot) 	},
			{ math.sin(rot),	math.cos(rot)		},
		}
		local calc = function(p)
			-- ax + by, cx + dy
			--[[if AA == true then
				assert.are.same(string.format("Rotation: %s, Offset: %.2f,%.2f ||| (%.2f,%.2f) => (%.2f,%.2f)",info.rotation,info.x,info.y,p.x,p.y,rotationMatrix[1][1]*p.x + rotationMatrix[1][2]*p.y + info.x,rotationMatrix[2][1]*p.x + rotationMatrix[2][2]*p.y + info.y),"")
			end
			AA = true;--]]

			return {
				x = rotationMatrix[1][1]*p.x + rotationMatrix[1][2]*p.y + info.x,
				y = rotationMatrix[2][1]*p.x + rotationMatrix[2][2]*p.y + info.y,
				world = info.world,
			}
		end

		local xOff,yOff = info.x,info.y;
		local guid,name = info.guid,info.name;

		-- add transitions to the zone
		for _,transition in pairs(templateInfo.ZONE or {}) do
			table.insert(floorData[zone],{
				direction = transition.direction,
				target = string.format(transition.target,guid),
				startPoint = calc(transition.startPoint),
				endPoint = calc(transition.endPoint),
			});
		end

		for index,transitionCollection in pairs(templateInfo) do
			if not(index == "ZONE" or index == "ref1" or index == "ref2" or index == "offset") then
				local t = {
					name = string.format(transitionCollection.name,name),
				};

				for _,transition in pairs(transitionCollection) do
					if type(transition) == "table" then
						table.insert(t,{
							direction = transition.direction,
							target = string.format(transition.target,guid),
							startPoint = calc(transition.startPoint),
							endPoint = calc(transition.endPoint),
						});

					end
				end
				---assert.are.same("floorData "..string.format(index,guid),tostring(t))
				floorData[string.format(index,guid)] = t;
			end
		end
	end

	-- Initialize floor data
	for zone,buildings in pairs(GHP_BUILDING_LOCATIONS or {}) do
		floorData[zone] = {};
		for _,buildingInfo in pairs(buildings) do
			InsertBuilding(zone,buildingInfo);
		end
	end

	return class;
end

