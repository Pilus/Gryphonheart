--
--
--				GHQ_QuestLogUI
--  			GHQ_QuestLogUI.lua
--
--		Functions used by the main quest log UI
--
-- 		  (c)2013 The Gryphonheart Team
--				All rights reserved
--

local questList, questListFrame, listFrame
local questDisplay, questDisplayFrame
local activeQuests

local function GHQ_CreateQuestListFrame()
	local ghqQuestList = GHQ_QuestList()
	local class = GHClass("GHQ_QuestLogList")
	questList ={
		{
			{
				{
				  type = "List",
				  lines = 18,
				  align = "l",
				  label = "quests",
				  column = {
					{
					  type = "Text",
					  catagory = "Title",
					  width = 302,
					  label = "title",
					  align = "left",
					},
				  },
				  OnLoad = function(obj)
				  end,
				  OnMarked = function(marked)
					local t = listFrame.GetTuble(marked);
					local quest = ghqQuestList.GetQuestInfo(t.guid)
					
					local _,_,title = quest.GetQuestInfo()
					local logEntry, logMat, logFont, titleFont = quest.GetLogInfo()	
					questDisplayFrame.ForceLabel("questTitle",title)
					questDisplayFrame.ForceLabel("questText",logEntry)
					
					local numObjectives = quest.GetNumObjectives()
					--ojectives are sorted by number
					--will need to change the infoAPI to do this better.and expand info saved
					local objString ="";
					--local objt =  quest.GetObjective(1)
						--print(numObjectives)
					--for i=0,numObjectives do
					--	local objt =  quest.GetObjective(i)
					--	print(objt.Details)
					--	objString = objString .. objt.Progress.." "..objt.Details.."/n"
					--end
					
				  end,
				},
			}
		},
		title = "",
		name = "GHQ_Quest_List",
		theme = "BlankTheme",
		width = 64,
		useWindow = false,
		OnHide = function()
		end,
	}
	
	questListFrame = GHM_NewFrame(class, questList)
	listFrame = questListFrame.GetLabelFrame("quests")
	listFrame:SetBackdrop(nil)
	questListFrame:SetParent(_G["GHQ_QuestLogFrame"])
	questListFrame:SetPoint("TOPLEFT",questListFrame:GetParent(),"TOPLEFT",-8,-52)
	questListFrame:Show()
	
end

local function GHQ_CreateQuestDisplayFrame()
	local class = GHClass("GHQ_QuestLogDisplay")
	questDisplay = {
		{
			{
				{
					type = "Text",
					text = "",--Quest Title",
					align = "l",
					label = "questTitle",
					fontSize = 18,
					font = "Morpheus",
					color = "white",
					shadow = true,
					outline = true,
					width = 290,
				},
			},
			{
				{
					type = "Text",
					text = "",--"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam enim sapien, cursus vel vestibulum sit amet, feugiat a est. Vivamus rutrum tincidunt ligula, et interdum leo congue condimentum.\n\nPellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Fusce lacinia erat ut enim iaculis elementum. In hac habitasse platea dictumst.\n\nCurabitur lacinia enim ut magna viverra id gravida risus fringilla. Vivamus faucibus dictum tellus, nec faucibus augue scelerisque eu.",
					align = "l",
					label = "questText",
					color = "black",
					fontSize = 13,
					width = 290,
				},
			},
			{
				{
					type = "Text",
					text = "Objectives:",
					align = "l",
					fontSize = 18,
					label = "objectivesTitle",
					font = "Morpheus",
					color = "white",
					shadow = true,
					outline = true,
					width = 290,
				},
			},
			{
				{
					type = "Text",
					text = "",--" - 1/0  Lorem ipsum dolor sit amet.\n - 1/0  Nullam enim sapien, cursus vel.    ",
					align = "l",
					label = "objectives",
					color = "black",
					fontSize = 13,
					width = 290,
				},
			},
			{
				{
					type = "Text",
					text = "Rewards:",
					align = "l",
					fontSize = 18,
					label = "rewardsTitle",
					font = "Morpheus",
					color = "white",
					shadow = true,
					outline = true,
					width = 290,
				},
			},
			{
				{
					type = "Text",
					text = "You will be able to choose one of these rewards:",
					align = "l",
					label = "mayChoose",
					color = "black",
					fontSize = 13,
					width = 290,
				},
			},
			{
				{
				  type = "ItemButtonSet",
				  align = "l",
				  label = "chooseableLoot",
				  returnIndex = true,
				  OnSelect = activatePage,
				  data = {
					{
					  icon = "Interface\\Icons\\INV_Misc_QuestionMark",
					  name = "Chooseable Loot 1",
					  tooltip = "This loot may be chosen.",
					},
					{
					  icon = "Interface\\Icons\\INV_Misc_QuestionMark",
					  name = "Chooseable Loot 2",
					  tooltip = "This loot may be chosen.",
					},
					{
					  icon = "Interface\\Icons\\INV_Misc_QuestionMark",
					  name = "Chooseable Loot 3",
					  tooltip = "This loot may be chosen.",
					},
					{
					  icon = "Interface\\Icons\\INV_Misc_QuestionMark",
					  name = "Chooseable Loot 4",
					  tooltip = "This loot may be chosen.",
					},
				  },                
				},
			},
			{
				{
					type = "Text",
					text = "You will receive: ",
					align = "l",
					label = "willReceive",
					color = "black",
					fontSize = 13,
					width = 290,
				},
			},
			{
				{
				  type = "ItemButtonSet",
				  align = "l",
				  label = "autoLoot",
				  returnIndex = true,
				  OnSelect = activatePage,
				  data = {
					{
					  icon = "Interface\\Icons\\INV_Misc_QuestionMark",
					  name = "Auto Loot 1",
					  tooltip = "This loot is automatically given.",
					},
					{
					  icon = "Interface\\Icons\\INV_Misc_QuestionMark",
					  name = "Auto Loot 2",
					  tooltip = "This loot is automatically given.",
					},
				  },                
				},
			},
		},
		title = "",
		name = "GHQ_Quest_Display",
		theme = "BlankTheme",
		width = 298,
		height = 403,
		useWindow = false,
		OnHide = function()
		end,
	}
	questDisplayFrame = GHM_NewFrame(class, questDisplay)
	local logDisplayScroll = _G["GHQ_QuestLogFrameDetailScrollFrame"]
	questDisplayFrame:SetPoint("TOPLEFT",logDisplayScroll,"TOPLEFT",0,0)
	logDisplayScroll:SetScrollChild(questDisplayFrame)
	logDisplayScroll:UpdateScrollChildRect()
	questDisplayFrame:Show()
