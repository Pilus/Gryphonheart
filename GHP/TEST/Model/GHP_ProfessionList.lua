describe("GHP_ProfessionList",function()

	require("StandardMock");
	require("GHP_ProfessionList");




	local list;

	local DATA = {
		["1234"] = {
			guid = "1234",
			name = "A",
		},
		["5678"] = {
			guid = "5678",
			name = "B",
		},
	};

	local PROFESSIONS = {};

	it("Should load abilities from GHP_ProfessionData when called LoadFromSaved",function()

		GHI_SavedData = function(i)
			assert.are.same("GHP_ProfessionData",i);
			return {
				GetAll = function()
					return DATA;
				end,
				SetVar = function(index,var)
					DATA[index] = var;
				end,
			};
		end

		list = GHP_ProfessionList();



		local m = mock({
			GHP_Profession = function(t)
				local personal = t.personal;
				local a = {};
				a.Serialize = function(stype)
					if stype == "personal" then
						return {
							guid = t.guid,
							personal = personal,
						};
					end
					return {
						guid = t.guid,
						name = t.name,
						personal = personal,
						version = t.version,
					};
				end
				a.IsClass = function(s) if s=="GHP_Profession" then return true; end return false; end;
				a.GetGuid = function() return t.guid; end
				a.GetVersion = function() return t.version; end
				a.GotPersonalData = function() return not(personal == nil) end
				a.SetPersonalData = function(d)
					personal = d.personal;
				end
				PROFESSIONS[t.guid] = a;
				return a;
			end,
		})
		GHP_Profession = function(...) return m.GHP_Profession(...) end;

		assert.are.same("function",type(list.LoadFromSaved));
		list.LoadFromSaved();
		assert.spy(m.GHP_Profession).was.called_with(DATA["1234"]);
		assert.spy(m.GHP_Profession).was.called_with(DATA["5678"]);

		assert.are.same("function",type(list.GetProfession));
		assert.are.same(PROFESSIONS["1234"],list.GetProfession("1234"))
		assert.are.same(PROFESSIONS["5678"],list.GetProfession("5678"))




	end)

	it("should implement SetProfession",function()
		assert.are.same("function",type(list.SetProfession));
		assert.are.same(nil,list.GetProfession("3333"))

		local PROFESSION = {
			guid = "3333",
			name = "C",
		};
		list.SetProfession(PROFESSION);
		assert.are.same(PROFESSIONS["3333"],list.GetProfession("3333"));
		assert.are.same(PROFESSION,DATA["3333"]);

		-- It should accept Profession objects
		local ADD_DATA_2 = {
			guid = "4444",
			name = "D",
		}
		local profession = GHP_Profession(ADD_DATA_2);
		assert.are.same("function",type(profession.IsClass));

		assert.are.same(nil,list.GetProfession("4444"));
		list.SetProfession(profession);
		assert.are_not.equal(nil,list.GetProfession("4444"));
	end);

	it("should not overwrite if the version number is lower",function()
		local ADD_DATA = {
			guid = "5555",
			name = "D5",
			version = 10,
		}
		local profession = GHP_Profession(ADD_DATA);
		assert.are.same(nil,list.GetProfession("5555"));
		list.SetProfession(profession);
		assert.are.equal(profession,list.GetProfession("5555"));

		local ADD_DATA = {
			guid = "5555",
			name = "D55",
			version = 5,
		}
		local profession2 = GHP_Profession(ADD_DATA);
		list.SetProfession(profession2);
		assert.are.equal(profession,list.GetProfession("5555"));
	end);

	it("should not overwrite the personal data if the new data is non personal",function()
		local ADD_DATA1 = {
			guid = "6666",
			name = "D6",
			version = 2,
			personal = {"abc"},
		}
		local profession = GHP_Profession(ADD_DATA1);
		assert.are.same(nil,list.GetProfession("6666"));
		list.SetProfession(profession);
		assert.are.equal(profession,list.GetProfession("6666"));

		local ADD_DATA2 = {
			guid = "6666",
			name = "D633",
			version = 5,
		}
		local profession2 = GHP_Profession(ADD_DATA2);
		list.SetProfession(profession2);

		local resultProf = list.GetProfession("6666").Serialize();
		assert.are.same(ADD_DATA1.guid,resultProf.guid);
		assert.are.same(ADD_DATA2.name,resultProf.name);
		assert.are.same(ADD_DATA2.version,resultProf.version);
		assert.are.same(ADD_DATA1.personal,resultProf.personal);
	end);

	it("should overwrite if the new data is the same version and got personal data",function()
		local ADD_DATA1 = {
			guid = "7777",
			name = "D7",
			version = 2,
			personal = {"abc"},
		}
		local profession = GHP_Profession(ADD_DATA1);
		assert.are.same(nil,list.GetProfession("7777"));
		list.SetProfession(profession);
		assert.are.equal(profession,list.GetProfession("7777"));

		local ADD_DATA2 = {
			guid = "7777",
			name = "D633",
			version = 2,
			personal = {"def"},
		}
		local profession2 = GHP_Profession(ADD_DATA2);
		list.SetProfession(profession2);

		local resultProf = list.GetProfession("7777").Serialize();
		assert.are.same(ADD_DATA1.guid,resultProf.guid);
		assert.are.same(ADD_DATA1.name,resultProf.name);
		assert.are.same(ADD_DATA1.version,resultProf.version);
		assert.are.same(ADD_DATA2.personal,resultProf.personal);
	end);


end);