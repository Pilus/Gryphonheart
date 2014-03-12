--===================================================
--
--				GHM_MultiPageToolbar
--  			GHM_MultiPageToolbar.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;
function GHM_MultiPageToolbar(parent, main, profile)
	local frame = CreateFrame("Frame", "GHM_MultiPageToolbar" .. count, parent);
	count = count + 1;

	local buttonHeight = 19;
	local backgroundColor = {0.5, 0.5, 0.5, 0.5};
	local backgroundColor2 = {0.8, 0.8, 0.8, 0.6};

	local height,width = 0,0;
	local pages = {};
	local pageButtons = {};

	local currentShown;
	local TogglePage = function(i)
		if currentShown then
			pages[currentShown]:Hide();
			pageButtons[currentShown].SetBGTextureColor(unpack(backgroundColor2))
		end

		pages[i]:Show();
		pageButtons[i].SetBGTextureColor(unpack(backgroundColor));
		currentShown = i;
	end

	for i = 1,#(profile) do
		local f = CreateFrame("Button", frame:GetName().."PageButton"..i, frame, "GHM_ToolbarPageButtonTemplate");
		local textFrame = _G[f:GetName().."Text"];
		textFrame:SetText(profile[i].name);

		f:SetWidth(textFrame:GetWidth() + 16);
		f:SetHeight(buttonHeight);

		f.SetBGTextureColor = function(r, g, b, a)
			_G[f:GetName().."Bg"]:SetTexture(r, g, b, a);
		end
		f.SetBGTextureColor(unpack(backgroundColor2));

		if pageButtons[i-1] then
			f:SetPoint("LEFT", pageButtons[i-1], "RIGHT");
		else
			f:SetPoint("TOPLEFT", frame, "TOPLEFT");
		end

		f:SetScript("OnClick",function()
			TogglePage(i);
		end);

		pageButtons[i] = f;
	end

	for i=1,#(profile) do
		local page = GHM_ToolbarPage(frame, main, profile[i]);
		page:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, - (buttonHeight + 2));
		page:Hide();
		width = math.max(width, page:GetWidth());
		height = math.max(height, page:GetHeight());

		table.insert(pages, page)
	end

	height = height + buttonHeight + 4;
	width = width + 4;

	frame:SetHeight(height);
	frame:SetWidth(width);

	local bg = frame:CreateTexture()
	bg:SetTexture(unpack(backgroundColor));
	bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -buttonHeight);
	bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0);

	GHM_FramePositioning(frame,profile,parent);

	TogglePage(1);

	return frame;
end

