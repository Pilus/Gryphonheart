--===================================================
--
--				GHI_ActionBarUI
--				GHI_ActionBarUI.lua
--
--		Custom buffs cast by items
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local supportedUnits = { "player", "target" };

local function GHI_Set(array, ...) -- last argument is the value to set as.
	for i, index in pairs({ ... }) do
		if not (type(array[index]) == "table") then
			assert(array[index] == nil or i == (#({ ... }) - 1), "Set error. Value " .. index .. " is already written as " .. type(array[index]));
			array[index] = {};
		end

		if i == #({ ... }) - 1 then
			array[index] = ({ ... })[i + 1];
			break;
		else
			array = array[index]
		end
	end
end

GHI_BuffUIDisplay = CreateFrame("frame");
GHI_BuffUIDisplay.debugType = "C";
GHI_BuffUIDisplay.buffs = {};
GHI_BuffUIDisplay.buffObjs = {};
GHI_BuffUIDisplay.debuffs = {};
GHI_BuffUIDisplay.nextUpdate = {};
GHI_BuffUIDisplay.stickToBlizzFrame = {};

local GHI_BuffUIFrames = {};
function GHI_BuffUIDisplay:OnEvent(event, arg1, arg2)
	if event == "PLAYER_TARGET_CHANGED" and GHI_BuffUIFrames["target"] then
		self:UpdateDB("target");
		if self.stickToBlizzFrame["target"] then
			GHI_BuffUIFrames["target"]:Hide();
		else
			GHI_BuffUIFrames["target"]:Show();
		end
	end

	if event == "PLAYER_ENTERING_WORLD" then
		GHI_Timer(self.CheckUpdate, 1, false, "Check buff updates")
		hooksecurefunc("BuffFrame_Update", function() GHI_BuffUIFrame_Update() end);
	end

	if event == "UNIT_AURA" and arg1 == "target" then
		if UnitExists("target") and self.stickToBlizzFrame["target"] then
			GHI_BuffUIFrame_UpdateAllBuffAnchors("target");
			GHI_BuffUIFrame_UpdateAllDebuffAnchors("target");
		end
	end
end

GHI_BuffUIDisplay:SetScript("OnEvent", GHI_BuffUIDisplay.OnEvent);
GHI_BuffUIDisplay:RegisterEvent("PLAYER_TARGET_CHANGED");
GHI_BuffUIDisplay:RegisterEvent("PLAYER_ENTERING_WORLD");
GHI_BuffUIDisplay:RegisterEvent("UNIT_AURA");

function GHI_BuffUIDisplay:RegisterBuffObj(buffObj)
	if not (type(self.buffObjs) == "table") then
		self.buffObjs = {};
		self.buffFrames = {};
		hooksecurefunc("BuffFrame_Update", GHI_BuffUIFrame_Update);
		self.buffs = {};
		self.debuffs = {};
		self.nextUpdate = {};
	end

	table.insert(self.buffObjs, buffObj);

	return self;
end


function GHI_BuffUIDisplay:GetBuffs(unit, filter) -- returns table with buff info
	if filter == 1 then
		return self.buffs[unit] or {};
	elseif filter == 2 then
		return self.debuffs[unit] or {};
	end
	return {};
end

function GHI_BuffUIDisplay:GetNumberBuffs(unit, filter)
	return #(self:GetBuffs(unit, filter));
end

function GHI_BuffUIDisplay:CheckUpdate()
	self = GHI_BuffUIDisplay;
	for unit, upTime in pairs(self.nextUpdate) do
		if type(upTime) == "number" and upTime <= GetTime() then
			self:UpdateDB(unit);
			break;
		end
	end
end

function GHI_BuffUIDisplay:UpdateDB(unit) -- remember to call this on target change etc.
	local guid = UnitGUID(unit);
	local nextUp

	self.buffs = self.buffs or {};

	-- update buffs
	self.buffs[unit] = {};
	for i, buffObj in pairs(self.buffObjs) do
		local res = buffObj:GetBuffs(guid, 1);

		if type(res) == "table" then
			for _, b in pairs(res) do
				b.buffObj = buffObj; -- Is this used? Maybe when clicking

				if b.expirationTime and not (b.expirationTime == 0) and b.expirationTime <= GetTime() then
					-- remove buff
					buffObj:RemoveBuff(b.refID, UnitGUID(unit), 0);
					return;
				else
					if b.expirationTime then
						if not (nextUp) or (nextUp > b.expirationTime and b.expirationTime > GetTime()) then
							nextUp = b.expirationTime;
						end
					end
					table.insert(self.buffs[unit], b);
				end
			end
		end
	end

	-- update debuffs
	self.debuffs[unit] = {};
	for _, buffObj in pairs(self.buffObjs) do
		local res = buffObj:GetBuffs(guid, 2);
		if type(res) == "table" then
			for _, b in pairs(res) do
				b.buffObj = buffObj;
				if b.expirationTime and not (b.expirationTime == 0) and b.expirationTime <= GetTime() then
					-- remove buff
					buffObj:RemoveBuff(b.refID, UnitGUID(unit), 0);
					return;
				else
					if b.expirationTime then
						if not (nextUp) or (nextUp > b.expirationTime and b.expirationTime > GetTime()) then
							nextUp = b.expirationTime;
						end
					end
					table.insert(self.debuffs[unit], b);
				end
			end
		end
	end

	self.nextUpdate[unit] = nextUp;

	-- call update func
	if (unit == "player") then
		GHI_BuffUIFrame_Update()
	elseif (unit == "target") then
		GHI_BuffUIFrame_Update()
	end
end

function GHI_BuffUIDisplay:FindBuff(unit, refID)
	local t1 = self:GetBuffs(unit, 1);
	for _, b in pairs(t1) do
		if b.refID == refID then return b; end;
	end

	local t2 = self:GetBuffs(unit, 2);
	for _, b in pairs(t2) do
		if b.refID == refID then return b; end;
	end

	return {};
end

function GHI_BuffUIDisplay:DisplayTooltip(button)
	local unit = button.unit;
	local refID = button.refID;
	if not (unit and refID) then return end;
	local buff = self:FindBuff(unit, refID);
	if not (buff) then return end;

	if button:GetCenter() > UIParent:GetWidth() / 2 then
		GameTooltip:SetOwner(button, "ANCHOR_BOTTOMLEFT", 0, 0);
	else
		GameTooltip:SetOwner(button, "ANCHOR_BOTTOMRIGHT", 15, -25);
	end

	GameTooltip:ClearLines();
	GameTooltip:SetText(buff.name or "", 1, 0.8196079, 0);
	GameTooltip:AddLine(buff.description or "", 1, 1, 1, 1, 1);

	if buff.expirationTime > 0 then
		local s1 = format(SecondsToTimeAbbrev(buff.expirationTime - GetTime()));
		local n, suffix = string.split(" ", string.match(s1, "%d* %a") or "")
		n = tonumber(n);

		local s2 = "";
		if suffix == "s" then s2 = SPELL_TIME_REMAINING_SEC; end
		if suffix == "m" then s2 = SPELL_TIME_REMAINING_MIN; end
		if suffix == "h" then s2 = SPELL_TIME_REMAINING_HOURS; end
		if suffix == "d" then s2 = SPELL_TIME_REMAINING_DAYS; end

		GameTooltip:AddLine(format(s2, n), 1, 0.8196079, 0);
	end

	if type(buff.customText) == "table" then
		GameTooltip:AddLine(unpack(buff.customText));
	end

	GameTooltip:Show();
end


function GHI_BuffUIDisplay:StickDisplayToBlizzFrame(unit, stick)
	if not (stick == true or stick == 1) then
		stick = nil;
	else
		stick = true
	end

	self.stickToBlizzFrame[unit] = stick;

	self:UpdateDB(unit);

	if GHI_BuffUIFrames[unit] then
		if stick then
			GHI_BuffUIFrames[unit]:Hide();
		else
			GHI_BuffUIFrames[unit]:Show();
		end
	end

end

-- ================================================================
-- Buff functions. Copied from Blizzard code and modified
-- ================================================================

function GHI_BuffUIResetAllPositions(self)
	local x, y = UIParent:GetWidth() / 2, UIParent:GetHeight() / 2;
	for _, unit in pairs(supportedUnits) do
		GHI_Set(GHI_MiscData, "BuffPos", unit, 1, x);
		GHI_Set(GHI_MiscData, "BuffPos", unit, 2, y);
		if GHI_BuffUIFrames[unit] then
			GHI_BuffUIFrames[unit]:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", x, y);
		end
	end
end

function GHI_BuffUIIconButtonIconMove(self)
	if (not self.iconDrag and not iconpos) then
		return;
	end
	if not (IsMouseButtonDown("leftbutton")) then
		self.iconDrag = false;
		return;
	end

	local xpos, ypos;

	if (iconpos) then
		xpos = iconpos[1];
		ypos = iconpos[2];
	end

	if (not xpos and not ypos) then
		local x, y = GetCursorPosition();
		local s = self.main:GetEffectiveScale();
		xpos, ypos = x / s, y / s;
	end

	GHI_Set(GHI_MiscData, "BuffPos", self.main.unit, { xpos + (self:GetWidth() / 2), ypos - (self:GetHeight() / 2) });

	-- Hide the tooltip
	GameTooltip:Hide();

	-- Set the position
	self.main:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", xpos + (self:GetWidth() / 2), ypos - (self:GetHeight() / 2));
end

-- ************ 		Player Buff frame		************
function GHI_BuffUIFrame_OnEnter(unit)
	if GHI_BuffUIFrames[unit] and not (GHI_BuffUIDisplay.stickToBlizzFrame[unit]) then
		GHI_BuffUIFrames[unit].button:Show();
	end
end

function GHI_BuffUIFrame_OnLeave(unit)
	if GHI_BuffUIFrames[unit] and not (GHI_BuffUIFrames[unit].button.iconDrag) then
		GHI_BuffUIFrames[unit].button:Hide();
	end
end

local function GHI_Get(array, ...)
	if not (type(array) == "table") then return array end
	for _, index in pairs({ ... }) do
		array = array[index];
		if not (type(array) == "table") then
			break;
		end
	end
	return array;
end

function GHI_BuffUIFrame_Update()
	for _, unit in pairs(supportedUnits) do
		if GHI_Get then
			-- Create new frames
			if not (GHI_BuffUIFrames[unit]) then
				local f = CreateFrame("Button", nil, UIParent);
				local x = GHI_Get(GHI_MiscData, "BuffPos", unit, 1) or UIParent:GetWidth() / 2;
				local y = GHI_Get(GHI_MiscData, "BuffPos", unit, 2) or UIParent:GetHeight() / 2;

				f:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", x, y);
				f:Show();

				f:SetFrameStrata("BACKGROUND")
				f:SetWidth(90)
				f:SetHeight(32)

				f:SetScript("OnEnter", function(f) GHI_BuffUIFrame_OnEnter(f.unit); end);
				f:SetScript("OnLeave", function(f) GHI_BuffUIFrame_OnLeave(f.unit); end);

				local b = CreateFrame("Button", nil, f);
				b.debugType = "E";
				b:SetWidth(100)
				b:SetHeight(40);
				local t = b:CreateTexture(nil, "BACKGROUND")
				t:SetTexture("Interface\\CHATFRAME\\ChatFrameTab.blp")
				t:SetAllPoints(b)
				b.texture = t;
				b:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", 10, -1);
				b:RegisterForClicks("AnyUp")
				b:SetScript("OnUpdate", function(b) GHI_BuffUIIconButtonIconMove(b) end)
				b:SetScript("OnDragStart", function(b) b.iconDrag = true end)
				b:SetScript("OnDragStop", function(b) b.iconDrag = false end)
				b:RegisterForDrag("LeftButton")
				b:SetMovable();
				b:Hide();

				local pf = b:CreateFontString();
				pf:SetFontObject("GameFontNormalSmall");
				pf:SetText("GH Buffs");
				pf:SetPoint("CENTER", 0, 0, b);

				local pf2 = b:CreateFontString();
				pf2:SetFontObject("GameFontWhiteTiny");
				pf2:SetText(strsub(strupper(unit), 0, 1) .. strsub(strlower(unit), 2));
				pf2:SetPoint("CENTER", 0, -10, b);

				b:SetScript("OnEnter", function() GHI_BuffUIFrame_OnEnter(b.main.unit) end);
				b:SetScript("OnLeave", function() GHI_BuffUIFrame_OnLeave(b.main.unit) end);
				b.main = f

				f.unit = unit
				f.button = b;
				GHI_BuffUIFrames[unit] = f;
			end

			if not (UnitExists(unit)) then
				GHI_BuffUIFrames[unit]:Hide();
			elseif not(GHI_BuffUIDisplay.stickToBlizzFrame[unit]) then
				GHI_BuffUIFrames[unit]:Show();
			end

			for i = 1, BUFF_MAX_DISPLAY do
				if (GHI_AuraButton_Update("GHI_BuffUIButton", i, "HELPFUL", unit)) then
				end
			end

			GHI_BuffUIFrame_UpdateAllBuffAnchors(unit);

			for i = 1, DEBUFF_MAX_DISPLAY do
				if (GHI_AuraButton_Update("GHI_DebuffButton", i, "HARMFUL", unit)) then
				end
			end

			GHI_BuffUIFrame_UpdateAllDebuffAnchors(unit);
		end
	end
end

function GHI_AuraButton_Update(buttonName, index, filter, unit)
	local buffName

	self = GHI_BuffUIDisplay;

	local name, rank, texture, count, debuffType, duration, expirationTime, _, _, shouldConsolidate; -- = UnitAura(unit, index, filter);
	local refID, buffObj;

	local done;

	if filter == "HELPFUL" and index <= self:GetNumberBuffs(unit, 1) then
		local t = self:GetBuffs(unit, 1)[index];

		if type(t) == "table" then
			name = t.name or "";
			rank = t.rank or 0;
			texture = t.icon or "Interface\\Icons\\Ability_Marksmanship";
			duration = t.totalDuration or 0;
			expirationTime = t.expirationTime;
			count = t.count or 1;
			refID = t.refID;
			buffObj = t.buffObj;
		else
			name = "";
			count = 0;
			duration = 0;
			texture = "Interface\\Icons\\Ability_Marksmanship";
		end
	elseif filter == "HARMFUL" and index <= self:GetNumberBuffs(unit, 2) then
		local t = self:GetBuffs(unit, 2)[index];
		if type(t) == "table" then
			name = t.name or "";
			rank = t.rank or 0;
			texture = t.icon or "Interface\\Icons\\Ability_Marksmanship";
			duration = t.totalDuration or 0;
			expirationTime = t.expirationTime;
			count = t.count or 1;
			debuffType = t.debuffType or "";
			refID = t.refID;
			buffObj = t.buffObj;
		else
			name = "";
			count = 0;
			duration = 0;
			texture = "Interface\\Icons\\Ability_Marksmanship";
		end
	end

	if not (buffName) then
		buffName = buttonName .. unit .. index;
	end

	local buff = _G[buffName];

	if (not name) then
		-- No buff so hide it if it exists
		if (buff) then
			buff:Hide();
			if unit == "player" then
				buff.duration:Hide();
			end
			buff.refID = nil;
		end
		return nil;
	else
		local helpful = (filter == "HELPFUL");

		-- If button doesn't exist make it
		if (not buff) then
			if (helpful) then
				buff = CreateFrame("Button", buffName, GHI_BuffUIFrames[unit], unit == "player" and "BuffButtonTemplate" or "TargetBuffFrameTemplate");
				buff.debugType = "A";
				if not (unit == "player") then
					buff:SetHeight(17);
					buff:SetWidth(17);
				end
			else
				buff = CreateFrame("Button", buffName, GHI_BuffUIFrames[unit], unit == "player" and "DebuffButtonTemplate" or "TargetDebuffFrameTemplate");
				buff.debugType = "B";
			end

			buff.parent = GHI_BuffUIFrames[unit];
			buff.unit = unit;
			buff.index = index;

			buff:SetScript("OnEnter", function()
				GHI_BuffUIFrame_OnEnter(buff.unit);
				GameTooltip:SetFrameLevel(buff:GetFrameLevel() + 2);
				GHI_BuffUIDisplay:DisplayTooltip(buff);
			end);
			buff:SetScript("OnLeave", function()
				GameTooltip:Hide();
				GHI_BuffUIFrame_OnLeave(buff.unit);
			end);
			buff:SetScript("OnUpdate", function()
				if (GameTooltip:IsOwned(buff)) then
					GHI_BuffUIDisplay:DisplayTooltip(buff);
				end
			end);

			if (helpful) then
				buff:SetScript("OnClick", function()
					if type(buff.buffObj) == "table" and unit == "player" then
						buff.buffObj:RemoveBuff(buff.refID, UnitGUID(buff.unit), 1);
					end
				end);
			end
		end

		if not (UnitExists(unit)) then
			buff:Hide();
			return;
		end

		-- Setup Buff
		buff.refID = refID;
		buff.buffObj = buffObj;

		buff:SetID(index);
		buff.unit = unit;
		buff.filter = filter;
		buff:SetAlpha(1.0);
		buff.exitTime = nil;
		buff.consolidated = nil;
		buff:Show();

		buff.expirationTime = expirationTime;

		-- Set filter-specific attributes
		if (not helpful) then
			-- Anchor Debuffs

			-- Set color of debuff border based on dispel class.
			local debuffSlot = _G[buffName .. "Border"];
			if (debuffSlot) then
				local color;
				if (debuffType) then
					color = DebuffTypeColor[debuffType];
				else
					color = DebuffTypeColor["none"];
				end
				debuffSlot:SetVertexColor(color.r, color.g, color.b);
			end
		end

		if unit == "player" then
			if (duration > 0 and expirationTime) then
				if (SHOW_BUFF_DURATIONS == "1") then
					buff.duration:Show();
				else
					buff.duration:Hide();
				end

				if (not buff.timeLeft) then
					buff.timeLeft = expirationTime - GetTime();
					buff:SetScript("OnUpdate", GHI_AuraButton_OnUpdate);
				else
					buff.timeLeft = expirationTime - GetTime();
				end
			else
				buff.duration:Hide();
				if (buff.timeLeft) then
					buff:SetScript("OnUpdate", nil);
				end
				buff.timeLeft = nil;
			end

			-- Set the number of applications of an aura
			if (count > 1) then
				buff.count:SetText(count);
				buff.count:Show();
			else
				buff.count:Hide();
			end
		else
			-- Handle cooldowns
			frameCooldown = _G[buffName .. "Cooldown"];
			if (duration > 0) then
				frameCooldown:Show();
				CooldownFrame_SetTimer(frameCooldown, expirationTime - duration, duration, 1);
			else
				frameCooldown:Hide();
			end
		end
		-- Set Texture
		local icon = _G[buffName .. "Icon"];
		icon:SetTexture(texture);

		-- Refresh tooltip
		if (GameTooltip:IsOwned(buff)) then
			self:DisplayTooltip(buff);
		end

		if (CONSOLIDATE_BUFFS == "1" and shouldConsolidate) then
			if (buff.timeLeft and duration > 30) then
				buff.exitTime = expirationTime - max(10, duration / 10);
			end
		end
	end
	return 1;
end

function GHI_AuraButton_OnUpdate(self)
	local index = self:GetID();
	if (self.timeLeft < BUFF_WARNING_TIME) then
		self:SetAlpha(BuffFrame.BuffAlphaValue);
	else
		self:SetAlpha(1.0);
	end

	-- Update duration
	AuraButton_UpdateDuration(self, self.timeLeft); -- Taint issue with SecondsToTimeAbbrev
	self.timeLeft = max(self.expirationTime - GetTime(), 0);

	if (GameTooltip:IsOwned(self)) then
		GHI_BuffUIDisplay:DisplayTooltip(self);
	end
end

local PlayerGotNonConsolidateBuff = function()
	local i = 1;
	while (UnitBuff("player",i)) do
		local shouldConsilidate = select(10,UnitBuff("player",i));
		if shouldConsilidate then
			return false;
		end
		i = i + 1;
	end
	return true;
end

function GHI_BuffUIFrame_UpdateAllBuffAnchors(unit)
	local self = GHI_BuffUIDisplay;
	local buff, previousBuff, aboveBuff;
	local numBuffs = 0;
	local slack = 0;

	numBuffs = 0;

	for i = 1, self:GetNumberBuffs(unit, 1) do
		local buff = _G["GHI_BuffUIButton" .. unit .. i];
		numBuffs = numBuffs + 1;
		local index = numBuffs + slack;
		if (buff.parent ~= GHI_BuffUIFrames[unit]) then
			buff.count:SetFontObject(NumberFontNormal);
			buff:SetParent(GHI_BuffUIFrames[unit]);
			buff.parent = GHI_BuffUIFrames[unit];
		end

		if GHI_BuffUIDisplay.stickToBlizzFrame[unit] then
			buff:SetParent(BuffFrame);
			if not (unit == "player") then
				buff:SetHeight(21);
				buff:SetWidth(21);
			end
		else
			buff:SetParent(buff.parent);
			if not (unit == "player") then
				buff:SetHeight(17);
				buff:SetWidth(17);
			end
		end

		buff:ClearAllPoints();
		if (index == 1) then
			if unit == "player" then
				if GHI_BuffUIDisplay.stickToBlizzFrame[unit] then
					-- determine the last shown buff button
					local f;
					local i = BUFFS_PER_ROW;
					while ((not (_G["BuffButton" .. i]) or not (_G["BuffButton" .. i]:IsShown())) and i > 0) do
						i = i - 1;
					end;
					if (i > 0) then
						buff:SetPoint("RIGHT", _G["BuffButton" .. i], "LEFT", -5, 0);
					elseif ConsolidatedBuffs and ConsolidatedBuffs:IsShown() and not(PlayerGotNonConsolidateBuff()) then
						buff:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPLEFT", -5, 0);
					else
						buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, 0);
					end
				else
					buff:SetPoint("TOPRIGHT", GHI_BuffUIFrames[unit], "TOPRIGHT", 0, -2);
				end
			elseif unit == "target" then
				if GHI_BuffUIDisplay.stickToBlizzFrame[unit] then
					-- determine the last shown buff button
					local f;
					local buffI = BUFFS_PER_ROW;
					while ((not (_G["TargetFrameBuff" .. buffI]) or not (_G["TargetFrameBuff" .. buffI]:IsShown())) and buffI > 0) do
						buffI = buffI - 1;
					end;
					local debuffI = BUFFS_PER_ROW;
					while ((not (_G["TargetFrameDebuff" .. debuffI]) or not (_G["TargetFrameDebuff" .. debuffI]:IsShown())) and debuffI > 0) do
						debuffI = debuffI - 1;
					end;

					if (buffI > 0) then
						buff:SetPoint("LEFT", _G["TargetFrameBuff" .. buffI], "RIGHT", 0, 0);
					else
						if debuffI == 0 then
							buff:SetPoint("TOPLEFT", TargetFrame, "BOTTOMLEFT", 5, 32);
						else
							-- special case. Official debuffs are shown in top line
							buff:SetPoint("LEFT", _G["TargetFrameDebuff" .. debuffI], "RIGHT", 5, 0);
						end
					end
				else
					buff:SetPoint("TOPLEFT", GHI_BuffUIFrames[unit], "TOPLEFT", 0, -2);
				end
			else
				buff:SetPoint("TOPLEFT", GHI_BuffUIFrames[unit], "TOPLEFT", 0, -2);
			end
		else

			if unit == "player" then
				buff:SetPoint("RIGHT", previousBuff, "LEFT", -5, 0);
			else
				buff:SetPoint("LEFT", previousBuff, "RIGHT", 0, 0);
			end
		end
		previousBuff = buff;
	end
end

function GHI_BuffUIFrame_UpdateAllDebuffAnchors(unit)
	local numBuffs = 0;
	self = GHI_BuffUIDisplay;

	local rows = ceil((numBuffs + self:GetNumberBuffs(unit, 2)) / BUFFS_PER_ROW);
	local buff;
	local buffHeight = TempEnchant1:GetHeight();
	local buttonName = "GHI_DebuffButton" .. unit;

	numBuffs = 0

	for index = 1, self:GetNumberBuffs(unit, 2) do
		buff = _G[buttonName .. index];
		buff:ClearAllPoints();

		if GHI_BuffUIDisplay.stickToBlizzFrame[unit] then
			buff:SetParent(BuffFrame);
			if not (unit == "player") then
				buff:SetHeight(21);
				buff:SetWidth(21);
			end
		else
			buff:SetParent(buff.parent);
			if not (unit == "player") then
				buff:SetHeight(17);
				buff:SetWidth(17);
			end
		end

		-- Position debuffs
		if (index == 1) then
			if unit == "player" then
				if GHI_BuffUIDisplay.stickToBlizzFrame[unit] then
					-- determine the last shown debuff button
					local f;
					local i = BUFFS_PER_ROW;
					while ((not (_G["DebuffButton" .. i]) or not (_G["DebuffButton" .. i]:IsShown())) and i > 0) do
						i = i - 1;
					end;
					if (i > 0) then
						buff:SetPoint("RIGHT", _G["DebuffButton" .. i], "LEFT", -5, 0);
					else
						buff:SetPoint("TOPRIGHT", ConsolidatedBuffs, "BOTTOMRIGHT", 0, -1 * ((2 * BUFF_ROW_SPACING) + TempEnchant1:GetHeight()));
					end
				else
					buff:SetPoint("TOPRIGHT", GHI_BuffUIFrames[unit], "TOPRIGHT", 0, -47);
				end
			elseif unit == "target" then
				if GHI_BuffUIDisplay.stickToBlizzFrame[unit] then
					-- determine the last shown buff button
					local f;
					local buffI = BUFFS_PER_ROW;
					while ((not (_G["TargetFrameBuff" .. buffI]) or not (_G["TargetFrameBuff" .. buffI]:IsShown())) and buffI > 0) do
						buffI = buffI - 1;
					end;
					local debuffI = BUFFS_PER_ROW;
					while ((not (_G["TargetFrameDebuff" .. debuffI]) or not (_G["TargetFrameDebuff" .. debuffI]:IsShown())) and debuffI > 0) do
						debuffI = debuffI - 1;
					end;

					if (debuffI > 0) then
						if (buffI > 0) then
							buff:SetPoint("LEFT", _G["TargetFrameDebuff" .. debuffI], "RIGHT", 0, 0);
						else
							-- special case. Official debuffs are shown in top line
							buff:SetPoint("LEFT", _G["TargetFrameDebuff" .. debuffI], "RIGHT", 5, -24);
						end
					else
						buff:SetPoint("TOPLEFT", TargetFrame, "BOTTOMLEFT", 5, 32 - 24);
					end
				else
					buff:SetPoint("TOPLEFT", GHI_BuffUIFrames[unit], "TOPLEFT", 0, -24);
				end
			else
				buff:SetPoint("TOPLEFT", GHI_BuffUIFrames[unit], "TOPLEFT", 0, -24);
			end
		else
			if unit == "player" then
				buff:SetPoint("RIGHT", previousBuff, "LEFT", -5, 0);
			else
				buff:SetPoint("LEFT", previousBuff, "RIGHT", 0, 0);
			end
		end
		previousBuff = buff;
	end
end


local GHI_BuffUI = {}
GHI_BuffUI.__index = GHI_BuffUI;
GHI_BuffUI.hooked = {};

-- 	standard
_G["GHI_BuffUI"] = function(...)

	local obj = {}
	setmetatable(obj, GHI_BuffUI)

	obj.buffs = {};
	obj.debuffs = {};

	obj.display = GHI_BuffUIDisplay:RegisterBuffObj(obj);

	obj.customText = { ... };

	return obj;
end



function GHI_BuffUI:SetFeedbackFunc(func)
	if not (type(func) == "function") then return end;
	self.feedbackFunc = func;
end

function GHI_BuffUI:CastBuff(filter, refID, guid, name, description, icon, totalDuration, endTime, count, debuffType, stackable) --API

	assert(type(filter) == "string" and (filter:lower() == "helpful" or filter:lower() == "harmful"), "Filter should be a string that is either 'helpful' or 'harmful'", filter)
	assert(type(refID) == "string" or type(refID) == "number", "RefID should either be a string or number")
	assert(type(guid) == "string" or type(guid) == "number", "Guid should either be a string or number")
	assert(type(name) == "string" and name:len() > 0, "The name should be a non-empty string")
	assert(type(description) == "string", "The name should be a string")
	assert(type(icon) == "string" and icon:len() > 0, "The icon should be a non-empty string")
	assert(type(totalDuration) == "number", "The totalDuration should be a number")
	assert(type(endTime) == "number", "The endTime should be a number")
	assert(type(count) == "number", "The count should be a number")

	filter = strlower(tostring(filter or ""));

	if not (guid) then return nil end

	-- make sure it is a valid debuff type
	local realDebuffType;
	for index, _ in pairs(DebuffTypeColor) do
		if strlower(index) == strlower(debuffType or "") then
			realDebuffType = index;
		end
	end

	local t = {
		refID = refID,
		name = name,
		description = description,
		icon = icon,
		totalDuration = totalDuration,
		expirationTime = endTime,
		count = stackable and count or 1,
		debuffType = realDebuffType,
		customText = self.customText,
	};


	if filter == "debuff" or filter == "harmful" or filter == "2" then
		self.debuffs[guid] = self.debuffs[guid] or {};
		local found;
		for i, buff in pairs(self.debuffs[guid]) do
			if (buff.refID == refID) then
				found = i;
			end
		end
		if found == nil then
			table.insert(self.debuffs[guid], t);
		else
			local t_old = self.debuffs[guid][found];
			if stackable then
				t.count = (t.count or 0) + (t_old.count or 1);
			else
				t.count = 1;
			end
			self.debuffs[guid][found] = t;
		end
	else
		self.buffs[guid] = self.buffs[guid] or {};
		local found;
		for i, buff in pairs(self.buffs[guid]) do
			if (buff.refID == refID) then
				found = i;
			end
		end
		if found == nil then
			table.insert(self.buffs[guid], t);
		else
			local t_old = self.buffs[guid][found];
			if stackable then
				t.count = (t.count or 0) + (t_old.count or 1);
			else
				t.count = 1;
			end

			self.buffs[guid][found] = t;
		end
	end

	-- if the guid is a supported unit for displaying, th en update DB
	for _, unit in pairs(supportedUnits) do
		if UnitGUID(unit) == guid then
			self.display:UpdateDB(unit);
		end
	end

	if self.feedbackFunc then self.feedbackFunc(guid); end
end

function GHI_BuffUI:GetBuffs(guid, buffType)
	if buffType == 1 then return self.buffs[guid] or {}; end
	if buffType == 2 then return self.debuffs[guid] or {}; end;

	return {};
end

function GHI_BuffUI:SetBuffs(guid, buffType, info) -- overwrites buffs from other GHI_BuffUIs too?
	if buffType == 1 then self.buffs[guid] = info; end
	if buffType == 2 then self.debuffs[guid] = info; end;
	for _, unit in pairs(supportedUnits) do
		if UnitGUID(unit) == guid then
			self.display:UpdateDB(unit);
		end
	end
end

function GHI_BuffUI:Serialize(guid)
	local buffs = {};
	local t1 = self:GetBuffs(guid, 1);
	for i = 1, #(t1) do
		buffs[i] = t1[i];
		buffs[i].buffObj = nil;
	end

	local debuffs = {};
	local t2 = self:GetBuffs(guid, 2);
	for i = 1, #(t2) do
		debuffs[i] = t2[i];
		debuffs[i].buffObj = nil;
	end
	return buffs, debuffs;
end

function GHI_BuffUI:Deserialize(guid, buffData, debuffData)
	if buffData then -- v.1.3
		self:SetBuffs(guid, 1, buffData);
	end
	if debuffData then -- v.1.3
		self:SetBuffs(guid, 2, debuffData);
	end
end

function GHI_BuffUI:CountBuff(refID, guid)
	unit = unit or "player";

	local found;
	local t;
	local aBuff;
	if type(self.buffs[guid]) == "table" then
		for i, buff in pairs(self.buffs[guid]) do
			if (buff.refID == refID) then
				--print(buff.refID)
				found = i;
				t = buff;
				aBuff = true;
			end
		end
	end
	if found == nil then
		if type(self.debuffs[guid]) == "table" then
			for i, buff in pairs(self.debuffs[guid]) do
				if (buff.refID == refID) then
					found = i;
					t = buff;
				end
			end
		end
	end

	if found and type(t) == "table" then
		return t.count or 0;
	end
	return 0;
end

function GHI_BuffUI:RemoveBuff(refID, guid, count, filter) --API
	--print(refID)
	local found;
	local t;
	local aBuff;
	local OnlyBuffs,OnlyDebuffs = false,false;
	if filter then
		if filter:lower() == "helpful" then
			OnlyBuffs = true;
		elseif filter:lower() == "harmful" then
			OnlyDebuffs = true;
		end
	end
	if type(self.buffs[guid]) == "table" and not(OnlyDebuffs == true) then
		for i, buff in pairs(self.buffs[guid]) do
			if (buff.refID == refID) then
				--print(buff.refID)
				found = i;
				t = buff;
				aBuff = true;
			end
		end
	end

	if found == nil and not(OnlyBuffs == true) then
		if type(self.debuffs[guid]) == "table" then
			for i, buff in pairs(self.debuffs[guid]) do
				if (buff.refID == refID) then
					found = i;
					t = buff;
				end
			end
		end
	end

	if found and type(t) == "table" then
		if ((t.count or 0) > count) and not (count == 0) then
			t.count = t.count - count;
		else
			if aBuff then
				table.remove(self.buffs[guid], found);
			else
				table.remove(self.debuffs[guid], found);
			end
		end
	end

	-- if the guid is a supported unit for displaying, th en update DB
	for _, unit in pairs(supportedUnits) do
		if UnitGUID(unit) == guid then
			self.display:UpdateDB(unit);
		end
	end

	if self.feedbackFunc then self.feedbackFunc(guid); end
end

function GHI_BuffUI:ClearAllBuffs(guid) --API
	if not (guid) then return end
	self.buffs[guid] = {};
	self.debuffs[guid] = {};

	-- if the guid is a supported unit for displaying, th en update DB
	for _, unit in pairs(supportedUnits) do
		--print("%s == %s",UnitGUID(unit),guid);
		if UnitGUID(unit) == guid then
			self.display:UpdateDB(unit);
		end
	end

	if self.feedbackFunc then self.feedbackFunc(guid); end
end

function GHI_BuffUI:StickToBlizzFrame(unit, stick)
	GHI_BuffUIDisplay:StickDisplayToBlizzFrame(unit, stick)
end

