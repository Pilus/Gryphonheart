describe("GHP_Object",function()

	require("StandardMock");
	require("GHP_ObjectInstanceRegister");

	local GHI_Event_mock = mock({
		TriggerEvent = function(...) end,
	});
	local EventFunc = {};
	GHI_Event = function(event,f)  if event and f then EventFunc[event] = f; end
		return {
			TriggerEvent = GHI_Event_mock.TriggerEvent,
		}
	end

	local OBJECT1 = {
		"obj1",
	}

	local reg;
	it("should initialize without errors",function()
		reg = GHP_ObjectInstanceRegister();
	end);

	it("should implement GetNumNearbyObjects",function()
		assert.are.same("function",type(reg.GetNumNearbyObjects));
		assert.are.same(0,reg.GetNumNearbyObjects());
	end);

	it("should implement AddObjectInstance",function()
		assert.are.same("function",type(reg.AddObjectInstance));
		reg.AddObjectInstance(OBJECT1);
		assert.spy(GHI_Event_mock.TriggerEvent).was.called_with("GHP_NEARBY_OBJECTS_UPDATED");
		assert.are.same(1,reg.GetNumNearbyObjects());
	end);

	it("should implement GetObjectInstance",function()
		assert.are.same("function",type(reg.GetObjectInstance));
		assert.are.same(OBJECT1,reg.GetObjectInstance(1));
	end);

	it("should implement RemoveObjectInstance",function()
		assert.are.same("function",type(reg.RemoveObjectInstance));
		reg.RemoveObjectInstance(OBJECT1);
		assert.spy(GHI_Event_mock.TriggerEvent).was.called_with("GHP_NEARBY_OBJECTS_UPDATED");
		assert.are.same(0,reg.GetNumNearbyObjects());
	end);





end);