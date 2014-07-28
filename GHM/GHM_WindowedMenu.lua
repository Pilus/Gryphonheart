--===================================================
--
--				GHM_WindowedMenu
--  			GHM_WindowedMenu.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHM_WindowedMenu(owner, profile)
	local class = GHM_BaseMenu(owner, profile);

	local window = CreateFrame("Frame", nil, UIParent, "GHM_Window");
	window.settingUp = true;
	class.window = window;
	window:SetWidth(class:GetWidth() + 30);
	window.menu = class;
	window:SetHeight(class:GetHeight() + 30);

	window:SetDevMode(false);
	window:SetContent(class);
	window:SetTitle(profile.title);
	window:SetIcon(profile.icon);


	if type(profile.menuBar) == "table" then
		for i=1,#(profile.menuBar) do
			GHM_Toolbar(window.MenuBar, class, profile.menuBar[i]);
		end
		window:ShowMenuBar();
	else
		window:HideMenuBar();
	end

	if profile.statusBar then
		window:ShowStatusBar();
	else
		window:HideStatusBar();
	end

	local texture =  profile.background or GHM_GetBackground() or "Interface/DialogFrame/UI-DialogBox-Background"
	window.BgFrame:SetBackdrop({
		bgFile = texture,
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	});

	window.BgFrame2:SetBackdrop({
		bgFile = "Interface\\AddOns\\GHI\\texture\\white.tga",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	});
	window.BgFrame2:SetBackdropColor(GHM_GetBackgroundColor());

	window.BgFrame:SetFrameLevel(window.BgFrame2:GetFrameLevel() + 1);
	window.TopBgFrame:SetFrameLevel(window.BgFrame:GetFrameLevel() + 1);
	window.TitleBar:SetFrameLevel(window.TopBgFrame:GetFrameLevel() + 1);


	-- Top bar
	window.TopBgFrame:SetBackdrop({
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false,
		tileSize = 0,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 0 }
	});
	window.TitleBar.bg = window.TitleBar:CreateTexture();
	window.TitleBar.bg:SetAllPoints(window.TitleBar);
	window.TitleBar.bg:SetTexture(GHM_GetTitleBarColor());
	window.TopBgFrame:SetFrameLevel(window.BgFrame:GetFrameLevel() + 1);

	window:SetFrameStrata("MEDIUM");

	class:SetScript("OnShow", function(self) GHM_LayerHandle(self.window or self); if self.onShow then self.onShow(self); end end);
	class:SetScript("OnHide", function(self) GHM_LayerHandle(self.window or self); if self.onHide then self.onHide(self); end end);

	class.ShowOrig = class.Show;
	class.Show = function(self) window:Show();
		window:ClearAllPoints();
		window:SetPoint("CENTER", 0, 0);
		class:ShowOrig()
	end;

	class.HideOrig = class.Hide;
	class.Hide = function(self)
		window:Hide(); class:HideOrig()
	end;

	class.SetTitle = function(_, t)
		window:SetTitle(t)
	end;

	class.AnimatedShow = function(self)
		self:Show();
		self.window:AnimatedShow();
	end

	window.settingUp = false;

	--class:ClearAllPoints()
	--class:SetPoint("CENTER", UIParent, "CENTER", 0, 0);

	return class;
end

