--===================================================
--
--				GHI_MarySueAPI
--  			GHI_MarySueAPI.lua
--
--	  API for accessing data from Mary Sue Protocol Addons
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_MarySueAPI()
	if class then
		return class;
	end
	class = GHClass("GHI_MarySueAPI");

	local api = {};
	
	local log = GHI_Log();
	local buffHandler = GHI_BuffHandler();

	--[[ MSP table flags
	HH = Home
	HI = Character History
	DE = Decription
	NT = Title
	GC = Game Class
	AG = Age
	HB = Birth Place
	AH = Height
	NA = Name
	RA = RP Race
	AW = Weigth
	FC = In Character Flag
	GR = Game Race
	NH = House Name
	NI = Nick Name
	FR = RP Style
	MO = Motto
	AE = Eyes
	CU = Currently
	]]
	-- functions for getting info about another character.
	api.GHI_GetCharacterPhysical = function(player)
		if _G.msp_RPAddOn and msp then
			if msp:PlayerKnownAbout(player) == true then
				local char = msp.char[player]["field"]
				-- Race, Age, Height, Weight, Eye Color, Description
				return char["RA"], char["AG"], char["AH"], char["AW"], char["AE"], char["DE"]
			end
		else
			log.Add(1, "No RP Addon detected. Returning only basic game information, Race \& Level (age).",nil);
			return UnitRace(player), UnitLevel(player)
		end
	end
	
	api.GHI_GetCharacterHistory = function(player)
		if _G.msp_RPAddOn and msp then
			if msp:PlayerKnownAbout(player) == true then
				local char = msp.char[player]["field"]
				-- Home, Birthplace, History
				return char["HH"], char["HB"], char["HI"]
			end
		else
			log.Add(1, "No RP Addon detected. Unable to return character History information.",nil);
			return
		end
	end
	
	api.GHI_GetCharacterWho = function(player)
		if _G.msp_RPAddOn and msp then
			if msp:PlayerKnownAbout(player) == true then
				local char = msp.char[player]["field"]
				-- Name, Title, House, Nickname
				return char["NA"], char["NT"], char["NH"], char["NI"]
			end
		else
			log.Add(1, "No RP Addon detected. Returning only basic game information, Name \& current Title.",nil);
			local nameTitle = UnitPVPName(player) or ""
			local tempName = UnitName(player) or ""
			nameTitle = gsub(nameTitle,tempName,"")
			nameTitle = gsub(nameTitle,",","")
			nameTitle = strtrim(nameTitle)
			--local name, title = strsplit("\ ", nameTitle,1)
			return  tempName, nameTitle
		end
	end
	
	api.GHI_GetCharacterStatus = function(player)
		if _G.msp_RPAddOn and msp then
			if msp:PlayerKnownAbout(player) == true then
				local char = msp.char[player]["field"]
				-- Currently, RP Style, Character Status
				return char["CU"], char["FR"], char["FC"]
			end
		else
			log.Add(1, "No RP Addon detected. Unable to return character History information.",nil);
			return
		end
	end
	-- functions for gettign the current player's info
	api.GHI_GetPlayerPhysical = function()
		if _G.msp_RPAddOn and msp then
			local char = msp.my
			-- Race, Age, Height, Weight, Eye Color, Description
			return char["RA"], char["AG"], char["AH"], char["AW"], char["AE"], char["DE"]
		else
			log.Add(1, "No RP Addon detected. Returning only basic game information, Race \& Level (age).",nil);
			return UnitRace("player"), UnitLevel("player")
		end
	end
	
	api.GHI_GetPlayerHistory = function()
		if _G.msp_RPAddOn and msp then
			local char = msp.my
			return char["HH"], char["HB"], char["HI"]
		else
			log.Add(1, "No RP Addon detected. Unable to return character History information.",nil);
			return
		end
	end
	
	api.GHI_GetPlayerWho = function()
		if _G.msp_RPAddOn and msp then
			local char = msp.my
			-- Name, Title, House, Nickname
			return char["NA"], char["NT"], char["NH"], char["NI"]
		else
			log.Add(1, "No RP Addon detected. Returning only basic game information, Name \& current Title.",nil);
			local nameTitle = UnitPVPName("player")
			local tempName = UnitName("player")
			nameTitle = gsub(nameTitle,tempName,"")
			nameTitle = gsub(nameTitle,",","")
			nameTitle = strtrim(nameTitle)
			--local name, title = strsplit("\ ", nameTitle,1)
			return  tempName, nameTitle
		end
	end
	
	api.GHI_GetPlayerStatus = function()
		if _G.msp_RPAddOn and msp then
			local char = msp.my
			-- Currently, RP Style, Character Status
			return char["CU"], char["FR"], char["FC"]
		else
			log.Add(1, "No RP Addon detected. Unable to return character History information.",nil);
			return
		end
	end
	-- function to allow updating the currently field of the player.
	api.GHI_SetPlayerCurrently = function(text)
		if _G.msp_RPAddOn and msp then
			local char = msp.my
			char["CU"] = text
			msp:Update()
			--
			local RPAddon = _G.msp_RPAddOn
			if RPAddon == "MyRolePlay" then
				mrp:SaveField( "CU", text )		
			end
		else
			log.Add(1, "No RP Addon detected. Unable to set current flag.",nil);
			if buffHandler.CountBuffs("Currently") then
				buffHandler.RemoveBuff("Currently","Helpful", 1, 0)
			end
			buffHandler.CastBuff("Currently", text, "Interface\\Addons\\GHM\\GHI_Icons\\_UI_Quest_Color_Blue", true, "Helpful", "Physical", 0, true, false, 1, 0, 0, true)
			return
		end
	end
	
	api.GHI_ClearPlayerCurrently = function(text)
		if _G.msp_RPAddOn and msp then
			local char = msp.my
			char["CU"] = ""
			msp:Update()
			local RPAddon = _G.msp_RPAddOn
			if RPAddon == "MyRolePlay" then
				mrp:SaveField( "CU", "" )		
			end
		else
			buffHandler.RemoveBuff("Currently","Helpful", 1, 0)
			log.Add(1, "No RP Addon detected. Unable to set current flag.",nil);
			return
		end
	end


	class.GetAPI = function()
		local a = {};
		for i, f in pairs(api) do
			a[i] = f;
		end
		return a;
	end



	return class;
end

