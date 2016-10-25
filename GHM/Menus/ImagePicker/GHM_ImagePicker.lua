--
--					GHM_ImagePicker
--				  GHM_ImagePicker.lua
--
--		Window for choosing an icon in a GHM window
--
-- 			(c)2013 The Gryphonheart Team
--				  All rights reserved
--

local menuIndex = 1;

function GHM_ImagePicker()

	local class = GHClass("GHM_ImagePicker");
	
	local miscApi = GHI_MiscAPI().GetAPI();
	local loc = GHI_Loc()

	local selectedIcon -- Path of selected icon
	local OnOkCallback
	local selectedImage, selectedIndex, selectedX, selectedY -- Path of selected image
	local currentImage = 1
	local chosenImages = {}
	local defaultImage = "Interface\\Icons\\INV_MISC_FILM_01"
	
	local menuFrame
	local inUse;
	
	if not (GHM_IMGLIST) then
			GHM_LoadImageList()
	end
	if not (GHM_IMGCATLIST) then
			GHM_GetImageCat()
	end
	
	local imageCatMenu = {}
	for i,v in pairs(GHM_IMGCATLIST) do
	  
		tempData = {}
		tempData.text = i
		tempData.value = i
		tempData.notCheckable = true
		if type(v) == "table" then
			tempData.hasArrow = true
			tempData.menuList ={}
			for i2,v2 in pairs(v) do
				local subMenuTemp1 = {}
				subMenuTemp1.text = v2
				subMenuTemp1.value = i2
				subMenuTemp1.notCheckable = true
				if type(v2) == "table" then
					subMenuTemp1.text = i2
					subMenuTemp1.hasArrow = true
					subMenuTemp1.menuList ={}
					for i3,v3 in pairs(v2) do
						local subMenuTemp2 = {}
						subMenuTemp2.text = v3
						subMenuTemp2.value = v3
						subMenuTemp2.index = i3
						subMenuTemp2.notCheckable = true
						tinsert(subMenuTemp1.menuList,subMenuTemp2)
					end
				end
				tinsert(tempData.menuList,subMenuTemp1)
			end
		end
		tinsert(imageCatMenu, tempData)
	end
	
	while _G["GHM_Image_Picker" .. menuIndex] do
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
					data= imageCatMenu,
					OnSelect = function(index, value)
						
						if GHM_IMGLIST[value] and menuFrame then
							menuFrame.ForceLabel("images",GHM_IMGLIST[value])
						end
						
					end,
				},
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
						local searchList = {}
						for _,cat in pairs(GHM_IMGLIST) do
							for i,v in pairs(cat) do
								if strfind(strlower(v.p), strlower(text)) then
									tinsert(searchList, v)
								end
							end
						end
						menuFrame.ForceLabel("images",searchList)
					end
				}, 
				{
					type = "ButtonWithIcon",
					align = "r",
					tooltip = loc.ICON_UNDO,
					label = "undo",
					path = "Interface\\PaperDollInfoFrame\\UI-GearManager-Undo",
					OnClick = function()
						if #chosenImages > 1 then
							tremove(chosenImages,currentImage)
							currentImage = #chosenImages
							menuFrame.ForceLabel("current", chosenImages[currentImage].p, chosenImages[currentImage].x, chosenImages[currentImage].y)
							selectedImage, selectedX, selectedY = chosenImages[currentImage].p, chosenImages[currentImage].x, chosenImages[currentImage].y
						elseif #chosenImages <= 1 then
							tremove(chosenImages,currentImage)
							menuFrame.ForceLabel("current", defaultImage, 256, 256)
							selectedImage, selectedX, selectedY = defaultImage, 256, 256
						end
					end,
				},
			},
			{
				{
					type = "ImageList",
					align = "l",
					height = 256,
					width = 256,
					label = "images",
					OnSelect = function(self, button, _path, _index, _X, _Y)
						selectedImage, selectedIndex, selectedX, selectedY = _path, _index, _X, _Y
						tinsert(chosenImages,{p = selectedImage, x = selectedX, y = selectedY})				
						currentImage = #chosenImages
						if menuFrame then
							menuFrame.ForceLabel("current", selectedImage, selectedX, selectedY)
						end
					end,
				},
				{
					type="Texture",
					align = "r",
					width = 256,
					height = 256,
					label = "current",
					path = defaultImage,
				},
			},
			{
				{
					type = "Button",
					text = OKAY,
					align = "l",
					label = "ok",
					xOff = 100,
					compact = false,
					OnClick = function()
						if not (selectedImage) then
							menuFrame:Hide()
							return
						end
						if OnOkCallback then
							OnOkCallback(selectedImage, selectedX, selectedY);
						end
						menuFrame:Hide()
						local list = menuFrame.GetLabelFrame("images")
						list.Clear()
					end,
				},
				{
					type = "Button",
					text = CANCEL,
					align = "r",
					label = "cancel",
					xOff = -100,
					compact = false,
					OnClick = function(obj)
						menuFrame:Hide()
						local list = menuFrame.GetLabelFrame("images")
						list.Clear()
					end,
				},
			},
		},
		title = "Image Picker",
		name = "GHM_Image_Picker"..menuIndex,
		theme = "BlankTheme",
		height = 350,
		width = 512,
		useWindow = true,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	}

	menuFrame = GHM_NewFrame(class, t);
	
	class.New = function(_OnOkCallback)
		OnOkCallback = _OnOkCallback;
		for i, v in pairs(GHM_IMGLIST) do
			menuFrame.ForceLabel("images",v);
			break;
		end
		menuFrame:Show();
		inUse = true;
	end
	
	class.Edit = function(path, _OnOkCallback)
		OnOkCallback = _OnOkCallback;
		menuFrame:Show();
		inUse = true;
	end
	
	class.IsInUse = function()
		return inUse;
	end
	
	menuFrame:Hide();
	return class;
end