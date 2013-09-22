describe("GHP_Object",function()

	require("StandardMock");
	require("GHP_Object");
	require("GHP_AuthorInfo");


	GHI_ItemInfo_AdvTooltip = function(info,class)
		local OtherSerialize = class.Serialize;
		class.Serialize = function(stype,t)
			t = t or {};
			if OtherSerialize then
				t = OtherSerialize(stype,t)
			end
			return t;
		end;
		class.inheritedAdvTooltip = true;
		return class;
	end

	it("should inherit GHI_ItemInfo_AdvTooltip",function()
		local obj = GHP_Object();
		assert.are.same(true,obj.inheritedAdvTooltip)
	end);

	local NAME = "name";
	local ICON = "icon";
	local GUID = "guid";
	local AUTHOR_NAME = "auname";
	local AUTHOR_GUID = "auguid";
	local VERSION = 5;
	local ATTRIBUTES = {
		att1 = {
			type = "number",
			defaultValue = 42,
		},
	}
	local RCT = "right click text"

	local INFO = {
		name = NAME,
		icon = ICON,
		guid = GUID,
		authorName = AUTHOR_NAME,
		authorGuid = AUTHOR_GUID,
		version = VERSION,
		attributes = ATTRIBUTES,
		rightClickText = RCT,
		abilities = {
			{
				"abc123",
			}
		},
	};

	GHP_AbilityInstance = function(info)
		return {
			Serialize = function()
				return info;
			end,
		};
	end

   	it("should serialize and deserialze",function()
		local obj = GHP_Object(INFO);
		local info = obj.Serialize();
		--assert.are.same(true,info);
		assert.are.same(INFO.name,info.name);
		assert.are.same(INFO.icon,info.icon);
		assert.are.same(INFO.guid,info.guid);
		assert.are.same(INFO.authorName,info.authorName);
		assert.are.same(INFO.authorGuid,info.authorGuid);
		assert.are.same(INFO.abilities,info.abilities);
		assert.are.same(INFO.version,info.version);
		assert.are.same(INFO.attributes,info.attributes);
		assert.are.same(INFO.rightClickText,info.rightClickText);
	end);

	it("should implement GetGuid",function()
		local obj = GHP_Object(INFO);
		assert.are.same("function",type(obj.GetGuid));
		local guid = obj.GetGuid();
		assert.are.same(GUID,guid);
	end);

	it("should implement GetAttributeInfo",function()
		local obj = GHP_Object(INFO);
		assert.are.same("function",type(obj.GetAttributeInfo));
		local attType,defVal = obj.GetAttributeInfo("att1");
		assert.are.same("number",attType);
		assert.are.same(42,defVal);
	end);

	it("should implement GetInfo",function()
		local obj = GHP_Object(INFO);
		assert.are.same("function",type(obj.GetInfo));
		local name,icon = obj.GetInfo();
		assert.are.same(NAME,name);
		assert.are.same(ICON,icon);
	end);

end);