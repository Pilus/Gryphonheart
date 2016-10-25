--
--
--				GHP_ObjectInstanceRegister
--  			GHP_ObjectInstanceRegister.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local VISIBLE_RANGE = 15;

local class;
function GHP_ObjectInstanceRegister()
	if class then
		return class;
	end
	class = GHClass("GHP_ObjectInstanceRegister");

	local objects = {}
	local event = GHI_Event();
	local pos = GHI_Position();


	local c1 = {x=0,y=0};
	local c2 = {x=10000,y=10000};
	local tree;

	class.AddObjectInstance = function(object) --print("add",object)  --if #(objects) == 0 then error("first"); end
		local pos = object.GetPosition();
		local o = {
			x=pos.x,
			y=pos.y,
			data = object,
		};
		object.kdRef = o;

		if not(tree) then
			tree = GHP_BuildKdTree({o},c1,c2)
		else
			GHP_InsertKdTree(tree,o);
		end

		event.TriggerEvent("GHP_NEARBY_OBJECTS_UPDATED");
	end

	class.RemoveObjectInstance = function(object)
		if object.kdRef then
			GHP_RemoveKdTree(object.kdRef);
			event.TriggerEvent("GHP_NEARBY_OBJECTS_UPDATED");
		end
	end




	local GetNearbyObjects = function(onlyVisible)
		local o = {}

		local x,y = pos.GetCoor();
		if tree then
			local result = GHP_SearchKdTree(tree,{x=x,y=y},VISIBLE_RANGE);    RES = result; TREE = tree;
			for _,treeObj in pairs(result) do
				local object = treeObj.data;
				if (not(onlyVisible) or not(object.GetAttributeValue("visible")==false)) and  pos.IsPosWithinRange(object.GetPosition(),VISIBLE_RANGE) then
					table.insert(o,object);
				end
			end
		end

		return o;
	end

	class.GetNumNearbyObjects = function(onlyVisible)
		--return #(objects)
		return #(GetNearbyObjects(onlyVisible))

	end

	class.GetObjectInstance = function(index,onlyVisible)
		if type(index) == "number" then
			return GetNearbyObjects(onlyVisible)[index]
		elseif type(index) == "string" then
			local nodes = GHP_GetAllKdNodes(tree)
			for i,node in pairs(nodes) do
				local obj = node.data;
				if obj.GetGuid() == index then
					return obj;
				end
			end
		end
	end


	return class;
end

