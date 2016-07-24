local function DoForAllEditBoxes(frame, func)
	local t = { frame:GetChildren() };
	for _, f in pairs(t) do
		if f:GetObjectType() == "EditBox" then
			func(f);
		else
			DoForAllEditBoxes(f, func)
		end
	end
end

local AnimationFrame = CreateFrame("Frame");
AnimationFrame.frames = {};

local DURATION = 0.2;
AnimationFrame.DoAnimation = function(self, frame, offX, offY)
	local point, _, _, x, y = frame:GetPoint();
	local info = {
		start = GetTime(),
		frame = frame,
		offX = offX,
		offY = offY,
		startX = x,
		startY = y,
		point = point,
	}
	table.insert(self.frames, info);
end
AnimationFrame:SetScript("OnUpdate", function(self)
	for i, info in pairs(self.frames) do
		local elapsed = GetTime() - info.start;
		if elapsed < DURATION then
			local progress = elapsed / DURATION;
			if progress == 0 then
				progress = 0.001;
			end
			info.frame:SetScale(progress);

			local x = info.startX + (info.offX * progress) - info.offX;
			local y = info.startY + (info.offY * progress) - info.offY;
			info.frame:SetPoint(info.point, x / progress, y / progress);
		else
			info.frame:SetScale(1);
			info.frame:SetPoint(info.point, info.startX, info.startY);
			self.frames[i] = nil;

			DoForAllEditBoxes(info.frame, function(f) f:SetCursorPosition(0) end)
		end
	end
end);

local animatedFrames = {};
local function AnimateWindowOpening(self)
	if not(GHM_UseAnimation()) then
		self:Show();
		return
	end

	local _x, _y = GetCursorPosition();
	local s = self:GetEffectiveScale();
	_x, _y = _x / s, _y / s;

	local x,y = (UIParent:GetWidth() / 2) - _x, (UIParent:GetHeight() / 2) - _y;

	self:Show();

	AnimationFrame:DoAnimation(self, x, y);

	table.insert(animatedFrames,self);
	self.inAnimatedFrames = true;
	self:AddScript("OnMove",function()
		if self.inAnimatedFrames == true then
			self.inAnimatedFrames = false;
			for i,frame in pairs(animatedFrames) do
				if frame == self then
					table.remove(animatedFrames,i);
					break;
				end
			end
		end
	end)

end


