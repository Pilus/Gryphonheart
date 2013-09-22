describe("GHP_AbilityAPI",function()

	require("StandardMock");
	require("GHP_AbilityAPI");

	local DATA = {};
	DATA["1234"] = {
		shownInSpellbookAndKnown = {
			profA = {"a1234","a5678",},
			profB = {"b4444","b3333","b2222",},
		}
	}

	GHP_ProfessionSystemList = function()
		return {
			GetSystem = function(guid)
				if guid == "1234" then
					return {
						GetAllAbilities = function(filter)
							return DATA[guid][filter];
						end,
					}
				end
			end,
		}
	end

	local EXECUTE;
	local ABILITY_INSTANCES = {}
	GHP_ProfessionList = function()
		return {
			GetProfession = function(guid)
				if guid == "5678" then
					return {
						GetAllAbilities = function(filter)
							assert.are.same("1234",guid)
							return DATA[guid][filter];
						end,
						GetAbilityInstance = function(guid)
							ABILITY_INSTANCES[guid] = {
								"test",
								guid,
								Execute = function(...) EXECUTE = {...} end,
							};
							return ABILITY_INSTANCES[guid];
						end
					}
				end
			end,
		}
	end

	local INFO = {
		["1234"] = {"info_a1234"},
		["a1234"] = {"info_a1234"},
		["5678"] = {"info_a5678"},
		["a5678"] = {"info_a5678"},
	}
	local ICON = "abcIcon"


	local COOLDOWN = {10,3};
	GHP_AbilityList = function()
		return {
			GetAbility = function(guid)
				return {
					GetInfo = function()
						return INFO[guid] or "unknown "..guid,"name",ICON;
					end,
					Execute = function(abilityInstance)
						EXECUTE = {guid,abilityInstance}
					end,
					GetCooldown = function()
						return COOLDOWN[1],COOLDOWN[2];
					end
				}
			end,
		}
	end

	local CURSOR = {}
	GHI_CursorHandler = function()
		return {
			SetActionBarHandler = function() end,
			SetCursor = function(...)
				CURSOR = {...}
			end,
		}
	end

	local ACTION_BAR_ARGS;
	GHI_ActionBarUI = function(...)
		ACTION_BAR_ARGS = {...}
		return {

		}
	end

	local api;
	local GUID = "abc123";
	before_each(function()
		CURSOR = {}
		api = GHP_AbilityAPI(GUID);
	end)

	local ABILITY_NOT_READY_YET = "Ability not ready yet"
	GHP_Loc = function()
		return {
			ABILITY_NOT_READY_YET = ABILITY_NOT_READY_YET;
		}
	end

	local ERROR_MSG
	GHI_ErrorThrower = function()
		return {
			CantUseItem = function(msg)
				ERROR_MSG = msg;
			end,
		};
	end;

	local MENU_NEW;
	GHI_MenuList = function()
		return {
			New = function(...)
				MENU_NEW = {...};
			end,
		}
	end

	it("should implement GetNumSpellbookAbilities",function()
		assert.are.same("function",type(api.GetNumSpellbookAbilities));
		assert.are.same(5,api.GetNumSpellbookAbilities("1234"))
		assert.are.same(0,api.GetNumSpellbookAbilities("5678"))

	end);

	it("should implement GetSpellbookAbilityInfo",function()
		assert.are.same("function",type(api.GetSpellbookAbilityInfo));
		assert.are.same(INFO.a1234,api.GetSpellbookAbilityInfo("1234",1) or nil);
		assert.are.same(INFO.a5678,api.GetSpellbookAbilityInfo("1234",2) or nil);
		assert.are.same(nil,api.GetSpellbookAbilityInfo("5678",2) or nil);
	end);

	it("should implement GetSpellbookAbilityGuids",function()
		assert.are.same("function",type(api.GetSpellbookAbilityGuids));
		assert.are.same({"1234","profA","a1234"},{api.GetSpellbookAbilityGuids("1234",1)});
		assert.are.same({"1234","profB","b3333"},{api.GetSpellbookAbilityGuids("1234",4)});
	end);

	it("should implement PickupAbility by index and by guid",function()
		assert.are.same("function",type(api.PickupAbility));
		-- cursor.SetCursor(cursorType, cursorDetail, onClearFunc, onOverlayClickFunc, systemGuid, professionGuid, abilityGuid, objectGuid);
		api.PickupAbility("1234",2);
		assert.are.same("table",type(CURSOR));
		assert.are.same("ITEM",CURSOR[1]);
		assert.are.same(ICON,CURSOR[2]);
		assert.are.same("function",type(CURSOR[3]));
		assert.are.same("function",type(CURSOR[4]));
		assert.are.same("GHP_ABILITY",CURSOR[5]);
		assert.are.same("1234",CURSOR[6]);
		assert.are.same("profA",CURSOR[7]);
		assert.are.same("a5678",CURSOR[8]);
	end);

	it("should initialize action bar",function()
		-- id,clickFunc,getInfoFunc,tooltipFunc,updateEvent
		assert.are.same("table",type(ACTION_BAR_ARGS));
		assert.are.same("GHP_ABILITY",ACTION_BAR_ARGS[1]);
		assert.are.same("function",type(ACTION_BAR_ARGS[2]));
		assert.are.same("function",type(ACTION_BAR_ARGS[3]));
		assert.are.same("function",type(ACTION_BAR_ARGS[4]));
		assert.are.same("GHP_ABILITY_UPDATED",ACTION_BAR_ARGS[5]);

		-- The getInfoFunc should return info for a guid = icon, count, totalCooldown, elapsed
		local getInfoFunc = ACTION_BAR_ARGS[3];
		local icon,count,totalCD,elapsedCD = getInfoFunc({"1234","profA","a5678"});
		assert.are.same(ICON,icon)
		assert.are.same(1,count)
		assert.are.same(COOLDOWN[1],totalCD)
		assert.are.same(COOLDOWN[2],elapsedCD)

		-- click function should run ExecuteAbility
		COOLDOWN = {10,nil};
		EXECUTE = nil;
		ACTION_BAR_ARGS[2]({"1234","5678","b3333"});
		assert.are.same("table",type(EXECUTE))
		assert.are.same({"1234","5678","b3333"},EXECUTE)
	end);

	it("should implement ExecuteAbility",function()
		assert.are.same("function",type(api.ExecuteAbility));

		COOLDOWN = {10,nil};
		EXECUTE = nil;
		ERROR_MSG = nil;

		api.ExecuteAbility("1234","5678","b3333")
		assert.are.same("table",type(EXECUTE))
		assert.are.same({"1234","5678","b3333"},EXECUTE)
		assert.are.same(nil,ERROR_MSG)

		-- on CD
		COOLDOWN = {10,3};
		EXECUTE = nil;
		ERROR_MSG = nil;
		api.ExecuteAbility("1234","5678","b3333")
		assert.are.not_same("table",type(EXECUTE))
		assert.are.same(ABILITY_NOT_READY_YET,ERROR_MSG)

	end);

	it("should implement GetAbilityCooldown",function()
		assert.are.same("function",type(api.GetAbilityCooldown));

		COOLDOWN = {10,3};

		local cd,elapsed = api.GetAbilityCooldown("1234","5678","b3333");
		assert.are.same(COOLDOWN[1],cd)
		assert.are.same(COOLDOWN[2],elapsed)
	end);

	it("should implement GetAbility",function()
		assert.are.same("function",type(api.GetAbility));

		local abilityObj = api.GetAbility("1234","profGuid","a1234","objGuid");
		assert.are.same("table",type(abilityObj));
		assert.are.same("function",type(abilityObj.GetInfo))
		local info = abilityObj.GetInfo();
		assert.are.same(INFO.a1234,info)


	end);

	it("should implement DisplayPerformUI",function()
		assert.are.same("function",type(api.DisplayPerformUI));

		local text,func = "Text",function() end;
		api.DisplayPerformUI(text,func)
		assert.are.same("table",type(MENU_NEW));
		assert.are.same({text,func},MENU_NEW);

	end);

end);