--===================================================
--
--				GHM_Item
--  			GHM_Item.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;
function GHM_Item(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_Item" .. count, parent, "GHM_Item_Template");
    count = count + 1;
	local loc = GHI_Loc();
	local miscApi = GHI_MiscAPI().GetAPI();
	local itemList = GHI_ItemInfoList();

	local area = _G[frame:GetName().."Area"];

	local label = _G[frame:GetName().."Label"];
	label:SetText(profile.text or "");

	local itemText = _G[area:GetName().."ItemText"];
	local itemButton = _G[area:GetName().."ItemButton"];
	local chooseItemButton = _G[area:GetName().."ChooseButton"];

	local ibText = _G[chooseItemButton:GetName().."Text"];
	chooseItemButton:SetNormalFontObject(SystemFont_Tiny);
	chooseItemButton:SetHighlightFontObject(SystemFont_Tiny);
	ibText:SetText(gsub(loc.CHOOSE_ITEM," ","\n"));


	local GetItemTextLine = function(item)

		local lines = item.GetTooltipLines()

		local infoLine = "";
		for _, line in pairs(lines) do
			local linetext = miscApi.GHI_ColorString(line.text, line.r, line.g, line.b)

			if infoLine == "" then
				infoLine = linetext;
			else
				infoLine = infoLine .. "\n" .. linetext;
			end
		end
		return infoLine;
	end

	local currentGuid;
	local SetItem = function(guid)
		currentGuid = guid;
		local item = itemList.GetItemInfo(currentGuid or "0")


		if not(currentGuid) or not(item) then
			itemText:SetText(loc.NO_ITEM_CHOOSEN);
			SetItemButtonTexture(itemButton,"Interface\\Icons\\INV_Misc_QuestionMark");
			return;
		end


		itemText:SetText(GetItemTextLine(item));
		local _,texture = item.GetItemInfo();
		SetItemButtonTexture(itemButton,texture);

	end

	SetItem(); --default

	chooseItemButton:SetScript("OnClick",function()
		miscApi.GHI_SetSelectItemCursor(SetItem);
	end);

	-- functions
	local varAttFrame;

	local Force1 = function(data)
		SetItem(data);
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then
			varAttFrame:SetValue(inputType, inputValue);

		else -- static
			varAttFrame:Clear();
			Force1(inputValue);
		end
	end

	frame.Force = function(self, ...)
		if self ~= frame then return frame.Force(frame, self, ...); end
		local numInput = #({ ... });

		if numInput == 1 then
			Force1(...);
		elseif numInput == 2 then
			Force2(...);
		end
	end

	frame.Clear = function(self)
		SetItem(nil);
	end


	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, area, frame:GetWidth());
			frame:SetHeight(frame:GetHeight());
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			return currentGuid;
		end
	end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame.Clear();
	frame:Show();



	return frame;
end

