--===================================================
--
--				GHM_Page
--  			GHM_Page.lua
--
--	          (description)
--
-- 	  (c)2014 The Gryphonheart Team
--			All rights reserved
--===================================================

local urlMenuList;
function GHM_Page(profile, parent, settings)
	local parentName = parent:GetName();
	local pageNumber = 1;
	while (_G[parentName.."_P"..pageNumber]) do
		pageNumber = pageNumber + 1;
	end
	local pageName = parentName.."_P"..pageNumber;

	local page = CreateFrame("Frame", pageName, parent);

	local lines = Linq();
	for i=1,#(profile) do
		lines[i] = GHM_Line(profile[i], page, settings);
	end

	if pageNumber == 1 then
		page:Show();
		page.active = true;
	else
		page:Hide();
		page.active = false;
	end

	page.active = true;

	page.GetPreferredDimensions = function()
		local lineSpacing = settings.lineSpacing or 0;
		local width, height;

		local gotLineWithNoWidthLimit = lines.Where(function(line) return ({line.GetPreferredDimensions()})[1] == nil; end).Any();
		local gotLineWithNoHeightLimit = lines.Where(function(line) return ({line.GetPreferredDimensions()})[2] == nil; end).Any();

		if not(gotLineWithNoWidthLimit) then
			width = lines.Select(function(line) return line.GetPreferredDimensions() end).MaxBy(function(v) return v; end);
		end

		if not(gotLineWithNoHeightLimit) then
			height = lines.Sum(function(line) return ({line.GetPreferredDimensions()})[2] + lineSpacing; end)
			if #(lines) > 0 then
				height = height - lineSpacing;
			end
		end

		return width, height;
	end

	local lastPosition = {};
	page.SetPosition = function(xOff, yOff, width, height)
		GHCheck("Page.SetPosition", {"numberNil", "numberNil", "numberNil", "numberNil"}, {xOff, yOff, width, height});

		if not(xOff) and not(yOff) and not(width) and not(height) then
			xOff, yOff, width, height = unpack(lastPosition);
		else
			lastPosition = {xOff, yOff, width, height};
		end

		local lineSpacing = settings.lineSpacing or 0;

		local preferredWidth, preferredHeight = page.GetPreferredDimensions();
		width = width or preferredWidth;
		height = height or preferredHeight;

		page:SetWidth(width);
		page:SetHeight(height);
		page:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, -yOff);

		local linesWithNoHeightLimit = lines.Where(function(line) return ({line.GetPreferredDimensions()})[2] == nil; end);
		local linesWithHeightLimit = lines.Where(function(line) return not(linesWithNoHeightLimit.Contains(line)); end)

		local heightUsed = 0;
		linesWithHeightLimit.Foreach(function(line)
			local w, h = line.GetPreferredDimensions();
			line.SetPosition(0, heightUsed, width, h or height);
			heightUsed = heightUsed + h + lineSpacing;
		end)

		local heightPrFlexObject = 0;
		if linesWithNoHeightLimit.Any() then
			local heightAvailable = height - heightUsed - (lineSpacing * (linesWithNoHeightLimit.Count() - 1));
			heightPrFlexObject =  heightAvailable / linesWithNoHeightLimit.Count();
		end

		local heightUsed = 0;
		lines.Foreach(function(line)
			local w, h = line.GetPreferredDimensions();
			line.SetPosition(0, heightUsed, width, h or heightPrFlexObject);
			heightUsed = heightUsed + (h or heightPrFlexObject) + lineSpacing;
		end)
	end

	page.GetLabelFrame = function(label)
		local frame;
		lines.Foreach(function(line) frame = frame or line.GetLabelFrame(label); end)
		return frame;
	end

	-- help button
	if profile.help then
		if not(urlMenuList) then
			urlMenuList = GHI_MenuList("GHI_URLUI");
		end
		local loc = GHI_Loc();
		local button = CreateFrame("Button","$parentHelpButton",page,"GHM_Button_Template");
		button:SetPoint("BOTTOMLEFT",page:GetParent(),"BOTTOMLEFT",15,15);
		button:SetText(loc.HELP);
		button:SetScript("OnClick",function()
			local url = string.format("http://pilus.info/index.php?title=%s",profile.help);
			urlMenuList.New(url);
		end)

	end

	--GHM_TempBG(page);

	return page;
end

