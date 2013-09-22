describe("GHP_ProfessionInstance",function()

	require("StandardMock");
	require("GHP_ProfessionInstance");

	local professionInstance;
	local PROFESSION_GUID = "1234";
	local PROFESSION_OBJ = {"obj"};
	local SKILL_LEVEL = 10;
	local ABILITIES_KNOWN = {"5678","9012",};

	before_each(function()
		GHP_ProfessionList = function()
			return {
				GetProfession = function(guid)
					if guid == PROFESSION_GUID then
						return PROFESSION_OBJ;
					end
				end
			}
		end



		professionInstance = GHP_ProfessionInstance({
			guid = PROFESSION_GUID,
			skillLevel = SKILL_LEVEL,
			abilitiesKnown = ABILITIES_KNOWN,

		});
	end)

	it("should serialize / deserialize",function()
		local t = professionInstance.Serialize();
		assert.are.same(PROFESSION_GUID,t.guid);
		assert.are.same(SKILL_LEVEL,t.skillLevel);
		assert.are.same(ABILITIES_KNOWN,t.abilitiesKnown);

		local t = professionInstance.Serialize("personal");
		assert.are.same(PROFESSION_GUID,t.guid);
		assert.are.same(SKILL_LEVEL,t.skillLevel);
		assert.are.same(ABILITIES_KNOWN,t.abilitiesKnown);

		local t = professionInstance.Serialize("nonpersonal");
		assert.are.same(PROFESSION_GUID,t.guid);
		assert.are.same(nil,t.skillLevel);
		assert.are.same(nil,t.abilitiesKnown);
	end);

	it("should implement GetGuid",function()
		assert.are.same("function",type(professionInstance.GetGuid));
		assert.are.same(PROFESSION_GUID,professionInstance.GetGuid());
	end);

	it("should implement GetProfession",function()
		assert.are.same("function",type(professionInstance.GetProfession));
		assert.are.is_true(PROFESSION_OBJ==professionInstance.GetProfession());

		professionInstance = GHP_ProfessionInstance({
			abilityGuid = "0000",
		});
		assert.are.is_true(nil==professionInstance.GetProfession());
	end);

	it("should implement AbilityIsKnown", function()
		assert.are.same("function",type(professionInstance.AbilityIsKnown));
		assert.are.same(true,professionInstance.AbilityIsKnown("5678"));
		assert.are.same(false,professionInstance.AbilityIsKnown("343434"));
	end);

	it("should implement GotPersonalData",function()
		assert.are.same("function",type(professionInstance.GotPersonalData));
		assert.are.same(true,professionInstance.GotPersonalData());
		professionInstance = GHP_ProfessionInstance({
			abilityGuid = "0000",
		});
		assert.are.same(false,professionInstance.GotPersonalData());
	end);

	it("should implement SetPersonalData",function()
		assert.are.same("function",type(professionInstance.SetPersonalData));
		local PERSONAL_DATA = {
			guid = PROFESSION_GUID,
			skillLevel = 55,
			abilitiesKnown = {"5678"},
		};
		professionInstance.SetPersonalData(PERSONAL_DATA);
		assert.are.same(PERSONAL_DATA,professionInstance.Serialize())
	end);

	it("should implement IsKnown",function()
		assert.are.same("function",type(professionInstance.IsKnown));
		assert.are.same(true,professionInstance.IsKnown())

		local professionInstance2 = GHP_ProfessionInstance({
			guid = PROFESSION_GUID,
			skillLevel = 0,
			abilitiesKnown = ABILITIES_KNOWN,
		});
		assert.are.same(false,professionInstance2.IsKnown())
	end);

	it("should implement LearnProfession",function()
		local professionInstance = GHP_ProfessionInstance({
			guid = PROFESSION_GUID,
			skillLevel = 0,
			abilitiesKnown = ABILITIES_KNOWN,

		});

		assert.are.same("function",type(professionInstance.LearnProfession));
		assert.are.same(false,professionInstance.IsKnown());
		assert.are.same(true,professionInstance.LearnProfession());
		assert.are.same(true,professionInstance.IsKnown());
	end)

	it("should implement LearnAbility",function()
		assert.are.same("function",type(professionInstance.LearnAbility));
		local professionInstance = GHP_ProfessionInstance({
			guid = PROFESSION_GUID,
			skillLevel = 0,
			abilitiesKnown = {"1234"},
		});
		local val = professionInstance.LearnAbility("5678");
		assert.are.same(true,val);
		assert.are.same({"1234","5678"},professionInstance.Serialize().abilitiesKnown);
		local val2 = professionInstance.LearnAbility("5678");
		assert.are.same(false,val2);
		assert.are.same({"1234","5678"},professionInstance.Serialize().abilitiesKnown);

	end)

end);