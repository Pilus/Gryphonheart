--===================================================
--
--				GHI_BookEditor
--  			GHI_BookEditor.lua
--
--	 Toggled by  /script GHI_MenuList("GHI_BookEditor").New();
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 0;

function GHI_BookEditor()
	local class = GHClass("GHI_BookEditor");
	count = count + 1;

	local inUse = false;
	local menuFrame
	local loc = GHI_Loc();
	local converter = GHI_BBCodeConverter();
	local itemList = GHI_ItemInfoList();
	local materials = GHI_BookMaterials();

	local action, textFrame, info, item, currentPageShown;
	local prevButton, nextButton, addBeforeButton, addAfterButton, deleteButton;

	local imageMenuList = GHM_ImagePickerList()
	local iconMenuList = GHM_IconPickerList()

	local SaveCurrentPage = function()
		if currentPageShown then
			info[currentPageShown] = info[currentPageShown] or {};
			local bbcode = textFrame.GetValue();
			local simpleHtml = converter.ToSimpleHtml(bbcode);
			info[currentPageShown].text1 = simpleHtml;
		end
	end

	local UpdateNavigationButtons = function()
		if currentPageShown == 1 then
			prevButton:Disable();
		else
			prevButton:Enable();
		end

		if currentPageShown == #(info) then
			nextButton:Disable();
		else
			nextButton:Enable();
		end

		if #(info) == 1 then
			deleteButton:Disable();
		else
			deleteButton:Enable();
		end
	end

	local UpdateToolbar = function()
		menuFrame.GetLabelFrame("bookTheme").Force(info.material);
		menuFrame.GetLabelFrame("bookFont").Force(info.font);
		menuFrame.GetLabelFrame("title").Force(info.title);
	end

	local ShowPage = function(i)
		if info[i] then
			currentPageShown = i;

			local mockup = converter.ToMockup(info[i].text1);
			textFrame.Force(mockup);
			UpdateNavigationButtons();
		end
	end

	class.New = function(...)
		--inUse = true;
		--menuFrame:AnimatedShow();
	end

	class.Edit = function(bookAction, _item, ...)
		action = bookAction;
		item = _item;
		info = action.GetInfo();
		inUse = true;
		ShowPage(1);
		UpdateToolbar();
		menuFrame:AnimatedShow();
	end

	local Revert = function()
		info = action.GetInfo();
		ShowPage(1);
		UpdateToolbar();
	end

	local Save = function()
		SaveCurrentPage();
		action.UpdateInfo(info);
		item.IncreaseVersion(true);
		itemList.UpdateItem(item);
		GHI_MiscData.lastUpdateItemTime = GetTime();
		--menuFrame:Hide();
	end

	class.IsInUse = function() return inUse; end

	local Preview = function()
		SaveCurrentPage();

		local display = GHI_BookDisplay(materials)
		.SetTitle(info.title)
		.SetFont(info.font or "Frizqt", info.n or 15, info.h1 or 24, info.h2 or 19, info.h3 or 17)
		.SetDefaultPageBackgroud(info.material or "Parchment")

		for i=1,#(info) do
			display.AddPage(info[i].text1,"SimpleHTML")
		end



		display.Show();
	end

	local GetHighlightedText = function(frame)
		if not (frame) then return nil end
		local origText = frame:GetText();
		if not (origText) then return nil end

		local cPos = frame:GetCursorPosition();

		frame:Insert("\127");
		local a = string.find(frame:GetText(), "\127");
		local dLen = math.max(0,string.len(origText)-(string.len(frame:GetText())-1));
		frame:SetText(origText);

		frame:SetCursorPosition(cPos);
		local hs, he = a - 1, a + dLen - 1;
		if hs < he then
			frame:HighlightText(hs, he);
			return hs, he;
		end
	end

	local InsertTag = function(tag)
		local tFrame = textFrame:GetFieldFrame();
		local hi1, hi2 = GetHighlightedText(tFrame);

		local inner = "";
		if hi1 and hi2 then
			inner = string.sub(tFrame:GetText(), hi1 + 1, hi2);
		end
		local s = string.format("[%s]%s[/%s]", tag, inner, tag);
		tFrame:Insert(s);
	end

	local bookIconsPath = "Interface\\addons\\GHI\\Texture\\BookIcons";
	local fractionPrIcon = 0.25;
	local GetTexCoord = function(x, y)
		local l = (x-1) * fractionPrIcon;
		local r = x * fractionPrIcon;
		local t = (y-1) * fractionPrIcon;
		local b = y * fractionPrIcon;
		return {l, t, l, b, r, t, r, b};
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

	local SetUpMetaCat = function()
		return {
			name = "Meta",
			{
				{
					type = "StandardButtonWithTexture",
					tooltip = "Undo",
					texture = "Interface\\addons\\GHI\\Texture\\BookIcons",
					texCoord = GetTexCoord(2, 2),
				},
				{
					type = "StandardButtonWithTexture",
					tooltip = "Redo",
					texture = "Interface\\addons\\GHI\\Texture\\BookIcons",
					texCoord = GetTexCoord(3, 2),
				},
			},
			{
				{
					type = "StandardButtonWithTexture",
					texture = "Interface\\addons\\GHI\\Texture\\BookIcons",
					tooltip = "Revert",
					texCoord = GetTexCoord(4, 2),
					onClick = Revert,
				},
				--[[{
					type = "StandardButtonWithTexture",
					texture = "Interface\\addons\\GHI\\Texture\\BookIcons",
					texCoord = GetTexCoord(4, 1),
					onClick = Save,
				},--]]
				{
					type = "StandardButtonWithTexture",
					texture = "Interface\\addons\\GHI\\Texture\\BookIcons",
					tooltip = "Preview",
					texCoord = GetTexCoord(1, 3),
					onClick = Preview,
				},
			},
		};
	end

	local SetFontCat = function()
		return {
			name = "Font",
			{
				{
					type = "TextButton",
					text = "Font color",
				}
			}
		}
	end

	local SetLayoutCat = function()
		return {
			name = "Layout",
			{
				{
					type = "StandardButtonWithTexture",
					tooltip = "Left",
					texture = "Interface\\addons\\GHI\\Texture\\BookIcons",
					texCoord = GetTexCoord(1, 1);
					onClick = function() InsertTag("left") end,
				},
				{
					type = "StandardButtonWithTexture",
					tooltip = "Center",
					texture = "Interface\\addons\\GHI\\Texture\\BookIcons",
					texCoord = GetTexCoord(2, 1);
					onClick = function() InsertTag("center") end,
				},
				{
					type = "StandardButtonWithTexture",
					tooltip = "Right",
					texture = "Interface\\addons\\GHI\\Texture\\BookIcons",
					texCoord = GetTexCoord(3, 1);
					onClick = function() InsertTag("right") end,
				},
			},
			{
				{
					type = "Button",
					text = "H1",
					compact = true,
					height = 24,
					width = 24,
					onClick = function() InsertTag("h1") end,
				},
				{
					type = "Button",
					text = "H2",
					compact = true,
					height = 24,
					width = 24,
					onClick = function() InsertTag("h2") end,
				},
				{
					type = "Button",
					text = "H3",
					compact = true,
					height = 24,
					width = 24,
					onClick = function() InsertTag("h3") end,
				}
			}
		}
	end

	local SetStyleCat = function()
		return {
			name = "Style",
			{
				{
					type = "DropDown",
					texture = "Tooltip",
					width = 100,
					label = "bookTheme",
					text = "Theme:",
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
					OnSelect = function(index, value)
						if info then
							info.material = value;
						end
					end,
					onMouseEnter = function(element)
						if not(element.previewFrame) then
							local pf = CreateFrame("Frame");
							pf:SetBackdrop({--bgFile = "Interface/Tooltips/UI-Tooltip-Background",
								edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
								tile = true, tileSize = 16, edgeSize = 16,
								insets = { left = 4, right = 4, top = 4, bottom = 4 }});
							--pf:SetBackdropColor(0,0,0,1);
							pf:SetParent(element);
							pf:SetPoint("TOPLEFT", element, "TOPRIGHT", 10, 5);
							pf:SetWidth(100);
							pf:SetHeight(120);
							element.previewFrame = pf;
						end

						if not(element.value == element.previewFrame.value) then
							if element.previewFrame.image then
								element.previewFrame.image:Hide();
							end
							local image = materials.GetImage(element.value, element.previewFrame);
							image:SetPoint("CENTER", element.previewFrame, "CENTER");
							image:SetWidth(96);
							image:SetHeight(116);
							image:SetParent(element.previewFrame);
							image:Show();
							element.previewFrame.image = image;
							element.previewFrame.value = element.value;
						end
						element.previewFrame:Show();
					end,
					onMouseLeave = function(element)
						if element.previewFrame then
							element.previewFrame:Hide();
						end
					end,
				},
				{
					type = "DropDown",
					width = 145,
					label = "bookFont",
					align = "l",
					text = "Font:",
					data = fonts,
					OnSelect = function(index, value)
						if info then
							info.font = value;
						end
					end,
				},
			}
		}
	end

	local SetUpGraphicsCat = function()
		return {
			name = "Graphics",
			{
				{
					type = "Button",
					text = "Img",
					compact = true,
					height = 24,
					width = 24,
					tooltip = loc.INSERT_IMAGE,
					onClick = function()
						imageMenuList.New(function(path, width, height)
							local imageText = string.format("[img width=%s height=%s]%s[/img]", width, height, path)
							textFrame:GetFieldFrame():Insert(imageText);
						end);
					end,
				},
				{
					type = "Button",
					text = "Icon",
					compact = true,
					height = 24,
					width = 24,
					tooltip = loc.INSERT_ICON,
					onClick = function()
						iconMenuList.New(function(icon)
							local imageText = string.format("[img width=%s height=%s]%s[/img]", 32, 32, icon)
							textFrame:GetFieldFrame():Insert(imageText);
						end);
					end,
				},
			}
		}
	end

	local SetUpInteractiveObjectsCat = function()
		return {
			name = "Interactive Objects",
			{
				{
					type = "Button",
					text = "Link",
					compact = true,
					height = 24,
					width = 24,
					onClick = function() end,
				},
			}
		}
	end

	local SetUpInsertPage = function()
		return	{
			name = "Insert",
			SetUpGraphicsCat(),
			SetUpInteractiveObjectsCat(),
		};
	end

	local SetUpFormattingPage = function()
		return	{
			name = "Formatting",
			SetUpMetaCat(),
			SetFontCat(),
			SetLayoutCat(),
			SetStyleCat(),
		};
	end

	local SetAllPagesCat = function()
		return {
			name = "Default - All pages",
			{
				{
					type = "TextButton",
					text = "Background style",
				},
				{
					type = "TextButton",
					text = "Default font",
				},
				{
					type = "TextButton",
					text = "Text color",
				},
				{
					type = "MultiNumberEditBox",
					text = "Font sizes:",
					editboxes = {
						{
							text = "N:",
							label = "n",
							digits = 2,
						},
						{
							text = "H1:",
							label = "h1",
							digits = 2,
						},
						{
							text = "H2:",
							label = "h2",
							digits = 2,
						},
					},
				},
			}
		}
	end

	local SetUpAppearancePage = function()
		return	{
			name = "Appearance",
			SetAllPagesCat(),
		}
	end

	local SetUpToolbar = function()
		return {
			type = "MultiPageToolbar",
			align = "l",
			SetUpFormattingPage(),
			SetUpAppearancePage(),
			SetUpInsertPage(),
		}
	end

	local yOff = 0;
	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				SetUpToolbar();
			},
			{
				{
					type = "Button",
					text = "+",
					align = "l",
					compact = true,
					height = 24,
					width = 24,
					onclick = function()
						table.insert(info, currentPageShown, {text1 = converter.ToSimpleHtml("")});
						currentPageShown = currentPageShown + 1;
						UpdateNavigationButtons();
					end,
					tooltip = loc.INSERT_PAGE_BEFORE,
					label = "addBeforeButton",
				},
				{
					type = "Button",
					text = PREV,
					align = "l",
					compact = true,
					height = 24,
					onclick = function()
						SaveCurrentPage();
						ShowPage(currentPageShown - 1);
					end,
					tooltip = loc.PREV_BOOK_PAGE,
					yOff = yOff,
					label = "prevButton"
				},
				{
					type = "Editbox",
					text = loc.TITLE,
					align = "c",
					label = "title",
					texture = "Tooltip",
					width = 260,
					xOff = 0,
					defaultValue = "",
					yOff = yOff,
					OnTextChanged = function(self)
						info.title = self:GetText();
					end,
				},
				{
					type = "Button",
					text = NEXT,
					align = "r",
					compact = true,
					height = 24,
					onclick = function()
						SaveCurrentPage();
						ShowPage(currentPageShown + 1);
					end,
					tooltip = loc.NEXT_BOOK_PAGE,
					yOff = yOff,
					label = "nextButton"
				},
				{
					type = "Button",
					text = "+",
					align = "r",
					compact = true,
					height = 24,
					width = 24,
					onclick = function()
						table.insert(info, currentPageShown + 1, {text1 = converter.ToSimpleHtml("")});
						UpdateNavigationButtons();
					end,
					tooltip = loc.INSERT_PAGE_AFTER,
					label = "addAfterButton",
				},
				{
					type = "Button",
					text = "-",
					align = "r",
					compact = true,
					height = 24,
					width = 24,
					onclick = function()
						table.remove(info, currentPageShown);
						currentPageShown = currentPageShown - 1;
						ShowPage(math.max(currentPageShown, 1));
					end,
					tooltip = loc.DELETE_PAGE,
					label = "deleteButton",
				},
			},
			{
				{
					type = "EditField",
					align = "c",
					label = "text",
				},
			},
		},
		title = loc.BOOK,
		name = "GHI_BookEditor" .. count,
		theme = "BlankTheme",
		width = 600,
		height = 550,
		useWindow = true,
		icon = "Interface\\Icons\\INV_Misc_Book_09",
		lineSpacing = 5,
		OnHide = function()
			Save();
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	});

	textFrame = menuFrame.GetLabelFrame("text");
	prevButton = menuFrame.GetLabelFrame("prevButton");
	nextButton = menuFrame.GetLabelFrame("nextButton");
	addBeforeButton = menuFrame.GetLabelFrame("addBeforeButton");
	addAfterButton = menuFrame.GetLabelFrame("addAfterButton");
	deleteButton = menuFrame.GetLabelFrame("deleteButton");

	return class;
end

