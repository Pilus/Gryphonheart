describe("GHP_Ability",function()

	require("StandardMock");
	require("GHP_Ability");
	require("GHP_AuthorInfo");


	local NAME = "itsName";
	local ICON = "theIconPath";
	local GUID = "1234";
	local COOLDOWN = 2;
	local LAST_CAST_TIME = 42;
	local AUTHOR_GUID = "5678";
	local AUTHOR_NAME = "Test";
	local VERSION = 2;
	local ATTRIBUTES = {
		att1 = {
			type = "number",
			defaultValue = 42,
		},
	}

	local ability;

	local dynSetSpy;

	local GHI_Event_mock = mock({
		TriggerEvent = function(...) end,
	});
	local EventFunc = {};
	GHI_Event = function(event,f)  if event and f then EventFunc[event] = f; end
		return {
			TriggerEvent = GHI_Event_mock.TriggerEvent,
		}
	end

	before_each(function()
		GHP_Loc = function() return {}; end
		dynSetSpy = mock({
			setup = function() end,
			Deserialize = function() end,
			Serialize = function() return; end,
			Execute = function() end,
		});
		GHI_DynamicActionInstanceSet = function(...) dynSetSpy.setup(...); return dynSetSpy; end;

		ability = GHP_Ability({
			name = NAME,
			icon = ICON,
			guid = GUID,
			cooldown = COOLDOWN,
			lastCastTime = LAST_CAST_TIME,
			authorName = AUTHOR_NAME,
			authorGuid = AUTHOR_GUID,
			version = VERSION,
			attributes = ATTRIBUTES,
		});
	end)

	it("should deserialze and serialize",function()
		local t = ability.Serialize();
		assert.are.same(NAME,t.name);
		assert.are.same(ICON,t.icon);
		assert.are.same(GUID,t.guid);
		assert.are.same(COOLDOWN,t.cooldown);
		assert.are.same(AUTHOR_NAME,t.authorName);
		assert.are.same(AUTHOR_GUID,t.authorGuid);
		assert.are.same(LAST_CAST_TIME,t.lastCastTime);
		assert.are.same(VERSION,t.version);
		assert.are.same(ATTRIBUTES,t.attributes);
	end);

	it("should not include player specific info when serialized with the flag 'sharing'",function()
		local t = ability.Serialize("sharing");
		assert.are.same(NAME,t.name);
		assert.are.same(ICON,t.icon);
		assert.are.same(GUID,t.guid);
		assert.are.same(COOLDOWN,t.cooldown);
		assert.are.same(nil,t.lastCastTime);
	end);

	it("should have a current cooldown after being run",function()
		local cd,timeElapsed = ability.GetCooldown();
		assert.are.same(COOLDOWN,cd);
		assert.are.same(nil,timeElapsed);

		ability.Execute();
		local castTime = time();

		local cd,timeElapsed = ability.GetCooldown();
		assert.are.same(COOLDOWN,cd);
		assert.are.same(0,timeElapsed);

		wait(COOLDOWN/2);
		local cd,timeElapsed = ability.GetCooldown();
		assert.are.same(COOLDOWN,cd);
		assert.are.same(COOLDOWN/2,timeElapsed);

		wait(COOLDOWN/2);
		local cd,timeElapsed = ability.GetCooldown();
		assert.are.same(COOLDOWN,cd);
		assert.are.same(nil,timeElapsed);

		local t = ability.Serialize();
		assert.are.same(castTime,t.lastCastTime);
	end);

	it("should have a GetGuid function that returns the attributes guid",function()
		assert.are.same("function",type(ability.GetGuid));
		assert.are.same(GUID,ability.GetGuid());
	end);

	it("must implement GetAuthorInfo",function()
	    assert.are.same("function",type(ability.GetAuthorInfo));
		local guid,name = ability.GetAuthorInfo();
		assert.are.same(AUTHOR_GUID,guid);
		assert.are.same(AUTHOR_NAME,name);
	end);

	it("must implement IsCreatedByPlayer",function()
		assert.are.same("function",type(ability.IsCreatedByPlayer));
		local PGUID = AUTHOR_GUID;
		GHUnitGUID = function(u) if string.lower(u) == "player" then return PGUID; end end;

		assert.are.same(true,ability.IsCreatedByPlayer());

		PGUID = "0000";
		assert.are.same(false,ability.IsCreatedByPlayer());
	end);


	it("should have a dynamic action set",function()
		local DYN = {};

		local locMock = mock({
			DYN_PORT_ABILITY_RUN_NAME = "A",
			DYN_PORT_ABILITY_RUN_DESCRIPTION = "B",
		});
		GHP_Loc = function() return locMock; end



		ability = GHP_Ability({
			name = NAME,
			icon = ICON,
			guid = GUID,
			cooldown = COOLDOWN,
			dynamicActionSet = DYN,
		});



		assert.spy(dynSetSpy.setup).was.called()
		assert.spy(dynSetSpy.setup).was.called_with(ability,"onExecute",{name=locMock.DYN_PORT_ABILITY_RUN_NAME,description=locMock.DYN_PORT_ABILITY_RUN_DESCRIPTION})

		assert.spy(dynSetSpy.Deserialize).was.called_with(DYN);

	end);

	it("should implement GetInfo",function()
		assert.are.same("function",type(ability.GetInfo));
		local guid,name,icon = ability.GetInfo();
		assert.are.same(GUID,guid);
		assert.are.same(NAME,name);
		assert.are.same(ICON,icon);
	end);

	it("should impleemnt GetVersion",function()
		assert.are.same("function",type(ability.GetVersion));
		assert.are.same(VERSION,ability.GetVersion());
	end);

	it("should implement Execute",function()
		assert.are.same("function",type(ability.Execute));
		-- execute should call dynamicActionSet.Execute("onclick", abilityInstance,1)
		local abilityInstance = {};
		local exeGuids = {"guids","more guids"}
		ability.Execute(abilityInstance,exeGuids);
		assert.spy(dynSetSpy.Execute).was.called_with("execute",abilityInstance,nil,nil,nil,exeGuids);
		assert.spy(GHI_Event_mock.TriggerEvent).was.called_with("GHP_ABILITY_UPDATED",GUID);

	end)

	it("should implement GetAttributeInfo",function()
		assert.are.same("function",type(ability.GetAttributeInfo));
		local attType,defVal = ability.GetAttributeInfo("att1");
		assert.are.same("number",attType);
		assert.are.same(42,defVal);
	end);




end)