local Result = GHI_TestResult;
local PENDING = 1;
local PASSED = 2;
local WARNING = 3;
local FAILED = 4;
if true then return end

GHI_RegisterTest("ExecuteV11_GetInfo", function(testSetName, runNum)
	local action = GHI_SimpleAction({
		["Type"] = "bag",
		["details"] = "34 slots",
		["marked"] = false,
		["type_name"] = "Bag",
		["texture_i"] = 1,
		["texture"] = "-Normal",
		["req"] = 1,
		["icon"] = "Interface\\Icons\\INV_Misc_Bag_09_Blue",
		["size"] = 34,
	});

	local name, icon, details = action.GetActionInfo();

	if not (name == "Bag") then
		Result(testSetName, runNum, 1, FAILED, "Incorrect name");
	elseif not (icon == "Interface\\Icons\\INV_Misc_Bag_09_Blue") then
		Result(testSetName, runNum, 1, FAILED, "Incorrect icon");
	elseif not (details == "34 slots") then
		Result(testSetName, runNum, 1, FAILED, "Incorrect details");
	else
		Result(testSetName, runNum, 1, PASSED);
	end
end);


GHI_RegisterTest("ExecuteV11_Bag", function(testSetName, runNum)
	local action = GHI_SimpleAction({
		["Type"] = "bag",
		["details"] = "34 slots",
		["marked"] = false,
		["type_name"] = "Bag",
		["texture_i"] = 1,
		["texture"] = "-Normal",
		["req"] = 1,
		["icon"] = "Interface\\Icons\\INV_Misc_Bag_09_Blue",
		["size"] = 34,
	});
	local env = GHI_ScriptEnviroment("SimpleAction_ConstructorsV11_Bag");
	-- hook the functions that is expected to be called
	local called = false;
	local correct = false;
	env.SetValue("GHI_OpenBag", function(size, texture)
		called = true;
		if (size == 34 and texture == "-Normal") then
			correct = true;
		end
	end)
	action.Execute(env);
	if called == true then
		if correct == true then
			Result(testSetName, runNum, 1, PASSED);
		else
			Result(testSetName, runNum, 1, FAILED, "Incorrect values");
		end
	else
		Result(testSetName, runNum, 1, FAILED, "Not called");
	end
end);

