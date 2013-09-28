--===================================================
--
--					GHI_BookMenu
--				GHI_BookMenu.lua
--
--				Simple action menu
--
--		(c)2013 The Gryphonheart Team
--				All rights reserved
--===================================================
local loc = GHI_Loc()
local menus = {};
local miscAPI;
local ICON = "Interface\\Icons\\INV_Misc_Book_09";
local NAME = "GHI_BookMenu";
local TYPE = "book";
local TYPE_LOC = loc.BOOK;

function GHI_BookMenu(_OnOkCallback, _editAction)
	if not (miscAPI) then miscAPI = GHI_MiscAPI().GetAPI(); end

	for i, menu in pairs(menus) do
		if _editAction and menu.IsInUse() and menu.editAction == _editAction then
			GHI_Message(loc.ACTION_BEING_EDITED);
			return;
		end
	end
	for i, menu in pairs(menus) do
		if not (menu.IsInUse()) then
			menu.Show(_OnOkCallback, _editAction)
			return menu
		end
	end
	local class = GHClass(NAME);
	table.insert(menus, class);

	local menuFrame, OnOkCallback;
	local inUse = false;
	local menuIndex = 1;
	while _G[NAME .. menuIndex] do menuIndex = menuIndex + 1; end

	class.Show = function(_OnOkCallback, _editAction)
		OnOkCallback = _OnOkCallback;
		inUse = true;
		if (_editAction) then
			class.editAction = _editAction;
			local info = class.editAction.GetInfo();
			
			local font
			if not (info.font) then info.font = GHI_FontList[GHI_BookDefaults.font] end
			if string.find(info.font,".TTF") then
				for i,v in pairs(GHI_FontList) do
					if info.font == v then
						font = i
						break
					end
				end
			end
			
			menuFrame.ForceLabel("bookTitle", info.title);
			if info.extraMat then
				menuFrame.ForceLabel("mat", info.extraMat)
			else
				menuFrame.ForceLabel("mat", info.material)
			end
			menuFrame.ForceLabel("font", font or info.font)
			menuFrame.ForceLabel("nSize", info.n)
			menuFrame.ForceLabel("h1Size", info.h1)
			menuFrame.ForceLabel("h2Size", info.h2)
			local pages = {}
			for i,v in ipairs(info) do
				local pageText = ""
				if v.text1 then pageText = v.text1 end
				if v.text2 then pageText = pageText..v.text2 end
				if v.text3 then pageText = pageText..v.text3 end
				if v.text4 then pageText = pageText..v.text4 end
				if v.text5 then pageText = pageText..v.text5 end
				if v.text6 then pageText = pageText..v.text6 end
				if v.text7 then pageText = pageText..v.text7 end
				if v.text8 then pageText = pageText..v.text8 end
				if v.text9 then pageText = pageText..v.text9 end
				if v.text10 then pageText = pageText..v.text10 end
				pages[i] = pageText
			end
			menuFrame.ForceLabel("text", pages)
		else
			class.editAction = nil;
			menuFrame.ForceLabel("bookTitle", "")
			menuFrame.ForceLabel("text", {""})
			menuFrame.ForceLabel("mat", "Parchment")
			menuFrame.ForceLabel("font", "Frizqt")
			menuFrame.ForceLabel("nSize", "14")
			menuFrame.ForceLabel("h1Size", "22")
			menuFrame.ForceLabel("h2Size", "17")
		end
		menuFrame:AnimatedShow();
	end

	class.IsInUse = function() return inUse; end

	local OnOk = function()
		local action;

		local title = menuFrame.GetLabel("bookTitle")
		local text = menuFrame.GetLabel("text")
		local mat = menuFrame.GetLabel("mat")
		local font = menuFrame.GetLabel("font")
		local n = menuFrame.GetLabel("nSize")
		local h1 = menuFrame.GetLabel("h1Size")
		local h2 = menuFrame.GetLabel("h2Size")
		local pages = {}
		for i,v in pairs(text) do
			local page = {}
			page.text1 = v
			table.insert(pages,page)
		end
		
		local stationary = {
			["Auction"] = "Parchment",
			["Orc"] = "Parchment",
			["Tauren"] = "Parchment",
			["Forsaken"] = "Parchment",
			["Illidari"] = "Stone",
			["Winter"] = "Parchment",
			["Vellum"] = "Parchment",
		}
		local extraMat
		for i,v in pairs(stationary) do
			if mat == i then
				extraMat = i
				mat = v
			end
		end

		if (class.editAction) then
			action = class.editAction;
			local t2 = action.GetInfo();
			
			for i = 1, t2.pages + 1 do
				if t2[i] then
					table.remove(t2,i)
				end
			end
			
			t2.title = title;
			t2.details = title;
			t2.material = mat
			t2.h1 = h1
			t2.h2 = h2
			t2.n = n
			t2.extraMat = extraMat
			t2.pages = #pages
			for i,v in pairs(pages) do
				t2[i] = pages[i]
			end
			t2.font = GHI_FontList[font]
			
			action.UpdateInfo(t2);
		else
			local t = {
				Type = TYPE,
				type_name = TYPE_LOC,
				icon = ICON,
				details = title,
				title = title,
				pages = #pages,
			};
			t["font"] = GHI_FontList[font]
			t["n"] = n
			t["h1"] = h1
			t["h2"] = h2
			t["material"] = mat
			for i,v in pairs(pages) do
				t[i] = pages[i]
			end
			t["extraMat"] = extraMat
			action = GHI_SimpleAction(t);
		end

		if OnOkCallback then
			OnOkCallback(action);
		end
		inUse = false;
		menuFrame:Hide();
	end
	local fonts = {}
	local fontIndex = 1
	for i,v in pairs(GHI_FontList) do
		local newFont = {}
		newFont.value = fontIndex
		newFont.font = v
		newFont.fontSize = 14
		newFont.text = i
		tinsert(fonts, newFont)
		fontIndex = fontIndex + 1
	end

	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				{
					type = "Editbox",
					text = loc.TITLE,
					align = "c",
					label = "bookTitle",
					texture = "Tooltip",
					width = 300,
				},
			},
			{
				{
					type = "DropDown",
					texture = "Tooltip",
					width = 150,
					label = "font",
					align = "l",
					text = "Font:",
					data = fonts,
				},
				{
					type = "Editbox",
					text = "N Size:",
					align = "l",
					label = "nSize",
					texture = "Tooltip",
					width = 60,
					xOff = 10,
					defaultValue = 15,
					numbersOnly = true,
				},
				{
					type = "Editbox",
					text = "H1 Size:",
					align = "l",
					label = "h1Size",
					texture = "Tooltip",
					width = 60,
					xOff = 10,
					defaultValue = 24,
					numbersOnly = true,
				},
				{
					type = "Editbox",
					text = "H2 Size:",
					align = "l",
					label = "h2Size",
					texture = "Tooltip",
					width = 60,
					xOff = 10,
					defaultValue = 19,
					numbersOnly = true,
				},
			},
			{
				{
					type = "DropDown",
					texture = "Tooltip",
					width = 150,
					label = "mat",
					align = "l",
					text = loc.MATERIAL,
					data = {
						{ text = "Parchment",  index=1},
						{ text = "Bronze",  index=2},
						{ text = "Marble",  index=3},
						{ text = "Silver",  index=4},
						{ text = "Stone",  index=5},
						{ text = "Vellum",  index=6},
						{ text = "Auction",  index=7},
						{ text = "Orc",  index=8},
						{ text = "Tauren",  index=9},
						{ text = "Forsaken",  index=10},
						{ text = "Illidari",  index=11},
						{ text = "Winter",  index=12},
						{ text = "Valentine",  index=13},
					},
				},
			},    
			{      
				{
					type = "MultiPageEditField",
					align = "c",
					width = 400,
					height = 400,
					label = "text",
					HTMLtools = true,
					toolbarButtons = {
						{
							texture = "Interface\\Icons\\INV_Misc_Spyglass_03",
							func = function()
								local title = menuFrame.GetLabel("bookTitle")
								local material = menuFrame.GetLabel("material")
								local font = menuFrame.GetLabel("font")
								local N = menuFrame.GetLabel("nSize")
								local H1 = menuFrame.GetLabel("h1Size")
								local H2 = menuFrame.GetLabel("h2Size")
								local extraMat
								for i,v in pairs(GHI_Stationeries) do
									if material == "Illidari" then
										extraMat = material
										material = "Stone"
									elseif material == i then
										extraMat = i
										material = "Parchment"
									end
								end

								local textFrame = menuFrame.GetLabelFrame("text")
								local page = textFrame.currentPage
								local text = menuFrame.GetLabel("text")
								GHI_ShowBook("Preview", nil, title, text[page], 0, material, GHI_FontList[font], N, H1, H2,nil,nil,extraMat,nil)
							end,
							tooltip = "Preview Page",
						},
					}
				},
			},
			{
				{
					type = "Button",
					text = OKAY,
					align = "c",
					label = "ok",
					compact = false,
					OnClick = OnOk,
					xOff = -100,
				},
				{
					type = "Button",
					text = CANCEL,
					align = "c",
					label = "cancel",
					compact = false,
					xOff = 100,
					OnClick = function(obj)
						menuFrame:Hide();
					end,
				},
			},
		},
		title = TYPE_LOC,
		name = NAME .. menuIndex,
		theme = "BlankTheme",
		width = 400,
		height = 600,
		useWindow = true,
		OnShow = UpdateTooltip,
		icon = ICON,
		lineSpacing = 0,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
		});

	class.Show(_OnOkCallback, _editAction)

	return class;
end