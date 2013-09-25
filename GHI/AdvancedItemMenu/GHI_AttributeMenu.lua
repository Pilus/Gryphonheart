--===================================================
--
--				GHI_AttributeMenu
--				GHI_AttributeMenu.lua
--
--	Menu to create or modify attributes
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;

function GHI_AttributeMenu()
	local class = GHClass("GHI_AttributeMenu");

	local menuFrame;
	local OnOk;

	local AttributeTypes = GHM_Input_GetAvailableTypes();
	local AttributeMergeRules = GHM_Input_GetAvailableMergeRules();

	local typeDependingAreas = {};
	local currentSelectedArea;
	local loc = GHI_Loc()
	local HideAllAreas = function()
		local anchor = menuFrame.GetLabelFrame("typeDependingAreaAnchor");
		for i, attTypeName in pairs(AttributeTypes) do
			local areaAnchor = menuFrame.GetLabelFrame(attTypeName .. "Area")
			if areaAnchor then
				local area = areaAnchor:GetParent();
				area:SetPoint("TOPLEFT", anchor, "TOPLEFT");
				area:Hide();
				typeDependingAreas[i] = area;
			end
		end
	end

	local SelectArea = function(i)
		if currentSelectedArea then
			if typeDependingAreas[currentSelectedArea] then
				typeDependingAreas[currentSelectedArea]:Hide();
			end
		end

		if typeDependingAreas[i] then
			currentSelectedArea = i;
			typeDependingAreas[i]:Show();
			--menuFrame:SetHeight(typeDependingAreas[i]:GetHeight() + 195)
		end
	end

	local t = {
		onOk = function(self) end,
		{
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.NAME;
					label = "name",
					texture = "Tooltip",
					width = 100,
				},
				{
					type = "DropDown",
					texture = "Tooltip",
					label = "type",
					align = "c",
					text = loc.TYPE,
					dataFunc = function()
						local t = {};
						for i, attType in pairs(AttributeTypes) do
							if attType then
								t[i] = loc["ATTYPE_" .. attType:upper()] or attType;
							end
						end
						return t;
					end,
					returnIndex = true,
					OnSelect = SelectArea,
				},
				{
					type = "RadioButtonSet",
					texture = "Tooltip",
					label = "modify",
					align = "r",
					text = loc.MODIFY_BY,
					data = {
						loc.MODIFY_OWN_ITEMS,
						loc.MODIFY_ALL_ITEMS,
					},
					returnIndex = true,
				},
			},
			{
				{
					type = "Dummy",
					height = 100,
					width = 100,
					align = "l",
					label = "typeDependingAreaAnchor"
				},
			},
			{
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
					OnClick = function()
						if OnOk then OnOk() end
					end,
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
			},
		},
		title = loc.ATTRIBUTE_TITLE,
		name = "GHI_AttributeMenu" .. count,
		theme = "BlankTheme",
		width = 380,
		height = 250,
		useWindow = true,
		lineSpacing = 20,
	};

	for i, attTypeName in pairs(AttributeTypes) do
		local default = GHM_Input_GenerateMenuObject(attTypeName,loc.ATTRI_DVAL,attTypeName.."_defaultValue",true);

		if default.height then
			default.height = math.min(120,default.height)
		end
		if default.width then
			default.width = math.min(300,default.width)
		end

		local rule = {
			type = "DropDown",
			texture = "Tooltip",
			label = attTypeName.."_merge",
			align = "r",
			text = loc.TEXT_MERGE_RULE,
			dataFunc = function()
				local t = {};
				local rules = AttributeMergeRules[attTypeName];
				if rules then
					for i, rule in pairs(rules) do
						if rule then
							t[i] = loc["MERGE_RULE_" .. rule:upper()] or rule;
						end
					end
				end
				return t;
			end,
			returnIndex = true,
		}

		table.insert(t[1],{
			{
				type = "Dummy",
				height = 10,
				width = 10,
				align = "c",
				label = attTypeName.."Area"
			},
			default,
			rule,
		});
	end

	menuFrame = GHM_NewFrame(class,t);
	count = count + 1;

	menuFrame:Hide();
	HideAllAreas();

	local GetMenuValues = function()

		local name = menuFrame.GetLabel("name");
		if not (name) or string.len(name) == 0 then return false, "Incorrect name"; end

		local attType = AttributeTypes[menuFrame.GetLabel("type")];
		if not (attType) then return false, "Unkown type ("..(menuFrame.GetLabel("type") or "nil")..")"; end

		local modifyVals = { "myItems","allItems" }
		local modify = modifyVals[menuFrame.GetLabel("modify")];
		if not (modify) then return false, loc.MODRULE_ERR; end

		local defaultValue = menuFrame.GetLabel(attType .. "_defaultValue");

		local merge = AttributeMergeRules[attType][menuFrame.GetLabel(attType .. "_merge")];

		return true, { name, attType, nil, defaultValue, modify, merge };
	end

	local SetMenu = function(attribute)
		menuFrame.ForceLabel("name", "");
		menuFrame.ForceLabel("type", 1);
		menuFrame.ForceLabel("modify", 1);

		for _, attType in pairs(AttributeTypes) do
			menuFrame.ForceLabel(attType .. "_defaultValue", "");
			menuFrame.ForceLabel(attType .. "_merge", 1);
		end

		if (attribute) then -- for edit
			local data = attribute.GetInfoTable();
			menuFrame.ForceLabel("name", data.name);
			for index, attType in pairs(AttributeTypes) do
				if attType == data.attType then
					menuFrame.ForceLabel("type", index);
				end
			end

			local modifyVals = { "allItems", "myItems" }
			for index, modify in pairs(modifyVals) do
				if modify == data.modifyAccess then
					menuFrame.ForceLabel("modify", index);
				end
			end

			menuFrame.ForceLabel(data.attType .. "_defaultValue", data.defaultValue);

			for index, mergeRule in pairs(AttributeMergeRules[data.attType] or {}) do
				if mergeRule == data.mergeRule then
					menuFrame.ForceLabel(data.attType .. "_merge", index)
				end
			end
		end
	end

	class.New = function(parentItem, createdFeedbackFunc)
		menuFrame:AnimatedShow();
		OnOk = function()
			local success, vals = GetMenuValues();
			if success then
				local attribute = GHI_Attribute(unpack(vals));
				parentItem.SetAttribute(attribute);

				menuFrame:Hide();
				if createdFeedbackFunc then
					createdFeedbackFunc(attribute)
				end
			else
				print("Add attribute error:",vals)
			end
		end
		SetMenu();
	end

	class.Edit = function(parentItem, editAttribute, createdFeedbackFunc)
		menuFrame:AnimatedShow();
		OnOk = function()
			local success, vals = GetMenuValues();
			if success then
				parentItem.RemoveAttribute(editAttribute)
				local attribute = GHI_Attribute(unpack(vals));
				parentItem.SetAttribute(attribute);

				menuFrame:Hide();
				if createdFeedbackFunc then
					createdFeedbackFunc(attribute)
				end
			else
				print("Edit attribute error:",vals)
			end
		end
		SetMenu(editAttribute);
	end

	return class;
end


