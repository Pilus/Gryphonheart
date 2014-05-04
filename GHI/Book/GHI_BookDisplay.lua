--===================================================
--
--				GHI_BookDisplay
--  			GHI_BookDisplay.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;
function GHI_BookDisplay()
	local class = GHClass("GHI_BookDisplay");
	local loc = GHI_Loc();

	-- Menu setup
	local menuFrame = GHM_NewFrame(class, {
		{
			{
				{
					type = "Dummy",
					height = 500,
					width = 1,
					align = "c",
				},
				{
					type = "Button",
					text = loc.EDIT_ACTION,
					width = 50,
					align = "r",
					label = "edit",
					--compact = true,
					OnClick = function()
					end,
				},
			},
		},
		title = "",
		name = "GHI_TooltipMenu" .. count,
		theme = "BlankTheme",
		width = 350,
		useWindow = true,
		lineSpacing = 20,
	});
	count = count + 1;

	local topBarFrame = CreateFrame("Frame", "$parentTopBar", menuFrame);
	topBarFrame:SetPoint("TOPLEFT", -3, -3);
	topBarFrame:SetPoint("TOPRIGHT", 24, -3);
	topBarFrame:SetHeight(50);
	topBarFrame:SetBackdrop({bgFile = "Interface\\FrameGeneral\\UI-Background-Rock",
		edgeFile = "",
		tile = true, tileSize = 75, edgeSize = 0,
	});

	local prevButton = CreateFrame("Button", "$parentPrev", topBarFrame);
	prevButton:SetWidth(32);
	prevButton:SetHeight(32);
	prevButton:SetPoint("LEFT", 8, 0);
	prevButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up");
	prevButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down");
	prevButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled");
	prevButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight");
	local fs = prevButton:CreateFontString("$parentFont", "ARTWORK", "GameFontNormal");
	fs:SetPoint("LEFT", prevButton, "RIGHT");
	fs:SetText(PREV);
	prevButton:SetScript("OnClick",function()
		PlaySound("igMainMenuOptionCheckBoxOn");
		class.PrevPage();
	end)

	local nextButton = CreateFrame("Button", "$parentNext", topBarFrame);
	nextButton:SetWidth(32);
	nextButton:SetHeight(32);
	nextButton:SetPoint("RIGHT", -70, 0);
	nextButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up");
	nextButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down");
	nextButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled");
	nextButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight");
	local fs = nextButton:CreateFontString("$parentFont", "ARTWORK", "GameFontNormal");
	fs:SetPoint("RIGHT", nextButton, "LEFT");
	fs:SetText(NEXT);
	nextButton:SetScript("OnClick",function()
		PlaySound("igMainMenuOptionCheckBoxOn");
		class.NextPage();
	end)

	local currentPageLabel = topBarFrame:CreateFontString("$parentFont", "ARTWORK", "GameFontNormal");
	currentPageLabel:SetPoint("CENTER", topBarFrame, "CENTER", -30, 0);

	local editButton = menuFrame.GetLabelFrame("edit");
	editButton:ClearAllPoints();
	editButton:SetParent(topBarFrame);
	editButton:SetPoint("RIGHT", topBarFrame, "RIGHT", -10, 0)
	editButton:Hide();

	local scrollFrame = CreateFrame("ScrollFrame","$parentScroll",menuFrame,"GHM_ScrollFrameTemplate")
	scrollFrame:SetPoint("TOP", topBarFrame, "BOTTOM", 0, 3);
	scrollFrame:SetPoint("BOTTOM",0,8);
	scrollFrame:SetPoint("LEFT",-3,0);
	scrollFrame:SetPoint("RIGHT", 10, 0);
	scrollFrame.ShowScrollBarBackgrounds();

	local backgroundFrame = CreateFrame("Frame");
	scrollFrame:SetScrollChild(backgroundFrame);
	backgroundFrame:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT");
	backgroundFrame:Show();


	local pages = {};
	local currentPage = 1;
	local standardPageWidth = 0;
	local standardPageHeight = 0;

	local UpdatePrevNext = function()
		currentPageLabel:SetText(string.format(loc.PAGE_OF_PAGES, currentPage, #(pages)));
		if currentPage == 1 then
			prevButton:Hide();
		else
			prevButton:Show();
		end

		if currentPage == #(pages) then
			nextButton:Hide();
		else
			nextButton:Show();
		end
	end

	class.AddPage = function(text, format)
		GHCheck("AddPage", {"string", "string"}, {text, format});

		local page = GHI_BookPage()
			.SetText(text, format)
			.SetSize(standardPageWidth, standardPageHeight, false)
			.SetBackground("Interface\\QuestFrame\\QuestBG", false, {0, 0.58, 0, 0.65})
			.SetFont('Fonts\\FRIZQT__.TTF', 13)
			.SetTextColor(0, 0, 0)
		page:Hide();

		table.insert(pages, page);
		page:SetParent(backgroundFrame);

		-- temp stuff
		page:SetPoint("CENTER", 0, 0);
		-- end of temp

		if #(pages) == 1 and currentPage == 1 then
			page:Show();
		end
		UpdatePrevNext();

		return class;
	end

	class.SetBackgroundSize = function(width, height)
		GHCheck("SetBackgroundSize", {"number", "number"}, {width, height});

		width = math.max(width, standardPageWidth);
		height = math.max(height, standardPageHeight);

		width = math.max(width, menuFrame:GetWidth() + 11);
		height = math.max(height, menuFrame:GetHeight() - topBarFrame:GetHeight() - 9);

		backgroundFrame:SetWidth(width);
		backgroundFrame:SetHeight(height);

		return class;
	end

	class.SetBackground = function(pathOrColor)
		GHCheck("SetBackground", {"stringortable"}, {pathOrColor});

		if not(backgroundFrame.texture) then
			backgroundFrame.texture = backgroundFrame:CreateTexture(nil,"BACKGROUND");
			backgroundFrame.texture:SetAllPoints(backgroundFrame);
		end

		if type(pathOrColor) == "string" then
			backgroundFrame.texture:SetTexture(pathOrColor);
		elseif type(pathOrColor) == "table" and type(pathOrColor.r) == "number" and type(pathOrColor.g) == "number" and type(pathOrColor.b) == "number" then
			backgroundFrame.texture:SetTexture(pathOrColor.r, pathOrColor.g, pathOrColor.b);
		else
			error("Usage: SetBackground(path) or SetBackground({r=0, g=0, b=0})");
		end

		return class;
	end

	class.SetDefaultPageSize = function(width, height)
		GHCheck("SetPageSize", {"number", "number"}, {width, height});

		width = math.min(width, backgroundFrame:GetWidth());
		height = math.min(height, backgroundFrame:GetHeight());

		standardPageWidth = width;
		standardPageHeight = height;

		for _, page in pairs(pages) do
			page.SetSize(width, height, false);
		end

		return class;
	end

	class.SetSpecialPageSize = function(index, width, height)
		GHCheck("SetSpecialPageSize", {"number", "number", "number"}, {index, width, height});
		assert(pages[index], string.format("Page %s does not exist.", index));
		pages[index].SetSize(width, height, true);

		return class;
	end

	class.SetDefaultPageBackgroud = function(pathOrColor)
		GHCheck("SetDefaultPageBackgroud", {"stringortable"}, {pathOrColor});
		if not(type(pathOrColor) == "string" or (type(pathOrColor) == "table" and type(pathOrColor.r) == "number" and type(pathOrColor.g) == "number" and type(pathOrColor.b) == "number")) then
			error("Usage: SetDefaultPageBackgroud(path) or SetDefaultPageBackgroud({r=0, g=0, b=0})");
		end

		for _, page in pairs(pages) do
			page.SetBackground(pathOrColor, false);
		end

		return class;
	end

	class.SetSpecialPageBackgroud = function(index, pathOrColor)
		GHCheck("SetSpecialPageBackgroud", {"number", "stringortable"}, {index, pathOrColor});
		assert(pages[index], string.format("Page %s does not exist.", index));
		if not(type(pathOrColor) == "string" or (type(pathOrColor) == "table" and type(pathOrColor.r) == "number" and type(pathOrColor.g) == "number" and type(pathOrColor.b) == "number")) then
			error("Usage: SetSpecialPageBackgroud(path) or SetSpecialPageBackgroud({r=0, g=0, b=0})");
		end

		pages[index].SetBackground(pathOrColor, true);
		return class;
	end

	local ChoosePage = function(num)
		if pages[num] then
			currentPage = num;
			UpdatePrevNext();
			for i,page in pairs(pages) do
				if i == currentPage then
					page:Show();
				else
					page:Hide();
				end
			end
		end
	end

	class.NextPage = function()
		ChoosePage(currentPage + 1);
		return class;
	end

	class.PrevPage = function()
		ChoosePage(currentPage - 1);
		return class;
	end

	class.Show = function()
		menuFrame:AnimatedShow();
		return class;
	end

	class.SetTitle = function(title)
		menuFrame:SetTitle(title);
		return class;
	end

	class.SetEditFunction = function(func)
		editButton:SetScript("OnClick", function()
			func();
		end)
		editButton:Show();
		return class;
	end

	class
		.SetBackgroundSize(0, 0) -- defaults to the size of the window.
		.SetDefaultPageSize(300, 410)
		.SetBackground({r=0.1, g=0.1, b=0.1})

	return class;
end

--[[
GHI_Event("GHI_LOADED", function()
	GHI_BookDisplay()
	.AddPage("<html><body><p>Test text</p></body></html>","none")
	.Show();

end);--]]