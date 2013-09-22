describe("GHP_MainUI",function()

	require("StandardMock");
	require("GHP_MainUI");

	-- Mocking of functions / frames
	local OnShowScript;
	GHP_MainUIFrame = {
		SetAttribute = function() end,
		SetScript = function(self,event,script)
			if event == "OnShow" then
				OnShowScript = script;
			end
		end,
		GetWidth = function() return 10; end,

		IsShown = function() return GHP_MainUIFrame.shown == true; end,
	};

	HideUIPanel = function(f) f.shown = nil; end;
	ShowUIPanel = function(f) f.shown = true; end;

	GHP_MainUIFrameInset = {
		Hide = function() end,
	};
	SetPortraitToTexture = function() end;

	local GHI_Event_mock = mock({
		TriggerEvent = function(...) end,
	});
	local EventFuncs = {};
	GHI_Event = function(e,f)   EventFuncs[e] = f;
		return {
			TriggerEvent = GHI_Event_mock.TriggerEvent,
		}
	end

	for i=1,3 do
		local m = {}
		m.SetScript = function(self,handler,func) assert.True(self==m)
			assert.are.same("OnClick",handler);
			assert.are.same("function",type(func));
			m.onClick = func;
		end
		_G["GHP_MainUIFrameTabButton"..i] = m;
	end
	PanelTemplates_TabResize = function() end;
	PanelTemplates_SelectTab = function() end;
	PanelTemplates_DeselectTab = function() end;


	local TIME = 242424;
	GetTime = function() return TIME; end

	local DATA;

	GHP_ProfessionSystemAPI = function()
		return {
			GetNumProfessionSystems = function() return #(DATA) end,
			GetProfessionSystemDetails = function(index)
				if index and DATA[index] then
					return DATA[index][1],DATA[index][2],DATA[index][3],DATA[index][4];
				end
				if index then
					for i,v in pairs(DATA) do
						if v[1] == index then
							return v[1],v[2],v[3],v[4];
						end
					end
				end
			end,
		}
	end;

	local ABILITIES = {
		{"a1234","Ability1","icon1"},
		{"a5678","Ability2","icon2"},
	}

	local ABILITY_PICKUP = {};
	local EXECUTE;
	local COOLDOWN = {10,nil};
	GHP_AbilityAPI = function()
		return {
			GetNumSpellbookAbilities = function()
				return #(ABILITIES);
			end,
			GetSpellbookAbilityInfo = function(_,i)
				return ABILITIES[i][1],ABILITIES[i][2],ABILITIES[i][3];
			end,
			PickupAbility = function(guid,i)
				ABILITY_PICKUP = {guid,i};
			end,
			ExecuteAbility = function(guid,i)
				EXECUTE = {guid,i};
			end,
			GetAbilityCooldown = function()
				return COOLDOWN[1],COOLDOWN[2];
			end,
		}
	end

	local tm = {};
	tm.SetVertexColor = function(s,r,g,b)
		tm.color = {r=r,g=g,b=b};
	end
	GHP_MainUIFramePageTextureMark = tm;

	local CreateSideTabMock = function(prevMock)
		local m = {};

		m.Show = function(self)	assert.True(self==m)
			m.shown = true;
		end;
		m.Hide = function(self)	assert.True(self==m)
			m.shown = false;
		end;
		m.SetNormalTexture = function(self,texture) assert.True(self==m)
			m.texture = texture;
		end
		m.SetScript = function(self,handler,func) assert.True(self==m)
			assert.are.same("OnClick",handler);
			assert.are.same("function",type(func));
			m.onClick = func;
		end
		m.onClick = prevMock.onClick;

		m.SetChecked = function(self,check) assert.True(self==m)
			assert.True(check == 1 or check == nil);
			m.checked = check;
		end

		return m;
	end


	local m = {};
	m.Show = function(self)	assert.True(self==m)
		m.shown = true;
	end;
	m.Hide = function(self)	assert.True(self==m)
		m.shown = false;
	end;
	GHP_MainUIFrameAbilities = m;

	CooldownFrame_SetTimer = function(btn,t1,t2)
		btn.cooldown = {t1,t2 }
		btn.shown = true;
	end

	local MockSpellButton = function(name)
		local m = {};
		m.Show = function(self)	assert.True(self==m)
			m.shown = true;
		end;
		m.Hide = function(self)	assert.True(self==m)
			m.shown = false;
		end;
		m.GetName = function()
			return name;
		end
		m.Enable = function()
			m.enabled = true;
		end
		m.SetScript = function(_,handler,func)
			m[handler] = func;
		end

		_G[name.."IconTexture"] = {
			SetTexture = function(_,texture)
				m.texture = texture;
			end,
			Show = function(self) end,
		}

		_G[name.."SpellName"] = {
			SetText = function(_,spellName)
				m.spellName = spellName;
			end,
			Show = function(self) end,
		}

		_G[name.."Cooldown"] = {
			Hide = function(self) self.shown = false;  end,
		}

		return m;
	end
	for i=1,12 do
		_G["GHP_MainUIFrameAbilitiesButton"..i] = MockSpellButton("GHP_MainUIFrameAbilitiesButton"..i);
	end

	before_each(function()
		-- Reset all side tab mocks
		for i=1,8 do
			_G["GHP_MainUIFrameSideTab"..i] = CreateSideTabMock(_G["GHP_MainUIFrameSideTab"..i] or {});
		end

		DATA = {
			{"GUID1","NAME1","ICON1"},
		}
	end);

	local main;
	it("should set up without errors",function()
		main = GHP_MainUI();
	end);

	it("should register an OnShow script",function()
		assert.are.same("function",type(OnShowScript));
	end);

	it("should display side tabs according to the profession systems available.",function()


		local TestSideTabs = function()
			OnShowScript();

			for i=1,#(DATA) do
				assert.are.same(true,_G["GHP_MainUIFrameSideTab"..i].shown);
				assert.are.same(DATA[i][1],_G["GHP_MainUIFrameSideTab"..i].guid);
				assert.are.same(DATA[i][2],_G["GHP_MainUIFrameSideTab"..i].text);
				assert.are.same(DATA[i][3],_G["GHP_MainUIFrameSideTab"..i].texture);
			end
			for i=#(DATA)+1,8 do
				assert.are.same(false,_G["GHP_MainUIFrameSideTab"..i].shown);
			end
		end

		-- with one
		TestSideTabs();

		-- with 0
		DATA = {};
		TestSideTabs();

		-- with 7
		DATA = {};
		for i=1,7 do
			table.insert(DATA,{"GUID"..i,"NAME"..i,"ICON"..i});
		end
		TestSideTabs();

		--with 8
		table.insert(DATA,{"GUID8","NAME8","ICON8"});
		TestSideTabs();

	end);

	it("the GHP_PROFESSION_SYSTEM_UPDATED event should trigger update of the side tabs",function()
		assert.are.same("function",type(EventFuncs["GHP_PROFESSION_SYSTEM_UPDATED"]));
		assert.are.same(nil,_G["GHP_MainUIFrameSideTab1"].shown);
		EventFuncs["GHP_PROFESSION_SYSTEM_UPDATED"]("GHP_PROFESSION_SYSTEM_UPDATED","1234");
		assert.are.same(true,_G["GHP_MainUIFrameSideTab1"].shown);
	end);

	it("should register clicks on the side bar tabs to trigger selection of current system",function()
		for i=1,8 do
		   assert.are.same("function",type(_G["GHP_MainUIFrameSideTab"..i].onClick));
		end
	end);

	it("should check the selected side button and default to 1",function()
		DATA = {};
		for i=1,7 do
			table.insert(DATA,{"GUID"..i,"NAME"..i,"ICON"..i});
		end
		OnShowScript();

		assert.are.same(1,_G["GHP_MainUIFrameSideTab1"].checked);
		for i=2,8 do
			assert.are.same(nil,_G["GHP_MainUIFrameSideTab"..i].checked);
		end

		-- after a click
		_G["GHP_MainUIFrameSideTab4"].onClick(_G["GHP_MainUIFrameSideTab4"]);
		assert.are.same(nil,_G["GHP_MainUIFrameSideTab1"].checked);
		assert.are.same(nil,_G["GHP_MainUIFrameSideTab2"].checked);
		assert.are.same(nil,_G["GHP_MainUIFrameSideTab3"].checked);
		assert.are.same(1,_G["GHP_MainUIFrameSideTab4"].checked);
		assert.are.same(nil,_G["GHP_MainUIFrameSideTab5"].checked);
		assert.are.same(nil,_G["GHP_MainUIFrameSideTab6"].checked);
		assert.are.same(nil,_G["GHP_MainUIFrameSideTab7"].checked);
		assert.are.same(nil,_G["GHP_MainUIFrameSideTab8"].checked);

		-- remove before selected   (selected (4) moves to 3)
		table.remove(DATA,3);
		OnShowScript();
		assert.are.same(nil,_G["GHP_MainUIFrameSideTab1"].checked);
		assert.are.same(nil,_G["GHP_MainUIFrameSideTab2"].checked);
		assert.are.same(1,_G["GHP_MainUIFrameSideTab3"].checked);
		for i=4,8 do
			assert.are.same(nil,_G["GHP_MainUIFrameSideTab"..i].checked);
		end

		-- remove current selected
		table.remove(DATA,3);
		OnShowScript();
		assert.are.same(1,_G["GHP_MainUIFrameSideTab1"].checked);
		for i=2,8 do
			assert.are.same(nil,_G["GHP_MainUIFrameSideTab"..i].checked);
		end
	end);

	it("should color the mark of the background with the color of the system",function()
		DATA = {};
		for i=1,3 do
			table.insert(DATA,{"GUID"..i,"NAME"..i,"ICON"..i});
		end

		local COLOR = {r=0.4,g=0.2,b=0.8};
		DATA[2][4] = COLOR;

		OnShowScript();

		-- default color
		assert.are.same({r=1.0,g=0.0,b=0.0},GHP_MainUIFramePageTextureMark.color);

		_G["GHP_MainUIFrameSideTab2"].onClick(_G["GHP_MainUIFrameSideTab2"]);

		assert.are.same(COLOR,GHP_MainUIFramePageTextureMark.color);
	end);

	it("should display abilities",function()

		GHP_MainUIFrameTabButton2.onClick();
		assert.are.same(true,GHP_MainUIFrameAbilities.shown);

		assert.are.same(true,GHP_MainUIFrameAbilitiesButton1.shown);
		assert.are.same(ABILITIES[1][2],GHP_MainUIFrameAbilitiesButton1.spellName);
		assert.are.same(ABILITIES[1][3],GHP_MainUIFrameAbilitiesButton1.texture);
		assert.are.same(true,GHP_MainUIFrameAbilitiesButton2.shown);
		assert.are.same(ABILITIES[2][2],GHP_MainUIFrameAbilitiesButton2.spellName);
		assert.are.same(ABILITIES[2][3],GHP_MainUIFrameAbilitiesButton2.texture);

		for i=3,12 do
			assert.are.same(false,_G["GHP_MainUIFrameAbilitiesButton"..i].shown);
		end

		GHP_MainUIFrameTabButton1.onClick();
		assert.are.same(false,GHP_MainUIFrameAbilities.shown);
	end);

	it("should call apilityAPI.PickupAbility(systemGuid,index) on click on ability",function()
		assert.are.same("function",type(GHP_MainUIFrameAbilitiesButton1.OnClick));
		assert.are.same(0,#(ABILITY_PICKUP));
		GHP_MainUIFrameAbilitiesButton1.OnClick(GHP_MainUIFrameAbilitiesButton1,"LeftButton")
		assert.are.same(2,#(ABILITY_PICKUP));
		assert.are.same(1,ABILITY_PICKUP[2]);
	end);

	it("should implement Toggle", function()
		assert.are.same("function",type(main.Toggle));
		GHP_MainUIFrame.shown = nil;
		main.Toggle();
		assert.are.same(true,GHP_MainUIFrame.shown)
		main.Toggle();
		assert.are.same(nil,GHP_MainUIFrame.shown)
	end);

	it("should call abilityApi.ExecuteAbility on click", function()
		assert.are.same("function",type(main.Toggle));
		EXECUTE = nil;
		GHP_MainUIFrameAbilitiesButton2.OnClick(GHP_MainUIFrameAbilitiesButton2,"RightButton")
		assert.are.same("table",type(EXECUTE))
		assert.are.same(2,EXECUTE[2]);
	end);

	it("should listing to the ABILITY_UPDATED event and update the view",function()
		assert.are.same("function",type(EventFuncs["GHP_ABILITY_UPDATED"]));

		assert.are.same(false,GHP_MainUIFrameAbilitiesButton1Cooldown.shown);

		-- it should result in a change of cooldown
		COOLDOWN = {10,5};
		EventFuncs["GHP_ABILITY_UPDATED"]();
		assert.are.same(true,GHP_MainUIFrameAbilitiesButton1Cooldown.shown);
		assert.are.same("table",type(GHP_MainUIFrameAbilitiesButton1Cooldown.cooldown));
		assert.are.same(TIME - COOLDOWN[2],GHP_MainUIFrameAbilitiesButton1Cooldown.cooldown[1]);
		assert.are.same(COOLDOWN[1],GHP_MainUIFrameAbilitiesButton1Cooldown.cooldown[2]);
	end);



end);