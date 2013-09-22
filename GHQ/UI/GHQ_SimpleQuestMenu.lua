--===================================================
--
--				GHQ_SimpleQuestMenu
--  			GHQ_SimpleQuestMenu.lua
--
--	  Simple Quest Creation UI
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
---Mockup to be refined

local UnitName = UnitName;
local UnitGUID = UnitGUID;
local loc = GHI_Loc()

function GHQ_SimpleQuestMenu()
	local class = GHClass("GHQ_SimpleQuestMenu")
	
	local inUse = false;
	local edit, menuFrame, quest
	local questList = GHQ_QuestList()
	local guidCreator = GHI_GUID();
	local miscApi = GHI_MiscAPI().GetAPI();
	local simpQuestWinCount = 1
			
	local UpdateMenu = function()
		local questAuthor, questGUID, questTitle = quest.GetQuestInfo()
		local logEntry, logMat, logFont, titleFont = quest.GetLogInfo()

		menuFrame.ForceLabel("questTitle", questTitle or "")
		menuFrame.ForceLabel("questLogEntry",logEntry or "")
		menuFrame.ForceLabel("logMaterial",logMat or "Parchment")
		menuFrame.ForceLabel("logFont",logFont or "Frizqt")
		menuFrame.ForceLabel("logTitleFont", titleFont or "Morpheus")
		local mini, maxi = 1, 90
		
		for i=1, quest.GetNumRequirements() do
			if quest.GetRequirementType(i) == "Level" then
				local details = quest.GetRequirementDetails(i, true)
				mini = details["LevelMin"] or 1
				maxi = details["LevelMax"] or GetMaxPlayerLevel()
			end
		end
		menuFrame.ForceLabel("levelRange", string.format("%s-%s",mini,maxi))
	end
		
	local SetupWithNewQuest = function()
		inUse = true;
		edit = false;
		quest = GHQ_QuestInfo({
			author = UnitName("player"),
			authorGUID = UnitGUID("player"),
			GUID = guidCreator.MakeGUID()
		});
		UpdateMenu()
	end
		
	local SetupWithEditQuest = function(guid)
		inUse = true;
		edit = true;
		
		UpdateMenu()	
	end
	
	local objectivePick, rewardList
	
	local OnOk = function()
		local logMat = menuFrame.GetLabel("logMaterial")
		local logFont = menuFrame.GetLabel("logFont")
		local questTitle = menuFrame.GetLabel("questTitle")
		local titleFont = menuFrame.GetLabel("logTitleFont")
		local logEntry = menuFrame.GetLabel("questLogEntry")
				
		quest.SetLogMaterial(logMat);
		quest.SetLogFont(logFont);
		quest.SetTitle(questTitle);
		quest.SetTitleFont(titleFont);
		quest.SetLogEntry(logEntry);
		
		local range = menuFrame.GetLabel("levelRange")
		
		local mini, maxi = 1, GetMaxPlayerLevel()
		if strlen(range) >= 1 and strfind(range,"\-") then
			mini,maxi = strsplit("\-",range)
		elseif not (strfind(range,"\-")) then
			mini = range
		end
		
		local levReqExists = false
		if quest.GetNumRequirements() > 0 then
			for i=1, quest.GetNumRequirements() do
				if quest.GetRequirementType(i) == "Level" then
					 quest.SetRequirementDetails(i, {
						["LevelMin"] = tonumber(mini),
						["LevelMax"] = tonumber(maxi),
					})
					levReqExists = true
				end
			end
		end
		if levReqExists == false then
			quest.AddRequirement("Level", {
				["LevelMin"] = tonumber(mini),
				["LevelMax"] = tonumber(maxi),
			})
		end
		quest.IncreaseQuestVersion();
		questList.AddQuest(quest);
		GHQ_UpdateQuestList()
		menuFrame:Hide();
	end--
	
	local killPage =   {
	  {
		{
		  type = "Text",
		  text = "Kill this many of this creature:",
		  align = "l",
		  fontSize = 14,
		},
	  },
	  {
		{
		  type = "Editbox",
		  text = "Kill Count:",
		  align = "l",
		  label = "killCount",
		  texture = "Tooltip",
		  tooltip = "How many to kill.",
		  width = 80,
		},
		{
		  type = "Editbox",
		  text = "Kill Creature:",
		  align = "l",
		  label = "killCreature",
		  tooltip = "Name of creature to kill.",
		  texture = "Tooltip",
		  width = 200,
		},
		{
		  type = "Editbox",
		  text = "Zone:",
		  align = "l",
		  label = "killZone",
		  tooltip = "What zone the creature is found in. Leave blank for any zone.",
		  texture = "Tooltip",
		  width = 200,      
		},
	  },
	}

	local goPage =   {
	  {
		{
		  type = "Text",
		  text = "Go Somewhere",
		  align = "l",
		  fontSize = 14,
		},
	  },
	  {
		 {
		  type = "Editbox",
		  text = "Got to Zone:",
		  align = "l",
		  label = "gotoZone",
		  tooltip = "Enter this Zone.",
		  texture = "Tooltip",
		  width = 200,                   
		},
		{
		  type = "Editbox",
		  text = "Got to Sub-Zone:",
		  align = "l",
		  label = "gotoSubZone",
		  tooltip = "Enter this Sub Zone. Leave bank for Zone only.",
		  texture = "Tooltip",
		  width = 200,                   
		},
	  },
	}

	local activatePage = function(actionChosen)
	  local pageCount = 2
	  local i = 1
	  while i <= pageCount do
		local pageToDeactivate = _G[menuFrame:GetName().."_P"..(i+2)]
		pageToDeactivate.active = false
		i = i+1
	  end
	  local pageToActivate = _G[menuFrame:GetName().."_P"..(actionChosen+2)]
	  pageToActivate.active = true
	  objectivePick = actionChosen
	  menuFrame.UpdatePages()
	end

	local EditMarkedReward = function()
	  local marked = rewardList.GetMarked();
	  if marked then
		local t = rewardList.GetTuble(marked);
		local reward = t.reward;
		if reward then
		  print(t.reward)
		end
	  end
	end


	pickQuestPage = {
	  {
		
		{
		  type = "Text",
		  text = "Choose Quest Objective:",
		  align = "l",
		  fontSize = 14,
		},
	  },
	  {
		{
		  type = "ItemButtonSet",
		  align = "l",
		  label = "objectiveChoice",
		  returnIndex = true,
		  OnSelect = activatePage,
		  data = {
			{
			  icon = "Interface\\Icons\\Spell_DeathKnight_Butcher",
			  name = "Kill X Creatures",
			  tooltip = "The player must kill a specified amount of creatures to complete this objective.",
			},
			{
			  icon = "Interface\\Icons\\INV_Misc_Map_01",
			  name = "Go to Subzone",
			  tooltip = "The player must go to a specified subzone int eh game world to complete this objective.",
			},
		  },                
		},
		
	  },
	}

	local lootTypes = {"GHI Item", "GHI Buff", "New GHI Item"}

	local lootPage = {
	  {
		{
		  type = "Text",
		  text = "Quest Rewards",
		  align = "l",
		  fontSize = 14,
		},
	  },
	  {
		{
		  type = "Button",
		  text = "Edit Selected Reward",
		  align = "l",
		  label = "button",
		  compact = true,
		  OnClick = function(self)
			-- Code Here
		  end,
		  
		},
		{
		  type = "DropDown",
		  width = 150,
		  label = "pickRewardType",
		  align = "r",
		  text = "Add Reward Type:",
		  data =  lootTypes,
		  --OnSelect = function(i) print(lootTypes[i]) end,
		  returnIndex = false,
		}, 
	  },
	  {
		{
		  type = "List",
		  lines = 10,
		  align = "l",
		  label = "rewards",
		  column = {
			{
			  type = "Icon",
			  catagory = "",
			  width = 48,
			  label = "icon",
			},
			{
			  type = "Text",
			  catagory = "Reward Type",
			  width = 420,
			  label = "rewardType",
			},
		  },
		  OnLoad = function(obj)
			obj:SetBackdropColor(0, 0, 0, 0.5);
		  end,
		},
	  }
	}

	local t = {  
	  {
		{
		  {
			type = "Editbox",
			text = "Quest Title:",
			align = "l",
			label = "questTitle",
			texture = "Tooltip",
			tooltip = "Title of the quest, displayed in log.",
			width = 350,
		  },
		},
		{
		  {
			type = "Editbox",
			text = "Level Range:",
			align = "l",
			label = "levelRange",
			texture = "Tooltip",
			tooltip = "Level range, seperated with a \"-\" ",
			width = 80,
		  },		  
		  {
			type = "CustomDD",
			texture = "Tooltip",
			width = 120,
			label = "logFont",
			align = "r",
			text = "Log Font:",
			data = {
			  "Morpheus",
			  "Frizqt",
			  "Arialn",
			  "Skurri",
			},
			returnIndex = false,
		  }, 
		  {
			type = "CustomDD",
			texture = "Tooltip",
			width = 120,
			label = "logTitleFont",
			align = "r",
			text = "Log Title Font:",
			data = {
			  "Morpheus",
			  "Frizqt",
			  "Arialn",
			  "Skurri",
			},
			returnIndex = false,
		  }, 
		  {
			type = "CustomDD",
			texture = "Tooltip",
			width = 120,
			label = "logMaterial",
			align = "r",
			text = "Log Material:",
			data = {
			  loc.PARCHMENT,
			  loc.BRONZE,
			  loc.MARBLE,
			  loc.SILVER,
			  loc.STONE,
			  loc.VALENTINE
			},
			returnIndex = false,
		  }, 
		},
		{
		  {
			type = "EditField",
			text = "Quest Description:",
			align = "l",
			label = "questLogEntry",
			texture = "Tooltip",
			tooltip = "Quest Description displayed in log.",
			width = 500,
			height = 240,
			yOff = -10,
		  },
		},
	  },
		background = "Interface\\EncounterJournal\\UI-EJ-JournalBG",
		title = "Quest Creation",
		name = "GHQ_Simple_Quest_Menu_"..simpQuestWinCount,
		theme = "BlankWizardTheme",
		height = 420,
		width = 500,
		useWindow = true,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	}
	t.OnOk = OnOk

	table.insert(t,2,pickQuestPage)
	table.insert(t,3,killPage)
	table.insert(t,4,goPage)
	table.insert(t,5,lootPage)


	menuFrame = GHM_NewFrame(class, t);--"SimpleQuestCreation"
	
	while _G["GHQ_Simple_Quest_Menu" .. simpQuestWinCount] do simpQuestWinCount = simpQuestWinCount + 1; end;

	rewardList = menuFrame.GetLabelFrame("rewards")

	page3 = _G[menuFrame:GetName().."_P4"]
	page4 = _G[menuFrame:GetName().."_P3"]
	page2 = _G[menuFrame:GetName().."_P2"]
	page5 = _G[menuFrame:GetName().."_P5"]

	page2.active = true
	page3.active = false
	page4.active = false
	page5.active = true
	menuFrame.UpdatePages()

	--menuFrame.Hide()
	
	class.IsInUse = function()
		return inUse and menuFrame.window:IsShown()
	end
	
	class.GetQuestGuid = function()
		return quest.GetGUID();
	end
	
	class.New = function()
		SetupWithNewQuest();
		menuFrame:AnimatedShow();
		menuFrame.SetPage(1);
	end

	class.Edit = function(guid)
		local editQuest = questList.GetQuestInfo(guid);
		
		if not (editQuest.IsCreatedByPlayer()) then
			GHI_Message("You do not have permission to edit this quest.");
			menuFrame:Hide();
			return
		end
		
		quest = editQuest.CloneQuest();
		
		SetupWithEditQuest();
		
		menuFrame:AnimatedShow();
		menuFrame.SetPage(1);
	end
	
	return class;
end