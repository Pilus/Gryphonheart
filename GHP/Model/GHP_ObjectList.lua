--===================================================
--
--				GHP_ObjectList
--  			GHP_ObjectList.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local OBJECT_DATA_SAVE_TABLE = "GHP_ObjectData";

local class;
function GHP_ObjectList()
	if class then
		return class;
	end

	local objects = {};

	local savedObjectInfo = GHI_SavedData(OBJECT_DATA_SAVE_TABLE);

	class = GHClass("GHP_ObjectList");

	class.LoadFromSaved = function()
   		local data = savedObjectInfo.GetAll();
		   objects = {};

		for index,value in pairs(data) do
			objects[index] = GHP_Object(value);
		end
	end

	class.GetObject = function(guid)
		return objects[guid];
	end

	local SetObject = function(newObject)
		local guid = newObject.GetGuid();
		local existingObject = objects[guid];
		if not(existingObject) or newObject.GetVersion() > existingObject.GetVersion() then
			objects[guid] = newObject;
			savedObjectInfo.SetVar(guid,objects[guid].Serialize());
		end
	end

	class.SetObject = function(value)
		if type(value) == "table" then
			if type(value.IsClass) == "function" then
				if value.IsClass("GHP_Object") then
					SetObject(value);
				end
			else
				SetObject(GHP_Object(value));
			end
		end
	end

	return class;
end