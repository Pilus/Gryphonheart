--
--
--				GHM_QualityDD
--  			GHM_QualityDD.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--
local num = 0;
function GHM_QualityDD(profile, parent, settings)
	num = num + 1;
	local obj = CreateFrame("Frame", "GHM_QualityDD"..num, parent, "GHM_QualityDD_Template");

	local label = _G[obj:GetName() .. "Text2Label"];
	local label2 = _G[obj:GetName() .. "TextLabel"];

	if type(profile.text) == "string" then
		label:SetText(profile.text);
	else
		label:SetText("Quality:");
	end

	local value;
	obj.GetValue = function()
		return value;
	end

	obj.Force = function(num)
		GHCheck("GHM_QualityDD.Force(num)", {"number"}, {num})
		local color = ITEM_QUALITY_COLORS[num];
		label2:SetText("|CFF" .. string.format("%.2x", color.r * 255) .. string.format("%.2x", color.g * 255) .. string.format("%.2x", color.b * 255) .. " " .. _G["ITEM_QUALITY" .. num .. "_DESC"] .. "|r");
		value = num;
	end

	obj.Force(profile.initPos or 1);

	obj:SetWidth(155);
	obj.OnValueChanged = profile.OnValueChanged;
	obj:Hide();
	obj:Show();

	return obj;
end

