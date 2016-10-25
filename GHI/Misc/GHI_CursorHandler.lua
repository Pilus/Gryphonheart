--
--
--				GHI_CursorHandler
--  			GHI_CursorHandler.lua
--
--	Handles cursor click, pickups and placements
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local class;
function GHI_CursorHandler()
	if class then
		return class;
	end
	class = GHClass("GHI_CursorHandler");

	local currentCursor;
	local GiveClearingFeedback;
	local overlay, cursorItemIcon;
	local actionBar;

	GiveClearingFeedback = function()
		if currentCursor then
			if currentCursor.onClearFunc then
				currentCursor.onClearFunc(unpack(currentCursor.info or {}))
			end
		end
	end

	class.SetActionBarHandler = function(ab)
		actionBar = ab;
	end

	class.SetCursor = function(cursorType, cursorDetail, onClearFunc, onOverlayClickFunc, type2, ...)
		GiveClearingFeedback();

		overlay:Show();
		ClearCursor();
		ResetCursor();
		local setCursorCursorType = cursorType

		if cursorType == "ITEM" then
			setCursorCursorType = "ITEM_CURSOR";
			--SetCursor("ITEM_CURSOR");
			cursorItemIcon:Show();
			cursorItemIcon.texture:SetTexture(cursorDetail);

			local guid;
			local id = gsub(type2,"_REF","");

			if id == "GHI_ITEM" then
				local stackGuid,slotID, stack, amount, itemGuid  = ...;
				guid = itemGuid;
			else
				guid = {...};
			end

			actionBar.ShowAll(id,guid,cursorDetail,function() class.ClearCursor(); end);
		else
			cursorItemIcon:Hide();
		end

		currentCursor = {};
		currentCursor.onClearFunc = onClearFunc
		currentCursor.onOverlayClickFunc = onOverlayClickFunc;
		currentCursor.info = { type2, ... };
		currentCursor.cursorType = cursorType;
		currentCursor.cursorDetail = cursorDetail;
		GHI_Timer(function() SetCursor(setCursorCursorType) end,0,true);
	end

	class.GetCursor = function()
		if currentCursor then
			return unpack(currentCursor.info or {});
		end
	end

	class.GetCursorInfo = function()
		if currentCursor then
			return currentCursor.cursorType,currentCursor.cursorDetail,currentCursor.onClearFunc,currentCursor.onOverlayClickFunc,unpack(currentCursor.info or {});
		end
	end

	class.ClearCursor = function()
		GiveClearingFeedback();
		class.ClearCursorWithoutFeedback();
	end

	class.ClearCursorWithoutFeedback = function()
		local type2 = unpack(currentCursor.info or {});
		if type2 and type2 == "GHI_ITEM" or type2 == "GHI_ITEM_REF" then
			actionBar.HideEmpty();
		end
		ResetCursor();
		overlay:Hide();
		cursorItemIcon:Hide();
		currentCursor = nil;
	end

	overlay = CreateFrame("Button", nil, UIParent);
	overlay:Hide();
	overlay:SetFrameStrata("BACKGROUND");
	overlay:SetAlpha(0);
	overlay:SetAllPoints(UIParent);
	overlay:RegisterForClicks("LeftButtonUp", "RightButtonDown");
	overlay:SetScript("OnClick", function(self, button)
		if button == "RightButton" then
			class.ClearCursor();
		elseif button == "LeftButton" then
			if currentCursor then
				if currentCursor.onOverlayClickFunc then
					currentCursor.onOverlayClickFunc(unpack(currentCursor.info or {}))
				end
			end
		end
	end);

	cursorItemIcon = CreateFrame("Frame", nil, UIParent);
	cursorItemIcon:SetFrameStrata("DIALOG");
	cursorItemIcon:SetWidth(26);
	cursorItemIcon:SetHeight(26);

	local t = cursorItemIcon:CreateTexture(nil, "DIALOG")
	t:SetTexture("");
	t:SetAllPoints(cursorItemIcon)
	cursorItemIcon.texture = t;

	cursorItemIcon:SetScript("OnUpdate", function(self)
		local x, y = GetCursorPosition();
		local s = self:GetEffectiveScale();
		self:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", (x / s), (y / s));
	end)

	return class;
end

