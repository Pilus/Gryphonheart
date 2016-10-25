--
--
--				GHP_ProfessionList
--  			GHP_ProfessionList.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local PROFESSION_DATA_SAVE_TABLE = "GHP_ProfessionData";


local class;
function GHP_ProfessionList()
	if class then
		return class;
	end
	class = GHClass("GHP_ProfessionList");

	local professions = {};

	local savedProfessionInfo = GHI_SavedData(PROFESSION_DATA_SAVE_TABLE);

	class.LoadFromSaved = function()
		local data = savedProfessionInfo.GetAll();
		professions = {};

		for index,value in pairs(data) do
			professions[index] = GHP_Profession(value);
			professions[index].Activate();
		end
	end

	class.GetProfession = function(guid)
		return professions[guid];
	end

	local SetAndSaveProfession = function(prof)
		local guid = prof.GetGuid();
		professions[guid] = prof;
		savedProfessionInfo.SetVar(guid,professions[guid].Serialize())
	end

	local UpdateOrAddProfession = function(prof)
		local guid = prof.GetGuid();
		local currentProf = professions[guid];
		if not(currentProf) then
			SetAndSaveProfession(prof);
			prof.Activate();
		elseif prof.GetVersion() > currentProf.GetVersion() then
			if prof.GotPersonalData() == false then -- transfer personal data from the old one
				prof.SetPersonalData(currentProf.Serialize("personal"));
			end
			SetAndSaveProfession(prof);
			currentProf.Deactivate();
			prof.Activate();
		elseif prof.GetVersion() == currentProf.GetVersion() then
			if prof.GotPersonalData() == true then -- transfer personal data from the new one
				currentProf.SetPersonalData(prof.Serialize("personal"));
				SetAndSaveProfession(currentProf);
			end
		end
	end;


	class.SetProfession = function(value)
		if type(value) == "table" then
			if type(value.IsClass) == "function" then
				if value.IsClass("GHP_Profession") then
					UpdateOrAddProfession(value)
				end
			else
				UpdateOrAddProfession(GHP_Profession(value));
			end
		end
	end

	return class;
end

