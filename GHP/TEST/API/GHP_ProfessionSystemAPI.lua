describe("GHP_ProfessionSystemAPI",function()

	require("StandardMock");
	require("GHP_ProfessionSystemAPI");

	local api;
	local GUIDS;
	local DETAILS = {
		["1234"] = {
			"DETAILS1",
		},
		["5678"] = {
			"DETAILS2",
		},
	}
	local USER_GUID = "user_abcabc";

	local LEARN_PROFESSION_CALLED,LEARN_ABILITY_CALLED
	GHP_ProfessionSystemList = function()
		return {
			GetSystemGuids = function()
				return GUIDS;
			end,
			GetSystem = function(guid)
				return {
					GetDetails = function()
						return DETAILS[guid];
					end,
					LearnProfession = function(...)
						LEARN_PROFESSION_CALLED = {guid,...};
					end,
					LearnAbility = function(...)
						LEARN_ABILITY_CALLED = {guid,...};
					end,
					IsCreatedByUser = function(uGuid)
						return guid == "1234"; -- only access to the first one
					end,
				}
			end,

		}
	end

	before_each(function()
		GUIDS = {"1234","5678"};

		api = GHP_ProfessionSystemAPI(USER_GUID);
	end)

	it("should implement GetNumProfessionSystems",function()
		assert.are.same("function",type(api.GetNumProfessionSystems));
		assert.are.same(#(GUIDS),api.GetNumProfessionSystems());
		GUIDS = {"12344","45678","65342"};
		assert.are.same(#(GUIDS),api.GetNumProfessionSystems());
	end);

	it("should implement GetProfessionSystemDetails",function()
		assert.are.same("function",type(api.GetProfessionSystemDetails));
		assert.are.same(DETAILS["1234"],api.GetProfessionSystemDetails(1));
		assert.are.same(DETAILS["5678"],api.GetProfessionSystemDetails(2));

		-- it should also accept guid as input
		assert.are.same(DETAILS["1234"],api.GetProfessionSystemDetails("1234"));
		assert.are.same(DETAILS["5678"],api.GetProfessionSystemDetails("5678"));
	end);

	it("should implement LearnProfession",function()
		assert.are.same("function",type(api.LearnProfession));
		LEARN_PROFESSION_CALLED = nil;
		api.LearnProfession("1234","abc")
		assert.are.same({"1234","abc"},LEARN_PROFESSION_CALLED)

		LEARN_PROFESSION_CALLED = nil;
		api.LearnProfession("5678","abc")
		assert.are.same(nil,LEARN_PROFESSION_CALLED)
	end);
	it("should imeplement LearnAbility",function()
		assert.are.same("function",type(api.LearnAbility));
		LEARN_ABILITY_CALLED = nil;
		api.LearnAbility("1234","abc","def")
		assert.are.same({"1234","abc","def"},LEARN_ABILITY_CALLED)

		LEARN_ABILITY_CALLED = nil;
		api.LearnAbility("5678","abc","def")
		assert.are.same(nil,LEARN_ABILITY_CALLED)
	end);

end);