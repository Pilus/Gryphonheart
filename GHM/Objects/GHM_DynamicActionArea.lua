--===================================================
--
--				GHM_DynamicActionArea
--  			GHM_DynamicActionArea.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local loc;
local frame  = CreateFrame("Frame");
frame:RegisterEvent("VARIABLES_LOADED");
frame:SetScript("OnEvent",function()
     loc = GHI_Loc();
end)

local cursor;
local UNIT_SIZE = 20;
local ACTION_FRAME_LEVEL = 2;
local PORT_FRAME_LEVEL = 5;
local function GetTableCoor(column, row)
	return column * UNIT_SIZE - 5, -row * UNIT_SIZE + 5;
end

local function SetFramePos(frame, column, row)
	frame:SetPoint("CENTER", frame:GetParent(), "TOPLEFT", GetTableCoor(column, row));
end

local actionListDD;
local connectionEditDD;
local dynamicActionList;
local UpdateActionArea


local GHI_BRANCH_TEXTURECOORDS = {
	up = {
		[1] = {0.12890625, 0.25390625, 0 , 0.484375},
		[-1] = {0.12890625, 0.25390625, 0.515625 , 1.0}
	},
	down = {
		[1] = {0, 0.125, 0, 0.484375},
		[-1] = {0, 0.125, 0.515625, 1.0}
	},
	left = {
		[1] = {0.2578125, 0.3828125, 0, 0.5},
		[-1] = {0.2578125, 0.3828125, 0.5, 1.0}
	},
	right = {
		[1] = {0.2578125, 0.3828125, 0, 0.5},
		[-1] = {0.2578125, 0.3828125, 0.5, 1.0}
	},
	topright = {
		[1] = {0.515625, 0.640625, 0, 0.5},
		[-1] = {0.515625, 0.640625, 0.5, 1.0}
	},
	topleft = {
		[1] = {0.640625, 0.515625, 0, 0.5},
		[-1] = {0.640625, 0.515625, 0.5, 1.0}
	},
	bottomright = {
		[1] = {0.38671875, 0.51171875, 0, 0.5},
		[-1] = {0.38671875, 0.51171875, 0.5, 1.0}
	},
	bottomleft = {
		[1] = {0.51171875, 0.38671875, 0, 0.5},
		[-1] = {0.51171875, 0.38671875, 0.5, 1.0}
	},
	tdown = {
		[1] = {0.64453125, 0.76953125, 0, 0.5},
		[-1] = {0.64453125, 0.76953125, 0.5, 1.0}
	},
	tup = {
		[1] = {0.7734375, 0.8984375, 0, 0.5},
		[-1] = {0.7734375, 0.8984375, 0.5, 1.0}
	},
};

local GHI_ARROW_TEXTURECOORDS = {
	top = {
		[1] = {0, 0.5, 0, 0.5},
		[-1] = {0, 0.5, 0.5, 1.0}
	},
	right = {
		[1] = {1.0, 0.5, 0, 0.5},
		[-1] = {1.0, 0.5, 0.5, 1.0}
	},
	left = {
		[1] = {0.5, 1.0, 0, 0.5},
		[-1] = {0.5, 1.0, 0.5, 1.0}
	},
};


