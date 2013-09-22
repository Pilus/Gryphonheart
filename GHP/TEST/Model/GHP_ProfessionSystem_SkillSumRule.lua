describe("GHP_ProfessionSystem_SkillSumRule",function()

	require("StandardMock");
	require("GHP_AuthorInfo");
	require("GHP_ProfessionSystem");
	require("GHP_ProfessionSystem_SkillSumRule");

	local system;
	local GUID = "ABC_123";
	local NAME = "NnAaMmEe";
	local ICON = "IiCcOoNn";
	local PROFESSION_INSTANCES_DATA = {
		{
			guid = "1234",
			skillLevel = 1,
		},
		{
			guid = "5678",
			skillLevel = 1,
		},
	}
	local PROFESSION_INSTANCES_DATA_NON_PERSONAL = {}
	for i,v in pairs(PROFESSION_INSTANCES_DATA) do
		PROFESSION_INSTANCES_DATA_NON_PERSONAL[i] = {
			guid = v.guid,
		}
	end

	local TRIGGERED_EVENT;
	local EventFunc;
	GHI_Event = function(_,f)   EventFunc = f;
		return {
			TriggerEvent = function(...)
				TRIGGERED_EVENT = {...};
			end
		}
	end

	local ALL_ABILITIES = {
		["1234"] = {{"abilitiesInstranceFrom1234-1"},{"abilitiesInstranceFrom1234-2"}},
		["5678"] = {{"abilitiesInstranceFrom5678-1"},{"abilitiesInstranceFrom5678-2"}},
	}

	local GOT_PERSONAL_DATA = {};
	local PERSONAL = {};
	local PROFESSION_OBJECTS = {
		["1234"] = {
			"Prof1234",
			GetAllAbilities = function() return ALL_ABILITIES["1234"]; end,
		},
		["5678"] = {
			"Prof5678",
			GetAllAbilities = function() return ALL_ABILITIES["5678"]; end,
		},
	}

	local INDEPENDENT_ABILITIES = {
		{
			guid = "ab1234",
			known = true,
		},
		{
			guid = "ab5678",
			known = false,
		},
		{
			guid = "ab9012",
		},
	}


	before_each(function()
		GHP_ProfessionInstance = function(info)
			local skillLevel = info.skillLevel;
			local abilitiesKnown = info.abilitiesKnown;
			local ins = {
				type = "ProfessionInstance",
				guid = info.guid,
				Serialize = function(stype)
					local t = {guid = info.guid};
					if not(stype) or stype == "personal" then
						t.skillLevel = skillLevel;
						t.abilitiesKnown = abilitiesKnown;
					end
					return t;
				end,
				name = NAME,
				GetProfession = function()
					return PROFESSION_OBJECTS[info.guid];
				end,

				GetGuid = function()
					return info.guid;
				end,
				GotPersonalData = function() return GOT_PERSONAL_DATA[info.guid] == true; end,
				SetPersonalData = function(data) PERSONAL[info.guid] = data; end,
				IsKnown = function() return  skillLevel > 0 end,
				LearnProfession = function() if skillLevel == 0 then skillLevel = 1; return true; end return false; end,
				AbilityIsKnown = function(a)
					if a[1] == "abilitiesInstranceFrom1234-1" or a[1] == "abilitiesInstranceFrom5678-1" then
						return true;
					else
						return false;
					end
				end,
				LearnAbility = function(aGuid)
					abilitiesKnown = abilitiesKnown or {};
					for _,v in pairs(abilitiesKnown) do
						if v == aGuid then
							return false;
						end
					end
					table.insert(abilitiesKnown,aGuid);
					return true;
				end,
			};
			return ins;
		end
		TRIGGERED_EVENT = nil;
		system = GHP_ProfessionSystem_SkillSumRule({
			guid = GUID,
			professions = PROFESSION_INSTANCES_DATA,
			name = NAME,
			icon = ICON,
			independentAbilities = INDEPENDENT_ABILITIES,
		});
	end)

	it("should serialize / deserialize",function()
		local t = system.Serialize();
		assert.are.same(GUID,t.guid);
		assert.are.same("SkillSumRule",t.type);
		assert.are.same(NAME,t.name);
		assert.are.same(PROFESSION_INSTANCES_DATA,t.professions);
		assert.are.same(ICON,t.icon);
		assert.are.same("table",type(t.independentAbilities));
		assert.are.same(INDEPENDENT_ABILITIES,t.independentAbilities);

		local t = system.Serialize("nonpersonal");
		assert.are.same(GUID,t.guid);
		assert.are.same("SkillSumRule",t.type);
		assert.are.same(NAME,t.name);
		assert.are.same(PROFESSION_INSTANCES_DATA_NON_PERSONAL,t.professions);
		assert.are.same(ICON,t.icon);
		assert.are.same("table",type(t.independentAbilities));
		assert.are.same({
			{ guid = INDEPENDENT_ABILITIES[1].guid,	},
			{ guid = INDEPENDENT_ABILITIES[2].guid,	},
			{ guid = INDEPENDENT_ABILITIES[3].guid,	},
		},t.independentAbilities);

		local t = system.Serialize("personal");
		assert.are.same(GUID,t.guid);
		assert.are.same(nil,t.type);
		assert.are.same(nil,t.name);
		assert.are.same(PROFESSION_INSTANCES_DATA,t.professions);
		assert.are.same(nil,t.icon);
		assert.are.same("table",type(t.independentAbilities));
		assert.are.same(INDEPENDENT_ABILITIES,t.independentAbilities);




	end);



	it("Should implement GetGuid",function()
		assert.are.same("function",type(system.GetGuid));
		assert.are.same(GUID,system.GetGuid());
	end);



	it("Should implement GetDetails",function()
		assert.are.same("function",type(system.GetDetails));
		local guid,name,icon = system.GetDetails();
		assert.are.same(GUID,guid);
		assert.are.same(NAME,name);
		assert.are.same(ICON,icon);
	end);

	it("Should implement GetAllAbilities(filter)",function()
		assert.are.same("function",type(system.GetAllAbilities));
		assert.are.same(ALL_ABILITIES,system.GetAllAbilities());

		assert.are.same(ALL_ABILITIES,system.GetAllAbilities("shownInSpellbook"));
		assert.are.same({["1234"] = {ALL_ABILITIES["1234"][1]},["5678"] = {ALL_ABILITIES["5678"][1]}},system.GetAllAbilities("shownInSpellbookAndKnown"));
	end);

	it("should implement GetProfessionInstanceGuids",function()
		assert.are.same("function",type(system.GetProfessionInstanceGuids));
		assert.are.same(2,#(system.GetProfessionInstanceGuids()));
	end);

	it("should implement AddProfessionInstance",function()
		assert.are.same("function",type(system.AddProfessionInstance));

		-- with table
		assert.are.same(2,#(system.GetProfessionInstanceGuids()));
		system.AddProfessionInstance({guid = "3333"});
		assert.are.same(3,#(system.GetProfessionInstanceGuids()));

		-- with object
		local profInst = GHP_ProfessionInstance({guid = "4444"});
		system.AddProfessionInstance(profInst);
		assert.are.same(4,#(system.GetProfessionInstanceGuids()));
	end);

	it("should implement GotPersonalData",function()
		assert.are.same("function",type(system.GotPersonalData));
		assert.are.same(false,system.GotPersonalData());
		GOT_PERSONAL_DATA["5678"] = true;
		assert.are.same(true,system.GotPersonalData());
	end);

	it("should implement SetPersonalData",function()
		assert.are.same("function",type(system.SetPersonalData));
		local D = {
			{
				guid = "5678",
				thePersonalData = "pers5678",
			},
			{
				guid = "1234",
				thePersonalData = "pers1234",
			},
		};
		system.SetPersonalData(D);
		assert.are.same(D[2],PERSONAL["1234"]);
		assert.are.same(D[1],PERSONAL["5678"]);
	end);

	it("should implement LearnProfession",function()
		local system = GHP_ProfessionSystem_SkillSumRule({
			guid = GUID,
			professions = {
				{
					guid = "1234",
					skillLevel = 0,
				},
			},
			name = NAME,
			icon = ICON,
		});
		assert.are.same("function",type(system.LearnProfession));
		assert.are.same(nil,TRIGGERED_EVENT)
		system.LearnProfession("1234");
		assert.are.same(1,system.Serialize().professions[1].skillLevel)
		assert.are.same({"GHP_PROFESSION_LEARNED",GUID,"1234"},TRIGGERED_EVENT);

		TRIGGERED_EVENT = nil;
		local system = GHP_ProfessionSystem_SkillSumRule({
			guid = GUID,
			professions = {
				{
					guid = "1234",
					skillLevel = 3,
				},
			},
			name = NAME,
			icon = ICON,
		});
		system.LearnProfession("1234");
		assert.are.same(3,system.Serialize().professions[1].skillLevel)
		assert.are.same(nil,TRIGGERED_EVENT);

	end)

	it("should implement LearnAbility",function()
		local system = GHP_ProfessionSystem_SkillSumRule({
			guid = GUID,
			professions = {
				{
					guid = "1234",
					skillLevel = 7,
				},
			},
			name = NAME,
			icon = ICON,
		});
		assert.are.same("function",type(system.LearnAbility));
		assert.are.same(nil,system.Serialize().professions[1].abilitiesKnown)
		assert.are.same(nil,TRIGGERED_EVENT)
		system.LearnAbility("1234","ab78");
		assert.are.same({"ab78"},system.Serialize().professions[1].abilitiesKnown)
		assert.are.same({"GHP_ABILITY_LEARNED",GUID,"1234","ab78"},TRIGGERED_EVENT);

		TRIGGERED_EVENT = nil;
		local system = GHP_ProfessionSystem_SkillSumRule({
			guid = GUID,
			professions = {
				{
					guid = "1234",
					skillLevel = 3,
					abilitiesKnown = {"ab78"}
				},
			},
			name = NAME,
			icon = ICON,
		});
		system.LearnAbility("1234","ab78");
		assert.are.same({"ab78"},system.Serialize().professions[1].abilitiesKnown)
		assert.are.same(nil,TRIGGERED_EVENT);
	end)



end);