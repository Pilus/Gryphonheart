--===================================================
--
--				GHM_Image
--  			GHM_Image.lua
--
--	          GHM_Image object for GHM
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;

function GHM_Image(parent, main, profile)
     local loc = GHI_Loc();
	local frame = CreateFrame("Frame", "GHM_Image" .. count, parent, "GHM_Image_Template");
	local area = _G[frame:GetName().."Area"];
	local button = _G[area:GetName().."Button"];
	local buttonImage = _G[area:GetName().."PreviewTexture"]
	count = count + 1;
	local varAttFrame;
	local imagePath, imageX, imageY
	local imageMenuList = GHM_ImageBrowser()

	profile = profile or {};

	local label = _G[frame:GetName() .. "TextLabel"];
	if type(profile.text) == "string" then
		label:SetText(profile.text);
	else
		label:SetText(loc.ATTYPE_IMAGE)
	end
	frame:SetSize(128,160)
	buttonImage:SetTexture("Interface\\Icons\\INV_MISC_FILM_01")
	buttonImage:SetSize(96,96)
	
	button:SetScript("OnClick", function()
		imageMenuList.New(function(selectedImage, selectedX, selectedY)
			imagePath = selectedImage
			imageX = selectedX
			imageY = selectedY
			if selectedX > selectedY then
				local ratio = selectedY / selectedX
				buttonImage:SetSize(96,96*ratio)
			elseif selectedY > selectedX then
				local ratio = selectedX / selectedY
				buttonImage:SetSize(96*ratio,96)
			else
				buttonImage:SetSize(96,96)
			end
			buttonImage:SetTexture(selectedImage)
		end)
	end)	

	-- positioning
	GHM_FramePositioning(frame,profile,parent);

	-- functions
	
	local Force1 = function(data)
		if type(data) == "string" then			
			imagePath = data;
			buttonImage:SetTexture(imagePath)
		elseif type(data) == "table" then
			local texture, x, y = unpack(data)
			if type(texture) == "string" then			
				imagePath = data;
				buttonImage:SetTexture(imagePath)
			else
				print("Invalid Texture")
				return
			end
			if type(x) and type(y) == "number" then
				imageX = x
				imageY = y				
				if imageX > imageY then
					local ratio = imageY / imageX
					buttonImage:SetSize(96,96*ratio)
				elseif imageY > imageX then
					local ratio = imageX / imageY
					buttonImage:SetSize(96*ratio,96)
				else
					buttonImage:SetSize(96,96)
				end
			end		
		end
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then
			varAttFrame:SetValue(inputType, inputValue);

		else -- static
			varAttFrame:Clear();
			imagePath = inputValue;
			buttonImage:SetTexture(imagePath)
		end
	end

	frame.Force = function(self, ...)
		if self ~= frame then return frame.Force(frame, self, ...); end
		local numInput = #({ ... });

		if numInput == 1 then
			Force1(...);
		elseif numInput == 2 then
			Force2(...);
		end
	end

	frame.Clear = function(self)
		buttonImage:SetTexture("Interface\\Icons\\INV_MISC_FILM_01")
		imagePath = nil
		imageX = nil
		imageY = nil
	end


	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, area, frame:GetWidth());
			frame:SetHeight(frame:GetHeight());
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			return imagePath,imageX,imageY
		end
     end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end
	frame:Show();

	return frame;
end



