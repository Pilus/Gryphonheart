--
--
--			GHM_RadioButtonSet
--  		GHM_RadioButtonSet.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

--[[
profile.data = {
	{
		icon = "",
		name = "",
		quality = 1,
		GUID = "",
	},
}
]]

local count = 1;
function GHM_ItemButtonSet(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_ItemButton" .. count, parent, "GHM_ItemButtonSet_Template");
    count = count + 1;
	local loc = GHI_Loc();
	local itemAPI = GHI_ContainerAPI().GetAPI()
	--local miscApi = GHI_MiscAPI().GetAPI();
	--local itemList = GHI_ItemInfoList();

	local returnIndex = profile.returnIndex;
	local selectedIndex;

	local area = _G[frame:GetName().."Area"];

	local label = _G[frame:GetName().."TextLabel"];
	label:SetText(profile.text or "");

	local GetData = function()
		if type(profile.dataFunc) == "function" then
			return profile.dataFunc() or {};
		elseif type(profile.data) == "table" then
			return profile.data;
		elseif type(frame.dataFunc) == "function" then
			return frame.dataFunc() or {};
		elseif type(frame.data) == "table" then
			return frame.data;
		end
		return {};
	end

	local GetItemValue = function()
		if returnIndex then
			return selectedIndex;
		else
			local data = GetData();
			if not(data[selectedIndex].name == nil) then
				return data[selectedIndex].name;
			end
			return data[selectedIndex];
		end
	end


	local selectItem = function(index)
		selectedIndex = index;
		local selectedItemFrame = _G[frame:GetName().."Item"..index]
		if selectedItemFrame then
			area.highlight:Show()
			area.highlight:SetParent(selectedItemFrame)
			area.highlight:SetPoint("TOPLEFT",selectedItemFrame,"TOPLEFT",-7,7)
			--[[local frameLevel = selectedItemFrame:GetFrameLevel() + 10
			area.highlight:SetFrameLevel(frameLevel)]]
		end
		
		frame.UpdateButtons();
	end

	local OnSelect;
	if type(profile.OnSelect) == "function" then
		OnSelect = profile.OnSelect;
	end
		
	frame.UpdateButtons = function()
		local parentFrame = frame:GetName()
		local data = GetData();
		local numButtons = #data
		local prevItem
		local height = 49
		
		for i, v in pairs(data) do
			local item = _G[parentFrame.."Item"..i]
			if not (item) then
				item = CreateFrame("Button",parentFrame.."Item"..i,area,"GHM_ItemButtonTemplate")
				if i == 1 then
				item:SetPoint("TOPLEFT",area,"TOPLEFT")
				elseif i == 2 then
				item:SetPoint("TOPLEFT",prevItem,"TOPRIGHT")
				elseif i > 2 then
				prevItem = _G[parentFrame.."Item"..(i-2)]
				item:SetPoint("TOPLEFT",prevItem,"BOTTOMLEFT",0,-8)
				end
				item:SetScript("OnClick",function()
					selectItem(i);
					if OnSelect then
						OnSelect(GetItemValue());
					end
				end)
			end
			if profile.scale then
			item:SetScale(profile.scale,profile.scale)
			end
			local itemName, icon, itemQual, white1,white2,yellow,use, r,g,b
			if data[i].GUID then
				itemName,icon,itemQual = itemAPI.GHI_GetItemInfo(data[i].GUID)
				white1,white2,yellow,use = itemAPI.GHI_GetFlavorText(data[i].GUID)
				item.icon:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")
				item.itemText:SetText(itemName or "None")
				r,g,b = GetItemQualityColor(itemQual or 1)
				item.itemText:SetTextColor(r,g,b)
			else
				item.icon:SetTexture(data[i].icon or "Interface\\Icons\\INV_Misc_QuestionMark")
				item.itemText:SetText(data[i].name or "None")
				r,g,b = GetItemQualityColor(data[i].quality or 1)
				item.itemText:SetTextColor(r,g,b)
			
			end
			item:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self)
					GameTooltip:SetAnchorType("ANCHOR_LEFT" ,0 , 0)
					GameTooltip:ClearLines();
					if data[i].GUID then
						GameTooltip:SetText(itemName, r,g,b)
						GameTooltip:AddLine(white1,1,1,1,true)
						GameTooltip:AddLine(white2,1,1,1,true)
						GameTooltip:AddLine('"'..yellow..'"',1,0.75,0,true)
						GameTooltip:AddLine("Use: "..use,0,1,0.25,true)
						GameTooltip:SetWidth(200)
					else
						GameTooltip:SetText(data[i].name,1,1,1,true)
						if data[i].tooltip then
							GameTooltip:AddLine(data[i].tooltip,nil,nil,nil,true)
						end
					end
					GameTooltip:Show()
			end    )
			item:SetScript("OnLeave", function()
					GameTooltip:Hide()
			end)
			prevItem = item
		end
		
		height = (math.floor(numButtons / 2) * height)
		frame:SetHeight(height);
		frame:SetWidth(294)
	end

	selectItem(profile.defaultSelected or 0);

	-- functions
	local varAttFrame;

	local Force1 = function(data)
		if returnIndex then
			selectItem(data);
		else
			local options = GetData();
			for i,v in pairs(options) do
				if type(v) == "table" then
					if data == v.value then
						selectItem(i);
					end
				else
					if data == v then
						selectItem(i);
					end
				end
			end
		end
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
		selectItem(profile.defaultSelected or 0)
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
			return GetItemValue();
		end
	end



	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame.Clear();
	frame:Show();

	return frame;
end

