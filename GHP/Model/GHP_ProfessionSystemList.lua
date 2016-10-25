--
--
--				GHP_ProfessionSystemList
--  			GHP_ProfessionSystemList.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local DATA_SAVE_TABLE = "GHP_ProfessionSystemData";

local class;
function GHP_ProfessionSystemList()
	if class then
		return class;
	end
	class = GHClass("GHP_ProfessionSystemList");

	local systems = {};

	local savedInfo = GHI_SavedData(DATA_SAVE_TABLE);
	local event = GHI_Event();

	class.LoadFromSaved = function()
		local data = savedInfo.GetAll();
		systems = {};

		for index,value in pairs(data) do

			if value.type and type(_G["GHP_ProfessionSystem_"..value.type]) == "function" then
				systems[index] = _G["GHP_ProfessionSystem_"..value.type](value);
			else
				print("no function found for ",value.type)
			end
		end

		-- setup data sharing
		GH_DataSharer("GHP","GHP_ProfessionSystems",class.GetSystem,class.SetSystem,class.GetSystemGuids,true)
	end

	class.GetSystem = function(guid)
		return systems[guid];
	end

	local IsVersionNewer = function(system)
		local guid = system.GetGuid();
		return not(systems[guid]) or system.GetVersion() > systems[guid].GetVersion();
	end

	local SetAndSaveSystem = function(system)
		local guid = system.GetGuid();
		systems[guid] = system;
		savedInfo.SetVar(guid,system.Serialize());
		event.TriggerEvent("GHP_PROFESSION_SYSTEM_UPDATED", guid);
	end

	GHI_Event("GHP_PROFESSION_LEARNED",function(_,guid) if guid and systems[guid] then SetAndSaveSystem(systems[guid]); end end);
	GHI_Event("GHP_ABILITY_LEARNED",function(_,guid) if guid and systems[guid] then SetAndSaveSystem(systems[guid]); end end);

	local UpdateOrAddSystem = function(newSystem)
		local guid = newSystem.GetGuid();
		local currentSystem = systems[guid];
		if not(currentSystem) then
			SetAndSaveSystem(newSystem);
		elseif newSystem.GetVersion() > currentSystem.GetVersion() then
			if newSystem.GotPersonalData() == false then -- transfer personal data from the old one
				newSystem.SetPersonalData(currentSystem.Serialize("personal"));
			end
			SetAndSaveSystem(newSystem);
		elseif newSystem.GetVersion() == currentSystem.GetVersion() then
			if newSystem.GotPersonalData() == true then -- transfer personal data from the new one
				currentSystem.SetPersonalData(newSystem.Serialize("personal"));
				SetAndSaveSystem(currentSystem);
			end
		end
	end


	class.SetSystem = function(value)
		if type(value)=="table" then
			if value.IsClass then
				if value.IsClass("GHP_ProfessionSystem") then
					UpdateOrAddSystem(value);
				end
			elseif value.type and value.guid and type(_G["GHP_ProfessionSystem_"..value.type]) == "function" then
				local guid = value.guid;
				local system = _G["GHP_ProfessionSystem_"..value.type](value);
				UpdateOrAddSystem(system);
			end
		end
	end

	class.GetSystemGuids = function()
		local t = {};
		for i,system in pairs(systems) do
			table.insert(t,system.GetGuid())
		end
		return t;
	end

	return class;
end

