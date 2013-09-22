describe("GHP_ObjectAPI",function()

	require("StandardMock");
	require("GHP_ObjectAPI");
	local GUID = "abc123";
	local POS = {"9E76840E0" }
	local pos = POS;
	local ATT = {abc=123};

	local OBJ = {
		IsCreatedByUser = function(u) return u==GUID; end
	}

	local OBJ_INS1 = {
		GetInfo = function()
			return "name1","icon1";
		end,
		GetObjectGuid = function()
			return "guid1";
		end,
		GetPosition = function()
			return pos;
		end,
		SetPosition = function(p)
			pos = p;
		end,
		GetAttributeValue = function(att)
			return ATT[att];
		end,
		SetAttributeValue = function(att,val)
			ATT[att] = val;
		end,
		GetObject = function()
			return OBJ;
		end,
	}

	local NEARBY = {
		OBJ_INS1,
	}

	GHP_ObjectInstanceRegister = function()
		return {
			GetNumNearbyObjects = function()
				return #(NEARBY);
			end,
			GetObjectInstance = function(index)
				if index == 1 then
					return OBJ_INS1;
				end
			end,
		}
	end

	GHP_ObjectList = function()
		return {

		}
	end
	GHI_ItemInfoList = function()
		return {

		}
	end
	GHI_ContainerList = function()
		return {

		}
	end
	GHI_ErrorThrower = function()
		return {

		}
	end
	GHI_Position = function()
		return {

		}
	end
	GHP_ProfessionSystemList = function()
		return {

		}
	end

	local api;

	it("should implement GetNumNearbyObjects",function()
		api = GHP_ObjectAPI(GUID);
		assert.are.same("function",type(api.GetNumNearbyObjects));
		assert.are.same(#(NEARBY),api.GetNumNearbyObjects());
	end);

	it("should implement GetObjectInfo",function()
		api = GHP_ObjectAPI(GUID);
		assert.are.same("function",type(api.GetObjectInfo));
		local name,icon = api.GetObjectInfo(1);
		assert.are.same("name1",name);
		assert.are.same("icon1",icon);
	end);

	it("should implement GetObjectGuid",function()
		api = GHP_ObjectAPI(GUID);
		assert.are.same("function",type(api.GetObjectGuid));
		local guid = api.GetObjectGuid(1);
		assert.are.same("guid1",guid);
	end);

	it("should implement GetObjectInstance",function()
		api = GHP_ObjectAPI(GUID);
		assert.are.same("function",type(api.GetObjectInstance));

		local api_withOutAccess = GHP_ObjectAPI("9E76867BD");

		local objIns = api.GetObjectInstance(1);
		assert.are.same("table",type(objIns));

		assert.are.same("function",type(objIns.GetAttribute));
		assert.are.same(123,objIns.GetAttribute("abc"));
		assert.are.same(nil,objIns.GetAttribute("def"));

		assert.are.same("function",type(objIns.SetAttribute));
		objIns.SetAttribute("abc",456);
		assert.are.same(456,objIns.GetAttribute("abc"));

		assert.are.same("function",type(objIns.GetPosition));
		assert.are.same(POS,objIns.GetPosition());
		assert.are.same("function",type(objIns.SetPosition));
		local newPos = {"9E768962D"}
		objIns.SetPosition(newPos)
		assert.are.same(newPos,objIns.GetPosition());

		-- ======  NEGATIVE TEST - NO ACCESS TO WRITE =====
		local errorThrown = false;
		error = function()
			errorThrown = true;
		end
		local api = GHP_ObjectAPI("9E76867BD");
		local objIns = api.GetObjectInstance(1);
		assert.are.same(456,objIns.GetAttribute("abc"));
		objIns.SetAttribute("abc",789);
		assert.are.same(true,errorThrown)
		assert.are.same(456,objIns.GetAttribute("abc"));

		errorThrown = false
		local newPos2 = {"9E768962D" }
		assert.are.same(newPos,objIns.GetPosition());
		objIns.SetPosition(newPos2)
		assert.are.same(true,errorThrown)
		assert.are.same(newPos,objIns.GetPosition());

	end);





end);