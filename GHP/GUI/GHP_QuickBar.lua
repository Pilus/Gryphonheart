--===================================================
--
--				GHP_QuickBar
--  			GHP_QuickBar.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local SNAP_DIST = 20;

local class;
function GHP_QuickBar()
	if class then
		return class;
	end
	class = GHClass("GHP_QuickBar");
    local frame = GHP_QuickBarFrame;

	local loc = GHP_Loc();
	local objApi = GHP_ObjectAPI();

	local sideFrameButton = GHI_ButtonUI().AddSideFrame(frame);

	local PlaceFrame = function(x,y)
		if x and y then
			x = math.max(frame:GetWidth()/2,x);
			y = math.max(frame:GetHeight()/2,y);
			x = math.min(UIParent:GetWidth()-frame:GetWidth()/2,x);
			y = math.min(UIParent:GetHeight()-frame:GetHeight()/2,y);

			frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
			GHP_MiscData.quickBarPos = {x = x, y = y};
		else
			GHP_QuickBarFrame:SetPoint("RIGHT",sideFrameButton,"LEFT",0,0);
			GHP_MiscData.quickBarPos = nil;
		end
	end

	local SetTooltipAnchor = function(btn)
		if (btn:GetRight() >= (GetScreenWidth() / 2)) then
			GameTooltip:SetOwner(btn, "ANCHOR_LEFT");
		else
			GameTooltip:SetOwner(btn, "ANCHOR_RIGHT");
		end
	end


	-- Nearby objects
	local UpdateNearbyObjects = function()
		local num = objApi.GetNumNearbyObjects(true);
		for i = 1,4 do
			local btn = _G["GHP_QuickBarFrameBar1Button"..i];
			if i <= num then
				local _,icon,count = objApi.GetObjectInfo(i,true);
				SetItemButtonTexture(btn,icon);
			else
				SetItemButtonTexture(btn,"Interface/PaperDoll/UI-Backpack-EmptySlot");
			end
		end
	end;

	for i = 1,4 do
		local btn = _G["GHP_QuickBarFrameBar1Button"..i];
		btn:RegisterForClicks("RightButtonUp","LeftButtonUp");
		btn:SetScript("OnEnter",function(self)
			SetTooltipAnchor(btn);
			btn.showTt = true;
		end);
		btn:SetScript("OnUpdate",function()
			if btn.showTt then
				objApi.DisplayObjectTooltip(i,GameTooltip,true);
			end
		end);
		btn:SetScript("OnLeave",function()
			btn.showTt = false;
			GameTooltip:Hide();
		end);

		btn:SetScript("OnClick",function(_,button)
			if button == "RightButton" then
				local options = objApi.GetObjectInteractionOptions(i);
				if (#(options) == 1) then
					options[1].func();
				elseif #(options) > 1 then
					UIDropDownMenu_Initialize(GHP_QuickBarDropDownMenu, function()
						for i,option in pairs(options) do
							UIDropDownMenu_AddButton({
								text = option.name,
								value = i,
								func = option.func,
								notCheckable = true,
								icon = option.icon,
							});
						end
					end, "MENU");
					ToggleDropDownMenu(1, nil, GHP_QuickBarDropDownMenu, btn, 0, 0);
				end
			end
		end);
	end

	-- Equipped objects
	local equipAPI = GHP_EquippedItemsAPI();
	local UpdateEquippedItems = function()
		local num = equipAPI.GetNumEquippedItemSlots();
		for i=1,4 do
			local btn = _G["GHP_QuickBarFrameBar2Button"..i];
			local itemGuid,icon,count,locked = equipAPI.GetEquippedItemInfo(i);

			if itemGuid then
				SetItemButtonTexture(btn,icon);
				SetItemButtonCount(btn,count);
				SetItemButtonDesaturated(btn, locked, 0.5, 0.5, 0.5);
				GHI_ContainerFrame_UpdateCooldown(itemGuid, btn);

				btn.itemGuid = itemGuid;
				btn.slotGuid = nil;
			else
				local slotGuid,icon = equipAPI.GetEquippedItemSlotInfo(i);
				SetItemButtonTexture(btn,icon);
				_G[btn:GetName().."Cooldown"]:Hide();

				btn.slotGuid = slotGuid;
				btn.itemGuid = nil;
			end
		end
	end

	local AddDDButton = function(i,option,level)
		if option.sub then
			UIDropDownMenu_AddButton({
				text = option.name,
				value = i,
				hasArrow = true,
				notCheckable = true,
				icon = option.icon,
			},level);
		else
			UIDropDownMenu_AddButton({
				text = option.name,
				value = i,
				func = option.func,
				notCheckable = true,
				icon = option.icon,
			},level);
		end
	end

	for i = 1,4 do
		local btn = _G["GHP_QuickBarFrameBar2Button"..i];
		btn:RegisterForClicks("RightButtonUp","LeftButtonUp");
		btn:SetScript("OnEnter",function(self)
			SetTooltipAnchor(btn);
			btn.showTt = true;
		end);
			btn:SetScript("OnUpdate",function()
			if btn.showTt then
				equipAPI.DisplayEquippedItemTooltip(i,GameTooltip);
			end
		end);
		btn:SetScript("OnLeave",function()
			btn.showTt = false;
			GameTooltip:Hide();
		end);



		btn:SetScript("OnClick",function(_,button)
			if button == "LeftButton" then
				equipAPI.PickupEquippedItem(i);
				equipAPI.DisplayEquippedItemTooltip(i,GameTooltip);
			elseif button == "RightButton" then
				local options = equipAPI.GetEquippedItemInteractionOptions(i);
				if (#(options) == 1) then
					options[1].func();
				elseif #(options) > 1 then
					UIDropDownMenu_Initialize(GHP_QuickBarDropDownMenu, function(self,level)
						level = level or 1;
						if level == 1 then
							for i,option in pairs(options) do
								AddDDButton(i,option,level);
							end
						elseif level == 2 then
							local index = UIDROPDOWNMENU_MENU_VALUE;
							local option = options[index];
							for i,option in pairs(option.sub) do
								AddDDButton(i,option,level);
							end
						end
					end, "MENU");
					ToggleDropDownMenu(1, nil, GHP_QuickBarDropDownMenu, btn, 0, 0);
				end
			end
		end);
	end



	-- Init


	frame:SetScript("OnHide",function()
		sideFrameButton:Hide();
		GHP_MiscData.quickBarShown = false;
	end);
	frame:SetScript("OnShow",function()
		sideFrameButton:Show();
		GHP_MiscData.quickBarShown = true;
	end);

	local drag = false;
	frame:SetScript("OnDragStart",function()
		drag = true;
	end);
	frame:SetScript("OnDragStop",function()
		drag = false;
	end);
	frame:SetScript("OnUpdate",function()
		if drag then
			local _x, _y = GetCursorPosition();
			local s = frame:GetEffectiveScale();
			frame:ClearAllPoints();
			local x, y = _x / s, _y / s;

			-- snap to button?
			local vx = (x + frame:GetWidth()/2)- sideFrameButton:GetLeft();
			local vy = y - (sideFrameButton:GetBottom() + sideFrameButton:GetHeight()/2);
			local dist = math.sqrt(vx^2 + vy^2);
			if dist <= SNAP_DIST then
				x,y = nil,nil;
			end

			PlaceFrame(x,y);
		end
	end);
	frame:RegisterForDrag("LeftButton")
	frame:SetMovable();
	GHP_QuickBarFrameTextLabel:SetText(string.format(loc.QUICK_WEIGHT,0,"kg"));
	GHP_QuickBarFrameBar1TextLabel:SetText(loc.QUICK_NEARBY_OBJECTS);
	GHP_QuickBarFrameBar2TextLabel:SetText(loc.QUICK_EQUIPPED_OBJECTS);

	GHP_MiscData = GHP_MiscData or {};
	local pos = GHP_MiscData.quickBarPos or {};
	PlaceFrame(pos.x,pos.y);

	GHP_QuickBarFrameMenuButton:SetScript("OnClick",function()
		GHP_MainUI().Toggle();
	end);

	frame:SetBackdrop({
		bgFile = GHM_GetBackground(),
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	});

	GHI_Event("GHP_NEARBY_OBJECTS_UPDATED",UpdateNearbyObjects);
	GHI_Event("GHP_EQUIPPED_ITEMS_UPDATE",UpdateEquippedItems);
	GHI_Position().OnNextMoveCallback(0.05,UpdateNearbyObjects,true);

	UpdateNearbyObjects();
	UpdateEquippedItems();

	if GHP_MiscData.quickBarShown then
		frame:Show();
	end

	return class;
end

