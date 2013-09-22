--===================================================
--
--				GHQ_AdvancedQuestMenu
--				GHQ_AdvancedQuestMenu.lua
--
--	  Simple Quest Creation UI
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
---Mockup to be refined
local class;
function GHQ_AdvancedQuestMenu(info)

	if class then
		return class;
	end
	class = GHClass("GHQ_AdvancedQuestMenu");
     --local api = {};
	local guidCreator = GHI_GUID();
     ---CreateNewQuest
     ---Args:
     ---Name --NAme/Title of Quest
     ---GUID --GUID of quest
     ---Author -- Who made the quest
     ---Objectives --Table, All objectives should have a GUID(or number) to diffreniate themselves
	 --logentry --number, entry in the log
	 --rewards --table, quest rewards
     ---Future version:QuestType
	 
     class.CreateNewQuest = function(name,author,guid,requirements,rewards,objective,logentry)
		local t = {
			name = name,
			author = author, --UnitName("player")
			guid = guid, 
			requuirements = requirements,
			objective = objective,
			logenty = logentry,
		}
		--GHQ_QuestData[guid] = t

     end

      ---AddQuest, take a name and GUID and add it to the quest log --ui function
     class.AddQuestToLog= function(name,GUID)

     end
     --Remove Quest, Remove quest from log by GUID, Maybe a DeleteQuest to remove it entirely from database
     class.RemoveQuestFromLog = function(guid)

     end
	
	
	local loc = GHI_Loc()
	local miscApi = GHI_MiscAPI().GetAPI();
	if WINCOUNT == nil then
	  WINCOUNT=1
	end
	local objectivePick, rewardList, menuFrame


	local killPage =   {
	  {
		{
		  type = "Text",
		  text = "Kill this many of this creature:",
		  align = "l",
		  label = "text",
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
		  texture = "Tooltip",
		  width = 200,
		},
		{
		  type = "Editbox",
		  text = "Zone:",
		  align = "l",
		  label = "killZone",
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
		  label = "text",
		  fontSize = 14,
		},
	  },
	  {
		{
		  type = "Editbox",
		  text = "Got to Sub-Zone:",
		  align = "l",
		  label = "gotoPlace",
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
			  tooltip = "The player must kill a specified amount of creatures to complete thsi quest.",
			},
			{
			  icon = "Interface\\Icons\\INV_Misc_Map_01",
			  name = "Go to Subzone",
			  tooltip = "The player must go to a specified subzone int eh game world to complete this quest.",
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
		  type = "CustomDD",
		  texture = "Tooltip",
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
	  OnOk = function()
		
	  end,  
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
			label = "levelStart",
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
			  "Friz Quadrata",
			  "Arial Narrow",
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
			  "Friz Quadrata",
			  "Arial Narrow",
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
			label = "questDescription",
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
	  name = "GHQ_TestMenu"..WINCOUNT,
	  theme = "BlankWizardTheme",
	  height = 420,
	  width = 500,
	  useWindow = true,
	}

	table.insert(t,2,pickQuestPage)
	table.insert(t,3,killPage)
	table.insert(t,4,goPage)
	table.insert(t,5,lootPage)


	menuFrame = GHM_NewFrame("Testq", t);

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

	menuFrame.Show()
	WINCOUNT = WINCOUNT + 1
	return class;
end