local function ActionListInitialize(self, level)
	local dropDownMenu = GHM_DropDownMenu()
	if not (dynamicActionList) then
		dynamicActionList = GHI_DynamicActionList();
	end
	local updateAction = self.isUpdateAction;
	if (level == 1) then
		local info = dropDownMenu.DropDownMenu_CreateInfo();
		info.text = loc.CONNECTION;
		info.checked = nil;
		info.func = function()
			cursor.SetCursor("CAST_CURSOR", nil, nil, nil, "CREATE_CONNECTION", actionListDD.actionArea.set, actionListDD.instanceGuid, actionListDD.portGuid)
		end;
		info.icon = "";
		info.value = "connection";
		info.notCheckable = true;
		info.hasArrow = false;
		dropDownMenu.DropDownMenu_AddButton(info);

		local actions = dynamicActionList.GetActions("", updateAction, self.specialActionCategory);
		for _, action in pairs(actions) do
			local info = dropDownMenu.DropDownMenu_CreateInfo();
			info.text = action.GetName();
			info.checked = nil;
			info.func = function()
				dropDownMenu.CloseDropDownMenus();
				local actionInstance = action.GenerateActionInstance(actionListDD.actionArea.set.GetItem().GetAuthorInfo());
				actionInstance.ShowMenu(UIParent, false, function() actionListDD.actionArea.set.AddInstance(actionInstance) UpdateActionArea(actionListDD.actionArea) end, actionListDD.instanceGuid, actionListDD.portGuid, actionListDD.actionArea.set);
			end;
			info.icon = action.GetIcon();
			info.value = action.GetGUID();
			info.notCheckable = true;
			info.hasArrow = false;
			dropDownMenu.DropDownMenu_AddButton(info);
		end

		local cats = dynamicActionList.GetCategories(updateAction);
		for _, cat in pairs(cats) do
			if cat ~= "" then
				local info = dropDownMenu.DropDownMenu_CreateInfo();
				info.text = cat;
				info.checked = nil;
				info.func = function() end;
				info.icon = "";
				info.value = cat;
				info.notCheckable = true;
				info.hasArrow = true;
				dropDownMenu.DropDownMenu_AddButton(info);
			end
		end
	else
		local actions = dynamicActionList.GetActions(dropDownMenu.MENU_VALUE, updateAction);
		for _, action in pairs(actions) do
			local info = dropDownMenu.DropDownMenu_CreateInfo();
			info.text = action.GetName();
			info.checked = nil;
			info.func = function()
				dropDownMenu.CloseDropDownMenus();
				local actionInstance = action.GenerateActionInstance(actionListDD.actionArea.set.GetItem().GetAuthorInfo());
				actionInstance.ShowMenu(UIParent, false, function() actionListDD.actionArea.set.AddInstance(actionInstance) UpdateActionArea(actionListDD.actionArea) end, actionListDD.instanceGuid, actionListDD.portGuid, actionListDD.actionArea.set);
			end;
			info.icon = action.GetIcon();
			info.value = action.GetGUID();
			info.notCheckable = true;
			info.hasArrow = false;
			dropDownMenu.DropDownMenu_AddButton(info, level);
		end
	end
end

local function ConnectionEditInitialize(self)
	local dropDownMenu = GHM_DropDownMenu()
	local info = dropDownMenu.DropDownMenu_CreateInfo();
	info.text =loc.TEST_ACTION;
	info.checked = nil;
	info.func = function()
		local set = connectionEditDD.actionArea.set;
		local actionInstanceGuid = connectionEditDD.instanceGuid;

		local stack = set.GetItem().GenerateStack();

		if actionInstanceGuid == "set" then
			local instance, portGuid = set.GetInstanceAtPort(connectionEditDD.portGuid)
			instance.Execute(portGuid, stack);
		else
			local instance = set.GetInstance(actionInstanceGuid);
			instance.Execute(connectionEditDD.portGuid, stack);
		end
	end;
	info.icon = "";
	info.value = "run";
	info.notCheckable = true;
	info.hasArrow = false;
	dropDownMenu.DropDownMenu_AddButton(info);

	local info = dropDownMenu.DropDownMenu_CreateInfo();
	info.text = loc.DELETE_CONNECT;
	info.checked = nil;
	info.func = function()
		local set = connectionEditDD.actionArea.set;
		local actionInstanceGuid = connectionEditDD.instanceGuid;
		local instance = set.GetInstance(actionInstanceGuid);
		instance.SetPortConnection(connectionEditDD.portGuid,nil,nil);
		UpdateActionArea(connectionEditDD.actionArea);
	end;
	info.icon = "";
	info.value = "delete";
	info.notCheckable = true;
	info.hasArrow = false;
	dropDownMenu.DropDownMenu_AddButton(info);

	local info = dropDownMenu.DropDownMenu_CreateInfo();
	info.text = loc.EDIT_CONNECT;
	info.checked = nil;
	info.func = function() end;
	info.icon = "";
	info.value = "edit";
	info.notCheckable = true;
	info.hasArrow = false;
	dropDownMenu.DropDownMenu_AddButton(info);
end

