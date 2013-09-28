--===================================================
--
--						GHI Target
--					GHI_TargetUI.lua
--	
-- 			(c)2013 The Gryphonheart Team
--===================================================

GHI_TargetUI = CreateFrame("Frame");
GHI_TargetUI.__index = GHI_TargetUI;
GHI_TargetUI.hooked = {};

GHI_TargetUI.buttons = {};

local loc = GHI_Loc();
-- 	standard
function GHI_TargetUI:Create(varName)
	_G[varName] = GHI_TargetUI; -- there is no need for more than one object
end

function GHI_TargetUI:OnEvent(event)
	local versionInfo = GHI_VersionInfo();

	if self.mainButton then
		if UnitExists("target") and UnitIsPlayer("target") and UnitFactionGroup("target") == UnitFactionGroup("player") then
			local displayMethod = GHI_MiscData.target_icon_display_method or 1;

			if displayMethod == 1 then
				self.mainButton:Show();
				return
			elseif displayMethod == 2 and #(versionInfo.GetPlayerAddOns(UnitName("target"))) > 0 then
				self.mainButton:Show();
				return
			end
		end
		self.mainButton:Hide();
	end
end

GHI_TargetUI:SetScript("OnEvent", GHI_TargetUI.OnEvent);
GHI_TargetUI:RegisterEvent("PLAYER_TARGET_CHANGED");

local function CreateTargetButton(name)
	local button = CreateFrame("Button", name, UIParent)
	button:SetHeight(33);
	button:SetWidth(33);

	local overlay = button:CreateTexture(nil, "OVERLAY");
	overlay:SetWidth(56);
	overlay:SetHeight(56);
	overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder");
	overlay:SetPoint("TOPLEFT", 0, 0);
	button.overlay = overlay;

	local icon = button:CreateTexture(nil, "BACKGROUND");
	icon:SetWidth(18);
	icon:SetHeight(18);
	icon:SetTexture("Interface\\AddOns\\GHI\\texture\\GH_RoundIcon")
	icon:SetPoint("TOPLEFT", 8, -8);
	icon:SetTexCoord(.075, .925, .075, .925)
	button.icon = icon;

	button:SetScript("PreClick", function() PlaySound("igMainMenuOptionCheckBoxOn") end);

	button:SetFrameStrata("MEDIUM");
	button:SetFrameLevel(8);
	button:Hide();
	button:RegisterForClicks("AnyUp")

	button:SetScript("OnMouseDown", function(b) b.icon:SetTexCoord(0, 1, 0, 1) end);
	button:SetScript("OnMouseUp", function(b) b.icon:SetTexCoord(.075, .925, .075, .925) end);
	return button;
end

function GHI_TargetUI:AddButton(refID, icon, tooltipFunc, clickFunc, targetType)

	assert(type(refID) == "string" or type(refID) == "number", "RefID must be a number or string.");
	assert(self.buttons[refID] == nil, format("Button %s already made", refID));

	self:SetUpMainButton();

	local button = CreateTargetButton("GHI_TargetUIButton" .. refID);

	button:SetParent(self.mainButton);
	button:SetScript("OnEnter", tooltipFunc)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	button:SetScript("OnClick", clickFunc)

	self.buttons[refID] = button;
	self:ChangeButtonSetup();
end

function GHI_TargetUI:SetUpMainButton()
	if not (self.mainButton) then

		local button = CreateTargetButton("GHU_MainTargetButton");
		button:RegisterForDrag("LeftButton")
		button:SetMovable();

		button:SetScript("OnUpdate", function(b) b.obj:UnitIconButtonIconMove() end)
		button:SetScript("OnDragStart", function(b) b.obj.iconDrag = true end)
		button:SetScript("OnDragStop", function(b) b.obj.iconDrag = false end)
		button:SetScript("OnLeave", function() GameTooltip:Hide() end)

		button.obj = self;

		self.mainButton = button;
		self:UnitIconButtonIconMove((GHI_MiscData or {})["TargetButtonPos"] or { UIParent:GetWidth() / 2, UIParent:GetHeight() / 2 });
	end
end

function GHI_TargetUI:NumButtons()
	local c = 0;
	for _, b in pairs(self.buttons) do
		c = c + 1;
	end
	return c;
end

function GHI_TargetUI:ChangeButtonSetup()

	if self:NumButtons() == 1 then
		-- hide button one
		local button;
		for ref, b in pairs(self.buttons) do
			b:Hide();
			button = b;
		end

		-- set up main button with its info
		self.mainButton:SetScript("OnEnter", button:GetScript("OnEnter"));
		self.mainButton:SetScript("OnClick", button:GetScript("OnClick"));
	else
		-- set up main button to only have main button into
		self.mainButton:SetScript("OnEnter", function()
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			GameTooltip:ClearLines()
			GameTooltip:AddLine(loc.BTN_TOGGLE, 1, 0.8196079, 0);
			GameTooltip:Show()
			self.UpdateTooltip = nil;
		end);
		self.mainButton:SetScript("OnClick", function(self, btn) if (button == "LeftButton") then b.obj:Toggle(); end end);
	end
end

function GHI_TargetUI:Toggle()
	if self:NumButtons() > 1 then
		for i, btn in pairs(self.buttons) do
			btn:Show();
		end
	end
end

function GHI_TargetUI:UnitIconButtonIconMove(iconpos)
	if (not self.iconDrag and not iconpos) then
		return;
	end

	local xpos, ypos;

	if (iconpos) then
		xpos = iconpos[1];
		ypos = iconpos[2];
	end

	if (not xpos and not ypos) then
		local x, y = GetCursorPosition();
		local s = self.mainButton:GetEffectiveScale();

		xpos, ypos = x / s, y / s;
	end

	GHI_MiscData = GHI_MiscData or {};
	GHI_MiscData["TargetButtonPos"] = { xpos, ypos };

	-- Hide the tooltip
	GameTooltip:Hide();

	-- Set the position
	self.mainButton:SetPoint("CENTER", UIParent, "BOTTOMLEFT", xpos, ypos);
end
