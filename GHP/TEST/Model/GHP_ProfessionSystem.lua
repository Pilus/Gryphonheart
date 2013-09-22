describe("GHP_ProfessionSystem",function()

	require("StandardMock");
	require("GHP_ProfessionSystem");
	require("GHP_AuthorInfo");

	local system;
	local GUID = "ABC_123";
	local NAME = "NnAaMmEe";
	local ICON = "IiCcOoNn";
	local COLOR = {r=1.0,g=0.4,b=0.5};
	local VER = 3;
	local AUTHOR_GUID = "1234321";
	local AUTHOR_NAME = "Gryphonheart Team";

	before_each(function()
		system = GHP_ProfessionSystem({
			guid = GUID,
			name = NAME,
			icon = ICON,
			markColor = COLOR,
			version = VER,
			authorGuid = AUTHOR_GUID,
			authorName = AUTHOR_NAME,
		});
	end)

	it("should serialize / deserialize",function()
		local t = system.Serialize();
		assert.are.same(GUID,t.guid);
		assert.are.same(NAME,t.name);
		assert.are.same(ICON,t.icon);
		assert.are.same(COLOR,t.markColor);
		assert.are.same(VER,t.version);
		assert.are.same(AUTHOR_GUID,t.authorGuid);
		assert.are.same(AUTHOR_NAME,t.authorName);
	end);

	it("Should implement GetGuid",function()
		assert.are.same("function",type(system.GetGuid));
		assert.are.same(GUID,system.GetGuid());
	end);

	it("Should implement GetDetails",function()
		assert.are.same("function",type(system.GetDetails));
		local guid,name,icon,color = system.GetDetails();
		assert.are.same(GUID,guid);
		assert.are.same(NAME,name);
		assert.are.same(ICON,icon);
		assert.are.same(COLOR,color);
	end);

	it("should implement GetVersion",function()
		assert.are.same("function",type(system.GetVersion));
		local ver = system.GetVersion();
		assert.are.same(VER,ver);
	end);



end);