end

GHQ_UpdateQuestList = function()
		activeQuests = GHQ_QuestList().GetActiveQuestList()
		for i = 1, #activeQuests do
			local title, guid = activeQuests[i].Title, activeQuests[i].GUID
			local existsAlready = false;
			for j = 1, listFrame.GetTubleCount() do
				local t = listFrame.GetTuble(j);
				
				if guid == t.guid then
					t.title = title;
					t.guid = guid;
					existsAlready = true;
					break;
				end
			end

			if existsAlready == false then
				--print("Exists already = false")
				local t = { guid = guid, title = title};
				listFrame.SetTuble(listFrame.GetTubleCount() + 1, t)
			end
		end

		-- delete all that doesn't exist
		local total = listFrame.GetTubleCount();
		local newData = {};
		for j = 1, total do
			local t = listFrame.GetTuble(j);
			for i = 1, #activeQuests do
				if t.guid == activeQuests[i].GUID then
					--print("New data loop: t.guid: "..t.guid)
					--print("New data loop: activeQuests[i].GUID: "..activeQuests[i].GUID)
					table.insert(newData, t);
					break;
				end
			end
		end
		--print("New Data")
		--print("Total count in new data table:"..#newData)
		--[[for i,v in pairs(newData) do
			if type(v) == "table" then
				print(i)
				for i2,v2 in pairs(v) do
					print("V2,i2")
					print(i2, v2)
					print("---")
				end
			else
				print(i,v)
			end
		end]]--	
		listFrame.data = newData;
		listFrame.UpdateAll()
		questListFrame.SetLabel(listFrame.label, listFrame.data);
end

GHQ_EditMarkedQuest = function()
	local marked = listFrame.GetMarked();
	if marked then
		local t = listFrame.GetTuble(marked);
		local guid = t.guid;
		local questList = GHQ_QuestList()
		local quest = questList.GetQuestInfo(guid)
		local simpleMenuList = GHQ_SimpleQuestMenuList()
		
		if quest.GetAuthorGUID() == GHUnitGUID("player") then
			simpleMenuList.Edit(guid)
		else
			print("You do not have permission to edit this quest.")
		end
	end
end

GHQ_CreateSimpleQuest = function()
	local simpleMenuList = GHQ_SimpleQuestMenuList()
	simpleMenuList.New()
end

GHI_Event("VARIABLES_LOADED", function()
		GHQ_CreateQuestDisplayFrame()
		GHQ_CreateQuestListFrame()
		GHQ_UpdateQuestList()
end);