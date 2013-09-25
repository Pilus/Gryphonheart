--===================================================
--
--				GHI_DynamicActionInstance
--  			GHI_DynamicActionInstance.lua
--
--	The instance of a dynamic action holds information
--	such as input variables and references.
--
--		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local list;
local scriptEnvList;
local instances = {};

function GHI_DynamicActionInstance(actionGuid, instanceGuid, authorGuid)
	local class = GHClass("GHI_DynamicActionInstance");
	local guid = instanceGuid or GHI_GUID().MakeGUID();

	local inputs = {};
	local outputs = {};

	local portConnectionsOut = {};
	local portConnectionsIn = {};

	local inPortFunctions = {};

	local version = 0;

	if not (list) then
		list = GHI_DynamicActionList();
	end
	if not (scriptEnvList) then
		scriptEnvList = GHI_ScriptEnvList();
	end

	class.Serialize = function()
		local t = {};
		t.guid = guid;
		t.actionGuid = actionGuid;
		t.inputs = GHClone(inputs);
		t.outputs = GHClone(outputs);
		t.version = version;
		t.portConnectionsOut = {};
		for portGuid, connection in pairs(portConnectionsOut) do
			t.portConnectionsOut[portGuid] = {
				instanceGuid = connection.instance.GetGUID(),
				portGuid = connection.portGuid,
			}
		end
		t.portConnectionsIn = {};
		for portGuid, connection in pairs(portConnectionsIn) do
			t.portConnectionsIn[portGuid] = {
				instanceGuid = connection.instance.GetGUID(),
				portGuid = connection.portGuid,
			}
		end
		return t;
	end

	class.Deserialize = function(t, GetInstanceFunc)
		guid = t.guid;
		actionGuid = t.actionGuid;
		inputs = t.inputs;
		outputs = t.outputs;
		version = t.version or 1;
		for portGuid, connection in pairs(t.portConnectionsOut) do
			portConnectionsOut[portGuid] = {
				instance = GetInstanceFunc(connection.instanceGuid),
				portGuid = connection.portGuid,
			}
		end
		for portGuid, connection in pairs(t.portConnectionsIn) do
			portConnectionsIn[portGuid] = {
				instance = GetInstanceFunc(connection.instanceGuid),
				portGuid = connection.portGuid,
			}
		end
	end

	class.GetGUID = function()
		return guid;
	end

	class.SetInputRef = function(inputGuid, refType, refInfo)
		GHCheck("GHI_DynamicActionInstance.SetInputRef", { "string", "stringNil", "stringNumberTableNilBoolean" }, { inputGuid, refType, refInfo });
		local action = list.GetAction(actionGuid);
		assert(action.GotInput(inputGuid) == true, "No input found with given inputGuid.", inputGuid);

		if refType == "attribute" then
			inputs[inputGuid] = {
				type = refType,
				info = refInfo,
			};
		elseif refType == "variable" then
			inputs[inputGuid] = {
				type = refType,
				info = refInfo,
			};
		elseif refType == "static" then
			if action.ValidateInput(inputGuid, refInfo) then
				inputs[inputGuid] = {
					type = refType,
					info = refInfo,
				};
			else
				print("Incorrect input",inputGuid, refInfo)
			end
		elseif refType == nil then
			inputs[inputGuid] = nil;
		else
			error("Incorrect input ref type (" .. refType .. ") for " .. inputGuid);
		end
	end

	class.GetInputRef = function(inputGuid)
		if inputs[inputGuid] then
			return inputs[inputGuid].type, inputs[inputGuid].info;
		end
	end

	class.SetOutputRef = function(outputGuid, refType, refInfo)
		GHCheck("GHI_DynamicActionInstance.SetOutputRef", { "string", "stringNil", "stringNil" }, { outputGuid, refType, refInfo });
		local action = list.GetAction(actionGuid);
		assert(action.GotOutput(outputGuid) == true, "No output found with given outputGuid.", outputGuid);

		if refType == "attribute" then
			outputs[outputGuid] = {
				type = refType,
				info = refInfo,
			}
		elseif refType == "variable" then
			outputs[outputGuid] = {
				type = refType,
				info = refInfo,
			};
		elseif refType == nil then
			outputs[outputGuid] = nil;
		else
			error("Incorrect output ref type (" .. refType .. ") for " .. outputGuid);
		end
	end

	class.GetOutputRef = function(outputGuid)
		if outputs[outputGuid] then
			return outputs[outputGuid].type, outputs[outputGuid].info;
		end
	end

	class.SetPortConnection = function(portGuid, connectedInstance, connectedPortGuid)
		GHCheck("GHI_DynamicActionInstance.SetPortConnection", { "string", "tableNil", "stringNil" }, { portGuid, connectedInstance, connectedPortGuid });
		portGuid = portGuid:lower();

		local action = list.GetAction(actionGuid);
		assert(action.GotPort(portGuid, "out") == true, "No out port found with given portGuid", portGuid);

		if portConnectionsOut[portGuid] then
			portConnectionsOut[portGuid].instance.SetInPortConnectionForSync(portConnectionsOut[portGuid].portGuid, nil, nil);
		end
		if connectedInstance then
			connectedInstance.SetInPortConnectionForSync(connectedPortGuid, class, portGuid);
			portConnectionsOut[portGuid] = {
				instance = connectedInstance,
				portGuid = connectedPortGuid,
			};
		else
			portConnectionsOut[portGuid] = nil;
		end
	end

	class.SetInPortConnectionForSync = function(portGuid, connectedInstance, connectedPortGuid) -- only intended to be called from other dynamic action instances
		GHCheck("GHI_DynamicActionInstance.SetPortConnection", { "string", "tableNil", "stringNil" }, { portGuid, connectedInstance, connectedPortGuid });
		portGuid = portGuid:lower();
		local action = list.GetAction(actionGuid);
		assert(action,"No action info found for action",actionGuid)
		assert(action.GotPort(portGuid, "in") == true, "No in port found with given portGuid", portGuid);

		if connectedInstance then
			portConnectionsIn[portGuid] = {
				instance = connectedInstance,
				portGuid = connectedPortGuid,
			};
		else
			portConnectionsIn[portGuid] = nil;
		end
	end

	class.DisconnectAction = function()
		local action = list.GetAction(actionGuid);
		for i=1,action.GetPortsCount("in") do
			local portGuid = action.GetPortInfo("in",i);
			if portConnectionsIn[portGuid] then
				local instance = portConnectionsIn[portGuid].instance;
				local instancePortGuid = portConnectionsIn[portGuid].portGuid;
				if instance.IsClass("GHI_DynamicActionInstance") then
					instance.SetPortConnection(instancePortGuid,nil,nil);
				elseif instance.IsClass("GHI_DynamicActionInstanceSet") then
					instance.SetInstanceAtPort(instancePortGuid,nil,nil);
				end
			end
		end
		for i=1,action.GetPortsCount("out") do
			local portGuid = action.GetPortInfo("out",i);
			class.SetPortConnection(portGuid,nil,nil);

		end
	end

	local currentPort;

	local RunSetupScript = function(stack, instanceIndex, isUpdateAction, feedbackFunctions, exeGuids)
		local guid;
		if not(stack) then
			return
		elseif stack.GetGUID then
			guid = stack.GetGUID();
		elseif stack.GetGuid then
			guid = stack.GetGuid();
		else
			guid = "";
		end

		local action = list.GetAction(actionGuid);
		local script = action.GetScript();
		local env = scriptEnvList.GetEnv(authorGuid, isUpdateAction);

		local exeGuidsCombined = "";
		if type(exeGuids) == "table" then
			for i=1,#(exeGuids) do
				exeGuidsCombined = exeGuidsCombined.."_"..(exeGuids[i] or "");
			end
		end

		local combinedGuid;
		if exeGuidsCombined then
			combinedGuid = strsub(tostring(class),8).."_"..exeGuidsCombined;
		else
			combinedGuid = guid.."_"..strsub(tostring(class),8).."_"..(instanceIndex or 1);
		end

		if not (env.GotHeaderApi(combinedGuid)) then
			env.SetValue("GetExecutionGuids_"..combinedGuid,function()
				return unpack(exeGuids or {})
			end);

			env.SetValue("GetInput_" .. combinedGuid, function(inputGuid)
				GHCheck("dyn.GetInput", { "string" }, { inputGuid });
				local input = inputs[inputGuid];

				if not (input) then
					local inputInfo action.GetInputByGuid(inputGuid)
					if inputInfo then
						return inputInfo.defaultValue;
					end
					return
				end

				if input.type == "static" then
					return input.info;
				elseif input.type == "variable" then
					return env.GetValue(input.info);
				elseif input.type == "attribute" then
					if stack.GetAttribute then
						return stack.GetAttribute(input.info, instanceIndex);
					elseif stack.GetAttributeValue then
						return stack.GetAttributeValue(input.info, instanceIndex);
					end
				end
			end);

			env.SetValue("TriggerOutPort_" .. combinedGuid, function(portGuid)
				GHCheck("dyn.TriggerOutPort", { "string" }, { portGuid });
				if action.GotPort(portGuid, "out") then
					local connection = portConnectionsOut[portGuid:lower()];
					if connection then
						connection.instance.Execute(connection.portGuid, stack, instanceIndex, isUpdateAction, feedbackFunctions, exeGuids);
					end
				else
					print("Port not found.")
				end
			end);

			env.SetValue("SetPortInFunction_" .. combinedGuid, function(portGuid, func)
				GHCheck("dyn.SetPortInFunction_", { "string", "function" }, { portGuid, func });
				if action.GotPort(portGuid, "in") then
					inPortFunctions[portGuid] = func;
				end
			end);

			env.SetValue("SetOutput_" .. combinedGuid, function(outputGuid, value)
				GHCheck("dyn.SetOutput_", { "string", "any" }, { outputGuid, value });
				local success, error = action.ValidateOutput(outputGuid, value);
				if success then
					local output = outputs[outputGuid];
					if output then
						if output.type == "variable" then
							env.SetValue(output.info, value);
						elseif output.type == "attribute" then
							if stack.SetAttribute then
								stack.SetAttribute(output.info, value, instanceIndex);
							elseif stack.SetAttributeValue then
								stack.SetAttributeValue(output.info, value, instanceIndex);
							end
						end
					else
						print("Output not set")
					end
				else
					print(error)
				end
			end);

			env.SetValue("GetCurrentPort_" .. combinedGuid, function()
				return currentPort;
			end);

			local apiScript = "";
			if stack.GetAPI then
				local api,apiName = stack.GetAPI(true, exeGuids);
				env.SetValue(apiName .. "_" .. combinedGuid,api );
				apiScript = string.format("local %s = %s_DYN_GUID; ",apiName,apiName);
			end

			if feedbackFunctions then
				env.SetValue("feedback_" .. combinedGuid, feedbackFunctions);
			end

			local preScript = apiScript..[[
				local dyn = {
					GetInput = GetInput_DYN_GUID,
					TriggerOutPort = TriggerOutPort_DYN_GUID,
					SetPortInFunction = SetPortInFunction_DYN_GUID,
					SetOutput = SetOutput_DYN_GUID,
					GetCurrentPort = GetCurrentPort_DYN_GUID,
				};

				local GetExecutionGuids = GetExecutionGuids_DYN_GUID;
				local oldDoScript = GHI_DoScript;
				local DoScript = function(s,d) oldDoScript(s,d,"DYN_GUID"); end
				local GHI_DoScript = DoScript;
				local oldDoScript = nil;
				local feedback = feedback_DYN_GUID;
				if stack and stack.GetItemGuid then _SetActionAPIItemGuid(stack.GetItemGuid()); end
			]];
			preScript = string.gsub(preScript, "DYN_GUID", combinedGuid);

			local postScript = "";
			if action.GotPort("OnSetup", "out") then
				postScript = [[ dyn.TriggerOutPort("OnSetup"); ]];
			end
			env.SetHeaderApi(combinedGuid, preScript, postScript)
		end
		env.ExecuteScript(script, 0, combinedGuid);
	end

	local setup = false;
	class.Execute = function(portGuid, stack, instanceIndex, isUpdateAction, feedbackFunctions, exeGuids)
		GHCheck("GHI_DynamicActionInstance.Execute", { "string", "table" , "numberNil","booleanNil","tableNil","tableNil"}, { portGuid, stack, instanceIndex, isUpdateAction, feedbackFunctions, exeGuids });
		local action = list.GetAction(actionGuid);
		if action.GetAllPortsTriggerScript() or not (portGuid) or (portGuid == "setup") then
			currentPort = portGuid or "setup";
			RunSetupScript(stack, instanceIndex, isUpdateAction, feedbackFunctions, exeGuids);
			setup = true;
		elseif setup == true then
			if inPortFunctions[portGuid] then
				currentPort = portGuid;
				inPortFunctions[portGuid]();
			end
		else
			error(string.format("GHI Dynamic action port triggered before load. Action: %s, port: %s.", list.GetAction(actionGuid).GetName(), portGuid));
		end
	end

	-- information for gui
	class.GetAction = function()
		return list.GetAction(actionGuid);
	end

	class.GetActionInfo = function()
		local action = list.GetAction(actionGuid);
		return action.GetName(), action.GetIcon(), action.GetDescription();
	end

	class.GetPortsInCount = function()
		local action = list.GetAction(actionGuid);
		return action.GetPortsCount("in");
	end

	class.GetPortsOutCount = function()
		local action = list.GetAction(actionGuid);
		return action.GetPortsCount("out");
	end

	class.GetPortInfo = function(direction, i)
		local action = list.GetAction(actionGuid);
		local pguid, name, description = action.GetPortInfo(direction, i);
		--print(direction,i,":",pguid)
		return pguid, name, description, portConnectionsIn[pguid] or portConnectionsOut[pguid];
	end

	class.IdentifyPort = function(portGuid)
		local action = list.GetAction(actionGuid);
		for _, dir in pairs({ "in", "out" }) do
			for i = 1, action.GetPortsCount(dir) do
				local pguid = action.GetPortInfo(dir, i)
				if pguid == portGuid then
					return dir, i;
				end
			end
		end
	end

	class.GetDependingItems = function(stack)
		local t = {};
		local action = list.GetAction(actionGuid);
		for guid,input in pairs(inputs) do
			local actionInput = action.GetInputByGuid(guid);
			if actionInput.type == "item" then
				if input.type == "static" then
					table.insert(t,input.info);
				elseif input.type == "attribute" and stack then
					for i = 1,stack.GetItemInstanceCount() do
						table.insert(t,stack.GetAttribute(input.info,i));
					end
				end
			end
		end
		return t;
	end

	class.ShowMenu = function(parent, edit, okFunc, connectedInstanceGuid, connectedPortGuid, set)
		local action = list.GetAction(actionGuid);
		local menu = action.GetFreeMenu(parent,set.GetItem().GetAuthorInfo());
		local connectedInstance;
		if connectedInstanceGuid then
			connectedInstance = instances[connectedInstanceGuid];
		end

		menu.OnOk = function()
			local action = list.GetAction(actionGuid);
			for i = 1, action.GetInputsCount() do
				local inputGuid, input = action.GetInput(i);
				local value = menu.GetLabel("_in_" .. inputGuid);
				if type(value) == "table" and value.type and value.value then
					class.SetInputRef(inputGuid, value.type, value.value);
				else
					class.SetInputRef(inputGuid, "static", value);
				end
			end

			for i = 1, action.GetOutputsCount() do
				local outputGuid, output = action.GetOutput(i);
				local value = menu.GetLabel("_out_" .. outputGuid);

				if type(value) == "table" and value.type and value.value then
					class.SetOutputRef(outputGuid, value.type, value.value);
				end
			end

			if not(edit == true) then
				if connectedInstance then
					connectedInstance.SetPortConnection(connectedPortGuid, class, "setup");
				elseif connectedInstanceGuid == "set" then
					set.SetInstanceAtPort(connectedPortGuid, class, "setup");
				end
			end
			version = version + 1;

			if okFunc then
				okFunc();
			end
			menu:Hide();
		end;

		for i = 1, action.GetInputsCount() do
			local inputGuid, input = action.GetInput(i);
			local inputFrame = menu.GetLabelFrame("_in_" .. inputGuid);
			if inputFrame.EnableVariableAttributeInput then
				local env = scriptEnvList.GetEnv(authorGuid);
				inputFrame:EnableVariableAttributeInput(env, set.GetItem());
			end

			if edit then
				local inputType, value = class.GetInputRef(inputGuid);
				menu.ForceLabel("_in_" .. inputGuid, inputType, value);
			else
				local default;
				if GHM_Input_Validate(input.type,input.defaultValue) then
					default = input.defaultValue;
				else
					default = GHM_Input_GetDefaultValue(input.type);
				end
				menu.ForceLabel("_in_" .. inputGuid, "static", default);
			end
		end

		for i = 1, action.GetOutputsCount() do
			local outputGuid, output = action.GetOutput(i);
			local outputFrame = menu.GetLabelFrame("_out_" .. outputGuid);
			if outputFrame.EnableVariableAttributeInput then
				local env = scriptEnvList.GetEnv(authorGuid);
				outputFrame:EnableVariableAttributeInput(env, set.GetItem());
			end

			if edit then
				local inputType, value = class.GetOutputRef(outputGuid);
				menu.ForceLabel("_out_" .. outputGuid, inputType, value);
			else
				menu.ForceLabel("_out_" .. outputGuid, output.defaultValue);
			end
		end

		menu:AnimatedShow();
	end

	instances[guid] = class;
	return class;
end