function GHM_Window_OnLoad(self)
	self:SetClampedToScreen(true)

	function self:AddScript(event, handler)
		local events = { "OnResize", "OnMove", "OnMinimize", "OnRestore", "OnDock", "OnUndock", };
		local exist = false;
		for key, value in ipairs(events) do
			if value == event then exist = true; end
		end
		if not exist then return false; end

		if not self.Scripts then self.Scripts = {}; end
		if not self.Scripts[event] then self.Scripts[event] = {}; end
		table.insert(self.Scripts[event], handler);
		return true;
	end

	function self:GetPointInfo(n)
		local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(n);
		return { ["Point"] = point, ["RelativeTo"] = relativeTo, ["RelativePoint"] = relativePoint, ["xOfs"] = floor(xOfs + 0.5), ["yOfs"] = floor(yOfs + 0.5) };
	end

	function self:SetTitle(text)
		if self.TitleBar and self.TitleBar.Text then
			self.TitleBar.Text:SetText(text);
			self.Title = text;
		end
	end

	function self:SetIcon(texture)
		if self.TitleBar and self.TitleBar.Icon then
			self.TitleBar.Icon:SetTexture(texture);
		end
	end

	function self:Minimize()
		if self.Minimized then return; end

		self.MenuBar:Hide();
		self.StatusBar:Hide();
		self.ContentFrame:Hide();
		self.BgFrame:Hide();
		self.BgFrame2:Hide();

		self.TitleBar.minimizeButton:Hide();
		self.TitleBar.restoreButton:Show();

		local oldHeight = self:GetHeight();
		local oldWidth = self:GetWidth();
		self:SetHeight(floor(self.TitleBar:GetHeight() + 0.5));
		local alphaHeight = self:GetHeight() - oldHeight;
		local alphaWidth = self:GetWidth() - oldWidth;

		local _, _, _, x, y = self:GetPoint()
		self:SetPoint("CENTER", x - math.floor(alphaWidth / 2), y - math.floor(alphaHeight / 2));

		if self.Scripts and self.Scripts["OnMinimize"] then
			for key, OnMinimize in ipairs(self.Scripts["OnMinimize"]) do
				OnMinimize(self);
			end
		end

		self.Minimized = true;
	end

	function self:Restore()
		if not self.Minimized then return; end

		local oldHeight = self:GetHeight();
		local oldWidth = self:GetWidth();
		self:SetHeight(self.Height);
		self:SetWidth(self.Width);
		local alphaHeight = self:GetHeight() - oldHeight;
		local alphaWidth = self:GetWidth() - oldWidth;
		local _, _, _, x, y = self:GetPoint();
		self:SetPoint("CENTER", x, y - math.floor(alphaHeight / 2));

		if not (self.StatusBar.forcedHidden) then
			self.StatusBar:Show();
		end
		if not (self.MenuBar.forcedHidden) then
			self.MenuBar:Show();
		end
		self.ContentFrame:Show();
		self.BgFrame:Show();
		self.BgFrame2:Show();
		self.TitleBar.restoreButton:Hide();
		self.TitleBar.minimizeButton:Show();

		self:UpdateScrollBarsVisibility();

		if self.Scripts and self.Scripts["OnRestore"] then
			for key, OnRestore in ipairs(self.Scripts["OnRestore"]) do
				OnRestore(self, self.Width, self.Height, self.Point);
			end
		end

		self.Minimized = false;
	end

	function self:SetContent(frame)
		frame:SetParent(self.ContentFrame);
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT", 2, -4);
		self.Content = frame;
		self.ContentFrame:Update();
		self:UpdateScrollBarsVisibility();
	end

	function self:SetContentScale(scale)
		self.Content:SetScale(scale);
		self.ContentFrame:Update();
	end

	function self:ShowMenuBar()
		self.MenuBar:Show();
		self.MenuBar.forcedHidden = false;
		self:UpdateScrollBarsVisibility();
	end

	function self:HideMenuBar()
		self.MenuBar:Hide();
		self.MenuBar.forcedHidden = true;
		self:UpdateScrollBarsVisibility();
	end

	function self:ShowStatusBar()
		self.StatusBar:Show();
		self.StatusBar.forcedHidden = false;
		self:UpdateScrollBarsVisibility();
	end

	function self:HideStatusBar()
		self.StatusBar:Hide();
		self.StatusBar.forcedHidden = true;
		self:UpdateScrollBarsVisibility();
	end

	self.AnimatedShow = AnimateWindowOpening;

	---------------------------------------------------------------------------------------------------------
	-- Event handlers
	---------------------------------------------------------------------------------------------------------
	function self:OnResize()
		if self.Minimized == true then return end;
		local prevWidth, prevHeight = self.Width, self.Height;
		local setWidth, setHeight = floor(self:GetWidth() + 0.5), floor(self:GetHeight() + 0.5);

		if prevWidth == setWidth and prevWidth == setHeight then return; end

		self.Width = setWidth;
		self.Height = setHeight;
		self:UpdateScrollBarsVisibility();

		--if not prevWidth and not prevHeight then return; end

		if self.Scripts and self.Scripts["OnResize"] then
			for key, OnResize in ipairs(self.Scripts["OnResize"]) do
				OnResize(self, setWidth, setHeight, prevWidth, prevHeight);
			end
		end
		GHM_LayerHandle(self);
	end

	function self:OnMove(deltaX, deltaY)
		local point = self:GetPointInfo(1);
		local prevPoint = self.Point;
		if type(prevPoint) == "function" then
			prevPoint = point
		end;
		if self.Scripts and self.Scripts["OnMove"] then
			for key, OnMove in ipairs(self.Scripts["OnMove"]) do
				OnMove(self, point["xOfs"], point["yOfs"], (prevPoint and prevPoint["xOfs"] or 0), (prevPoint and prevPoint["yOfs"] or 0), point, prevPoint);
			end
		end
		self.Point = point;

		GHM_LayerHandle(self);
	end


	---------------------------------------------------------------------------------------------------------
	-- Main init
	---------------------------------------------------------------------------------------------------------
	self:RegisterForDrag("LeftButton");
	self:SetMovable();

	local TITLE_BAR_HEIGHT = 20;

	-- Title Bar
	local titleBar = CreateFrame("Button", "$parentTitleBar", self);
	titleBar:SetHeight(TITLE_BAR_HEIGHT);
	titleBar:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0);
	titleBar:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0);

	local titleText = titleBar:CreateFontString(nil, "OVERLAY", "SystemFont_Med1");
	titleText:SetHeight(TITLE_BAR_HEIGHT);
	titleText:SetPoint("CENTER", 0, 0);
	titleText:SetJustifyH("CENTER");
	titleText:SetTextColor(GHM_GetTitleBarTextColor());
	titleBar.Text = titleText;

	local titleIcon = titleBar:CreateTexture(nil, "OVERLAY");

	titleIcon:SetHeight(TITLE_BAR_HEIGHT);
	titleIcon:SetWidth(TITLE_BAR_HEIGHT);
	titleIcon:SetPoint("LEFT");
	titleBar.Icon = titleIcon;

	titleBar.Window = self;

	self:SetMovable(true);
	titleBar:SetScript("OnMouseDown", function(self) if self.Window then
		local w = self.Window
		local _, _, _, x, y = w:GetPoint();
		w.lastX = x;
		w.lastY = y;

		w:StartMoving();

		local w = self.Window
		local _, _, _, x, y = w:GetPoint();
		w.startX = x;
		w.startY = y;

		GHM_LayerHandle(w);
	end
	end)
	titleBar:SetScript("OnMouseUp", function(self) if self.Window then
		local w = self.Window
		local _, _, _, x, y = w:GetPoint();
		local deltaX, deltaY = x - w.startX, y - w.startY;
		w.startY = y;

		w:StopMovingOrSizing();

		w:ClearAllPoints();
		w:SetPoint("CENTER", w.lastX + deltaX, w.lastY + deltaY);

		w:OnMove(deltaX, deltaY);
	end
	end)
	titleBar:SetScript("OnHide", function(self) if self.Window then self.Window:StopMovingOrSizing(); end end)

	titleBar:RegisterForClicks("AnyUp")

	self.TitleBar = titleBar;

	-- Close button
	local closeButton = CreateFrame("Button", "$parentCloseButton", titleBar, "UIPanelCloseButton");
	closeButton:SetPoint("RIGHT", titleBar, "RIGHT", 2, 0);
	closeButton:SetHeight(TITLE_BAR_HEIGHT + 6);
	closeButton:SetWidth(TITLE_BAR_HEIGHT + 6);
	closeButton:Show();
	closeButton:SetScript("OnClick", function(...)
		if self.Minimized then
			self:Restore()
		end
		self:Hide();
	end);

	-- Minimize button
	local minimizeButton = CreateFrame("Button", "$parentCloseButton", titleBar, "UIPanelCloseButton");
	minimizeButton:SetPoint("RIGHT", closeButton, "LEFT", 9, 0);
	minimizeButton:SetHeight(TITLE_BAR_HEIGHT + 6);
	minimizeButton:SetWidth(TITLE_BAR_HEIGHT + 6);
	minimizeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-HideButton-Up");
	minimizeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-HideButton-Down");
	minimizeButton:Show();
	minimizeButton:SetScript("OnClick", function(...) self:Minimize(); end);
	titleBar.minimizeButton = minimizeButton;

	-- Restore button
	local restoreButton = CreateFrame("Button", "$parentCloseButton", titleBar, "UIPanelCloseButton");
	restoreButton:SetPoint("RIGHT", closeButton, "LEFT", 9, 0);
	restoreButton:SetHeight(TITLE_BAR_HEIGHT + 6);
	restoreButton:SetWidth(TITLE_BAR_HEIGHT + 6);
	restoreButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-ExpandButton-Up");
	restoreButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-ExpandButton-Down");
	restoreButton:Hide();
	restoreButton:SetScript("OnClick", function(...) self:Restore(); end);
	titleBar.restoreButton = restoreButton;

	-- Menu Bar
	local menuBar = CreateFrame("Frame", "$parentMenuBar", self);
	menuBar:SetHeight(20);
	menuBar:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, 0);
	menuBar:SetPoint("TOPRIGHT", titleBar, "BOTTOMRIGHT", 0, 0);
	menuBar.Window = self;
	self.MenuBar = menuBar;

	-- Status Bar
	local statusBar = CreateFrame("Frame", "$parentStatusBar", self);
	statusBar:SetHeight(15);
	statusBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0);
	statusBar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
	statusBar.Window = self;
	self.StatusBar = statusBar;


	-- Content Frame

	local scrollFrame = CreateFrame("ScrollFrame", "$parentContentContainer", self);
	scrollFrame:SetPoint("TOPLEFT", menuBar, "BOTTOMLEFT", 0, 0);
	scrollFrame:SetPoint("BOTTOMRIGHT", statusBar, "TOPRIGHT", 0, 0); --]]


	local sliderV = CreateFrame("Slider", "$parentScrollBarV", scrollFrame, "UIPanelScrollBarTemplate");
	sliderV:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 2, -16);
	sliderV:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 2, 16);
	sliderV:SetValueStep(1);
	sliderV:SetValue(0);
	sliderV:SetScript("OnValueChanged", function(self, value) self.ScrollFrame:SetVerticalScroll(value) end);
	sliderV.ScrollFrame = scrollFrame;
	scrollFrame.ScrollBarV = sliderV;
	scrollFrame.ScrollBarV:Hide();

	local sliderH = CreateFrame("Slider", "$parentScrollBarH", scrollFrame, "UIPanelScrollBarTemplate");
	sliderH:SetPoint("TOPLEFT", scrollFrame, "BOTTOMLEFT", 16, 6);
	sliderH:SetPoint("TOPRIGHT", scrollFrame, "BOTTOMRIGHT", -16, 6);
	sliderH:SetValueStep(1);
	sliderH:SetValue(0);
	sliderH:SetScript("OnValueChanged", function(self, value) self.ScrollFrame:SetHorizontalScroll(value) end);
	sliderH.ScrollFrame = scrollFrame;
	scrollFrame.ScrollBarH = sliderH;
	scrollFrame.ScrollBarH:Show();

	-- Background frame
	local BORDER_SIZE = 4;
	local bgFrame = CreateFrame("Frame", "$parentBgFrame", self);
	bgFrame:SetHeight(self:GetHeight() + BORDER_SIZE * 2);
	bgFrame:SetWidth(self:GetWidth() + BORDER_SIZE * 2);
	bgFrame:SetPoint("CENTER", self, "CENTER", 0, 0);

	bgFrame:Show();
	self:AddScript("OnResize", function(self, ...) bgFrame:SetHeight(self:GetHeight() + BORDER_SIZE * 2); bgFrame:SetWidth(self:GetWidth() + BORDER_SIZE * 2); end);
	self.BgFrame = bgFrame;

	local bgFrame2 = CreateFrame("Frame", "$parentBgFrame", self);
	bgFrame2:SetHeight(self:GetHeight() + BORDER_SIZE * 2);
	bgFrame2:SetWidth(self:GetWidth() + BORDER_SIZE * 2);
	bgFrame2:SetPoint("CENTER", self, "CENTER", 0, 0);

	bgFrame2:Show();
	self:AddScript("OnResize", function(self, ...) bgFrame2:SetHeight(self:GetHeight() + BORDER_SIZE * 2); bgFrame2:SetWidth(self:GetWidth() + BORDER_SIZE * 2); end);
	self.BgFrame2 = bgFrame2;

	-- Top Bar Background frame
	local topBgFrame = CreateFrame("Frame", "$parentBgFrame", self);
	topBgFrame:SetHeight(titleBar:GetHeight() + BORDER_SIZE * 2);
	topBgFrame:SetWidth(titleBar:GetWidth() + BORDER_SIZE * 2);
	topBgFrame:SetPoint("CENTER", titleBar, "CENTER", 0, 0);
	topBgFrame:Show();
	self:AddScript("OnResize", function(self, ...) topBgFrame:SetHeight(titleBar:GetHeight() + BORDER_SIZE * 2); topBgFrame:SetWidth(titleBar:GetWidth() + BORDER_SIZE * 2); end);
	self.TopBgFrame = topBgFrame;

	function self:UpdateScrollBarsVisibility()

		if self.Content and self.Content:GetHeight() > self.ContentFrame:GetHeight() and false then
			self.ContentFrame.ScrollBarV:Show();
			if menuBar:IsShown() then
				self.ContentFrame:SetPoint("TOPLEFT", menuBar, "BOTTOMLEFT", 0, 0);
			else
				self.ContentFrame:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, 0);
			end
			if statusBar:IsShown() then
				self.ContentFrame:SetPoint("BOTTOMRIGHT", statusBar, "TOPRIGHT", -20, 0);
			else
				self.ContentFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -20, 0);
			end

			scrollFrame:Update()
		else
			self.ContentFrame.ScrollBarV:Hide();
			if menuBar:IsShown() then
				self.ContentFrame:SetPoint("TOPLEFT", menuBar, "BOTTOMLEFT", 0, 0);
			else
				self.ContentFrame:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, 0);
			end
			if statusBar:IsShown() then
				self.ContentFrame:SetPoint("BOTTOMRIGHT", statusBar, "TOPRIGHT", 0, 0);
			else
				self.ContentFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
			end
		end
	end

	function scrollFrame:Update()
		if self:GetScrollChild() then
			local sliderV, sliderH = self.ScrollBarV, self.ScrollBarH;
			local maxV = self:GetScrollChild():GetHeight() * self:GetScrollChild():GetScale() - self:GetHeight();
			if maxV < 0 then maxV = 0; sliderV:Disable(); else sliderV:Enable(); end
			local maxH = self:GetScrollChild():GetWidth() * self:GetScrollChild():GetScale() - self:GetWidth();
			if maxH < 0 then maxH = 0; sliderH:Disable(); else sliderH:Enable(); end
			sliderV:SetMinMaxValues(0, maxV);
			sliderH:SetMinMaxValues(0, maxH);
		end
	end

	self.ContentFrame = scrollFrame;
	self:UpdateScrollBarsVisibility()

	---------------------------------------------------------------------------------------------------------
	-- OnUpdate Handler
	---------------------------------------------------------------------------------------------------------

	self:SetScript("OnUpdate", function(self, elapsed)
		self.TimeSinceLastUpdate = (self.TimeSinceLastUpdate or 0) + elapsed;

		if (self.TimeSinceLastUpdate > 0.1 and not(self.settingUp == true)) then
			local w, h = floor(self:GetWidth() + 0.5), floor(self:GetHeight() + 0.5);
			local cw, ch = self.Width or 0, self.Height or 0;

			if w ~= cw or h ~= ch then
				self:OnResize();
			end
			self.TimeSinceLastUpdate = 0;
		end
	end);

	---------------------------------------------------------------------------------------------------------
	-- Debug Stuff
	---------------------------------------------------------------------------------------------------------

	-- Backgrounds for Dev mode
	function self:SetDevMode(devMode)
		self.Debug = devMode;

		self.TitleBar.bg = self.TitleBar:CreateTexture();
		self.TitleBar.bg:SetAllPoints(self.TitleBar);
		self.TitleBar.bg:SetColorTexture(.8, .8, .8, .5);

		if devMode then
			self.bg = self:CreateTexture();
			self.bg:SetAllPoints(self);
			self.bg:SetColorTexture(.5, .5, .5, .5);

			self.MenuBar.bg = self.MenuBar:CreateTexture();
			self.MenuBar.bg:SetAllPoints(self.MenuBar);
			self.MenuBar.bg:SetColorTexture(.8, .8, .1, .5);



			self.StatusBar.bg = self.StatusBar:CreateTexture();
			self.StatusBar.bg:SetAllPoints(self.StatusBar);
			self.StatusBar.bg:SetColorTexture(.3, .3, .3, .5);

			self.ContentFrame.bg = self.ContentFrame:CreateTexture();
			self.ContentFrame.bg:SetAllPoints(self.ContentFrame);
			self.ContentFrame.bg:SetColorTexture(.4, .3, .8, .5);
		end
	end

	self.Type = "Window";

	self.UpdateTheme = function()

		self.BgFrame:SetBackdrop({
			bgFile = GHM_GetBackground(),
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		});
		self.TitleBar.bg:SetColorTexture(GHM_GetTitleBarColor());
		self.TitleBar.Text:SetTextColor(GHM_GetTitleBarTextColor())
		self.BgFrame2:SetBackdropColor(GHM_GetBackgroundColor())

	end

	GHM_AddThemedObject(self)

