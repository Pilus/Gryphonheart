describe("GHP_Ability",function()

	require("StandardMock");
	require("GHP_ObjectSpawner");



	local DATA = {
		guid = "guidA",
		name = "Spawn list A",
		objects= {
			{
				guid = "abc123",
				pos = {x=23,y=35,world=1,floorLevel="mine1"},
				attributes = {
					size = 2,
					visible = false,
					resources = 0,
				}, -- Personal
			},
			{
				guid = "abc567",
				pos = {x=233,y=355,world=1,floorLevel="mine2"},
				attributes = {
					size = 10,
					visible = false,
					resources = 2,
				},
			},
		},
		respawnInterval = 10,
		maxSize = 100,
		sizeRespawnAmount = 1,
		resourceRespawnAmount = 1.30, -- 130% chance for 1 resource growth
		offlineRespawnModifer = 0,
	}

	local LAST_OBJ;
	GHP_ObjectInstance = function(info)
		local att = info.attributes or {};
		local o = {
			Serialize = function(stype)
				if stype == "personal" then
					return {
						guid = info.guid,
						attributes = att,
					};
				end
				if stype == "nonpersonal" then
					return {
						guid = info.guid,
						pos = info.pos,
					}
				end
				return {
					guid = info.guid,
					pos = info.pos,
					attributes = att,
				};
			end,
			GotPersonalData = function()
				for i,v in pairs(att) do
					return true;
				end
				return false;
			end,
			SetPersonalData = function(d)
				att = d.attributes;
			end,
			GetGuid = function()
				return info.guid;
			end,
			GetAttributeValue = function(attName)
				return att[attName];
			end,
			SetAttributeValue = function(attName,value)
				att[attName] = value;
			end,
		};
		o.att = att;
		LAST_OBJ = o;
		return o;
	end

	local updateFunc,updateTime;
	GHI_Timer = function(func,upt,_)
		updateFunc = func;
		updateTime = upt;
	end
	local os
	before_each(function()
		updateFunc = nil;
		os = GHP_ObjectSpawner(DATA);
	end);

	it("Should serialize and deserialize",function()
		local t = os.Serialize();
		assert.are.same(DATA,t);

		local t = os.Serialize("personal");
		local ex = {
			guid = DATA.guid,
			objects = {
				{
					guid = DATA.objects[1].guid,
					attributes = DATA.objects[1].attributes,
				},
				{
					guid = DATA.objects[2].guid,
					attributes = DATA.objects[2].attributes,
				},
			}
		};
		assert.are.same(#(ex),#(t));
		for i,_ in pairs(ex) do
			assert.are.same(ex[i],t[i]);
		end
		assert.are.same(ex,t);


		local t = os.Serialize("nonpersonal");
		assert.are.same({
			guid = DATA.guid,
			name = DATA.name,
			objects = {
				{
					guid = DATA.objects[1].guid,
					pos = DATA.objects[1].pos,
				},
				{
					guid = DATA.objects[2].guid,
					pos = DATA.objects[2].pos,
				},
			},
			respawnInterval = DATA.respawnInterval,
			maxSize = DATA.maxSize,
			sizeRespawnAmount = DATA.sizeRespawnAmount,
			resourceRespawnAmount = DATA.resourceRespawnAmount,
			offlineRespawnModifer = DATA.offlineRespawnModifer,
		},t);
	end);

	it("should implement GetGuid",function()
		assert.are.same("function",type(os.GetGuid));
		assert.are.same(DATA.guid,os.GetGuid())
	end);

	it("should implement GotPersonalData",function()
		assert.are.same("function",type(os.GotPersonalData));
		assert.are.same(true,os.GotPersonalData());
		local os2 = GHP_ObjectSpawner({
			guid = "guidA",
			name = "Spawn list A",
			objects= {
				guid = "abc123",
				pos = {x=23,y=35,world=1,floorLevel="mine1"},
				attributes = {}, -- Personal
			},
			respawnInterval = DATA.respawnInterval,
			maxSize = DATA.maxSize,
			sizeRespawnAmount = DATA.sizeRespawnAmount,
			resourceRespawnAmount = DATA.resourceRespawnAmount,
			offlineRespawnModifer = DATA.offlineRespawnModifer,
		});
		assert.are.same(false,os2.GotPersonalData());

	end);

	it("should implement SetPersonalData",function()
		assert.are.same("function",type(os.SetPersonalData));
		local ATT1 = {testatt = "test1",};
		local ATT2 = {testatt = "test2",};

		os.SetPersonalData({
			guid = DATA.guid,
			objects = {
				{
					guid = DATA.objects[2].guid,
					attributes = ATT2,
				},
				{
					guid = DATA.objects[1].guid,
					attributes = ATT1,
				},
			}
		});
		local t = os.Serialize();
		assert.are.same(ATT1,t.objects[1].attributes)
		assert.are.same(ATT2,t.objects[2].attributes)
	end);

	it("should register an update func in the timer",function()
		assert.are.same("function",type(updateFunc));
		assert.are.same(10,updateTime)
	end);

	it("should update object instances",function()
		updateFunc = nil;
		os = GHP_ObjectSpawner({
			guid = DATA.guid,
			name = DATA.name,
			objects = {
				{
					guid = "abc567",
					pos = {x=233,y=355,world=1,floorLevel="mine2"},
					attributes = {
						size = 10,
						visible = false,
						resources = 2,
					},
				},
			},
			respawnInterval = 10,
			maxSize = 100,
			sizeRespawnAmount = 5,
			resourceRespawnAmount = 1.40,
			offlineRespawnModifer = 0.05,
		});
		assert.are.same("function",type(updateFunc));

		updateFunc();
		assert.are.same(15,LAST_OBJ.att.size);
	    assert.are_true(LAST_OBJ.att.resources == 3 or LAST_OBJ.att.resources == 4)
	end);
end);