GHI_RegisterTest("ExecuteV11_Script", function(testSetName, runNum)

	local action = GHI_SimpleAction({
		["type_name"] = "Script",
		["Type"] = "script",
		["marked"] = false,
		["code"] = {
			"print(\"slashes \\\\ / ok\")", -- [1]
		},
		["details"] = "print(\"slashes \\ / ok\")",
		["delay"] = 0,
		["icon"] = "Interface\\Icons\\Trade_Engineering",
		["req"] = 1,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	local castTime = GetTime();
	env.SetValue("print", function(s)
		if s == "slashes \\ / ok" then
			Result(testSetName, runNum, 1, PASSED);
		else
			Result(testSetName, runNum, 1, FAILED, "Incorrest string: " .. (s or "nil"));
		end
	end)
	action.Execute(env);

	local action = GHI_SimpleAction({
		["type_name"] = "Script",
		["Type"] = "script",
		["marked"] = false,
		["code"] = {
			"print(\"it works\")", -- [1]
		},
		["details"] = "print(\"it works\")",
		["delay"] = 3,
		["icon"] = "Interface\\Icons\\Trade_Engineering",
		["req"] = 1,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	Result(testSetName, runNum, 2, PENDING);
	local castTime = GetTime();
	env.SetValue("print", function(s)
		if s == "it works" then
			local elapsed = GetTime() - castTime;
			if elapsed > 2 and elapsed < 4 then
				Result(testSetName, runNum, 2, PASSED);
			else
				Result(testSetName, runNum, 2, FAILED, "Incorrest delay: " .. (elapsed or 0) .. " sec");
			end
		else
			Result(testSetName, runNum, 2, FAILED, "Incorrest string: " .. (s or "nil"));
		end
	end)
	action.Execute(env);
end);

GHI_RegisterTest("ExecuteV11_Buff", function(testSetName, runNum)
	local action = GHI_SimpleAction({
		["icon"] = "Interface\\Icons\\Spell_Holy_WordFortitude",
		["Type"] = "buff",
		["buffName"] = "Buff test",
		["buffIcon"] = "Interface\\Icons\\INV_ValentinesBoxOfChocolates02",
		["buffDuration"] = 86400,
		["req"] = 1,
		["marked"] = false,
		["details"] = "A buff for testing",
		["castOnSelf"] = 1,
		["type_name"] = "Buff",
		["filter"] = "Helpful",
		["buffType"] = "Magic",
		["buffDetails"] = "A buff for testing",
	});

	local env = GHI_ScriptEnviroment("SimpleAction_" .. testSetName);
	env.SetValue("GHI_ApplyBuff", function(buffName, buffDetails, buffIcon, untilCanceled, filter, buffType, buffDuration, cancelable, stackable, count, delay, range, alwaysCastOnSelf)
		if not (buffName == "Buff test") then
			Result(testSetName, runNum, 1, FAILED, "Incorrest name: " .. (buffName or "nil"));
		elseif not (buffDetails == "A buff for testing") then
			Result(testSetName, runNum, 1, FAILED, "Incorrest details: " .. (buffDetails or "nil"));
		elseif not (buffIcon == "Interface\\Icons\\INV_ValentinesBoxOfChocolates02") then
			Result(testSetName, runNum, 1, FAILED, "Incorrest icon: " .. (buffIcon or "nil"));
		elseif not (untilCanceled == false) then
			Result(testSetName, runNum, 1, FAILED, "Incorrest untilCanceled");
		elseif not (filter == "Helpful") then
			Result(testSetName, runNum, 1, FAILED, "Incorrest filter: " .. (filter or "nil"));
		elseif not (buffType == "Magic") then
			Result(testSetName, runNum, 1, FAILED, "Incorrest type: " .. (buffType or "nil"));
		elseif not (buffDuration == 86400) then
			Result(testSetName, runNum, 1, FAILED, "Incorrest duration: " .. (buffDuration or "nil"));
		elseif not (cancelable == false) then
			Result(testSetName, runNum, 1, FAILED, "Incorrest cancelable");
		elseif not (stackable == false) then
			Result(testSetName, runNum, 1, FAILED, "Incorrest stackable");
		elseif not (count == 1) then
			Result(testSetName, runNum, 1, FAILED, "Incorrest count: " .. (count or "nil"));
		elseif not (delay == 0) then
			Result(testSetName, runNum, 1, FAILED, "Incorrest delay: " .. (delay or "nil"));
		elseif not (range == 0) then
			Result(testSetName, runNum, 1, FAILED, "Incorrest range: " .. (range or "nil"));
		elseif not (alwaysCastOnSelf == true) then
			Result(testSetName, runNum, 1, FAILED, "Incorrest alwaysCastOnSelf");
		else
			Result(testSetName, runNum, 1, PASSED);
		end
	end)
	action.Execute(env);


	local action = GHI_SimpleAction({
		["icon"] = "Interface\\Icons\\Spell_Holy_WordFortitude",
		["Type"] = "buff",
		["buffName"] = "Buff test 2",
		["buffIcon"] = "Interface\\Icons\\INV_ValentinesBoxOfChocolates01",
		["buffDuration"] = 600,
		["req"] = 1,
		["marked"] = false,
		["details"] = "A debuff for testing",
		["type_name"] = "Buff",
		["filter"] = "Harmful",
		["buffType"] = "Poison",
		["untilCanceled"] = 1,
		["buffDetails"] = "A debuff for testing",
		["count"] = 4,
		["delay"] = 3,
		["stackable"] = true,
		["range"] = 10,
	});

	local env = GHI_ScriptEnviroment("SimpleAction_" .. testSetName);
	env.SetValue("GHI_ApplyBuff", function(buffName, buffDetails, buffIcon, untilCanceled, filter, buffType, buffDuration, cancelable, stackable, count, delay, range, alwaysCastOnSelf)
		if not (buffName == "Buff test 2") then
			Result(testSetName, runNum, 2, FAILED, "Incorrest name: " .. (buffName or "nil"));
		elseif not (buffDetails == "A debuff for testing") then
			Result(testSetName, runNum, 2, FAILED, "Incorrest details: " .. (buffDetails or "nil"));
		elseif not (buffIcon == "Interface\\Icons\\INV_ValentinesBoxOfChocolates01") then
			Result(testSetName, runNum, 2, FAILED, "Incorrest icon: " .. (buffIcon or "nil"));
		elseif not (untilCanceled == true) then
			Result(testSetName, runNum, 2, FAILED, "Incorrest untilCanceled");
		elseif not (filter == "Harmful") then
			Result(testSetName, runNum, 2, FAILED, "Incorrest filter: " .. (filter or "nil"));
		elseif not (buffType == "Poison") then
			Result(testSetName, runNum, 2, FAILED, "Incorrest type: " .. (buffType or "nil"));
		elseif not (buffDuration == 600) then
			Result(testSetName, runNum, 2, FAILED, "Incorrest duration: " .. (buffDuration or "nil"));
		elseif not (cancelable == false) then
			Result(testSetName, runNum, 2, FAILED, "Incorrest cancelable");
		elseif not (stackable == true) then
			Result(testSetName, runNum, 2, FAILED, "Incorrest stackable");
		elseif not (count == 4) then
			Result(testSetName, runNum, 2, FAILED, "Incorrest count: " .. (count or "nil"));
		elseif not (delay == 3) then
			Result(testSetName, runNum, 2, FAILED, "Incorrest delay: " .. (delay or "nil"));
		elseif not (range == 10) then
			Result(testSetName, runNum, 2, FAILED, "Incorrest range: " .. (range or "nil"));
		elseif not (alwaysCastOnSelf == false) then
			Result(testSetName, runNum, 2, FAILED, "Incorrest alwaysCastOnSelf");
		else
			Result(testSetName, runNum, 2, PASSED);
		end
	end)
	action.Execute(env);
end);

GHI_RegisterTest("ExecuteV11_EquipItem", function(testSetName, runNum)
	local action = GHI_SimpleAction({
		["type_name"] = "Equip Item",
		["Type"] = "equip_item",
		["marked"] = false,
		["icon"] = "Interface\\Icons\\INV_Helmet_03",
		["item_name"] = "Darnassus Tabard",
		["details"] = "Darnassus Tabard",
		["delay"] = 2,
		["req"] = 1,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	Result(testSetName, runNum, 1, PENDING);
	local castTime = GetTime();
	env.SetValue("EquipItemByName", function(n)
		if n == "Darnassus Tabard" then
			local elapsed = GetTime() - castTime;
			if elapsed > 1 and elapsed < 3 then
				Result(testSetName, runNum, 1, PASSED);
			else
				Result(testSetName, runNum, 1, FAILED, "Incorrest delay: " .. (elapsed or 0) .. " sec");
			end
		else
			Result(testSetName, runNum, 1, FAILED, "Incorrest string: " .. (n or "nil"));
		end
	end)
	action.Execute(env);
end);

GHI_RegisterTest("ExecuteV11_Expression", function(testSetName, runNum)
	local action = GHI_SimpleAction({
		["Type"] = "expression",
		["details"] = "Say: I Test!",
		["text"] = "I Test!",
		["marked"] = false,
		["type_name"] = "Expression",
		["expression_type"] = "Say",
		["expression_type_i"] = 1,
		["icon"] = "Interface\\Icons\\Spell_Shadow_SoothingKiss",
		["req"] = 1,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	env.SetValue("GHI_Say", function(text, delay)
		if text == "I Test!" then
			if delay == 0 or delay == nil then
				Result(testSetName, runNum, 1, PASSED);
			else
				Result(testSetName, runNum, 1, FAILED, "Incorrest delay: " .. (delay or 0) .. " sec");
			end
		else
			Result(testSetName, runNum, 1, FAILED, "Incorrest string: " .. (text or "nil"));
		end
	end)
	action.Execute(env);

	local action = GHI_SimpleAction({
		["Type"] = "expression",
		["details"] = "Say: I Test 2!",
		["text"] = "I Test! 2",
		["marked"] = false,
		["type_name"] = "Expression",
		["expression_type"] = "Say",
		["expression_type_i"] = 1,
		["icon"] = "Interface\\Icons\\Spell_Shadow_SoothingKiss",
		["req"] = 1,
		["delay"] = 3,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	env.SetValue("GHI_Say", function(text, delay)
		if text == "I Test! 2" then
			if delay == 3 then
				Result(testSetName, runNum, 2, PASSED);
			else
				Result(testSetName, runNum, 2, FAILED, "Incorrest delay: " .. (delay or 0) .. " sec");
			end
		else
			Result(testSetName, runNum, 2, FAILED, "Incorrest string: " .. (text or "nil"));
		end
	end)
	action.Execute(env);

	local action = GHI_SimpleAction({
		["Type"] = "expression",
		["details"] = "Emote: is testing",
		["text"] = "is testing",
		["marked"] = false,
		["type_name"] = "Expression",
		["expression_type"] = "Emote",
		["expression_type_i"] = 2,
		["icon"] = "Interface\\Icons\\Spell_Shadow_SoothingKiss",
		["req"] = 1,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	env.SetValue("GHI_Emote", function(text, delay)
		if text == "is testing" then
			if delay == 0 or delay == nil then
				Result(testSetName, runNum, 3, PASSED);
			else
				Result(testSetName, runNum, 3, FAILED, "Incorrest delay: " .. (delay or 0) .. " sec");
			end
		else
			Result(testSetName, runNum, 3, FAILED, "Incorrest string: " .. (text or "nil"));
		end
	end)
	action.Execute(env);

	local action = GHI_SimpleAction({
		["Type"] = "expression",
		["details"] = "Emote: is testing",
		["text"] = "is testing",
		["marked"] = false,
		["type_name"] = "Expression",
		["expression_type"] = "Emote",
		["expression_type_i"] = 2,
		["icon"] = "Interface\\Icons\\Spell_Shadow_SoothingKiss",
		["req"] = 1,
		["delay"] = 4,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	env.SetValue("GHI_Emote", function(text, delay)
		if text == "is testing" then
			if delay == 4 then
				Result(testSetName, runNum, 4, PASSED);
			else
				Result(testSetName, runNum, 4, FAILED, "Incorrest delay: " .. (delay or 0) .. " sec");
			end
		else
			Result(testSetName, runNum, 4, FAILED, "Incorrest string: " .. (text or "nil"));
		end
	end)
	action.Execute(env);
end);

GHI_RegisterTest("ExecuteV11_RandomExpression", function(testSetName, runNum)
	local action = GHI_SimpleAction({
		["Type"] = "random_expression",
		["details"] = "6 Expressions.",
		["text"] = {
			"Test 1", -- [1]
			"Test 2", -- [2]
			"Test 3", -- [3]
			"Test 4", -- [4]
			"Test 5", -- [5]
			"Test 6", -- [6]
		},
		["marked"] = false,
		["type_name"] = "Random Expression",
		["expression_type"] = {
			"Say", -- [1]
			"Say", -- [2]
			"Say", -- [3]
			"Say", -- [4]
			"Say", -- [5]
			"Say", -- [6]
		},
		["expression_type_i"] = {
			1, -- [1]
			1, -- [2]
			1, -- [3]
			1, -- [4]
			1, -- [5]
			1, -- [6]
		},
		["icon"] = "Interface\\Icons\\Ability_Warrior_RallyingCry",
		["req"] = 1,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	env.SetValue("GHI_Say", function(text, delay)
		if string.sub(text, 1, 5) == "Test " then
			if delay == 0 or delay == nil then
				Result(testSetName, runNum, 1, PASSED);
			else
				Result(testSetName, runNum, 1, FAILED, "Incorrest delay: " .. (delay or 0) .. " sec");
			end
		else
			Result(testSetName, runNum, 1, FAILED, "Incorrest string: " .. (text or "nil"));
		end
	end)
	action.Execute(env);

	local allowTestFailed;
	local last = "";
	env.SetValue("GHI_Say", function(text, delay)
		allowTestFailed = allowTestFailed or 1;
		if text == last then
			allowTestFailed = 2;
			Result(testSetName, runNum, 2, FAILED, "Same input was repeated");
		end
		last = text;
	end);

	for i = 1, 50 do
		action.Execute(env);
	end
	if allowTestFailed == 1 then
		Result(testSetName, runNum, 2, PASSED);
	elseif allowTestFailed == 2 then
		Result(testSetName, runNum, 2, FAILED, "Repeating occured");
	else
		Result(testSetName, runNum, 2, FAILED, "No run");
	end

	local action = GHI_SimpleAction({
		["Type"] = "random_expression",
		["details"] = "6 Expressions.",
		["text"] = {
			"Test 1", -- [1]
			"Test 2", -- [2]
			"Test 3", -- [3]
			"Test 4", -- [4]
			"Test 5", -- [5]
			"Test 6", -- [6]
		},
		["marked"] = false,
		["type_name"] = "Random Expression",
		["expression_type"] = {
			"Say", -- [1]
			"Emote", -- [2]
			"Say", -- [3]
			"Emote", -- [4]
			"Say", -- [5]
			"Say", -- [6]
		},
		["expression_type_i"] = {
			1, -- [1]
			1, -- [2]
			1, -- [3]
			1, -- [4]
			1, -- [5]
			1, -- [6]
		},
		["icon"] = "Interface\\Icons\\Ability_Warrior_RallyingCry",
		["req"] = 1,
		["allow_same"] = true,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	env.SetValue("GHI_Say", function(text, delay)
		if string.sub(text, 1, 5) == "Test " then
			if delay == 0 or delay == nil then
				Result(testSetName, runNum, 3, PASSED);
			else
				Result(testSetName, runNum, 3, FAILED, "Incorrest delay: " .. (delay or 0) .. " sec");
			end
		else
			Result(testSetName, runNum, 3, FAILED, "Incorrest string: " .. (text or "nil"));
		end
	end)
	env.SetValue("GHI_Emote", function(text, delay)
		if string.sub(text, 1, 5) == "Test " then
			if delay == 0 or delay == nil then
				Result(testSetName, runNum, 3, PASSED);
			else
				Result(testSetName, runNum, 3, FAILED, "Incorrest delay: " .. (delay or 0) .. " sec");
			end
		else
			Result(testSetName, runNum, 3, FAILED, "Incorrest string: " .. (text or "nil"));
		end
	end)
	action.Execute(env);
end);

GHI_RegisterTest("ExecuteV11_Book", function(testSetName, runNum)
	local action = GHI_SimpleAction({
		{
			["text4"] = "",
			["text5"] = "",
			["text3"] = "",
			["text9"] = "",
			["text6"] = "",
			["text2"] = "test",
			["text8"] = "",
			["text10"] = "",
			["text1"] = "<HTML><BODY><P>Test</P></BODY></HTML>",
			["text7"] = "",
		}, -- [1]
		{
			["text4"] = "",
			["text5"] = "",
			["text3"] = "",
			["text9"] = "",
			["text6"] = "",
			["text2"] = "",
			["text8"] = "",
			["text10"] = "",
			["text1"] = "<HTML><BODY><P>Page 2</P></BODY></HTML>",
			["text7"] = "",
		},
		["Type"] = "book",
		["details"] = "",
		["req"] = 1,
		["h1"] = 24,
		["type_name"] = "Book",
		["font"] = "Fonts\\MORPHEUS.TTF",
		["title"] = "Title of the book",
		["icon"] = "Interface\\Icons\\INV_Misc_Book_09",
		["h2"] = 19,
		["material"] = "Parchment",
		["pages"] = 1,
		["n"] = 15,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	local castTime = GetTime();
	env.SetValue("GHI_ShowBook", function(title, pages, material, font, normalSize, h1Size, h2Size)
		if not (title == "Title of the book") then
			Result(testSetName, runNum, 1, FAILED, "Incorrect title: " .. (title or "nil"));
		elseif not (type(pages) == "table") then
			Result(testSetName, runNum, 1, FAILED, "Incorrect page format " .. type(pages));
		elseif not (#(pages) == 2) then
			Result(testSetName, runNum, 1, FAILED, "Incorrect page number " .. #(pages));
		elseif not (pages[1] == "<HTML><BODY><P>Test</P></BODY></HTML>test") then
			Result(testSetName, runNum, 1, FAILED, "Incorrect page 1 content " .. (pages[1] or "nil"));
		elseif not (pages[2] == "<HTML><BODY><P>Page 2</P></BODY></HTML>") then
			Result(testSetName, runNum, 1, FAILED, "Incorrect page 2 content " .. (pages[2] or "nil"));
		elseif not (material == "Parchment") then
			Result(testSetName, runNum, 1, FAILED, "Incorrect material: " .. (material or "nil"));
		elseif not (font == "Fonts\\MORPHEUS.TTF") then
			Result(testSetName, runNum, 1, FAILED, "Incorrect font: " .. (font or "nil"));
		elseif not (normalSize == 15) then
			Result(testSetName, runNum, 1, FAILED, "Incorrect normal size: " .. (normalSize or "nil"));
		elseif not (h1Size == 24) then
			Result(testSetName, runNum, 1, FAILED, "Incorrect h1 size: " .. (h1Size or "nil"));
		elseif not (h2Size == 19) then
			Result(testSetName, runNum, 1, FAILED, "Incorrect h2 size: " .. (h2Size or "nil"));
		else
			Result(testSetName, runNum, 1, PASSED);
		end
	end)
	action.Execute(env);
end);

GHI_RegisterTest("ExecuteV11_Sound", function(testSetName, runNum)
	local action = GHI_SimpleAction({
		["type_name"] = "Sound",
		["Type"] = "sound",
		["marked"] = true,
		["details"] = "...Murloc\\mMurlocAggroOld.wav",
		["icon"] = "Interface\\Icons\\INV_Misc_Drum_01",
		["sound_path"] = "Sound\\Creature\\Murloc\\mMurlocAggroOld.wav",
		["req"] = 1,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	env.SetValue("GHI_PlaySound", function(path, delay)
		if not (path == "Sound\\Creature\\Murloc\\mMurlocAggroOld.wav") then
			Result(testSetName, runNum, 1, FAILED, "Incorrest path: " .. (path or "nil"));
		elseif not (delay == 0) then
			Result(testSetName, runNum, 1, FAILED, "Incorrest delay: " .. (delay or "nil"));
		else
			Result(testSetName, runNum, 1, PASSED);
		end
	end)
	action.Execute(env);

	local action = GHI_SimpleAction({
		["type_name"] = "Sound",
		["Type"] = "sound",
		["marked"] = true,
		["details"] = "...Murloc\\mMurlocAggroOld.wav",
		["icon"] = "Interface\\Icons\\INV_Misc_Drum_01",
		["sound_path"] = "Sound\\Creature\\Murloc\\mMurlocAggroOld.wav",
		["delay"] = 5,
		["range"] = 10,
		["req"] = 1,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	env.SetValue("GHI_PlayAreaSound", function(path, range, delay)
		if not (path == "Sound\\Creature\\Murloc\\mMurlocAggroOld.wav") then
			Result(testSetName, runNum, 2, FAILED, "Incorrest path: " .. (path or "nil"));
		elseif not (delay == 5) then
			Result(testSetName, runNum, 2, FAILED, "Incorrest delay: " .. (delay or "nil"));
		elseif not (range == 10) then
			Result(testSetName, runNum, 2, FAILED, "Incorrest range: " .. (range or "nil"));
		else
			Result(testSetName, runNum, 2, PASSED);
		end
	end)
	action.Execute(env);
end);


GHI_RegisterTest("ExecuteV11_ProduceItem", function(testSetName, runNum)
	local action = GHI_SimpleAction({
		["item_data"] = {
			["stackSize"] = 20,
			["white2"] = "",
			["rightClicktext"] = "",
			["comment"] = "Nom nom!",
			["version"] = 1,
			["white1"] = "Nom",
			["name"] = "Cookie",
			["creater"] = "Iruviel",
			["locked"] = 0,
			["icon"] = "Interface\\Icons\\INV_ValentinesChocolate01",
			["quality"] = 3,
		},
		["Type"] = "script",
		["loot_text"] = "Loot",
		["details"] = "1 of Cookie",
		["dynamic_rc"] = true,
		["id"] = "Iruviel_114044072",
		["type_name"] = "Produce Item",
		["code"] = {
			"local ID = \"ITEM_ID\"; if not(ID) then GHI_Message(\"Could not identify source ID\"); return; end; local info = GHI_GetRightClickInfo(ID); local t={}; if type(info) == \"table\" then for i=1,#(info) do if info[i].id == \"Iruviel_114044072\"  and info[i].dynamic_rc_type == \"produce_item\" then t=info[i]; end end end UpdateItemInfo(t.id,t[\"item_data\"]);  if GHI_ProduceItem(\"Iruviel_114044072\",1) then GHI_Message(\"You recieve loot: \"..(GHI_GenerateLink(\"Iruviel_114044072\") or \"unknown\")..\".\"); end", -- [1]
		},
		["dynamic_rc_type"] = "produce_item",
		["amount"] = 2,
		["autoUpdateVersion"] = 1,
		["loot_text_i"] = 1,
		["icon"] = "Interface\\Icons\\Spell_ChargePositive",
		["req"] = 1,
	});

	local env = GHI_ScriptEnviroment(testSetName);
	local correctID, correctAmount, correctMsg;
	env.SetValue("GHI_ProduceItem", function(guid, amount)
		if guid == "Iruviel_114044072" then correctID = true; end
		if amount == 2 then correctAmount = true; end
		return true;
	end)

	env.SetValue("GHI_Message", function(msg)
		if (string.find(msg, "Cookie") or 0) > 0 then
			correctMsg = true;
		end
	end)

	env.SetValue("GHI_GenerateLink", function(guid)
		return "[Cookie]"
	end)

	action.Execute(env);

	local item = GHI_ItemInfoList().GetItemInfo("Iruviel_114044072");
	if not (item) then
		Result(testSetName, runNum, 1, FAILED, "Item not saved");
	elseif not (item.GetItemInfo() == "Cookie") then
		Result(testSetName, runNum, 1, FAILED, "Incorrest saved name");
	elseif not (correctID) then
		Result(testSetName, runNum, 1, FAILED, "Incorrest ID");
	elseif not (correctAmount) then
		Result(testSetName, runNum, 1, FAILED, "Incorrest amount");
	elseif not (correctMsg) then
		Result(testSetName, runNum, 1, FAILED, "Incorrest msg");
	else
		Result(testSetName, runNum, 1, PASSED);
	end
end);

