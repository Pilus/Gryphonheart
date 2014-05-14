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

	local action, textFrame, info, item, currentPageShown;
	local prevButton, nextButton, addBeforeButton, addAfterButton, deleteButton;

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

	local ShowPage = function(i)
		if info[i] then
			SaveCurrentPage();
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
		menuFrame:AnimatedShow();
	end

	local Revert = function()
		info = action.GetInfo();
		ShowPage(1);
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
		local display = GHI_BookDisplay()
		.SetTitle(info.title)
		.SetFont(info.font or "Frizqt", info.n or 15)

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
					width = 120,
					label = "bookMaterial",
					text = "Background material:",
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
			}
		}
	end

	local SetUpAppearancePage = function()
		return	{
			name = "Formatting",
			SetAllPagesCat(),
		}
	end

	local SetUpToolbar = function()
		return {
			type = "MultiPageToolbar",
			align = "l",
			SetUpFormattingPage(),
			SetUpAppearancePage(),
		}
	end

	local yOff = -10;
	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				SetUpToolbar();
			},
			{
				{
					type = "Button",
					text = PREV,
					align = "l",
					compact = true,
					height = 24,
					onclick = function() ShowPage(currentPageShown - 1); end,
					tooltip = loc.PREV_BOOK_PAGE,
					yOff = yOff,
					label = "prevButton"
				},
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
					type = "Editbox",
					text = loc.TITLE,
					align = "c",
					label = "title",
					texture = "Tooltip",
					width = 200,
					xOff = 0,
					defaultValue = "",
					yOff = yOff,
				},
				{
					type = "Button",
					text = NEXT,
					align = "r",
					compact = true,
					height = 24,
					onclick = function() ShowPage(currentPageShown + 1); end,
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
					onclick = function() end,
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
						table.insert(info, currentPageShown, {text1 = converter.ToSimpleHtml("")});
						UpdateNavigationButtons();
					end,
					tooltip = loc.DELETE_PAGE,
					label = "deleteButton",
				},
			},
			{
				{
					type = "EditField",
					align = "c",
					width = 600,
					height = 480,
					label = "text",
				},
			},
		},
		title = loc.BOOK,
		name = "GHI_BookEditor" .. count,
		theme = "BlankTheme",
		width = 600,
		height = 600,
		useWindow = true,
		icon = "Interface\\Icons\\INV_Misc_Book_09",
		lineSpacing = -15,
		OnHide = function()
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

