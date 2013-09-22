describe("GHP_Profession",function()

	require("StandardMock");
	require("GHP_Profession");
	require("GHP_AuthorInfo");


	local NAME = "Prof name";
	local ICON = "prof icon";
	local GUID = "1234";
	local AUTHOR_NAME = "A name";
	local AUTHOR_GUID = "7890";
	local VERSION = 5;
	local ABILITIES = {
		{
			guid = "i1234",
			abilityGuid = "1234",
			skillLevels = {0,10,15,20},
			orangeSkillsAwarded = 3,
			shownInSpellBook = false,
		},
		{
			guid = "i5678",
			abilityGuid = "5678",
			skillLevels = {17,20,25,30},
			orangeSkillAwarded = 1,
			shownInSpellBook = true,
		},
	};

	local OBJECT_SPAWNER_INFO = {
		{
			name = "SPAWNER A",
			guid = "g11",
			objects = { "abc"},
			personal = "pers1",
		},
		{
			name = "SPAWNER B",
			guid = "g22",
			objects = { "def"},
			personal = "pers2",
		},
	};
	local PERSONAL_OBJECT_SPAWNER_INFO = {
		{
			guid = OBJECT_SPAWNER_INFO[1].guid,
			personal = OBJECT_SPAWNER_INFO[1].personal,
		},
		{
			guid = OBJECT_SPAWNER_INFO[2].guid,
			personal = OBJECT_SPAWNER_INFO[2].personal,
		},
	};
	local NONPERSONAL_OBJECT_SPAWNER_INFO = {
		{
			guid = OBJECT_SPAWNER_INFO[1].guid,
			name = OBJECT_SPAWNER_INFO[1].name,
			objects = OBJECT_SPAWNER_INFO[1].objects,
		},
		{
			guid = OBJECT_SPAWNER_INFO[2].guid,
			name = OBJECT_SPAWNER_INFO[2].name,
			objects = OBJECT_SPAWNER_INFO[2].objects,
		},
	};

	local ABILITY_OBJS = {
		["1234"] = {"obj1234"},
		["5678"] = {"obj4578"},
	}


	local profession;
	local ABILITY_INSTANCES = {}

	before_each(function()
		GHP_AbilityInstance = function(info)
			local abIn = {
				type = "AbilityInstance",
				guid = info.guid,
				Serialize = function() return info; end,
				GetSkillLevels = function() return unpack(info.skillLevels); end,
				GetAbility = function() return ABILITY_OBJS[info.guid]; end,
				ShownInSpellbook = function() return info.shownInSpellBook; end,
				GetGuid = function() return info.guid; end,
				GetAbilityGuid = function() return info.abilityGuid; end,
			};
			ABILITY_INSTANCES[info.guid] = abIn;
			return abIn
		end

		GHP_ObjectSpawner = function(info)
			local os = {};
			local personal = info.personal;
			os.Serialize = function(stype)
				if stype == "personal" then
					return {
						guid = info.guid,
						personal = personal,
					}
				elseif stype == "nonpersonal" then
					return {
						guid = info.guid,
						name = info.name,
						objects = info.objects,
					};
				else
					return {
						guid = info.guid,
						name = info.name,
						objects = info.objects,
						personal = personal,
					};
				end
			end
			os.GetGuid = function() return info.guid; end
			os.GotPersonalData = function() return not(personal == nil); end
			os.SetPersonalData = function(p) personal = p.personal; end


			return os;
		end

		profession = GHP_Profession({
			name = NAME,
			icon = ICON,
			guid = GUID,
		   	version = VERSION,
			authorName = AUTHOR_NAME,
			authorGuid = AUTHOR_GUID,
			abilities = ABILITIES,
			objectSpawners = OBJECT_SPAWNER_INFO,
		});
	end)


	it("should deserialze and serialize",function()
		local t = profession.Serialize();
		assert.are.same(NAME,t.name);
		assert.are.same(ICON,t.icon);
		assert.are.same(GUID,t.guid);
		assert.are.same(VERSION,t.version);
		assert.are.same(AUTHOR_NAME,t.authorName);
		assert.are.same(AUTHOR_GUID,t.authorGuid);
		assert.are.same(ABILITIES,t.abilities);
		assert.are.same(OBJECT_SPAWNER_INFO,t.objectSpawners);

		local t = profession.Serialize("personal");
		assert.are.same(nil,t.name);
		assert.are.same(nil,t.icon);
		assert.are.same(GUID,t.guid);
		assert.are.same(nil,t.authorName);
		assert.are.same(nil,t.authorGuid);
		assert.are.same(ABILITIES,t.abilities);
		assert.are.same(PERSONAL_OBJECT_SPAWNER_INFO,t.objectSpawners);

		local t = profession.Serialize("nonpersonal");
		assert.are.same(NAME,t.name);
		assert.are.same(ICON,t.icon);
		assert.are.same(GUID,t.guid);
		assert.are.same(VERSION,t.version);
		assert.are.same(AUTHOR_NAME,t.authorName);
		assert.are.same(AUTHOR_GUID,t.authorGuid);
		assert.are.same(ABILITIES,t.abilities);
		assert.are.same(NONPERSONAL_OBJECT_SPAWNER_INFO,t.objectSpawners);
	end);

	it("should have a GetGuid function that returns the professions guid",function()
		assert.are.same("function",type(profession.GetGuid));
		assert.are.same(GUID,profession.GetGuid());
	end);

	it("must implement GetAuthorInfo",function()
		assert.are.same("function",type(profession.GetAuthorInfo));
		local guid,name = profession.GetAuthorInfo();
		assert.are.same(AUTHOR_GUID,guid);
		assert.are.same(AUTHOR_NAME,name);
	end);

	it("must implement IsCreatedByPlayer",function()
		assert.are.same("function",type(profession.IsCreatedByPlayer));
		local PGUID = AUTHOR_GUID;
		UnitGUID = function(u) if string.lower(u) == "player" then return PGUID; end end;

		assert.are.same(true,profession.IsCreatedByPlayer());

		PGUID = "0000";
		assert.are.same(false,profession.IsCreatedByPlayer());
	end);

	it("must implement GetNumAbility",function()
		assert.are.same("function",type(profession.GetNumAbilities));
		assert.are.same(#(ABILITIES),profession.GetNumAbilities());
	end);

	it("should sort the abilities inserted after their (orange) skill level",function()
		profession = GHP_Profession({
			name = NAME,
			icon = ICON,
			guid = GUID,
		   	version = VERSION,
			authorName = AUTHOR_NAME,
			authorGuid = AUTHOR_GUID,
			abilities = {
				ABILITIES[2],
				ABILITIES[1],
			},
		});
		local t = profession.Serialize();
		assert.are.same(ABILITIES,t.abilities);
	end);

	it("should implement GetAllAbilities(filter)",function()
		assert.are.same("function",type(profession.GetAllAbilities));
		assert.are.same({"1234","5678"},profession.GetAllAbilities())
		assert.are.same({"5678"},profession.GetAllAbilities("shownInSpellbook"))
	end);


	it("should implement GetVersion",function()
		assert.are.same("function",type(profession.GetVersion));
		assert.are.same(VERSION,profession.GetVersion())
	end);

	it("should implement GotPersonalData",function()
		assert.are.same("function",type(profession.GotPersonalData));
		assert.are.same(true,profession.GotPersonalData());

		local profession = GHP_Profession({
			name = NAME,
			icon = ICON,
			guid = GUID,
			version = VERSION,
			authorName = AUTHOR_NAME,
			authorGuid = AUTHOR_GUID,
			abilities = {
				ABILITIES[2],
				ABILITIES[1],
			},
			objectSpawners = {
				{
					guid = "abc",
					name = "def",
				}
			}
		});
		assert.are.same(false,profession.GotPersonalData());
	end);

	it("should implement SetPersonalData",function()
		assert.are.same("function",type(profession.SetPersonalData));
		profession.SetPersonalData({
			guid = GUID,
			objectSpawners = {
				{
					guid = OBJECT_SPAWNER_INFO[2].guid,
					personal = "customPersonal",
				},
				{
					guid = OBJECT_SPAWNER_INFO[1].guid,
					personal = "customPersonal1",
				}
			}
		});

		local t = profession.Serialize();
		assert.are.same("customPersonal",t.objectSpawners[2].personal);
		assert.are.same("customPersonal1",t.objectSpawners[1].personal);

	end);

	it("should implement GetAbilityInstance",function()
		assert.are.same("function",type(profession.GetAbilityInstance));
		assert.are.same(ABILITY_INSTANCES["i1234"],profession.GetAbilityInstance("1234") or nil);
		assert.are.not_same(ABILITY_INSTANCES["i1234"],nil)
	end);


end);