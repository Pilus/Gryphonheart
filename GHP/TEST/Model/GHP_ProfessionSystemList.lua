describe("GHP_ProfessionSystemList",function()

	require("StandardMock");
	require("GHP_ProfessionSystemList");


	GHP_ProfessionSystem = function() return spy.new() end;

	local list;

	local DATA = {
		["1234"] = {
			guid = "1234",
			name = "A",
			type = "SkillSumRule",
		},
		["5678"] = {
			guid = "5678",
			name = "B",
			type = "SkillSumRule",
		},
	};

	GHI_SavedData = function(i)
		assert.are.same("GHP_ProfessionSystemData",i);
		return {
			GetAll = function()
				return DATA;
			end,
			SetVar = function(index,value)
				DATA[index] = value;
			end,
		};
	end

	local GHI_Event_mock = mock({
		TriggerEvent = function(...) end,
	});
	local EventFunc = {};
	GHI_Event = function(event,f)  if event and f then EventFunc[event] = f; end
		return {
			TriggerEvent = GHI_Event_mock.TriggerEvent,
		}
	end



	list = GHP_ProfessionSystemList();

	local PROFESSION_SYSTEMS = {};

	local m = mock({
		GHP_ProfessionSystem_SkillSumRule = function(t)
			local a = {};
			a.Serialize = function(stype)
				if stype == "personal" then
					return {professions=t.professions};

				end
				return t;
			end;
			a.GetGuid = function() return t.guid; end
			a.IsClass = function() return "GHP_ProfessionSystemData"; end
			a.GetVersion = function() return t.version or 0; end
			a.GotPersonalData = function() if (t.professions and t.professions[1]) then return not(t.professions[1].skillLevel == nil) end return false; end
			a.SetPersonalData = function(d) t.professions[1] = d.professions[1]; end;
			PROFESSION_SYSTEMS[t.guid] = a;
			return a;
		end,
	})
	GHP_ProfessionSystem_SkillSumRule = function(...) return m.GHP_ProfessionSystem_SkillSumRule(...) end;

	it("should load abilities from GHP_ProfessionSystemData when called LoadFromSaved",function()



		assert.are.same("function",type(list.LoadFromSaved));
		list.LoadFromSaved();
		assert.spy(m.GHP_ProfessionSystem_SkillSumRule).was.called_with(DATA["1234"]);
		assert.spy(m.GHP_ProfessionSystem_SkillSumRule).was.called_with(DATA["5678"]);
	end)

	it("should implement GetSystem",function()
		assert.are.same("function",type(list.GetSystem));
		assert.are.same(PROFESSION_SYSTEMS["1234"],list.GetSystem("1234"))
		assert.are.same(PROFESSION_SYSTEMS["5678"],list.GetSystem("5678"))
	end)

	local ADD_DATA = {
		guid = "2222",
		name = "C",
		type = "SkillSumRule",
	};
	it("should implement SetSystem, which should trigger GHP_PROFESSION_SYSTEM_UPDATED event",function()
		assert.are.same("function",type(list.SetSystem));
		assert.are.same(nil,list.GetSystem("2222"));

		list.SetSystem(ADD_DATA);

		assert.are_not.equal(nil,list.GetSystem("2222"));
		assert.are.same(PROFESSION_SYSTEMS["2222"],list.GetSystem("2222"));
		assert.are.same(ADD_DATA,list.GetSystem("2222").Serialize());
		assert.are.same(ADD_DATA,DATA["2222"]);

		-- trigger event
		assert.spy(GHI_Event_mock.TriggerEvent).was.called_with("GHP_PROFESSION_SYSTEM_UPDATED","2222");


	end);

	it("should listen to the GHP_PROFESSION_LEARNED event and save the changed data",function()
		assert.are.same("function",type(EventFunc["GHP_PROFESSION_LEARNED"]));
		DATA["5678"] = nil;
		EventFunc["GHP_PROFESSION_LEARNED"]("GHP_PROFESSION_LEARNED","5678","bla");
		assert.are.not_same(nil,DATA["5678"])
	end);

	it("should listen to the GHP_ABILITY_LEARNED event and save the changed data",function()
		assert.are.same("function",type(EventFunc["GHP_ABILITY_LEARNED"]));
		DATA["5678"] = nil;
		EventFunc["GHP_ABILITY_LEARNED"]("GHP_ABILITY_LEARNED","5678","bla","bla");
		assert.are.not_same(nil,DATA["5678"])
	end);

	it("Set System should also accept objects",function()
		local ADD_DATA_2 = {
			guid = "4444",
			name = "D",
			type = "SkillSumRule",
			professions = {
				{
					guid = "1234",
					skillLevel = 23, -- Personal data
				}
			},
			version = 5,
		}
		local sys = GHP_ProfessionSystem_SkillSumRule(ADD_DATA_2);
		assert.are.same("function",type(sys.IsClass));

		assert.are.same(nil,list.GetSystem("4444"));
		list.SetSystem(sys);
		assert.are.equal(sys,list.GetSystem("4444"));
	end);

	it("should not overwrite if the version number is lower",function()
		--
		local ADD_DATA_3 = {
			guid = "4444",
			name = "D",
			type = "SkillSumRule",
			version = 2,
			professions = {
				{
					guid = "something",
					skillLevel = 0,
				},
			}
		}
		local sys2 = GHP_ProfessionSystem_SkillSumRule(ADD_DATA_3);
		list.SetSystem(sys2);
		assert.are.not_same(sys2.Serialize(),list.GetSystem("4444").Serialize());
	end);

	it("should not overwrite the personal data if the new data is non personal",function()
		-- it
		local NON_PERSONAL_DATA = {
			guid = "4444",
			name = "The name has changed",
			type = "SkillSumRule",
			version = 10,
			professions = {
				{
					guid = "1234",
				},
			}
		}
		local sys3 = GHP_ProfessionSystem_SkillSumRule(NON_PERSONAL_DATA);
		list.SetSystem(sys3);
		local DATA2 = list.GetSystem(sys3.GetGuid()).Serialize();
		assert.are.same(NON_PERSONAL_DATA.name,DATA2.name);
		assert.are.same(NON_PERSONAL_DATA.version,DATA2.version);
		assert.are.same(23,DATA2.professions[1].skillLevel);
	end);

	it("should overwrite if the new data is the same version and got personal data",function()
		local PERSONAL_DATA = {
			guid = "4444",
			name = "The name has changed",
			type = "SkillSumRule",
			version = 10,
			professions = {
				{
					guid = "1234",
					skillLevel = 30,
				},
			}
		}
		local sys4 = GHP_ProfessionSystem_SkillSumRule(PERSONAL_DATA);
		list.SetSystem(sys4);
		local DATA3 = list.GetSystem(sys4.GetGuid()).Serialize();
		assert.are.same(PERSONAL_DATA.professions[1].skillLevel,DATA3.professions[1].skillLevel);


	end);

	it("should implement GetSystemGuids",function()
		assert.are.same("function",type(list.GetSystemGuids));
		assert.are.same({"1234","2222","4444","5678"},list.GetSystemGuids());

		list.SetSystem({
			guid="4445",
			name="E",
			type = "SkillSumRule",
		});
		assert.are.same({"1234","4444","5678","4445","2222"},list.GetSystemGuids());
	end)


end);