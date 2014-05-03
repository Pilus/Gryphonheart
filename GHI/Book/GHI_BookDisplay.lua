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

	-- Menu setup
	local menuFrame = GHM_NewFrame(class, {
		{
			{
				{
					type = "Dummy",
					height = 400,
					width = 1,
					align = "c",
				},
			},
		},
		title = "",
		name = "GHI_TooltipMenu" .. count,
		theme = "BlankTheme",
		width = 380,
		useWindow = true,
		lineSpacing = 20,
	});
	count = count + 1;

	local scrollFrame = CreateFrame("ScrollFrame","$parentScroll",menuFrame,"GHM_ScrollFrameTemplate")

	scrollFrame:SetPoint("TOP",0,-3);
	scrollFrame:SetPoint("BOTTOM",0,8);
	scrollFrame:SetPoint("LEFT",-3,0);
	scrollFrame:SetPoint("RIGHT",10,0);

	local backgroundFrame = CreateFrame("Frame");
	scrollFrame:SetScrollChild(backgroundFrame);
	backgroundFrame:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT");
	backgroundFrame:Show();

	local pages = {};
	local currentPage = 1;
	local standardPageWidth = 0;
	local standardPageHeight = 0;

	class.AddPage = function(text, format)
		GHCheck("AddPage", {"string", "string"}, {text, format});

		local page = GHI_BookPage()
			.SetText(text, format)
			.SetSize(standardPageWidth, standardPageHeight, false)
			.SetBackground("Interface/Stationery/StationeryTest1", false)
			.SetFont('Fonts\\FRIZQT__.TTF', 11)

		table.insert(pages, page);
		page:SetParent(backgroundFrame);
		page:SetPoint("CENTER", 0, 0); -- temp.

		return class;
	end

	class.SetBackgroundSize = function(width, height)
		GHCheck("SetBackgroundSize", {"number", "number"}, {width, height});

		width = math.max(width, standardPageWidth);
		height = math.max(height, standardPageHeight);

		width = math.max(width, menuFrame:GetWidth() + 14);
		height = math.max(height, menuFrame:GetHeight() - 11);

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

	class.Show = function()
		menuFrame:AnimatedShow();
		return class;
	end

	class
		.SetBackgroundSize(0, 0) -- defaults to the size of the window.
		.SetDefaultPageSize(300, 350)
		.SetBackground({r=0.1, g=0.1, b=0.1})

	return class;
end

--[[
GHI_Event("GHI_LOADED", function()
	GHI_BookDisplay()
	.AddPage("<html><body><p>Test text</p></body></html>","none")
	.Show();

end);--]]