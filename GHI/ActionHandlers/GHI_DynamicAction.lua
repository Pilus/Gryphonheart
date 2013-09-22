--===================================================
--
--				GHI_DynamicAction
--  			GHI_DynamicAction.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_DynamicAction(dataTable)
	local class = GHClass("GHI_DynamicAction");

	local guid, name, description, icon, category, version, authorGuid, authorName, script, ports, inputs, outputs, allowedInUpdateSequence, specialActionCategory;
	local gotOnSetupPort, portsOrderIn, portsOrderOut, allPortsTriggerScript, requiredDisabledMenuElements;

	local OrderPorts = function()
		portsOrderIn = {};
		portsOrderOut = {};
		for guid, port in pairs(ports) do
			local portsOrder = portsOrderIn;
			if port.direction == "out" then
				portsOrder = portsOrderOut;
			end
			if port.order and #(portsOrder) > 0 then
				local placed = false;
				for i = 1, #(portsOrder) do
					local otherPort = ports[portsOrder[i]];
					if not (otherPort.order) or (otherPort.order > port.order) then
						table.insert(portsOrder, i, guid);
						placed = true;
						break;
					end
				end
				if placed == false then
					table.insert(portsOrder, guid);
				end
			else
				table.insert(portsOrder, guid);
			end
		end
	end

	local SetupDynamicActionInfo = function(data)
		if type(data) ~= "table" then return end

		if type(data.guid) == "string" then
			guid = data.guid;
		else
			guid = "";
		end
		if type(data.name) == "string" then
			name = data.name;
		else
			name = "";
		end
		if type(data.description) == "string" then
			description = data.description;
		else
			description = "";
		end

		if type(data.icon) == "string" then
			icon = data.icon;
		else
			icon = "Interface\\Icons\\INV_Misc_QuestionMark";
		end
		if type(data.category) == "string" then
			category = data.category;
		else
			category = "";
		end
		if type(data.version) == "number" then
			version = data.version;
		else
			version = "";
		end
		if type(data.authorGuid) == "string" then
			authorGuid = data.authorGuid;
		else
			authorGuid = "";
		end
		if type(data.authorName) == "string" then
			authorName = data.authorName;
		else
			authorName = "";
		end
		if type(data.script) == "string" then
			script = data.script;
		else
			script = "";
		end
		if type(data.ports) == "table" then
			ports = {};
			for i, v in pairs(data.ports) do
				ports[i:lower()] = v;
			end
			OrderPorts();
		else
			ports = {};
		end
		if type(data.inputs) == "table" then
			inputs = data.inputs;
		else
			inputs = {};
		end
		if type(data.outputs) == "table" then
			outputs = data.outputs;
		else
			outputs = {};
		end
		if data.gotOnSetupPort == true then
			gotOnSetupPort = true;
		else
			gotOnSetupPort = false;
		end
		if data.allPortsTriggerScript then
			allPortsTriggerScript = true;
		else
			allPortsTriggerScript = false;
		end
		if data.allowedInUpdateSequence then
			allowedInUpdateSequence = true;
		else
			allowedInUpdateSequence = false;
		end

		requiredDisabledMenuElements = data.requiredDisabledMenuElements;

		specialActionCategory = data.specialActionCategory;
	end
	SetupDynamicActionInfo(dataTable);

	local GetInput = function(inputGuid)
		return inputs[inputGuid];
	end
	class.GetInputByGuid = GetInput;

	class.GetGUID = function()
		return guid;
	end

	class.GetName = function()
		return name;
	end

	class.GetDescription = function()
		return description;
	end

	class.GetIcon = function()
		return icon;
	end

	class.GetAuthor = function()
		return authorGuid, authorName;
	end

	class.GetScript = function()
		return script;
	end

	class.GetCategory = function()
		return category;
	end

	class.GenerateActionInstance = function(ownerGuid)
		return GHI_DynamicActionInstance(guid,GHI_GUID().MakeGUID(),ownerGuid);
	end

	class.GetAllPortsTriggerScript = function()
		return allPortsTriggerScript;
	end

	class.ValidateInput = function(inputGuid, value)
		local input = GetInput(inputGuid);
		if input then
			return GHM_Input_Validate(input.type, value);
		end
		return false,"No input found for"..tostring(inputGuid);
	end

	class.ValidateOutput = function(outputGuid, value)
		local output = outputs[outputGuid];
		if output then
			if output.type == "any" then
				return true;
			end
			return GHM_Input_Validate(output.type, value);
		end
		return false;
	end

	class.GotPort = function(portGuid, direction)
		if portGuid:lower() == "onsetup" and direction == "out" and gotOnSetupPort then
			return true;
		end
		if portGuid:lower() == "setup" and direction == "in" then
			return true;
		end
		local port = ports[portGuid:lower()];
		if port and port.direction == direction then
			return true;
		end
		return false;
	end

	class.GotInput = function(inputGuid)
		if inputs[inputGuid] then
			return true;
		end
		return false;
	end

	class.GotOutput = function(outputGuid)
		if outputs[outputGuid] then
			return true;
		end
		return false;
	end

	class.GetPortsCount = function(direction)
		local c = 0;
		if (direction == "in") or (direction == "out" and gotOnSetupPort) then
			c = 1;
		end

		for _, port in pairs(ports) do
			if port.direction == direction then
				c = c + 1;
			end
		end
		return c;
	end

	class.GetInputsCount = function()
		local c = 0;
		for _, _ in pairs(inputs) do
			c = c + 1;
		end
		return c;
	end

	class.GetInput = function(i)
		local c = 0;
		for inputGuid, input in pairs(inputs) do
			c = c + 1;
			if c == i then
				return inputGuid, input;
			end
		end
		return c;
	end

	class.GetOutputsCount = function()
		local c = 0;
		for _, _ in pairs(outputs) do
			c = c + 1;
		end
		return c;
	end

	class.GetOutput = function(i)
		local c = 0;
		for outputGuid, output in pairs(outputs) do
			c = c + 1;
			if c == i then
				return outputGuid, output;
			end
		end
		return c;
	end

	class.GetPortInfo = function(direction, i)
		if direction == "in" then
			if i == 1 then
				return "setup", "Setup Action", "Initializes and runs the action."; --todo: loc
			end
			i = i - 1;
		end

		if direction == "out" and gotOnSetupPort then
			if i == 1 then
				return "onsetup", "Setup Done", "Fired when the action is set up.";  --todo: loc
			end
			i = i - 1;
		end


		local order;
		if direction == "in" then
			order = portsOrderIn;
		elseif direction == "out" then
			order = portsOrderOut;
		end
		if order and order[i] then
			local portGuid = order[i];
			local port = ports[portGuid];
			return portGuid, port.name, port.description;
		end
		return;
	end


	-- menu functions
	local menus = {};

	local GenerateTextboxData = function(name, id)
		return {
			type = "Editbox",
			text = name,
			align = "l",
			label = id,
			width = 150,
			texture = "Tooltip",
		};
	end

	local envList = GHI_ScriptEnvList();

	local GenerateMenu = function(parent,itemAuthorGuid)
		local menuPageData = {};
		local menuFrame;

		table.insert(menuPageData, {
			{
				type = "Dummy",
				height = (math.floor(description:len() / 70) + 2) * 10,
				width = 10,
				align = "c",
			},
			{
				type = "Text",
				fontSize = 11,
				text = description,
				align = "l",
				color = "white",
				width = 380,
			},
		});
		if class.GetInputsCount() > 0 then
			table.insert(menuPageData, {
				{
					type = "Text",
					fontSize = 14,
					text = "Inputs:",
					align = "l",
					color = "yellow",
					width = 100,
				},
			});

			local line = {};
			local inputsSorted = {};
			for i,v in pairs(inputs) do
				table.insert(inputsSorted,{
					inputGuid=i, input=v,
				})
			end
			table.sort(inputsSorted,function(i1,i2) if not(i1.input.order) or i1.input.order>= (i2.input.order or 0) then return false; else return true end end)
			for _,inputInfo in pairs(inputsSorted) do
				local inputGuid,input = inputInfo.inputGuid,inputInfo.input;
				local m = GHM_Input_GenerateMenuObject(input.type, input.name..":", "_in_" .. inputGuid,input.specialGHM);
				local size = m.size or "S";
				local limit = line.limit or 4;

				if input.specialGHM == "ghm_fromDDList" or input.specialGHM == "ghm_fromRadio" then
					local env = envList.GetEnv(itemAuthorGuid);
					env.ExecuteScript(""..input.specialGHMScript);
					m.dataFunc = env.GetValue("dataFunc");
					if m.UpdateButtons then
						m.UpdateButtons();
					end
				end

				if (size == "L" and #(line) > 0) or (size == "M" and #(line) > 1) then
					table.insert(menuPageData, line);
					line = {};
					limit = 4;
				end

				local align;
				local xOff;
				if (size == "L") then
					align = "c";
					limit = 1;
				elseif (size == "M") then
					limit = 3;
					if #(line) == 0 then
						align = "l";
					else
						align = "r";
					end
				elseif (size == "S") then
					if limit == 4 then
						if #(line) == 0 then
							align = "l";
							xOff = 3
						elseif #(line) == 1 then
							align = "l";
							xOff = 3
						elseif #(line) == 2 then
							align = "l";
							xOff = 3
						else
							align = "l";
							xOff = 3
						end
					elseif limit == 2 then
						align = "r";
					end
				else
					error("unknown size");
				end

				m.tooltip = input.description;
				m.align = align;
				m.xOff = xOff;
				table.insert(line, m);

				line.limit = limit;
				if #(line) == limit then
					table.insert(menuPageData, line);
					line = {};
				end
			end

			if #(line) > 0 then
				table.insert(menuPageData, line);
			end
		end

		if class.GetOutputsCount() > 0 then
			if class.GetInputsCount() > 0 then
				table.insert(menuPageData, {
					{
						type = "HBar",
						align = "c",
						width = 380,
					},
				});
			end
			table.insert(menuPageData, {
				{
					type = "Text",
					fontSize = 14,
					text = "Outputs:",
					align = "l",
					color = "yellow",
					width = 100,
				},
			});

			local line = {};
			for outputGuid, output in pairs(outputs) do
				local align = "l";

				if #(line) == 1 then
					align = "c";
				elseif #(line) == 2 then
					align = "r";
				end

				local m = {
					type = "Editbox",
					outputOnly = true,
					width = 130,
					texture = "Tooltip",
					align = align,
					text = output.name,
					label = "_out_" .. outputGuid,
					tooltip = output.description,
				};

				table.insert(line, m);


				if #(line) == 3 then
					table.insert(menuPageData, line);
					line = {};
				end
			end

			if #(line) > 0 then
				table.insert(menuPageData, line);
			end
		end

		table.insert(menuPageData, {
			{
				type = "Dummy",
				height = 10,
				width = 100,
				align = "l",
			},
			{
				type = "Button",
				text = OKAY,
				align = "l",
				label = "ok",
				compact = false,
				OnClick = function() menuFrame.OnOk() end,
			},
			{
				type = "Dummy",
				height = 10,
				width = 100,
				align = "r",
			},
			{
				type = "Button",
				text = CANCEL,
				align = "r",
				label = "cancel",
				compact = false,
				OnClick = function(obj)
					menuFrame:Hide();
				end,
			},
		});


		menuFrame = GHM_NewFrame(parent, {
			[1] = menuPageData,
			title = name,
			name = guid .. #(menus) + 1,
			theme = "BlankTheme",
			width = 524,
			useWindow = true,
			icon = icon,
			lineSpacing = 20,
			OnShow = function()
				menuFrame.inUse = true;
			end,
			OnHide = function()
				if not (menuFrame.window:IsShown()) then
					menuFrame.inUse = false;
				end
			end,
		});

		table.insert(menus, menuFrame);
		return menuFrame;
	end

	class.GetFreeMenu = function(parent,itemAuthorGuid)
		for _, menu in pairs(menus) do
			if not (menu.inUse == true) then
				return menu;
			end
		end
		return GenerateMenu(parent,itemAuthorGuid);
	end

	class.AllowedInUpdateSequence = function()
		return allowedInUpdateSequence;
	end

	class.GetSpecialActionCategory = function()
		return specialActionCategory;
	end

	class.GetVersion = function()
		return version;
	end

	class.RequiredDisabledMenuElements = function()
		return requiredDisabledMenuElements;
	end

	class.Serialize = function()
		local t = {
			guid = guid,
			name = name,
			description = description,
			icon = icon,
			category = category,
			version = version,
			authorGuid = authorGuid,
			authorName = authorName,
			script = script,
			ports = ports,
			inputs = inputs,
			outputs = outputs,
			gotOnSetupPort = gotOnSetupPort,
			allPortsTriggerScript = allPortsTriggerScript,
			allowedInUpdateSequence = allowedInUpdateSequence,
			specialActionCategory = specialActionCategory,
			requiredDisabledMenuElements = requiredDisabledMenuElements,
		};

		return t;
	end

	return class;
end