end


function GHM_Window_Test_OnLoad(self)

	function self:AddScript(event, handler)
		local events = { "OnResize", "OnMove", "OnMinimize", "OnRestore", "OnDock", "OnUndock", "OnClose" };
		local exist = false;
		for key, value in ipairs(events) do
			if value == event then exist = true; end
		end
		if not exist then return false; end

		if not self.Scripts then self.Scripts = {}; end
		if not self.Scripts[event] then self.Scripts[event] = {}; end
		table.insert(self.Scripts[event], handler);
		return true;
	end

	function self:GetPointInfo(n)
		local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(n);
		return { ["Point"] = point, ["RelativeTo"] = relativeTo, ["RelativePoint"] = relativePoint, ["xOfs"] = floor(xOfs + 0.5), ["yOfs"] = floor(yOfs + 0.5) };
	end

	function self:SetTitle(text)
		if self.TitleBar and self.TitleBar.Text then
			self.TitleBar.Text:SetText(text);
			self.Title = text;
		end
	end

	function self:Minimize()
		if self.Minimized then return; end

		self.MenuBar:Hide();
		self.ContentFrame:Hide();
		self.StatusBar:Hide();
		self:SetHeight(floor(self.TitleBar:GetHeight() + 0.5));

		if self.Scripts and self.Scripts["OnMinimize"] then
			for key, OnMinimize in ipairs(self.Scripts["OnMinimize"]) do
				OnMinimize(self);
			end
		end

		self.Minimized = true;
	end

	function self:Restore()
		if not self.Minimized then return; end

		self:SetHeight(self.Height);
		self:SetWidth(self.Width);

		self.MenuBar:Show();
		self.ContentFrame:Show();
		self.StatusBar:Show();

		if self.Scripts and self.Scripts["OnRestore"] then
			for key, OnRestore in ipairs(self.Scripts["OnRestore"]) do
				OnRestore(self, self.Width, self.Height, self.Point);
			end
		end

		self.Minimized = false;
	end

	function self:Close()
		if self.Minimized then
			self:Restore()
		end

		self:Hide();

		if self.Scripts and self.Scripts["OnClose"] then
			for key, OnClose in ipairs(self.Scripts["OnClose"]) do
				OnClose(self);
			end
		end
		self:SetParent(nil);

		self = nil;
	end

	function self:SetContent(frame)
		self.ContentFrame:SetScrollChild(frame);
		self.Content = frame;
		self.ContentFrame:Update();
	end

	function self:SetContentScale(scale)
		self.Content:SetScale(scale);
		self.ContentFrame:Update();
	end

	---------------------------------------------------------------------------------------------------------
	-- Event handlers
	---------------------------------------------------------------------------------------------------------
	function self:OnResize()
		if self.Minimized then return; end
		local prevWidth, prevHeight = self.Width, self.Height;
		local setWidth, setHeight = floor(self:GetWidth() + 0.5), floor(self:GetHeight() + 0.5);

		if prevWidth == setWidth and prevWidth == setHeight then return; end

		self.Width = setWidth;
		self.Height = setHeight;

		if not prevWidth and not prevHeight then return; end

		if self.Scripts and self.Scripts["OnResize"] then
			for key, OnResize in ipairs(self.Scripts["OnResize"]) do
				OnResize(self, setWidth, setHeight, prevWidth, prevHeight);
			end
		end
	end

	function self:OnMove()
		local point = self:GetPointInfo(1);
		local prevPoint = self.Point;

		local changed = false;

		if prevPoint then
			for key, value in pairs(point) do
				if prevPoint[key] ~= value then changed = true; end
			end
		else
			changed = true;
		end

		if changed and self:IsVisible() then
			if self.Scripts and self.Scripts["OnMove"] then
				for key, OnMove in ipairs(self.Scripts["OnMove"]) do
					OnMove(self, point["xOfs"], point["yOfs"], (prevPoint and prevPoint["xOfs"] or 0), (prevPoint and prevPoint["yOfs"] or 0), point, prevPoint);
				end
			end
			self.Point = point;
		end
	end


	---------------------------------------------------------------------------------------------------------
	-- Main init
	---------------------------------------------------------------------------------------------------------
	self:RegisterForDrag("LeftButton");
	self:SetMovable();

	-- Title Bar
	local titleBar = CreateFrame("Frame", "$parentTitleB", self);
	titleBar:SetHeight(15);
	titleBar:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0);
	titleBar:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0);


	local titleText = titleBar:CreateFontString(nil, "OVERLAY", "SystemFont_Tiny");
	titleText:SetHeight(15);
	titleText:SetPoint("CENTER", 0, 0);
	titleText:SetJustifyH("CENTER");
	titleBar.Text = titleText;

	titleBar.Window = self;

	titleBar:SetScript("OnMouseDown", function(self) if self.Window then self.Window:StartMoving(); end end)
	titleBar:SetScript("OnMouseUp", function(self) if self.Window then self.Window:StopMovingOrSizing(); self.Window:OnMove(); end end)
	titleBar:SetScript("OnHide", function(self) if self.Window then self.Window:StopMovingOrSizing(); self.Window:OnMove(); end end)


	local btnClose = CreateFrame("Button", "$parentCloseButton", titleBar);
	btnClose.Window = self;
	btnClose:SetPoint("TOPRIGHT", titleBar, "TOPRIGHT", 5, 5);
	btnClose:SetWidth(24);
	btnClose:SetHeight(24);
	--btnClose:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Up");
	btnClose:SetHighlightTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Up", "ADD");
	--btnClose:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Down");
	btnClose:SetScript("OnClick", function(self) self.Window:Close(); end);

	local txtClose = btnClose:CreateTexture();
	txtClose:SetTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Up");
	txtClose:SetAllPoints();


	local btnMinimize = CreateFrame("Button", nil, titleBar);
	btnMinimize.Window = self;
	btnMinimize:SetPoint("TOPRIGHT", btnClose, "TOPLEFT", 10, 0);
	btnMinimize:SetWidth(24);
	btnMinimize:SetHeight(24);
	--btnMinimize:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-HideButton-Up");
	btnMinimize:SetHighlightTexture("Interface\\BUTTONS\\UI-Panel-HideButton-Up", "ADD");
	--btnMinimize:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-HideButton-Down");
	btnMinimize:SetScript("OnClick", function(self) self.Window:Minimize(); end);

	local txtMin = btnMinimize:CreateTexture();
	txtMin:SetTexture("Interface\\BUTTONS\\UI-Panel-HideButton-Up");
	txtMin:SetAllPoints();


	local btnRestore = CreateFrame("Button", nil, titleBar);
	btnRestore.Window = self;
	btnRestore:SetPoint("TOPRIGHT", btnMinimize, "TOPLEFT", 10, 0);
	btnRestore:SetWidth(24);
	btnRestore:SetHeight(24);
	--btnRestore:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-BiggerButton-Up");
	btnRestore:SetHighlightTexture("Interface\\BUTTONS\\UI-Panel-BiggerButton-Up", "ADD");
	--btnRestore:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-BiggerButton-Down");
	btnRestore:SetScript("OnClick", function(self) self.Window:Restore(); end);

	local txtRest = btnRestore:CreateTexture();
	txtRest:SetTexture("Interface\\BUTTONS\\UI-Panel-BiggerButton-Up");
	txtRest:SetAllPoints();


	self.TitleBar = titleBar;


	-- Menu Bar
	local menuBar = CreateFrame("Frame", "$parentMenuBar", self);
	menuBar:SetHeight(40);
	menuBar:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, 0);
	menuBar:SetPoint("TOPRIGHT", titleBar, "BOTTOMRIGHT", 0, 0);
	menuBar.Window = self;
	self.MenuBar = menuBar;

	-- Status Bar
	local statusBar = CreateFrame("Frame", "$parentStatusBar", self);
	statusBar:SetHeight(15);
	statusBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0);
	statusBar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
	statusBar.Window = self;
	self.StatusBar = statusBar;


	-- Content Frame
	local scrollFrame = CreateFrame("ScrollFrame", "$parentContentContainer", self);
	scrollFrame:SetFrameStrata("DIALOG");

	scrollFrame:SetPoint("TOPLEFT", menuBar, "BOTTOMLEFT", 0, 0);
	scrollFrame:SetPoint("BOTTOMRIGHT", statusBar, "TOPRIGHT", 0, 0);
	scrollFrame.Window = self;

	local sliderV = CreateFrame("Slider", "$parentScrollBarV", scrollFrame, "GHU_ScrollBarTemplateV");
	sliderV:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 1, -12);
	sliderV:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 1, 12);
	sliderV:SetValueStep(1);
	sliderV:SetValue(0);
	sliderV:SetScript("OnValueChanged", function(self, value) self.ScrollFrame:SetVerticalScroll(value) end);
	sliderV.ScrollFrame = scrollFrame;
	scrollFrame.ScrollBarV = sliderV;
	scrollFrame.ScrollBarV:Show();

	local sliderH = CreateFrame("Slider", "$parentScrollBarH", scrollFrame, "GHU_ScrollBarTemplateH");
	sliderH:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMLEFT", 12, 0);
	sliderH:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", -12, 0);
	sliderH:SetValueStep(1);
	sliderH:SetValue(0);
	sliderH:SetScript("OnValueChanged", function(self, value) self.ScrollFrame:SetHorizontalScroll(value); end);
	sliderH.ScrollFrame = scrollFrame;
	scrollFrame.ScrollBarH = sliderH;
	scrollFrame.ScrollBarH:Show();


	function scrollFrame:Update()
		local width, height = self:GetWidth(), self:GetHeight();

		local sliderV, sliderH = self.ScrollBarV, self.ScrollBarH;
		local cScale = self:GetScrollChild():GetScale();

		local maxV = floor(self:GetScrollChild():GetHeight() - (self:GetHeight() / cScale) + 0.5);
		if maxV < 0 then maxV = 0; sliderV:Hide(); else sliderV:Show(); end

		local maxH = floor(self:GetScrollChild():GetWidth() - (self:GetWidth() / cScale) + 0.5);
		if maxH < 0 then maxH = 0; sliderH:Hide(); else sliderH:Show(); end

		local vV, vH = sliderV:GetValue(), sliderV:GetValue();

		sliderV:SetMinMaxValues(0, maxV);
		sliderH:SetMinMaxValues(0, maxH);

		sliderV:SetValue(vV);
		sliderH:SetValue(vH);
	end

	self.ContentFrame = scrollFrame;


	---------------------------------------------------------------------------------------------------------
	-- OnUpdate Handler
	---------------------------------------------------------------------------------------------------------

	self:SetScript("OnUpdate", function(self, elapsed)
		self.TimeSinceLastUpdate = (self.TimeSinceLastUpdate or 0) + elapsed;

		if (self.TimeSinceLastUpdate > 0.1) then
			local w, h = floor(self:GetWidth() + 0.5), floor(self:GetHeight() + 0.5);
			local cw, ch = self.Width or 0, self.Height or 0;

			if w ~= cw or h ~= ch then
				self:OnResize();
			end
			self.TimeSinceLastUpdate = 0;
		end
	end);

	---------------------------------------------------------------------------------------------------------
	-- Debug Stuff
	---------------------------------------------------------------------------------------------------------

	-- Backgrounds for Dev mode
	function self:SetDevMode(devMode)
		self.Debug = devMode;
		if devMode then
			self.bg = self:CreateTexture();
			self.bg:SetAllPoints(self);
			self.bg:SetColorTexture(.5, .5, .5, .5);

			self.TitleBar.bg = self.TitleBar:CreateTexture();
			self.TitleBar.bg:SetAllPoints(self.TitleBar);
			self.TitleBar.bg:SetColorTexture(.8, .8, .8, .5);

			self.MenuBar.bg = self.MenuBar:CreateTexture();
			self.MenuBar.bg:SetAllPoints(self.MenuBar);
			self.MenuBar.bg:SetColorTexture(.8, .8, .1, .5);



			self.StatusBar.bg = self.StatusBar:CreateTexture();
			self.StatusBar.bg:SetAllPoints(self.StatusBar);
			self.StatusBar.bg:SetColorTexture(.3, .3, .3, .5);

			self.ContentFrame.bg = self.ContentFrame:CreateTexture();
			self.ContentFrame.bg:SetAllPoints(self.ContentFrame);
			self.ContentFrame.bg:SetColorTexture(.4, .3, .8, .5);
		end
	end

	self.Type = "Window";
end