local PortOnClick = function(self)
	local dropDownMenu = GHM_DropDownMenu()
	local cursorType, set, startInstanceGuid, startPortGuid = cursor.GetCursor();
	local actionArea = self:GetParent()
	if cursorType == "CREATE_CONNECTION" and set == actionArea.set then
		if self.direction == "in" then
			local startInstance = set.GetInstance(startInstanceGuid);
			local endInstance = set.GetInstance(self.instanceGuid);
			local endPortGuid = self.portGuid;
			if self.isConnected == true then
				local _, _, _, connection = endInstance.GetPortInfo(endInstance.IdentifyPort(endPortGuid))
				local currentConnectedInstance, currentConnectedPort = connection.instance, connection.portGuid;

				local CreateTheConnection = function()
					local action = dynamicActionList.GetAction("or_01");
					local orInstance = action.GenerateActionInstance(actionListDD.actionArea.set.GetItem().GetAuthorInfo());
					set.AddInstance(orInstance);

					if currentConnectedInstance.GetType() == "GHI_DynamicActionInstanceSet" then
						currentConnectedInstance.SetInstanceAtPort(currentConnectedPort, orInstance, "in1");
					else
						currentConnectedInstance.SetPortConnection(currentConnectedPort, orInstance, "in1");
					end
					if startInstance.GetType() == "GHI_DynamicActionInstanceSet" then
						startInstance.SetInstanceAtPort(currentConnectedPort, orInstance, "in2");
					else -- currentConnectedInstance is the set
						startInstance.SetPortConnection(startPortGuid, orInstance, "in2");
					end

					orInstance.SetPortConnection("out", endInstance, endPortGuid);
					UpdateActionArea(actionArea);
				end

				-- todo: ask if an "or" action should be inserted
				CreateTheConnection();
				cursor.ClearCursor();
			else
				startInstance.SetPortConnection(startPortGuid, endInstance, endPortGuid);
				UpdateActionArea(actionArea);
				cursor.ClearCursor();
			end
		end
	else
		if self.isConnected == true then
			if not (connectionEditDD) then
				connectionEditDD = CreateFrame("Frame", "GHI_connectionEditDD", UIParent, "GHM_DropDownMenuTemplate");
				dropDownMenu.DropDownMenu_Initialize(connectionEditDD, ConnectionEditInitialize, "MENU");
			end
			connectionEditDD.actionArea = actionArea;
			connectionEditDD.portGuid = self.portGuid;
			connectionEditDD.instanceGuid = self.instanceGuid;
			dropDownMenu.ToggleDropDownMenu(1, nil, connectionEditDD, self, 0, 20);
		elseif self.direction == "out" then
			if not (actionListDD) then
				actionListDD = CreateFrame("Frame", "GHI_ActionListDD", UIParent, "GHM_DropDownMenuTemplate");
				actionListDD.specialActionCategory = actionArea.specialActionCategory;
				dropDownMenu.DropDownMenu_Initialize(actionListDD, ActionListInitialize, "MENU");
			end
			actionListDD.actionArea = actionArea;
			actionListDD.portGuid = self.portGuid;
			actionListDD.instanceGuid = self.instanceGuid;
			actionListDD.isUpdateAction = self.isUpdateAction;
			actionListDD.specialActionCategory = actionArea.specialActionCategory;
			dropDownMenu.ToggleDropDownMenu(1, nil, actionListDD, self, 0, 20);
		end
	end
end



local DeleteActionOnClick = function(actionFrame)
	local instanceGuid = actionFrame.instanceGuid;
	local actionArea = actionFrame:GetParent();
	local set = actionArea.set;
	local actionInstance = set.GetInstance(instanceGuid);
	actionInstance.DisconnectAction();
	set.RemoveInstance(actionInstance);
	UpdateActionArea(actionArea);
end

local EditActionOnClick = function(actionFrame)
	local dropDownMenu = GHM_DropDownMenu()
	local instanceGuid = actionFrame.instanceGuid;
	local actionArea = actionFrame:GetParent();
	local set = actionArea.set;
	local actionInstance = set.GetInstance(instanceGuid);
	actionInstance.ShowMenu(UIParent, true, function()

		UpdateActionArea(actionArea)
	end, nil, nil, set);
end

