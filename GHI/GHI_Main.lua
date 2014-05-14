--===================================================
--									
--						GHI Main
--						GHI_Main.lua
--
--					Main setup file
--	
-- 			(c)2013 The Gryphonheart Team
--					All rights reserved
--===================================================	

local class
function GHI_Main()
	if class then
		return class
	end
	class = GHClass("GHI_Main")
	local loc = GHI_Loc();
	local slashCmd, ghiPing, trade, options, log, itemList, containerList, miscAPI, dynamicActionList;
	log = GHI_Log();

	local function SetUpOnGHILoaded()
		if not(type(GHI_MiscData)=="table") then
			GHI_MiscData = {};
		end

		GHI_Event().TriggerEvent("GHI_FILES_LOADED");
		-- remember, only set up the classes that are really needed to run all the time
		log.Add(3, "GHI Files loaded");

		miscAPI = GHI_ActionAPI().GetAPI();

		slashCmd = GHI_SlashCmd("GHI"); -- need to run to listen for chat commands
		ghiPing = GHI_Ping(); -- needs to run to reply to other pings

		slashCmd.SetDefaultFunc(function(x) GHI_ToggleBackpack(); end);
		slashCmd.RegisterSubPrefix("ping", ghiPing.SendPing);
		slashCmd.RegisterSubPrefix("reload", function(x) GHI_ReloadUI() end);

	end

	local function SetUpOnTradeFrameShown()
		trade = GHI_Trade();
	end


	local function SetUpOnVariablesLoaded()
		itemList = GHI_ItemInfoList();
		itemList.LoadFromSaved();

		containerList = GHI_ContainerList();
		dynamicActionList = GHI_DynamicActionList();
		local loading;
		GHI_Event("GHI_ITEM_INFO_LOADED", function()
			log.Add(3, "GHI item data loaded");
			containerList.LoadFromSaved();
			dynamicActionList.LoadFromSaved();
			itemList.ClearItemCache()
			loading = true;
		end);

		GHI_Event("GHI_ITEM_CACHE_CLEARED",function()
			if loading then
				GHI_Message(loc.LOADED);
				GHI_Event().TriggerEvent("GHI_LOADED");
				log = GHI_Log();
				log.Add(3, loc.LOADED);
				loading = false;
			end
		end)

		options = GHI_MainOptionsMenu()
		GHI_UnitTooltip();

		-- initialize the following so they are ready to receive data
		local buffHandler = GHI_BuffHandler();
		local areaSound = GHI_AreaSound();
	end

	-- Let SetUp run when GHI is loaded
	local f = CreateFrame("frame");
	f:SetScript("OnEvent", function(self, event, addon) -- These events should later on be set up by calling an event handler class
		if event == "ADDON_LOADED" then
			local loaded = IsAddOnLoaded("GHM")
			if not(loaded) then
				error("Gryphonheart Menu (GHM) Must be loaded with GHI")
				return
			end
			if addon == "GHI" then
				SetUpOnGHILoaded();
			end
		elseif event == "TRADE_SHOW" then
			SetUpOnTradeFrameShown()
		elseif event == "VARIABLES_LOADED" then
			GHI_Timer(SetUpOnVariablesLoaded, 0, true);
		end
	end);
	f:RegisterEvent("ADDON_LOADED");
	f:RegisterEvent("TRADE_SHOW");
	f:RegisterEvent("VARIABLES_LOADED");

	return class;
end

GHI_Main();
GHI_Main = nil;

GHI_ProvidedDynamicActions = {};





