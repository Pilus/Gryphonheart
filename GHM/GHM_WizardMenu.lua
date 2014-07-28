--===================================================
--
--				GHM_WizardMenu
--  			GHM_WizardMenu.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHM_WizardMenu(owner, profile)
	local class = GHM_WindowedMenu(owner, profile)
	local loc = GHI_Loc();

	local backButton = _G[class:GetName() .. "Back"];
	local nextButton = _G[class:GetName() .. "Next"];

	local currentPage;

	-- setup handle
	class.UpdatePages = function(self)
		local activePages = class.Pages.Where(function(page) return page.active; end);

		if not(currentPage) or not(currentPage.active) then
			currentPage = activePages.First();
		end

		if activePages.First() == currentPage then
			backButton:Disable();
		else
			backButton:Enable();
			local index = activePages.GetIndexOf(currentPage);
			backButton.targetPage = activePages[index - 1];
		end

		if activePages.Last() == currentPage then
			nextButton:SetText(loc.FINISH);
			nextButton.targetPage = "ok";
		else
			nextButton:SetText(loc.NEXT);
			local index = activePages.GetIndexOf(currentPage);
			nextButton.targetPage = activePages[index + 1];
		end

		class.Pages.Foreach(function(page)
			if page == currentPage then
				page:Show();
			else
				page:Hide();
			end
		end)

		if profile.OnPageChange then
			profile.OnPageChange(activePages.GetIndexOf(currentPage));
		end
	end

	backButton:SetText(loc.BACK);
	backButton:SetScript("OnClick", function(self)
		local class = self:GetParent();
		currentPage = self.targetPage;
		class.UpdatePages()
	end);

	nextButton:SetScript("OnClick", function(self)
		if self.targetPage == "ok" then
			profile.OnOk(self);
			if not (class.autohide == false) then
				class:Hide();
			end
		else
			currentPage = self.targetPage;
			class.UpdatePages()
		end
	end);

	class.SetPage = function(index)
		currentPage = class.Pages[index];
		class.UpdatePages();
	end

	class.ActivatePage = function(i)
		class.Pages[i].active = true;
		class.UpdatePages();
	end

	class.DeactivatePage = function(i)
		class.Pages[i].active = false;
		class.UpdatePages();
	end

	class.UpdatePages();

	return class;
end

