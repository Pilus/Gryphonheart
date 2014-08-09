--===================================================
--
--				GHM_SlotSlider
--  			GHM_SlotSlider.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local num = 0;
function GHM_SlotSlider(profile, parent, settings)
	num = num + 1;
	local obj = CreateFrame("Slider", "GHM_SlotSlider"..num, parent, "GHM_SlotSlider_Template");
	local label = _G[obj:GetName().."Label1"];

	obj.OrigGetValue = obj.GetValue;
	obj.StackSliderValues = {1,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36};
	obj:SetMinMaxValues(1, #(obj.StackSliderValues));
	obj:SetValueStep(1);
	obj:SetValue(2);
	obj:SetValue(1);

	if profile.text then label:SetText(profile.text); end
	if type(profile.width) == "number" then
		obj:SetWidth(profile.width);
	end
	obj.OnValueChanged = profile.OnValueChanged;
	obj.IgnoreGetValueFunc = true;

	obj.Force = function(data)
		if type(data) == "number" and obj.StackSliderValues then
			for i=1,#(obj.StackSliderValues) do
				if obj.StackSliderValues[i] == data then
					obj:SetValue(i);
					break;
				end
			end
		end
	end

	obj.Clear = function(self)
		obj:SetValue(1);
	end

	obj.GetValue = function()
		return obj.amount;
	end

	--GHM_TempBG(obj);
	return obj;
end
