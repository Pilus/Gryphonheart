--
--
--				GHM_Button
--  			GHM_Button.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local num = 0;
function GHM_Button(profile, parent, settings)
	num = num + 1;
	local obj = CreateFrame("Button", "GHM_Button"..num, parent, "GHM_Button_Template");

	local label = _G[obj:GetName() .. "Text"];
	if label then
		if type(profile.text) == "string" then
			label:SetText(profile.text);
		end
		if profile.compact == true then
			obj:SetHeight(label:GetHeight() + 8);
			obj:SetWidth(label:GetWidth() + 8);
		else
			local origWidth = obj:GetWidth();
			obj:SetWidth(200);
			if label:GetWidth() > (origWidth - 10) then
				obj:SetWidth(label:GetWidth() + 10);
			else
				obj:SetWidth(origWidth);
			end
		end
		if profile.width then
			obj:SetWidth(profile.width);
		end
		if profile.height then
			obj:SetHeight(profile.height);
		end
	end
	if profile.tooltip then
		obj.tooltip = profile.tooltip;
	end

	obj.ignoreTheme = profile.ignoreTheme;

	if type(profile.onclick) == "function" then
		obj:SetScript("OnClick", profile.onclick);
	end
	if type(profile.onClick) == "function" then
		obj:SetScript("OnClick", profile.onClick);
	end
	if type(profile.OnClick) == "function" then
		obj:SetScript("OnClick", profile.OnClick);
	end

	obj:Show();

	return obj;
end

