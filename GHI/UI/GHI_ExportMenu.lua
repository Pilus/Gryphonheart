--===================================================
--
--				GHI_ExportMenu
--  			GHI_ExportMenu.lua
--
--			Menu for export of items
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;

function GHI_ExportMenu()
	if class then
		return class;
	end
	class = GHClass("GHI_ExportMenu");
	local loc = GHI_Loc()
	local menuFrame;
	local miscAPI = GHI_MiscAPI().GetAPI();
	local containerAPI = GHI_ContainerAPI().GetAPI();

	local itemGuid, amount, scriptBefore, req, scriptAfter, containerGuid, containerSlot;

	class.StartExport = function()
		local f = menuFrame;
		local ID = f.ID;
		local exID = f.ExportID;
		local amount = f.GetLabel("amount") or 1;
		local prChar = f.GetLabel("total") or 0;
		local changeID = f.GetLabel("changeID");
		local changeCreator = f.GetLabel("changeCreator");
		local limitType = f.GetLabel("limitation_type");
		local limitFilter = f.GetLabel("limitation_filter");

		local scriptBefore = "IMPORT_REQ = true;";
		local req = "IMPORT_REQ == true";
		local scriptAfter = "";

		-- pr char limitation
		if prChar > 0 then
			scriptBefore = scriptBefore .. " GHI_MiscData = (GHI_MiscData or {}); GHI_MiscData.Import = (GHI_MiscData.Import or {}); local n = GHI_MiscData.Import." .. exID .. "; if not(type(n) == \"number\") then n = 0; end  if not(n < " .. prChar .. ") then IMPORT_REQ = false end";
			scriptAfter = scriptAfter .. " GHI_MiscData.Import." .. exID .. " = (GHI_MiscData.Import." .. exID .. " or 0)+1;"
		end

		-- limitation
		if limitType == 5 then
			scriptBefore = scriptBefore .. " if not(" .. limitFilter .. ") then IMPORT_REQ = false end";
		elseif limitType > 1 then
			local st = {}
			st[2] = "UnitName(\"player\")";
			st[3] = "GetGuildInfo(\"player\")";
			st[4] = "GetRealmName()"
			if st[limitType] then
				scriptBefore = scriptBefore .. " local t = {strsplit(\",\",\"" .. limitFilter .. "\")}; local found; for i=1,#(t) do if strlower(strtrim(t[i] or \"\")) == strlower(" .. st[limitType] .. ") then found = true; end end if not(found == true) then IMPORT_REQ = false end"
			end
		end

		-- change creator
		if changeCreator == 1 or changeCreator == true then
			scriptAfter = scriptAfter .. " G_Import.item.creater = UnitName(\"player\");"
			-- also change ID
			scriptAfter = scriptAfter .. " G_Import.ID = GHI_GUID().MakeGUID();"
		elseif changeID == 1 or changeID == true then -- change ID
			scriptAfter = scriptAfter .. " G_Import.ID = GHI_GUID().MakeGUID();"
		end

		local s = containerAPI.GHI_GenerateExportCode(itemGuid, amount, scriptBefore, req, scriptAfter, containerGuid, containerSlot)
		_G[f.GetLabelFrame("code"):GetName() .. "AreaScrollText"]:SetMaxLetters((s or ""):len() + 5)

		if amount > 0 then
			f.ForceLabel("code", s);
		else
			GHI_Message("Amount must be more then 0, Export halted.")
		end
	end

	class.Show = function(guid,_containerGuid, _containerSlot)
		containerGuid, containerSlot = _containerGuid, _containerSlot;
		menuFrame:AnimatedShow();
		itemGuid = guid;
	end

	local OnOk = function()
		local main = menuFrame;
		menuFrame.ForceLabel("code", "")
		main:Hide()
	end

	local OnShow = function()
		menuFrame.ForceLabel("code", "")
		menuFrame.ForceLabel("amount",1)
	end

	-- Menu setup
	local icon = "Interface\\Icons\\INV_Crate_04";
	menuFrame = GHM_NewFrame(class,
	{
		OnShow = OnShow,
		OnOk = function(self) end,
		{
			{
				{
					align = "l",
					type = "Text",
					text = loc.ITEM_INFO,
					label = "iteminfo",
					fontSize = 14,
					color = "white",
					width = 100
				},
			},
			{
				{
					height = 25,
					type = "Dummy",
					align = "l",
					width = 10,
				},
				{
					type = "Editbox",
					text = loc.AMOUNT,
					align = "l",
					label = "amount",
					texture = "Tooltip",
					width = 50,
					numbersOnly = true,
				},
				{
					height = 25,
					type = "Dummy",
					align = "l",
					width = 100,
				},
				{
					type = "Editbox",
					text = loc.TOTAL_PR_CHAR,
					align = "l",
					label = "total",
					texture = "Tooltip",
					width = 50,
					numbersOnly = true,
				},
			},
			{
				{
					height = 25,
					type = "Dummy",
					align = "l",
					width = 5,
				},
				{
					type = "DropDown",
					text = loc.LIMITED_TO,
					width = 130,
					align = "l",
					label = "limitation_type",
					returnIndex = true,
					data = { loc.NONE, loc.CHARS, loc.GUILDS, loc.REALMS, loc.EXPORT_LUA_STATEMENT },
				},
				{
					height = 25,
					type = "Dummy",
					align = "c",
					width = 200,
				},
				{
					type = "Editbox",
					text = loc.NAMES,
					align = "c",
					texture = "Tooltip",
					label = "limitation_filter",
					width = 110,
					numbersOnly = false,
				},
			},
			{
				{
					type = "Text",
					fontSize = 11,
					color = "white",
					width = 260,
					text = loc.EXPORT_LIMITATION_TEXT,
					align = "c",
				},
				{
					height = 25,
					type = "Dummy",
					align = "c",
					width = 10,
				},
			},
			{
				{
					type = "CheckBox",
					text = loc.CHANGE_ID,
					align = "l",
					label = "changeID",
				},
			},
			{
				{
					type = "CheckBox",
					text = loc.CHANGE_USER,
					align = "l",
					label = "changeCreator",
				},
			},
			{
				{
					align = "c",
					type = "Button",
					text = loc.EXPORT,
					label = "Export",
					onclick = function()
						class.StartExport()
					end,
				},
			},
			{
				{
					align = "c",
					label = "code",
					type = "EditField",
					width = 400,
					height = 250,
				},
			},
			{
				{
					height = 70,
					type = "Dummy",
					align = "l",
					width = 10,
				},
				{
					align = "c",
					type = "Text",
					text = loc.EXPORT_TEXT,
					fontSize = 11,
					color = "white",
					width = 300,
				},
			},
			{
				{
					align = "c",
					type = "Button",
					text = loc.ICON_CLOSE,
					label = "close",
					onclick = function()
						menuFrame:Hide();
					end,
				},
			},
		},
		title = loc.EXPORT,
		name = "GHI_ExportMenuUI",
		theme = "BlankTheme",
		width = 400,
		useWindow = true,
	});

	return class;
end

