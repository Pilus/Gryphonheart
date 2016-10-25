--
--									
--										GHQ Main
--									GHQ_Main.lua
--
--								Main setup file
--	
-- 						(c)2013 The Gryphonheart Team
--								All rights reserved
--	

local class
function GHQ_Main()
	if class then
		return class
	end
	
	class = GHClass("GHQ_Main")
    -- local loc = GHI_Loc();--our own loc file if we choose to have one
	local slashCmd, ghqPing,options; --log,;--further can be added here
    
	local function SetUpOnGHQLoaded()
	
		--GHI_Event().TriggerEvent("GHI_FILES_LOADED");
		-- remember, only set up the classes that are really needed to run all the time
		if not(type(GHQ_MiscData)=="table") then
			GHQ_MiscData = {};
		end

		slashCmd = GHI_SlashCmd("GHQ"); -- need to run to listen for chat commands
		--ghqPing = GHQ_Ping(); -- needs to run to reply to other pings

		slashCmd.SetDefaultFunc(function(x) GHQ_QuestLogFrame:Show(); end);
		--slashCmd.RegisterSubPrefix("ping", ghiPing.SendPing);
		


		local currentVersion = GetAddOnMetadata("GHQ","version")
		
		local frame = GHQ_QuestLogFrame
		
		GHI_ButtonUI().AddSubButton("Interface\\Addons\\GHQ\\Textures\\ui-button-GHQ",
		"Gryphonheart Quests",
		function() 
		if not(GHQ_QuestLogFrame:IsShown()) then GHQ_QuestLogFrame:Show(); else GHQ_QuestLogFrame:Hide(); end 
		end);
		

	end


	local function SetUpOnVariablesLoaded()
		questList = GHQ_QuestList();
		questList.LoadFromSaved();

		--objectiveList = GHQ_ContainerList();--this could be for the quest log instead
		--chainList = GHQ_DynamicActionList();--chain quests
		end

	GHI_Event("VARIABLES_LOADED",function()
	
				
		local ghmloaded = IsAddOnLoaded("GHM")
		if not(ghmloaded) then error("Gryphonheart Menu (GHM) Must be loaded with GHQ") return end
		local ghiloaded = IsAddOnLoaded("GHI")
		if not(ghiloaded) then error("Gryphonheart Items (GHI) Must be loaded with GHQ") return end

		SetUpOnGHQLoaded()
		GHI_Timer(SetUpOnVariablesLoaded, 5, true);
	
	end)
	
	
		

	return class;
end

GHQ_Main();
GHQ_Main = nil;




