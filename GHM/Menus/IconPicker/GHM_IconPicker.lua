--===================================================
--					GHM_IconPicker
--				  GHM_IconPicker.lua
--
--		Window for choosing an icon in a GHM window
--
-- 			(c)2013 The Gryphonheart Team
--				  All rights reserved
--===================================================
local menuIndex = 1
function GHM_IconPicker()
	local class = GHClass("GHM_IconPicker");
	
	local miscApi = GHI_MiscAPI().GetAPI();
	local loc = GHI_Loc()

	local selectedIcon -- Path of selected icon
	local OnOkCallback
	
	GHM_LoadIconList()

	local iconCatMenu = {}
	for i,v in pairs(GHM_IconCategories) do
		tempData = {}
		tempData.text = v
		tempData.value = i
		tempData.notCheckable = true
		tempData.hasArrow = true
		tempData.menuList ={}
		for i2,v2 in pairs(GHM_IconSubcategories[v]) do
			local subMenuTemp = {}
			subMenuTemp.text = v2
			subMenuTemp.value = i2
			subMenuTemp.notCheckable = true

			tinsert(tempData.menuList,subMenuTemp)
		end

		tinsert(iconCatMenu, tempData)
	end

	local menuFrame
	local inUse = false;
	local defaultIcon = "Interface\\Icons\\INV_Misc_QuestionMark"
	local chosenIcons = {}
	local iconCat = {}
	
	while _G["GHM_Icon_Picker" .. menuIndex] do
		menuIndex = menuIndex + 1
	end
	
	local t = {
		{
			{
				{
					type = "DropDown",
					align = "l",
					width = 140,
					text = loc.ICON_CATAGORY,
					label = "category",
					data = iconCatMenu,
					OnSelect = function(index, value)
						if iconCat[1] then
							table.wipe(iconCat)
						else
							iconCat = {}
						end
						
						local force = false

						if GHM_StockIcons[value] then
							for i,v in pairs(GHM_StockIcons[value]) do
								tinsert(iconCat, "Interface\\Icons\\"..v)
							end
							force = true
						end
						
						if GHM_GHIIcons[value] then
							for i2, v2 in pairs(GHM_GHIIcons[value]) do
								tinsert(iconCat, "Interface\\AddOns\\GHM\\GHI_Icons\\"..v2)
							end
							force = true
						end

						if force == true then
							menuFrame.ForceLabel("icons",iconCat)
						end
					end,
				},
				{
					type="Texture",
					align = "r",
					width = 48,
					height = 48,
					label = "current",
					path = chosenIcons[currentIcon] or defaultIcon
				},
			},
			{
				{
					type = "Editbox",
					align = "l",
					width = 140,
					text = loc.ICON_SEARCH,
					tooltip = loc.ICON_SEARCH_TT,
					texture = "Tooltip",      
					label = "searchBox",
					OnEnterPressed = function(self)
						local text = self:GetText()
						if strlen(text) >= 3 and strlower(text) ~= "inv" and strlower(text) ~= "mis" and strlower(text) ~= "misc" then
							local searchList = {}
							for _,cat in pairs(GHM_StockIcons) do
								for i,v in pairs(cat) do
									if strfind(strlower(v), strlower(text)) then
										tinsert(searchList, "Interface\\Icons\\"..v)
									end
								end
							end
							for _,cat in pairs(GHM_GHIIcons) do
								for i,v in pairs(cat) do
									if strfind(strlower(v), strlower(text)) then
										tinsert(searchList, "Interface\\AddOns\\GHM\\GHI_Icons\\"..v)
									end
								end
							end
							menuFrame.ForceLabel("icons",searchList)
						elseif strlower(text) == "misc" then
							print("The search returned too many matches. Please be more specific.")
						elseif strlen(text) > 0 and strlen(text) < 3 then
							print("The search returned too many matches. Please be more specific.")
						end
						
					end,
					OnTextChanged = function(self)
						local text = self:GetText()
						if strlen(strlower(text)) >= 3 and strlower(text) ~= "inv" and strlower(text) ~= "mis" and strlower(text) ~= "misc" then
							local searchList = {}
							for _,cat in pairs(GHM_StockIcons) do
								for i,v in pairs(cat) do
									if strfind(strlower(v), strlower(text)) then
										tinsert(searchList, "Interface\\Icons\\"..v)
									end
								end
							end
							for _,cat in pairs(GHM_GHIIcons) do
								for i,v in pairs(cat) do
									if strfind(strlower(v), strlower(text)) then
										tinsert(searchList, "Interface\\AddOns\\GHM\\GHI_Icons\\"..v)
									end
								end
							end
							menuFrame.ForceLabel("icons",searchList)
						end					
					end,
				}, 
				{
					type = "ButtonWithIcon",
					align = "r",
					tooltip = loc.ICON_UNDO,
					label = "undo",
					path = "Interface\\PaperDollInfoFrame\\UI-GearManager-Undo",
					OnClick = function()
						if #chosenIcons > 1 then
							tremove(chosenIcons,currentIcon)
							currentIcon = currentIcon - 1          
							menuFrame.ForceLabel("current", chosenIcons[currentIcon])
							selectedIcon = chosenIcons[currentIcon]
						elseif #chosenIcons <= 1 then
							tremove(chosenIcons,currentIcon)
							menuFrame.ForceLabel("current", defaultIcon)
							selectedIcon = defaultIcon
						end
					end,
				},
			},
			{
				{
					type = "ImageList",
					align = "c",
					height = 250,
					width = 230,
					sizeX = 48,
					sizeY = 48,
					label = "icons",
					OnSelect = function(self)
						local path, index = menuFrame.GetLabel("icons")
						tinsert(chosenIcons,path)
						currentIcon = #chosenIcons
						selectedIcon = chosenIcons[currentIcon]
						menuFrame.ForceLabel("current", chosenIcons[currentIcon]) 
					end,
				},
			},
			{
				{
					type = "Button",
					text = OKAY,
					align = "l",
					label = "ok",
					compact = false,
					OnClick = function(self)
						if not (selectedIcon) then
							menuFrame:Hide()
							return
						end
						if OnOkCallback then
							OnOkCallback(selectedIcon);
						end
						local list = menuFrame.GetLabelFrame("icons")
						list.Clear()
						menuFrame:Hide()
					end,
				},
				{
					type = "Button",
					text = CANCEL,
					align = "r",
					label = "cancel",
					compact = false,
					OnClick = function(self)
						local list = menuFrame.GetLabelFrame("icons")
						list.Clear()
						menuFrame:Hide()
					end,
				},
			},
		},
		title = "Icon Picker",
		name = "GHM_Icon_Picker"..menuIndex,
		theme = "BlankTheme",
		height = 400,
		width = 200,
		useWindow = true,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
			  inUse = false;
			end
		end,
	}

	menuFrame = GHM_NewFrame(class, t );

	class.New = function(_OnOkCallback)
		OnOkCallback = _OnOkCallback;
		defaultIcon = "Interface\\Icons\\INV_Misc_QuestionMark"
		menuFrame.ForceLabel("current", defaultIcon)
		menuFrame.ForceLabel("category","Ability")
		menuFrame:Show();
		inUse = true;
	end
	
	class.Edit = function(iconPath, _OnOKCallback)
		defaultIcon = iconPath
		selectedIcon = defaultIcon
		menuFrame:Show()
		menuFrame.ForceLabel("current", defaultIcon)
	end
		
	class.IsInUse = function()
		 return inUse;
	end
	
	menuFrame:Hide();
	
	return class;
end