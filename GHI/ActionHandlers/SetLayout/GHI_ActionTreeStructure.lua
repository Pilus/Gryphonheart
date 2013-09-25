--===================================================
--
--				GHI_ActionTreeStructure
--				GHI_ActionTreeStructure.lua
--
--		Holds a tree stucture of the actions in a
--			dynamic action set.
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_ActionTreeStructure()
	if class then
		return class;
	end
	class = GHClass("GHI_ActionTreeStructure");

	local GenerateSubTree;
	GenerateSubTree = function(dept, instance, remainingInstances)
		-- The actions are ordered in a tree structure including only the connections that goes into a 'SetUp' port (I1).
		-- A action can at this point have many children, each connected to a port from 1 to N.

		local tree = {
			dept = dept,
			instance = instance,
		};
		remainingInstances[instance] = nil;

		for i = 1, instance.GetPortsOutCount() do
			local pGuid, _, _, connectedTo = instance.GetPortInfo("out", i);
			if connectedTo then
				local firstGuid = connectedTo.instance.GetPortInfo("in", 1)
				if connectedTo.portGuid == firstGuid then
					table.insert(tree, GenerateSubTree(tree.dept + 1, connectedTo.instance,remainingInstances));
				end
			end
		end
		return tree;
	end

	class.GenerateActionTree = function(availablePorts,portConnections,instances)
		local instancesToInsert = {};
		for _,instance in pairs(instances or {}) do
			instancesToInsert[instance] = true;
		end

		local tree = { dept = 1 };
		for _, portGuid in pairs(availablePorts) do
			if portConnections[portGuid] then -- if something is connected to the port
				local instance, instancePortGuid = unpack(portConnections[portGuid]);
				local firstUsedPortGuid;
				for i = 1,instance.GetPortsInCount() do
					local pg = instance.GetPortInfo("in", i);
					if pg then
						firstUsedPortGuid = pg;
					end
					break;
				end
				if instancePortGuid == firstUsedPortGuid then
					table.insert(tree, GenerateSubTree(tree.dept + 1, instance, instancesToInsert));
				end
			end
		end

		-- Handle free instances
		for instance,_ in pairs(instancesToInsert) do
			if instancesToInsert[instance] == true then
				table.insert(tree,GenerateSubTree(2,instance,instancesToInsert));
			end
		end

		return tree;
	end

	return class;
end

