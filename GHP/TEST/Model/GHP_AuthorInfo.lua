describe("GHP_AuthorInfo",function()

	require("StandardMock");
	require("GHP_AuthorInfo");

	local info;
	local AUTHOR_GUID = "ABC_123";
	local AUTHOR_NAME = "NnAaMmEe";

	before_each(function()
		info = GHP_AuthorInfo({
			authorGuid = AUTHOR_GUID,
			authorName = AUTHOR_NAME,
		});
	end)

	it("should serialize and deserialize",function()
		local t = info.Serialize();
		assert.are.same(AUTHOR_GUID,t.authorGuid);
		assert.are.same(AUTHOR_NAME,t.authorName);
	end);

	it("should implement IsCreatedByUser",function()
		assert.are.same("function",type(info.IsCreatedByUser));
		assert.are.same(true,info.IsCreatedByUser(AUTHOR_GUID));
		assert.are.same(false,info.IsCreatedByUser("bla bla"));
	end);

end);