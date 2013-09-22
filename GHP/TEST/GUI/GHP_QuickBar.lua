describe("GHP_MainUI",function()

	require("StandardMock");
	require("GHP_QuickBar");

	-- Mocking of functions / frames
	local POINT;
	local BACKDROP;
	local SCRIPTS = {};
	local DRAG,MOVEABLE,CLEARED;
	local WIDTH,HEIGHT = 20,10;
	GHP_QuickBarFrame = {
		SetPoint = function(self,...)
			POINT = {...};
		end,
		SetBackdrop = function(self,t)
			BACKDROP = t;
		end,
		SetScript = function(self,name,func)
			SCRIPTS[name] = func;
		end,
		GetEffectiveScale = function()
			return 1;
		end,
		RegisterForDrag = function(_,d)
			DRAG = d;
		end,
		SetMovable = function()
			MOVEABLE = true;
		end,
		ClearAllPoints = function()
			CLEARED = true;
		end,
		GetWidth = function()
			return WIDTH;
		end,
		GetHeight = function()
			return HEIGHT;
		end,
		GetBottom = function() return UIParent:GetHeight() - (POINT[4] + WIDTH/2); end,
		GetRight = function() return UIParent:GetWidth() - (POINT[5] + HEIGHT/2); end,
	};

	UIParent = {
		GetWidth = function() return 1000; end,
		GetHeight = function() return 1500; end,
	};

	GHP_Loc = function()
		return {
			QUICK_NEARBY_OBJECTS = "Nearby objects:",
			QUICK_EQUIPPED_OBJECTS = "Equipped objects:",
			QUICK_WEIGHT = "Weight: %.1f",
		}
	end;
	local WEIGHT_TEXT, BAR1_TEXT, BAR2_TEXT;
	GHP_QuickBarFrameTextLabel = {SetText = function(_,t) WEIGHT_TEXT = t; end}
	GHP_QuickBarFrameBar1TextLabel = {SetText = function(_,t) BAR1_TEXT = t; end}
	GHP_QuickBarFrameBar2TextLabel = {SetText = function(_,t) BAR2_TEXT = t; end }

	GHP_QuickBarFrameMenuButton = {SetScript = function() end}

	local sideFrameAdded;
	local BUTTON_FRAME;
	BUTTON_FRAME = {
		POS = {
			X = 200,
			Y = 300,
		},
		Hide = function()
			BUTTON_FRAME.hidden = true;
		end,
		Show = function()
			BUTTON_FRAME.hidden = false;
		end,
		GetBottom = function() return BUTTON_FRAME.POS.Y; end,
		GetLeft = function() return BUTTON_FRAME.POS.X; end,
		GetHeight = function() return 10; end,
		GetWidth = function() return 5; end,
		RegisterForClicks = function() end,
	};
	GHI_ButtonUI = function()
		return {
			AddSideFrame = function(f)
				sideFrameAdded = f;
				return BUTTON_FRAME;
			end,
		};
	end;

	local BG = "bg";
	GHM_GetBackground = function()
		return BG;
	end

	local CURSOR_X,CURSOR_Y = 30,70;
	GetCursorPosition = function()
		return CURSOR_X,CURSOR_Y;
	end

	-- Position mock
	local X,Y,WORLD = 0,0,1;
	local MOVE_UPDATE_FUNC;
	GHI_Position = function()
		return {
			GetPlayerPos = function()
				return {
					x = X,
					y = Y,
					world = WORLD,
				}
			end,
			OnNextMoveCallback = function(_,func,_)
				MOVE_UPDATE_FUNC = func;
			end,
		}
	end

	local EVENT_UPDATE_FUNC;
	GHI_Event = function(_,func)
		EVENT_UPDATE_FUNC = func;
	end

	-- Object api mock
	local OBJECTS = {};
	GHP_ObjectAPI = function()
		return {
			GetNumNearbyObjects = function() return #(OBJECTS) end,
			GetObjectInfo = function(index) return unpack(OBJECTS[index] or {}); end,
		}
	end

	-- Nearby object buttons mock
	local NEARBY_TEXTURES = {};
	for i=1,4 do
		_G["GHP_QuickBarFrameBar1Button"..i] = {
			id=i,
			RegisterForClicks = function() end,
			SetScript = function() end,
		};
		_G["GHP_QuickBarFrameBar2Button"..i] = {
			id=i,
			RegisterForClicks = function() end,
			SetScript = function() end,
			GetName = function() return "GHP_QuickBarFrameBar2Button"..i; end,
		};
		_G["GHP_QuickBarFrameBar2Button"..i.."Cooldown"] = {
			Hide = function() end,
		}
	end
	SetItemButtonTexture = function(btn,texture)
		NEARBY_TEXTURES[btn.id] = texture;
	end

	GHP_EquippedItemsAPI = function()
		return {
			GetNumEquippedItemSlots = function() return 0; end,
			GetEquippedItemInfo = function() end,
			GetEquippedItemSlotInfo = function() end,
		}
	end

	it("should load without errors",function()
		GHP_QuickBar();
	end);

	it("should call GHI_ButtonUI.AddSideFrame with the quick bar frame",function()
		assert.are.same(GHP_QuickBarFrame,sideFrameAdded);
	end);

	it("should load position information from GHP_MiscData and place the frame accordingly",function()

		local x = 100;
		local y = 60;
		GHP_MiscData = {
			quickBarPos = {
				x = x,
				y = y,
			}
		}

		reload("GHP_QuickBar");
		GHP_QuickBar();

		assert.are.same("CENTER",POINT[1]);
		assert.are.same(UIParent,POINT[2]);
		assert.are.same("BOTTOMLEFT",POINT[3]);
		assert.are.same(x,POINT[4]);
		assert.are.same(y,POINT[5]);

	end);

	it("should ancor itself to the sidebutton when there is no coordinates",function()
		reload("GHP_QuickBar");
		GHP_MiscData = nil;
		POINT = {};

		GHP_QuickBar();

		assert.are.same("RIGHT",POINT[1]);
		assert.are.same(BUTTON_FRAME,POINT[2]);
		assert.are.same("LEFT",POINT[3]);
		assert.are.same(0,POINT[4]);
		assert.are.same(0,POINT[5]);
	end);

	it("should hide the side button when hidden",function()
		assert.are.same("function",type(SCRIPTS["OnHide"]));
		assert.are.same("function",type(SCRIPTS["OnShow"]));
		assert.are.same(nil,BUTTON_FRAME.hidden)
		SCRIPTS["OnHide"]();
		assert.are.same(true,BUTTON_FRAME.hidden)
		SCRIPTS["OnShow"]();
		assert.are.same(false,BUTTON_FRAME.hidden)
	end);

	it("should apply the ghm background",function()
		local expected = {
			bgFile = BG,
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		};

		for i,exp in pairs(expected) do
			assert.are.same(exp,BACKDROP[i])
		end
	end);

	it("should be dragable",function()
		assert.are.same("LeftButton",DRAG);
		assert.are.same(true,MOVEABLE);

		-- should register OnUpdate, OnDragStart, OnDragStop
		assert.are.same("function",type(SCRIPTS["OnUpdate"]));
		assert.are.same("function",type(SCRIPTS["OnDragStart"]));
		assert.are.same("function",type(SCRIPTS["OnDragStop"]));
		local x = 100;
		local y = 60;
		GHP_MiscData = {
			quickBarPos = {
				x = x,
				y = y,
			}
		}

		reload("GHP_QuickBar");
		GHP_QuickBar();
		assert.are.same(nil,CLEARED);
		local x,y = POINT[2],POINT[3];

		-- should not change
		SCRIPTS["OnUpdate"]();
		assert.are.same(x,POINT[2]);
		assert.are.same(y,POINT[3]);
		assert.are.same(nil,CLEARED);

		SCRIPTS["OnDragStart"]();
		SCRIPTS["OnUpdate"]();
		assert.are.same(CURSOR_X,POINT[4]);
		assert.are.same(CURSOR_Y,POINT[5]);
		assert.are.same(true,CLEARED);

		-- should be saved
		assert.are.same(CURSOR_X,GHP_MiscData.quickBarPos.x);
		assert.are.same(CURSOR_Y,GHP_MiscData.quickBarPos.y);

		local x,y = CURSOR_X,CURSOR_Y;
		CURSOR_X,CURSOR_Y = 10,20;

		SCRIPTS["OnDragStop"]();
		SCRIPTS["OnUpdate"]();
		assert.are.same(x,POINT[4]);
		assert.are.same(y,POINT[5]);


	end);

	it("should not be possible to drag it over the edge of the screen",function()
		CURSOR_X = -200;
		SCRIPTS["OnDragStart"]();
		SCRIPTS["OnUpdate"]();
		assert.are.same(WIDTH/2,POINT[4]);
		assert.are.same(CURSOR_Y,POINT[5]);
		SCRIPTS["OnDragStop"]();

		CURSOR_X = 100;
		CURSOR_Y = -200;
		SCRIPTS["OnDragStart"]();
		SCRIPTS["OnUpdate"]();
		assert.are.same(CURSOR_X,POINT[4]);
		assert.are.same(HEIGHT/2,POINT[5]);
		SCRIPTS["OnDragStop"]();

		CURSOR_X = 1100;
		CURSOR_Y = 100;
		SCRIPTS["OnDragStart"]();
		SCRIPTS["OnUpdate"]();
		assert.are.same(1000-WIDTH/2,POINT[4]);
		assert.are.same(CURSOR_Y,POINT[5]);
		SCRIPTS["OnDragStop"]();

		CURSOR_X = 100;
		CURSOR_Y = 1600;
		SCRIPTS["OnDragStart"]();
		SCRIPTS["OnUpdate"]();
		assert.are.same(CURSOR_X,POINT[4]);
		assert.are.same(1500-HEIGHT/2,POINT[5]);
		SCRIPTS["OnDragStop"]()

	end);

	it("should snap to the side button if moved back close to it",function()
		CURSOR_X = 190;
		CURSOR_Y = 300;
		SCRIPTS["OnDragStart"]();
		SCRIPTS["OnUpdate"]();
		assert.are.same("RIGHT",POINT[1]);
		assert.are.same(BUTTON_FRAME,POINT[2]);
		assert.are.same("LEFT",POINT[3]);
		assert.are.same(0,POINT[4]);
		assert.are.same(0,POINT[5]);
		assert.are.same(nil,GHP_MiscData.quickBarPos);
		SCRIPTS["OnDragStop"]()
	end);

	it("should put text on the labels from the localization file",function()
		local loc = GHP_Loc();
		assert.are.same(loc.QUICK_NEARBY_OBJECTS,BAR1_TEXT)
		assert.are.same(loc.QUICK_EQUIPPED_OBJECTS,BAR2_TEXT)
		assert.are.same(string.format(loc.QUICK_WEIGHT,0),WEIGHT_TEXT)
	end);

	it("should register an nearby object update function",function()
		assert.are.same("function",type(MOVE_UPDATE_FUNC));
		assert.are.same("function",type(EVENT_UPDATE_FUNC));
	end);

	it("should update the nearby objects correctly",function()

		NEARBY_TEXTURES = {};
		OBJECTS = {
			{"test1","icon1",3},
			{"test2","icon2",3},
		}
		MOVE_UPDATE_FUNC();
		assert.are.same("icon1",NEARBY_TEXTURES[1])
		assert.are.same("icon2",NEARBY_TEXTURES[2])
		assert.are.same("Interface/PaperDoll/UI-Backpack-EmptySlot",NEARBY_TEXTURES[3] or nil)
		assert.are.same("Interface/PaperDoll/UI-Backpack-EmptySlot",NEARBY_TEXTURES[4] or nil)

	end);

end);