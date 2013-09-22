describe("GHP_AbilityList",function()

	require("StandardMock");
	require("GHP_AbilityList");


	GHI_DynamicActionInstanceSet = function() return spy.new() end;

	local list;

	local DATA = {
		["1234"] = {
			name = "name1",
			icon = "icon1",
			guid = "1234",
			cooldown = 10,
			lastCastTime = 0,
			authorName = "name1",
			authorGuid = "1234",
		},
		["5678"] = {
			name = "name2",
			icon = "icon2",
			guid = "5678",
			cooldown = 20,
			lastCastTime = time(),
			authorName = "name2",
			authorGuid = "5678",
		},
	};

	local GHI_Event_mock = mock({
		TriggerEvent = function(...) end,
	});
	local EventFunc = {};
	GHI_Event = function(event,f)  if event and f then EventFunc[event] = f; end
		return {
			TriggerEvent = GHI_Event_mock.TriggerEvent,
		}
	end


	local ABILITIES = {};

	it("Should load abilities from GHP_AbilityData when called LoadFromSaved",function()

		GHI_SavedData = function(i)
			assert.are.same("GHP_AbilityData",i);
			return {
				GetAll = function()
					return DATA;
				end,
				SetVar = function(index,value)
					DATA[index] = value;
				end,
			};
		end

		list = GHP_AbilityList();



		local m = mock({
			GHP_Ability = function(t)
				local a = {};
				a.Serialize = function() return t; end
				a.GetGuid = function() return t.guid; end
				a.IsClass = function(c) if c == "GHP_Ability" then return true; end return false end
				a.GetVersion = function() return t.version or 1; end
				ABILITIES[t.guid] = a;
				return a;
			end,
		})
		GHP_Ability = function(...) return m.GHP_Ability(...) end;

		assert.are.same("function",type(list.LoadFromSaved));
		list.LoadFromSaved();
		assert.spy(m.GHP_Ability).was.called_with(DATA["1234"]);
		assert.spy(m.GHP_Ability).was.called_with(DATA["5678"]);
		assert.spy(GHI_Event_mock.TriggerEvent).was.called_with("GHP_ABILITY_UPDATED","1234");
		assert.spy(GHI_Event_mock.TriggerEvent).was.called_with("GHP_ABILITY_UPDATED","5678");

		assert.are.same("function",type(list.GetAbility));
		assert.are.same(ABILITIES["1234"],list.GetAbility("1234"))
		assert.are.same(ABILITIES["5678"],list.GetAbility("5678"))
	end)

	it("should implement SetAbility",function()
		assert.are.same("function",type(list.SetAbility));
		assert.are.same(nil,list.GetAbility("3333"))

		local ABILITY = {
			name = "name3",
			icon = "icon3",
			guid = "3333",
			cooldown = 10,
			lastCastTime = 0,
			authorName = "name3",
			authorGuid = "1234",
			version = 1,
		};
		list.SetAbility(ABILITY);
		assert.are.same(ABILITIES["3333"],list.GetAbility("3333"));
		assert.are.same(ABILITY,DATA["3333"]);
		assert.spy(GHI_Event_mock.TriggerEvent).was.called_with("GHP_ABILITY_UPDATED","3333");


		-- It should accept Ability objects
		local ADD_DATA_2 = {
			name = "name4",
			icon = "icon4",
			guid = "4444",
			cooldown = 10,
			lastCastTime = 0,
			authorName = "name4",
			authorGuid = "1234",
			version = 10,
		}
		local ability = GHP_Ability(ADD_DATA_2);
		assert.are.same("function",type(ability.IsClass));

		assert.are.same(nil,list.GetAbility("4444"));
		list.SetAbility(ability);
		assert.are_not.equal(nil,list.GetAbility("4444"));

		-- It should not overwrite if the version is lower
		local ADD_DATA_3 = {
			name = "name4x",
			icon = "icon4x",
			guid = "4444",
			cooldown = 12,
			lastCastTime = 0,
			authorName = "name4",
			authorGuid = "1234",
			version = 4,
		}
		local ability = GHP_Ability(ADD_DATA_3);
		list.SetAbility(ability);
		assert.are.same(ADD_DATA_2,list.GetAbility("4444").Serialize());

	end);
end);