--===================================================
--
--				GHM_CustomSlider
--  			GHM_CustomSlider.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local num = 0;
function GHM_CustomSlider(profile, parent, settings)
	num = num + 1;
	local obj = CreateFrame("Slider", "GHM_CustomSlider"..num, parent, "GHM_CustomSlider_Template");

	local label = _G[obj:GetName() .. "Label1"];
	if type(profile.text) == "string" then
		label:SetText(profile.text);
	end

	obj:SetValue(2);
	obj:SetValue(1);
	if type(profile.values) == "table" then
		obj.SliderValues = profile.values;
		obj:SetMinMaxValues(1, #(profile.values));
		obj:SetValue(2);
		obj:SetValue(1);
	end
	if type(profile.width) == "number" then
		obj:SetWidth(profile.width);
	end
	obj.OnValueChanged = profile.OnValueChanged;
	obj.IgnoreGetValueFunc = true;

	obj:Show();

	return obj;
end

