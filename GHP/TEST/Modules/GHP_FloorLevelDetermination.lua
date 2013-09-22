describe("GHP_FloorLevelDetermination",function()
	require("StandardMock");
	require("GHP_SegmentIntersection");
	require("GHP_FloorLevelDetermination");

	it("should be a function",function()
		assert.are.same("function",type(GHP_FloorLevelDetermination));
	end);

	GHP_BUILDING_DATA = {
		["DemoHouse"] = {
			["ZONE"] = {
				-- all transitions from outside to inside
				{
					startPoint = {
						x = -15,
						y = 0,
					},
					endPoint = {
						x = -15,
						y = 15,
					},
					direction = -1,
					target = "%s_FloorA",
				}
			},
			["%s_FloorA"] = {
				{
					startPoint = {
						x = -15,
						y = 0,
						world = 1,
					},
					endPoint = {
						x = -15,
						y = 15,
						world = 1,
					},
					direction = 1,
					target = "ZONE",
				},
				{
					startPoint = {
						x = 20,
						y = 20,
						world = 1,
					},
					endPoint = {
						x = 0,
						y = 20,
						world = 1,
					},
					direction = -1,
					target = "%s_FloorB",
				},
				{
					startPoint = {
						x = 0,
						y = 20,
						world = 1,
					},
					endPoint = {
						x = 0,
						y = 40,
						world = 1,
					},
					direction = -1,
					target = "%s_FloorB",
				},
				name = "%s ground floor",
			},
			["%s_FloorB"] = {
				{
					startPoint = {
						x = 20,
						y = 20,
						world = 1,
					},
					endPoint = {
						x = 0,
						y = 20,
						world = 1,
					},
					direction = 1,
					target = "%s_FloorA",
				},
				{
					startPoint = {
						x = 0,
						y = 20,
						world = 1,
					},
					endPoint = {
						x = 0,
						y = 40,
						world = 1,
					},
					direction = 1,
					target = "%s_FloorA",
				},
				{
					startPoint = {
						x = 0,
						y = 0,
						world = 1,
					},
					endPoint = {
						x = 0,
						y = 20,
						world = 1,
					},
					direction = 1,
					target = "%s_FloorC",
				},
				name = "%s stairs",
			},
			["%s_FloorC"] = {
				{
					startPoint = {
						x = 0,
						y = 0,
						world = 1,
					},
					endPoint = {
						x = 0,
						y = 40,
						world = 1,
					},
					direction = -1,
					target = "%s_FloorB",
				},
				name = "%s first floor",
			},
			ref1 = {
				x = 0,
				y = 0,
				world = 1,
			},
			ref2 = {
				x = 0,
				y = 20,
				world = 1,
			},
		},
	};

	GHP_BUILDING_LOCATIONS = {
		["Test Zone"] = {
			{
				x = 100,
				y = 100,
				rotation = -45,
				world = 1,
				type = "DemoHouse",
				guid = "Mansion",
				name = "The mansion",
			},
		},
	}

	-- Position mock
	local X,Y,WORLD = 0,0,1;
	local UPDATE_FUNC;
	GHI_Position = function()
		return {
			GetPlayerPos = function()
				return {
					x = X,
					y = Y,
					world = WORLD,
				}
			end,
			OnNextMoveCallback = function(_,func,_)
				UPDATE_FUNC = func;
			end,
		}
	end

	local INDOOR = 1;
	IsIndoors = function()
		return INDOOR;
	end

	local ZONE = "";
	GetRealZoneText = function()
		return ZONE;
	end

	it("should load its current floorguid and floorname from GHP_MiscData",function()
		local GUID = "HouseX_Floor2";
		local NAME = "Floor 2 of HouseX";
		GHP_MiscData = {
			floorLevel = {
				guid = GUID;
				name = NAME;
			}
		}
		local fld = GHP_FloorLevelDetermination();
		assert.are.same("function",type(fld.GetCurrentFloorLevel));
		local guid,name = fld.GetCurrentFloorLevel();
		assert.are.same(guid,GUID);
		assert.are.same(name,NAME);
	end)

	it("should register a update func",function()
		assert.are.same("function",type(UPDATE_FUNC));
	end)

	it("should change state depending on movement",function()

		local fld = GHP_FloorLevelDetermination();
		INDOOR = nil;
		UPDATE_FUNC();
		UPDATE_FUNC();
		assert.are.same(nil,fld.GetCurrentFloorLevel());

		ZONE = "Test Zone";

		-- Move towards the door
		X,Y = 85,125;
		INDOOR = nil;
		UPDATE_FUNC();
		assert.are.same(nil,fld.GetCurrentFloorLevel());

		-- Move inside the door
		X,Y = 100,115;
		INDOOR = 1;
		UPDATE_FUNC();
		local floorGuid,floorName = fld.GetCurrentFloorLevel();
		assert.are.same("Mansion_FloorA",floorGuid);
		assert.are.same("The mansion ground floor",floorName);

		-- Move towards the staircase
		X,Y = 120,130;
		INDOOR = 1;
		UPDATE_FUNC();
		local floorGuid,floorName = fld.GetCurrentFloorLevel();
		assert.are.same("Mansion_FloorA",floorGuid);

		-- Move up the staircase
		X,Y = 150,100;
		INDOOR = 1;
		UPDATE_FUNC();
		local floorGuid,floorName = fld.GetCurrentFloorLevel();
		assert.are.same("Mansion_FloorB",floorGuid);
		assert.are.same("The mansion stairs",floorName);

		-- Around in the staircase
		X,Y = 130,85;
		UPDATE_FUNC();
		local floorGuid,floorName = fld.GetCurrentFloorLevel();
		assert.are.same("Mansion_FloorB",floorGuid);

		-- onto the first floor
		X,Y = 100,115;
		UPDATE_FUNC();
		local floorGuid,floorName = fld.GetCurrentFloorLevel();
		assert.are.same("Mansion_FloorC",floorGuid);
		assert.are.same("The mansion first floor",floorName);

		-- Goes outside (for some reason)
		INDOOR = nil
		UPDATE_FUNC();
		local floorGuid,floorName = fld.GetCurrentFloorLevel();
		assert.are.same(nil,floorGuid);
	end)
end);