local nonUsedBranches = {};
local function SetBranch(parent, branchType, column, row, gotArrow)
	local dropDownMenu = GHM_DropDownMenu()
	local frame;
	if #(nonUsedBranches) > 0 and false then
		frame = tremove(nonUsedBranches);
	else
		frame = CreateFrame("Frame", nil, parent)
		frame:SetWidth(20)
		frame:SetHeight(20)
		frame.t = frame:CreateTexture()
		frame.t:SetAllPoints(frame);
		frame.t:SetTexture("Interface/TALENTFRAME/UI-TalentBranches");
	end

	if gotArrow then
		if not (frame.arrow) then
			local arrow = CreateFrame("Frame", nil, frame)
			arrow.t = arrow:CreateTexture()
			arrow:SetWidth(26)
			arrow:SetHeight(26)

			arrow.t:SetTexture("Interface/TALENTFRAME/UI-TalentArrows");
			arrow:SetPoint("LEFT", frame, "LEFT", 5, 0);
			arrow.t:SetAllPoints(arrow);

			frame.arrow = arrow;
		end
		frame.arrow:SetFrameLevel(frame:GetFrameLevel() + 1);
		frame.arrow:Show();
		frame.arrow.t:SetTexCoord(unpack(GHI_ARROW_TEXTURECOORDS["left"][-1]));
	elseif frame.arrow then
		frame.arrow:Hide();
	end

	SetFramePos(frame, column, row);
	frame.t:SetTexCoord(unpack(GHI_BRANCH_TEXTURECOORDS[branchType][-1]));
	frame:Show();
	tinsert(parent.usedBranches, frame);
end

local function RemoveBranch(frame)
	local dropDownMenu = GHM_DropDownMenu()
	frame:Hide();
	table.insert(nonUsedBranches, frame);
end

local nonUsedPorts = {};
local function SetPort(parent, guid, instanceGuid, name, description, column, row, direction, isConnected, isUpdateAction)
	local dropDownMenu = GHM_DropDownMenu()
	local frame;
	if #(nonUsedPorts) > 0 and false then
		frame = tremove(nonUsedPorts);
	else
		frame = CreateFrame("Button", nil, parent, "GHM_ActionAreaPort_Template");

		frame:SetScript("OnEnter", function()
			GameTooltip:SetOwner(frame, "ANCHOR_LEFT");
			GameTooltip:ClearLines()
			GameTooltip:AddLine("Port: " .. frame.name);
			GameTooltip:AddLine(frame.description, 1.0, 1.0, 1.0, true);
			if frame.direction == "out" then
				if frame.isConnected == true then
					GameTooltip:AddLine(loc.DYN_AREA_TIPEDIT, 0.1176, 1.0, 0.0, true);
				else
					GameTooltip:AddLine(loc.DYN_AREA_TIPADD, 0.1176, 1.0, 0.0, true);
				end
			end
			GameTooltip:Show()
		end);
		frame:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end);
		frame:SetScript("OnClick", PortOnClick)
	end
	frame:SetParent(parent)
	frame:SetFrameLevel(parent:GetFrameLevel() + PORT_FRAME_LEVEL);
	frame.name = name;
	frame.description = description;
	frame.direction = direction;
	frame.isConnected = isConnected;
	frame.portGuid = guid;
	frame.instanceGuid = instanceGuid;
	frame.isUpdateAction = isUpdateAction;
	SetFramePos(frame, column, row);
	frame:Show();
	tinsert(parent.usedPorts, frame);
end