local menuCount = 1;
local menuFrame
function GHM_ImageBrowser()

	local miscApi = GHI_MiscAPI().GetAPI();
	local loc = GHI_Loc()
		
	if not (GHM_IMGLIST) then
			GHM_LoadImageList()
	end
	if not (GHM_IMGCATLIST) then
			GHM_GetImageCat()
	end
	
	local imgCat
	local previewFrame, previewImage
	local selList
	local selectedImage, selectedIndex, selectedX, selectedY -- Path of selected image
	local OnOkCallback
	
	local t = {
	  {
		 {
			{
			  type = "Dummy",
			  align = "c",
			  height = 10,
			  width = 600,
			},
		},
		{
		  {
			  type = "Dummy",
			  align = "7",
			  height = 256,
			  width = 240,
			  label = "ListAnchor",
		  },
		  {
			type = "ImageList",
			align = "c",
			height = 256,
			width = 256,
			scaleX = 1.3,
			scaleY = 1.3,
			label = "image",
			xOff = 0,
			OnSelect = function(self, path)
				selectedImage,selectedIndex = menuFrame.GetLabel("image");
				local selectedX = selList[selectedIndex].x
				local selectedY = selList[selectedIndex].y
				previewImage:SetSize(selectedX,selectedY)
				previewImage:SetTexture(selectedImage)

			end,
		  },
		  {
			  type = "Dummy",
			  align = "r",
			  height = 256,
			  width = 256,
			  label = "preview",
		  },
		},
		{
			{
			  type = "Dummy",
			  align = "c",
			  height = 10,
			  width = 600,
			},
		},
		{
			{
				type = "Dummy",
				height = 10,
				width = 200,
				align = "l",
			},
			{
				type = "Button",
				text = OKAY,
				align = "l",
				label = "ok",
				compact = false,
				OnClick = function()
					if not (selectedImage) then
						menuFrame:Hide()
						return
					end
					selectedX = selList[selectedIndex].x
					selectedY = selList[selectedIndex].y
					if OnOkCallback then
						OnOkCallback(selectedImage, selectedX, selectedY);
					end
						--print(selectedImage, selectedX, selectedY ,selectedIndex)
					menuFrame:Hide()
				end,
			},
			{
				type = "Dummy",
				height = 10,
				width = 200,
				align = "r",
			},
			{
				type = "Button",
				text = CANCEL,
				align = "r",
				label = "cancel",
				compact = false,
				OnClick = function(obj)
					menuFrame:Hide()
					local list = menuFrame.GetLabelFrame("image")
					list.Clear()
				end,
			},
		}
	  },
	  title = "Image Browser",
	  name = "GHM_ImagePicker"..menuCount,
	  theme = "BlankTheme",
	  height = 320,
	  width = 800,
	  useWindow = true,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	}
	menuCount = menuCount + 1;
	menuFrame = GHM_NewFrame("ImageBrowser", t);
	-- Preview Frame
	local previewBackdrop = {
		bgFile = "Interface\\Tooltips\\ChatBubble-Background",
		edgeFile = "Interface\\Tooltips\\ChatBubble-Backdrop",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = {left = 32, right = 32, top = 32, bottom = 32}
	}
	local previewAnchor = menuFrame.GetLabelFrame("preview")
	local previewFrame = CreateFrame("Frame",menuFrame:GetName().."Preview",menuFrame)
	previewFrame:SetSize(275,275)
	previewFrame:SetPoint("CENTER",previewAnchor,"CENTER")
	previewFrame:SetBackdrop(previewBackdrop)
	previewImage = previewFrame:CreateTexture()
	previewImage:SetParent(previewFrame)
	previewImage:SetPoint("CENTER",previewFrame,"CENTER")		
	previewImage:SetTexture("")
	
	-- List View
	local scrollBG = CreateFrame("Frame",nil,menuFrame)
	scrollBG:SetSize(256,256)
	scrollBG:SetPoint("TOPLEFT",menuFrame.GetLabelFrame("ListAnchor"),"TOPLEFT")
	scrollBG:SetBackdrop(
	{
		bgFile = "",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = {left = 16, right = 16, top = 16, bottom = 16},
	})
	local scroll = CreateFrame("ScrollFrame","$parentScroll",scrollBG,"GHM_ScrollFrameTemplate")
	scroll:SetSize(230,250)
	scroll:SetPoint("TOPRIGHT",scrollBG,"TOPRIGHT",-20,-3)
	local tree = CreateFrame("Frame", scroll:GetName() .. "TreeView", scroll, "GHM_TreeView_Template");
	tree:SetHeight(232)
	tree:SetWidth(232)
	tree:SetAllPoints(scroll);
	scroll:SetScrollChild(tree)
	
		-- List View Scripts
	local OnExpand;

	local InsertNode = function(pTree, index, text, nodeValue, tableValue)
		local subTree
		if pTree.Elements and pTree.Elements[index] then
			subTree = pTree.Elements[index];
			subTree.Value = nodeValue;
			subTree.Title.Text:SetText(text);
		else
			subTree = pTree:AddNode(text, nodeValue, pTree:GetWidth() - 15, 15)
			subTree:AddScript("OnExpand", OnExpand);
		end

		subTree:SetMargins(15, 0);
		subTree.tableValue = tableValue;
		if (type(tableValue) == "table") then
			if #(subTree.Elements or {}) == 0 then
				local dummyNode = subTree:AddNode("dummy", "dummy", subTree:GetWidth() - 15, 15);
				dummyNode:AddScript("OnExpand", OnExpand);
			end
		end
		pTree.Elements[index]:Show();
	end

	local function pairsByKeys(t, f)
		local a = {}
		for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0 -- iterator variable
		local iter = function() -- iterator function
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
			end
		end
		return iter
	end
	
	local StringContainsKeyword = function(str)
		local keywords = scroll.keywords or {};
		for _, keyword in pairs(keywords) do
			if not (string.find(string.lower(str), string.lower(keyword))) then
				return false;
			end
		end
		return true;
	end
	
	local TableContainsKeyword;
	TableContainsKeyword = function(pTree, index, tableValue)
		if pTree and pTree.Value then
			index = string.join("", unpack(pTree:GetFullPath())) .. index;
		end
		if index and (StringContainsKeyword(index)) then     -- the whole subtable is okay
			return true;
		end

		if tableValue then
			for i, v in pairs(tableValue) do
				if (StringContainsKeyword(index..i)) then
					return true;
				elseif (type(v) == "table") then
					if TableContainsKeyword(nil, index .. i, v) then
						return true;
					end
				end
			end
		end
		return false;
	end


	OnExpand = function(pTree)
		if not (pTree.refreshing == true) and type(pTree.tableValue) == "table" then
			local i = 1;
			for index, value in pairsByKeys(pTree.tableValue) do
				local name = string.gsub(index, "[\\_]", "");
				name = string.gsub(name, ".mp3", "")
				if type(value) == "table" then
					InsertNode(pTree, i, name, index, value);

					if TableContainsKeyword(pTree, index, value) then
						pTree.Elements[i]:Show();
					else
						pTree.Elements[i]:Hide();
					end

					i = i + 1;
			
				end
			end
			for index, value in pairsByKeys(pTree.tableValue) do
				if type(value) == "string" then
				local name = value;
					InsertNode(pTree, i, name, index, value);
				end
					i = i + 1;
			end
			while pTree.Elements[i] do
				pTree.Elements[i]:Hide();
				i = i + 1;
			end

			pTree.refreshing = true;
			if pTree.Collapse and pTree.Expand then

				pTree:Collapse();
				pTree:Expand();
			end
			pTree:SkipAllHidden()
			pTree.refreshing = false;
		end
	end

	tree.tableValue = GHM_IMGCATLIST;
	local loaded = false;
	tree:SetScript("OnShow", function()
		tree:SetWidth(scroll:GetWidth() - 20);
		OnExpand(tree);
	end)
	tree:AddScript("OnSelectionChange", function(node)
		local cata = node.tableValue
		if type(cata) == "table" then
			return
		else
			selList = GHM_IMGLIST[cata]
			menuFrame.GetLabelFrame("image").SetImages(selList)
		end
	end);



	-- end list view scripts
	
	
	scroll.treeView = tree;
	menuFrame.treeView = tree;
	
	menuFrame.from = {};
	
	menuFrame.New = function(_OnOkCallback)
		OnOkCallback = _OnOkCallback;
		menuFrame:Show();
		inUse = true;
	end
		
	menuFrame.IsInUse = function()
		 return inUse;
	end
	menuFrame:Hide();
	return menuFrame;
end