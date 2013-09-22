describe("GHP_AbilityInstance",function()

	require("StandardMock");
	require("GHP_AbilityInstance");

	local abilityInstance;
	local ABILITY_GUID = "1234";
	local GUID = "9E57CD0AE";

	local SKILL_LEVELS = {0,10,15,20};
	local ORANGE_SKILLS_AWARDED = 3;
	local IN_SPELL_BOOK = true;
	local ATTRIBUTES = {
		abc = "etest",
	}

	local ATT_INFO = {
		att1 = {type="boolean",defaultValue=false, },
		att2 = {type="number",defaultValue=43, },
		att3 = {type="number",defaultValue=3, },
		att4 = {type="string",defaultValue="test", },
		att6 = {type="number",defaultValue="test",},
		amount = {type="number",defaultValue=1},
		icon = {type="string",defaultValue=""},
	};
	local executeObj;
	local executeGuids;
	local ABILITY_OBJ = {
		GetAttributeInfo = function(attName)
			if ATT_INFO[attName] then
				return ATT_INFO[attName].type,ATT_INFO[attName].defaultValue;
			end
		end,
		Execute = function(v,g)
			executeObj = v;
			executeGuids = g;
		end,
		GetAuthorInfo = function()
			return "au1234","person";
		end
	};
	local ABILITY_API_OBJS = {
		["1234"] = {"9E7669540"};
		["abilityGuid1"] = {"9E7669FF8"};
	};

	GHP_AbilityAPI = function()
		return {
			GetAbility = function(sys,prof,ability,obj)
				return ABILITY_API_OBJS[ability];
			end,
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

	before_each(function()
		GHP_AbilityList = function()
			return {
				GetAbility = function(guid)
					if guid == ABILITY_GUID then
						return ABILITY_OBJ;
					end
				end,
			}
		end

		abilityInstance = GHP_AbilityInstance({
			abilityGuid = ABILITY_GUID,
			skillLevels = SKILL_LEVELS,
			orangeSkillsAwarded = ORANGE_SKILLS_AWARDED,
			shownInSpellbook = IN_SPELL_BOOK,
			attributes = ATTRIBUTES,

		});
	end)

	it("should serialize / deserialize",function()
		local t = abilityInstance.Serialize();
		assert.are.same(ABILITY_GUID,t.abilityGuid);
		assert.are.same(SKILL_LEVELS,t.skillLevels);
		assert.are.same(ORANGE_SKILLS_AWARDED,t.orangeSkillsAwarded);
		assert.are.same(IN_SPELL_BOOK,t.shownInSpellbook);
		assert.are.same(ATTRIBUTES,t.attributes);
	end);


	it("should implement GetAbilityGuid",function()
		assert.are.same("function",type(abilityInstance.GetAbilityGuid));
		assert.are.same(ABILITY_GUID,abilityInstance.GetAbilityGuid());
	end);

	it("should implement GetAbility",function()
		assert.are.same("function",type(abilityInstance.GetAbility));
		assert.are.is_true(ABILITY_OBJ==abilityInstance.GetAbility());

		abilityInstance = GHP_AbilityInstance({
			abilityGuid = "0000",
		});
		assert.are.is_true(nil==abilityInstance.GetAbility());
	end);

	it("should implement GetSkillLevels",function()
		assert.are.same("function",type(abilityInstance.GetSkillLevels));
		assert.are.same(SKILL_LEVELS,{abilityInstance.GetSkillLevels()});
	end);

	it("should implement ShownInSpellbook",function()
		assert.are.same("function",type(abilityInstance.ShownInSpellbook));
		assert.are.same(IN_SPELL_BOOK,abilityInstance.ShownInSpellbook());
	end);

	it("should implement GetAttributeValue",function()
		assert.are.same("function",type(abilityInstance.GetAttributeValue));

		local abilityInstance = GHP_AbilityInstance({
			guid = GUID,
			abilityGuid = ABILITY_GUID,
			skillLevels = SKILL_LEVELS,
			orangeSkillsAwarded = ORANGE_SKILLS_AWARDED,
			shownInSpellbook = IN_SPELL_BOOK,
			attributes = {
				att1 = true,
				att2 = 34,
				att5 = "an attribute not there",
			},
		});

		assert.are.same(true,abilityInstance.GetAttributeValue("att1") or "nil");
		assert.are.same(34,abilityInstance.GetAttributeValue("att2") or "nil");

		-- It should draw on the default values for the attributes that have no attribute data
		assert.are.same(3,abilityInstance.GetAttributeValue("att3") or "nil");
		assert.are.same("test",abilityInstance.GetAttributeValue("att4") or "nil");


		assert.are.same(nil,abilityInstance.GetAttributeValue("att5") or nil);

		-- It should return a default value if the if the attribute data is not validated to be correct
		assert.are.same(0,abilityInstance.GetAttributeValue("att6"));

	end);

	it("should implement SetAttributeValue",function()
		assert.are.same("function",type(abilityInstance.SetAttributeValue));
		local abilityInstance = GHP_AbilityInstance({
			guid = GUID,
			abilityGuid = ABILITY_GUID,
			skillLevels = SKILL_LEVELS,
			orangeSkillsAwarded = ORANGE_SKILLS_AWARDED,
			shownInSpellbook = IN_SPELL_BOOK,
			attributes = {
				att1 = true,
				att2 = 34,
				att5 = "an attribute not there",
			},
		});

		abilityInstance.SetAttributeValue("att1",false);
		assert.are.same(false,abilityInstance.GetAttributeValue("att1"));

		abilityInstance.SetAttributeValue("att2",42);
		assert.are.same(42,abilityInstance.GetAttributeValue("att2"));

		-- should not set values that are incorrect
		abilityInstance.SetAttributeValue("att2","test");
		assert.are.same(42,abilityInstance.GetAttributeValue("att2"));

		-- should not set values for attributes that does not exist
		abilityInstance.SetAttributeValue("att5","test");
		assert.are.same(nil,abilityInstance.GetAttributeValue("att5") or nil);

	end);

	it("should implement Execute",function()
		assert.are.same("function",type(abilityInstance.Execute));
		executeObj = nil;
		executeGuids = nil;
		abilityInstance.Execute("systemGuid","profGuid")
		assert.are.same(abilityInstance,executeObj);
		assert.are.same({"systemGuid","profGuid",ABILITY_GUID},executeGuids);

		executeObj = nil;
		executeGuids = nil;
		abilityInstance.Execute("systemGuid","profGuid","objGuid")
		assert.are.same(abilityInstance,executeObj);
		assert.are.same({"systemGuid","profGuid",ABILITY_GUID,"objGuid"},executeGuids);
	end);

	it("should implement GetAPI",function()
		assert.are.same("function",type(abilityInstance.GetAPI))

		local api,apiName = abilityInstance.GetAPI(true,{"sysGuid1","profGuid1","abilityGuid1"});
		assert.are.same("table",type(api) or nil);
		assert.are.same(ABILITY_API_OBJS["abilityGuid1"],api);
		assert.are.same("ability",apiName or nil);
	end);


end);