local nonUsedActionBGs = {}
local function SetAction(parent, guid, name, icon, description, column, row, width, height)
	local dropDownMenu = GHM_DropDownMenu()
	local frame;
	if #(nonUsedActionBGs) > 0 and false then
		frame = tremove(nonUsedActionBGs);
	else
		frame = CreateFrame("Button", nil, parent);
		frame:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		});
		frame:SetBackdropColor(0.0, 0.0, 0.0, 1.0);

		frame.icon = frame:CreateTexture(nil, "NORMAL");
		frame.icon:SetWidth(UNIT_SIZE+5);
		frame.icon:SetHeight(UNIT_SIZE+5);
		frame.icon:SetPoint("TOP", frame, "TOP", 0, -20);

		frame:SetScript("OnEnter", function()
			GameTooltip:SetOwner(frame, "ANCHOR_LEFT");
			GameTooltip:ClearLines()
			GameTooltip:AddLine(frame.name);
			GameTooltip:AddLine(frame.description, 1.0, 1.0, 1.0, true);
			GameTooltip:Show()
		end);
		frame:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end);

		frame.deleteButton = CreateFrame("Button", nil, frame);
		frame.deleteButton:SetWidth(24);
		frame.deleteButton:SetHeight(24);
		frame.deleteButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0);
		frame.deleteButton:SetNormalTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Up");
		frame.deleteButton:SetPushedTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Down");
		frame.deleteButton:SetScript("OnEnter", function()
			GameTooltip:SetOwner(frame.deleteButton, "ANCHOR_RIGHT");
			GameTooltip:ClearLines()
			GameTooltip:AddLine("Delete Action");
			GameTooltip:Show()
		end);
		frame.deleteButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end);
		frame.deleteButton:SetScript("OnClick", function()
			DeleteActionOnClick(frame);
		end)

		frame.editButton = CreateFrame("Button", nil, frame);
		frame.editButton:SetWidth(20);
		frame.editButton:SetHeight(20);
		frame.editButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2);
		local t1 = frame.editButton:CreateTexture();
		t1:SetTexture("Interface/GossipFrame/HealerGossipIcon");
		t1:SetAllPoints(frame.editButton);
		t1:SetTexCoord(-0.1, 1.1, -0.1, 1.1);
		frame.editButton:SetNormalTexture(t1);
		local t1 = frame.editButton:CreateTexture();
		t1:SetTexture("Interface/GossipFrame/HealerGossipIcon");
		t1:SetAllPoints(frame.editButton);
		t1:SetTexCoord(-0.06, 1.14, -0.14, 1.06);
		frame.editButton:SetPushedTexture(t1);
		frame.editButton:SetScript("OnEnter", function()
			GameTooltip:SetOwner(frame.editButton, "ANCHOR_RIGHT");
			GameTooltip:ClearLines()
			GameTooltip:AddLine("Edit Action");
			GameTooltip:Show()
		end);
		frame.editButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end);
		frame.editButton:SetScript("OnClick", function()
			EditActionOnClick(frame);
		end)
	end
	frame:SetParent(parent)
	frame:SetFrameLevel(parent:GetFrameLevel() + ACTION_FRAME_LEVEL);
	frame:SetWidth(UNIT_SIZE * (width + 1));
	frame:SetHeight(UNIT_SIZE * (height + 1));
	frame.icon:SetTexture(icon);
	frame.name = name;
	frame.instanceGuid = guid;
	frame.description = description;
	frame:SetPoint("TOPLEFT", frame:GetParent(), "TOPLEFT", GetTableCoor(column, row));
	tinsert(parent.usedActionBgs, frame);
end

