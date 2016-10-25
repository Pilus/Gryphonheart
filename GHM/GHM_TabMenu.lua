--
--
--				GHM_TabMenu
--  			GHM_TabMenu.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHM_TabMenu(owner, profile)
	local class = GHM_WindowedMenu(owner, profile);

	local tabButtons;
	local currentTab;

	local CreateButtonFrame = function(index)
		local button = CreateFrame("Button", class:GetName().."Tab"..index, class, "CharacterFrameTabButtonTemplate");
		if index == 1 then
			button:SetPoint("TOPLEFT", class, "BOTTOMLEFT", 20, 0);
		else
			button:SetPoint("TOPLEFT", tabButtons[index-1], "TOPRIGHT", 5, 0);
		end
		tabButtons[index] = button;
	end

	local currentPage;

	local CreateTabButtons = function()
		tabButtons = {};
		for i, page in ipairs(class.Pages) do
			page:Hide();
			CreateButtonFrame(i);
			local button = tabButtons[i];
			button:SetText(page.Name or "nil");

			button.ShowTab = function()
				PanelTemplates_TabResize(button, 0, nil, 36, button:GetParent().maxTabWidth or 88);
				if currentPage then
					currentPage:Hide();
				end
				currentPage = page;
				currentPage:Show();
			end

			button:SetScript("OnClick", button.ShowTab);
		end
	end

	class.DisplayTab = function(tabIndex)
		if tabButtons == nil then
			CreateTabButtons();
		end
		tabButtons[tabIndex].ShowTab();
	end

	class.GetPreferredInsert = function()
		return 10, 10, 10, 20;
	end
	class.UpdatePosition();

	class.DisplayTab(1);

	return class;
end

