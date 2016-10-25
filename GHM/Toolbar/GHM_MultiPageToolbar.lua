--
--
--				GHM_MultiPageToolbar
--  			GHM_MultiPageToolbar.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local count = 1;
function GHM_MultiPageToolbar(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_MultiPageToolbar" .. count, parent);
	count = count + 1;

	local buttonHeight = 19;
	local margin = 2;
	local backgroundColor = {0.5, 0.5, 0.5, 0.5};
	local backgroundColor2 = {0.2, 0.2, 0.2, 0.6};

	local height,width = 0,0;
	local pages = Linq();
	local pageButtons = {};

	local currentShown;
	local lastClickTime = 0;
	local TogglePage = function(i)
		if GetTime() - lastClickTime < 1 and (not(currentShown) or currentShown == i) then
			if currentShown then
				pages[currentShown]:Hide();
				currentShown = nil;
				frame.GetPage().SetPosition();
			end
			lastClickTime = GetTime();
			return
		elseif currentShown then
			pages[currentShown]:Hide();
			pageButtons[currentShown].SetBGTextureColor(unpack(backgroundColor2));
			currentShown = i;
		else
			currentShown = i;
			frame.GetPage().SetPosition();
		end

		pages[i]:Show();
		pageButtons[i].SetBGTextureColor(unpack(backgroundColor));
		lastClickTime = GetTime();
	end

	local i = profile[0] and 0 or 1;
	local c = 1;
	while type(profile[i]) == "table" do
		local f = CreateFrame("Button", frame:GetName().."PageButton"..i, frame, "GHM_ToolbarPageButtonTemplate");
		local textFrame = _G[f:GetName().."Text"];
		textFrame:SetText(profile[i].name);

		f:SetWidth(textFrame:GetWidth() + 16);
		f:SetHeight(buttonHeight);

		f.SetBGTextureColor = function(r, g, b, a)
			_G[f:GetName().."Bg"]:SetColorTexture(r, g, b, a);
		end
		f.SetBGTextureColor(unpack(backgroundColor2));

		if pageButtons[c-1] then
			f:SetPoint("LEFT", pageButtons[c-1], "RIGHT");
		else
			f:SetPoint("TOPLEFT", frame, "TOPLEFT");
		end

		f.index = c;
		f:SetScript("OnClick",function()
			TogglePage(f.index);
		end);

		pageButtons[c] = f;


		local page = GHM_ToolbarPage(profile[i], frame, settings);
		page:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, - (buttonHeight - margin));
		page:Hide();
		width = math.max(width, page:GetWidth());
		height = math.max(height, page:GetHeight());

		table.insert(pages, page)

		i = i + 1;
		c = c + 1;
	end


	height = height + buttonHeight + 4;
	width = width + 4;

	frame:SetHeight(height);
	frame:SetWidth(width);

	local bg = frame:CreateTexture()
	bg:SetColorTexture(unpack(backgroundColor));
	bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -buttonHeight - margin);
	bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, margin);

	frame.GetLabelFrame = function(label)
		local frame;
		pages.Foreach(function(page)
			frame = frame or page.GetLabelFrame(label);
		end);
		return frame;
	end

	frame.GetPreferredDimensions = function()
		local height = 0;
		if currentShown then
			height = pages.MaxBy(function(page) return page:GetHeight(); end):GetHeight();
		end
		return nil, height + buttonHeight - margin;
	end

	frame.SetPosition = function(xOff, yOff, width, height)
		frame:SetWidth(width);
		frame:SetHeight(height);
		frame:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, -yOff);
		if currentShown then
			pages.Foreach(function(page) page.SetPosition(0, (buttonHeight - margin), width, height - (buttonHeight - margin)); end)
		end
	end

	--TogglePage(1);

	return frame;
end