local function DrawConnection(self, coor)
	for i = 1, #(coor) - 1 do
		local from = coor[i];
		local to = coor[i + 1];
		SetBranch(self, from.t, from.x, from.y);  -- start element
		if from.x == to.x then    -- vertical lines
			for y = math.min(from.y, to.y) + 1, math.max(from.y, to.y) - 1 do
				SetBranch(self, "up", from.x, y);
			end
		elseif from.y == to.y then  -- horizontal lines
			for x = math.min(from.x, to.x) + 1, math.max(from.x, to.x) - 1 do
				SetBranch(self, "left", x, from.y);
			end
		end
	end
	local last = coor[#(coor)];
	if last then
		SetBranch(self, last.t, last.x, last.y, true);   -- end element
	end
end

local function DrawInstance(self, instance, posX, posY)
	local dropDownMenu = GHM_DropDownMenu()
	local name, icon, description = instance.GetActionInfo();
	local instanceGuid = instance.GetGUID();
	local size = math.max(instance.GetPortsInCount(), instance.GetPortsOutCount());
	SetAction(self, instanceGuid, name, icon, description, posX, posY, 1, size + 1);

	for i = 1, instance.GetPortsInCount() do
		local portGuid, name, description, connectedInstance = instance.GetPortInfo("in", i);
		SetPort(self, portGuid, instanceGuid, name, description, posX, posY + i + 1, "in", connectedInstance and true or false, self.set.IsUpdateSequence());
	end
	for i = 1, instance.GetPortsOutCount() do
		local portGuid, name, description, connectedInstance = instance.GetPortInfo("out", i);
		SetPort(self, portGuid, instanceGuid, name, description, posX + 2, posY + i + 1, "out", connectedInstance and true or false, self.set.IsUpdateSequence());
	end
end

UpdateActionArea = function(self)
	local dropDownMenu = GHM_DropDownMenu()
	
	for _, f in pairs(self.usedActionBgs or {}) do
		f:Hide();
		tinsert(nonUsedActionBGs, f);
	end
	self.usedActionBgs = {};


	for _, f in pairs(self.usedPorts or {}) do
		f:Hide();
		tinsert(nonUsedPorts, f);
	end
	self.usedPorts = {};

	for _, f in pairs(self.usedBranches or {}) do
		f:Hide();
		tinsert(nonUsedBranches, f);
	end
	self.usedBranches = {};

	--[[
	self.drawnActions = {};
	local ports = self.set.GetAvailablePorts();

	local instance = self.set.GetInstanceAtPort(ports[1]);
	SetPort(self,ports[1],"set","On Click","Port triggered when the item is right clicked.",1,3,"out",instance and true or false);
	if instance then
		DrawInstance(self,instance,{1,3});
	end  --]]

	--local ports = self.set.GetAvailablePorts();
	--local instance = self.set.GetInstanceAtPort(ports[1]);
	--DrawInstance(self,instance,1,1);

	local set = self.set;
	set.UpdateDisplayStructure();

	local gotInstances = false;
	for _, instanceGuid in pairs(set.GetInstanceGuids()) do
		local instance = set.GetInstance(instanceGuid);
		local x, y = set.GetInstanceCoordinates(instanceGuid);
		if x and y then
			DrawInstance(self, instance, x, y);
			gotInstances = true;
		end
	end
	for i, portGuid in pairs(set.GetAvailablePorts()) do
		local x, y = 1,3*i; -- todo: need to be changed when multiple ports in the set is allowed
		local connectedInstance = set.GetInstanceAtPort(portGuid);
		local name,description = set.GetPortInfo(portGuid);

		if x and y then
			SetPort(self, portGuid, "set", name,description, x, y, "out", connectedInstance and true or false, set.IsUpdateSequence());
		end
	end

	for i = 1, set.GetNumConnections() do
		local connectionCoor = set.GetConnectionCoors(i);
		if connectionCoor then
			DrawConnection(self, connectionCoor);
		end
	end

	if gotInstances then
		self.tipFrame:Hide();
	else
		self.tipFrame:Show();
	end

	local h, w = set.GetRequiredSize();
	self:SetHeight(h * UNIT_SIZE);
	self:SetWidth(w * UNIT_SIZE);

	if self.OnChangeFunc then
		self.OnChangeFunc();
	end
end


local count = 1;
function GHM_DynamicActionArea(parent, main, profile)
	
	local frame = CreateFrame("Frame", "GHM_DynamicActionArea" .. count, parent, "GHM_DynamicActionArea_Template");
	count = count + 1;

	if not (cursor) then
		cursor = GHI_CursorHandler();
	end

	if profile.height then
		frame:SetHeight(profile.height);
	end

	if profile.width then
		frame:SetWidth(profile.width);
	end



	local area = _G[frame:GetName() .. "ScrollChild"];

	if profile.OnChangeFunc then
		area.OnChangeFunc = profile.OnChangeFunc;
	end

	area.specialActionCategory = profile.specialActionCategory;
	area.IsDynamicActionArea = true;
	frame.main = main;
	area.main = main;
	area:Show();
	frame.SetDynamicActionInstanceSet = function(set) area.set = set; UpdateActionArea(area); end
	frame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	});
	frame:SetBackdropColor(0.0, 0.0, 0.0, 0.5);

	-- tutorial tip
	local tipFrame = CreateFrame("Frame",nil,area);
	tipFrame:SetWidth(250);
	tipFrame:SetHeight(45);
	tipFrame:SetPoint("TOPLEFT",area,"TOPLEFT",25,-30);
	local tex = tipFrame:CreateTexture();
	tex:SetWidth(70);
	tex:SetHeight(45);
	tex:SetTexture("Interface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME");
	tex:SetPoint("LEFT");
	tex:SetTexCoord(0.48, 0.32, 0.22, 0.35);
	area.tipFrame = tipFrame;
	local fontString = tipFrame:CreateFontString();
	fontString:SetFont("Fonts\\FRIZQT__.TTF",11);
	fontString:SetPoint("LEFT",75,-2);
	fontString:SetText(loc.DYNAMIC_ACTION_TIP);

	-- positioning
	local extraX = profile.xOff or 0;
	local extraY = profile.yOff or 0;

	if profile.align == "c" then
		frame:SetPoint("CENTER", parent, "CENTER", extraX, extraY);
	elseif profile.align == "r" then
		frame:SetPoint("RIGHT", parent.lastRight or parent, "RIGHT", extraX, extraY);
		parent.lastRight = frame;
	else
		if parent.lastLeft then frame:SetPoint("LEFT", parent.lastLeft, "RIGHT", extraX, extraY); else frame:SetPoint("LEFT", parent, "LEFT", extraX, extraY); end
		parent.lastLeft = frame;
	end

	frame:Show();

	return frame;
end

