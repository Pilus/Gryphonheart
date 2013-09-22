describe("GHP_ObjectInstance",function()

	require("StandardMock");
	require("GHP_ObjectInstance");

	local objectInstance;
	local GUID = "myGuid";
	local OBJECT_GUID = "1234";

	local OBJ_NAME,OBJ_ICON = "Name of object","icon for object";

	local ATT_INFO = {
		att1 = {type="boolean",defaultValue=false, },
		att2 = {type="number",defaultValue=43, },
		att3 = {type="number",defaultValue=3, },
		att4 = {type="string",defaultValue="test", },
		att6 = {type="number",defaultValue="test",},
		amount = {type="number",defaultValue=1},
		icon = {type="string",defaultValue=""},
	};
	local OBJECT_OBJ = {
		GetAttributeInfo = function(attName)
			if ATT_INFO[attName] then
				return ATT_INFO[attName].type,ATT_INFO[attName].defaultValue;
			end
		end,
		GetInfo = function()
			return OBJ_NAME,OBJ_ICON;
		end,
		"obj"
	};
	local ATTRIBUTES = {
		abc = 121212,
	}
	local IN_SPELL_BOOK = true;
	local POSITION = {
		x = 100,
		y = 200,
		world = 1,
		level = "TestA",
	}

	local GHI_Event_mock = mock({
		TriggerEvent = function(...) end,
	});
	local EventFunc = {};
	GHI_Event = function(event,f)  if event and f then EventFunc[event] = f; end
		return {
			TriggerEvent = GHI_Event_mock.TriggerEvent,
		}
	end


   	GHM_Input_Validate = function(attType,val)
		return type(val) == attType;
	end
	GHM_Input_GetDefaultValue = function(attType)
		if attType == "number" then
			return 0;
		end
	end

	GHI_Position = function()
	end


	local REGISTERED;
	GHP_ObjectInstanceRegister = function()
		return {
			AddObjectInstance = function(o)
				REGISTERED = o;
			end,
		};
	end;

	before_each(function()
		GHP_ObjectList = function()
			return {
				GetObject = function(guid)
					if guid == OBJECT_GUID then
						return OBJECT_OBJ;
					end
				end
			}
		end

		objectInstance = GHP_ObjectInstance({
			guid = GUID,
			objectGuid = OBJECT_GUID,
			attributes = ATTRIBUTES,
			position = POSITION,
		});
	end)

	it("should serialize / deserialize",function()
		local t = objectInstance.Serialize();
		assert.are.same(GUID,t.guid);
		assert.are.same(OBJECT_GUID,t.objectGuid);
		assert.are.same(ATTRIBUTES,t.attributes);
		assert.are.same(POSITION,t.position);
	end);

	it("should implement GetGuid",function()
		assert.are.same("function",type(objectInstance.GetGuid));
		assert.are.same(GUID,objectInstance.GetGuid());
	end);

	it("should implement GetObjectGuid",function()
		assert.are.same("function",type(objectInstance.GetObjectGuid));
		assert.are.same(OBJECT_GUID,objectInstance.GetObjectGuid());
	end);

	it("should implement GetObject",function()
		assert.are.same("function",type(objectInstance.GetObject));
		assert.are.is_true(OBJECT_OBJ==objectInstance.GetObject());

		objectInstance = GHP_ObjectInstance({
			objectGuid = "0000",
		});
		assert.are.is_true(nil==objectInstance.GetObject());
	end);

	it("should register itself in the object instance register",function()
		assert.are.same(objectInstance,REGISTERED)
	end);

	it("should implement GotPersonalData",function()
		assert.are.same("function",type(objectInstance.GotPersonalData));
		assert.are.same(true,objectInstance.GotPersonalData());

		local objectInstance2 = GHP_ObjectInstance({
			guid = OBJECT_GUID,
			attributes = {},
			position = POSITION,
		});
		assert.are.same(false,objectInstance2.GotPersonalData());
	end);

	it("should implement SetPersonalData",function()
		assert.are.same("function",type(objectInstance.SetPersonalData));
		local TEST_ATT = {
			testA = "test",
		};
		objectInstance.SetPersonalData({
			guid = GUID,
			attributes = TEST_ATT,
		});
		assert.are.same({
			guid = GUID,
			attributes = TEST_ATT,
			objectGuid = OBJECT_GUID,
			position = POSITION,
		},objectInstance.Serialize())
	end);

	it("should implement GetAttributeValue",function()
		assert.are.same("function",type(objectInstance.GetAttributeValue));

		local objectInstance = GHP_ObjectInstance({
			guid = GUID,
			objectGuid = OBJECT_GUID,
			attributes = {
				att1 = true,
				att2 = 34,
				att5 = "an attribute not there",
			},
			position = POSITION,
		});



		assert.are.same(true,objectInstance.GetAttributeValue("att1") or "nil");
		assert.are.same(34,objectInstance.GetAttributeValue("att2") or "nil");

		-- It should draw on the default values for the attributes that have no attribute data
		assert.are.same(3,objectInstance.GetAttributeValue("att3") or "nil");
		assert.are.same("test",objectInstance.GetAttributeValue("att4") or "nil");


		assert.are.same(nil,objectInstance.GetAttributeValue("att5") or nil);

		-- It should return a default value if the if the attribute data is not validated to be correct
		assert.are.same(0,objectInstance.GetAttributeValue("att6"));

	end);

	it("should implement SetAttributeValue",function()
		assert.are.same("function",type(objectInstance.SetAttributeValue));
		local objectInstance = GHP_ObjectInstance({
			guid = GUID,
			objectGuid = OBJECT_GUID,
			attributes = {
				att1 = true,
				att2 = 34,
				att5 = "an attribute not there",
			},
			position = POSITION,
		});

		objectInstance.SetAttributeValue("att1",false);
		assert.are.same(false,objectInstance.GetAttributeValue("att1"));

		objectInstance.SetAttributeValue("att2",42);
		assert.are.same(42,objectInstance.GetAttributeValue("att2"));

		-- should not set values that are incorrect
		objectInstance.SetAttributeValue("att2","test");
		assert.are.same(42,objectInstance.GetAttributeValue("att2"));

		-- should not set values for attributes that does not exist
		objectInstance.SetAttributeValue("att5","test");
		assert.are.same(nil,objectInstance.GetAttributeValue("att5") or nil);

	end);

	it("should implement GetInfo",function()
		assert.are.same("function",type(objectInstance.GetInfo));

		-- should forward GetInfo from the object and add the amount attribute, if present
		local name,icon,amount = objectInstance.GetInfo();
		assert.are.same(OBJ_NAME,name);
		assert.are.same(OBJ_ICON,icon);
		assert.are.same(nil,amount or nil);

		-- if there are an icon attribute, it should replace the icon from the object
		local ICON,AMOUNT = "icon path",43;
		local objectInstance = GHP_ObjectInstance({
			guid = GUID,
			objectGuid = OBJECT_GUID,
			attributes = {
				att1 = true,
				att2 = 34,
				icon = ICON,
				amount = AMOUNT,
			},
			position = POSITION,
		});

		local name,icon,amount = objectInstance.GetInfo();
		assert.are.same(OBJ_NAME,name);
		assert.are.same(ICON,icon);
		assert.are.same(AMOUNT,amount or nil);
	end);

   	it("should implement GetPosition",function()
		assert.are.same("function",type(objectInstance.GetPosition));
		assert.are.same(POSITION,objectInstance.GetPosition());
	end);

	it("should implement SetPosition",function()
		assert.are.same("function",type(objectInstance.SetPosition));

		local POSITION2 = {
			x = 245,
			y = 256,
			world = 2,
			level = "TestB",
		}
		objectInstance.SetPosition(POSITION2);
		assert.are.same(POSITION2,objectInstance.GetPosition());
		assert.spy(GHI_Event_mock.TriggerEvent).was.called_with("GHP_OBJECT_MOVED",GUID,POSITION2);

		local t = objectInstance.Serialize();
		assert.are.same(POSITION2,t.position)
	end);

end);



