describe("GHP_ObjectList",function()

	require("StandardMock");
	require("GHP_ObjectList");


	GHI_DynamicActionInstanceSet = function() return spy.new() end;

	local list;

	local DATA = {
		["1234"] = {
			name = "name1",
			icon = "icon1",
			guid = "1234",
			authorName = "name1",
			authorGuid = "1234",
		},
		["5678"] = {
			name = "name2",
			icon = "icon2",
			guid = "5678",
			authorName = "name2",
			authorGuid = "5678",
		},
	};


	local OBJECTS = {};

	it("Should load abilities from GHP_ObjectData when called LoadFromSaved",function()

		GHI_SavedData = function(i)
			assert.are.same("GHP_ObjectData",i);
			return {
				GetAll = function()
					return DATA;
				end,
				SetVar = function(index,value)
					DATA[index] = value;
				end,
			};
		end

		list = GHP_ObjectList();



		local m = mock({
			GHP_Object = function(t)
				local a = {};
				a.Serialize = function() return t; end
				a.GetGuid = function() return t.guid; end
				a.IsClass = function(c) if c == "GHP_Object" then return true; end return false end
				a.GetVersion = function() return t.version; end
				OBJECTS[t.guid] = a;
				return a;
			end,
		})
		GHP_Object = function(...) return m.GHP_Object(...) end;

		assert.are.same("function",type(list.LoadFromSaved));
		list.LoadFromSaved();
		assert.spy(m.GHP_Object).was.called_with(DATA["1234"]);
		assert.spy(m.GHP_Object).was.called_with(DATA["5678"]);

		assert.are.same("function",type(list.GetObject));
		assert.are.same(OBJECTS["1234"],list.GetObject("1234"))
		assert.are.same(OBJECTS["5678"],list.GetObject("5678"))
	end)

	it("should implement SetObject",function()
		assert.are.same("function",type(list.SetObject));
		assert.are.same(nil,list.GetObject("3333"))

		local OBJECT = {
			name = "name3",
			icon = "icon3",
			guid = "3333",
			cooldown = 10,
			lastCastTime = 0,
			authorName = "name3",
			authorGuid = "1234",
		};
		list.SetObject(OBJECT);
		assert.are.same(OBJECTS["3333"],list.GetObject("3333"));
		assert.are.same(OBJECT,DATA["3333"]);

		-- It should accept Object objects
		local ADD_DATA_2 = {
			name = "name4",
			icon = "icon4",
			guid = "4444",
			cooldown = 10,
			lastCastTime = 0,
			authorName = "name4",
			authorGuid = "1234",
		}
		local object = GHP_Object(ADD_DATA_2);
		assert.are.same("function",type(object.IsClass));

		assert.are.same(nil,list.GetObject("4444"));
		list.SetObject(object);
		assert.are_not.equal(nil,list.GetObject("4444"));
	end);

	it("should not overwrite if the version number is lower",function()
		local ADD_DATA = {
			guid = "5555",
			icon = "icon4",
			name = "D5",
			version = 10,
			cooldown = 10,
			lastCastTime = 0,
			authorName = "name4",
			authorGuid = "1234",
		}
		local profession = GHP_Object(ADD_DATA);
		assert.are.same(nil,list.GetObject("5555"));
		list.SetObject(profession);
		assert.are.equal(profession,list.GetObject("5555"));

		local ADD_DATA = {
			guid = "5555",
			icon = "icon4",
			name = "D55",
			version = 5,
			cooldown = 43,
			lastCastTime = 20,
			authorName = "name64",
			authorGuid = "1234",
		}
		local profession2 = GHP_Object(ADD_DATA);
		list.SetObject(profession2);
		assert.are.equal(profession,list.GetObject("5555"));
	end);
end);