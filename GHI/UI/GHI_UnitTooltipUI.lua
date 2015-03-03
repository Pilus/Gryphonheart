--===================================================
--									
--					GHI Unit Tooltip
--					GHI_UnitTooltipUI.lua
--
--	Adds information to the tooltip of a unit
--	
-- 			(c)2013 The Gryphonheart Team
--					All rights reserved
--===================================================	

local versionInfo
function GHI_UnitTooltip()
	local class = GHClass("GHI_UnitTooltip","frame");

	if not(versionInfo) then
		versionInfo = GHI_VersionInfo();
	end

	local currentName;
	local updateTooltip = function()
		local _, unit = GameTooltip:GetUnit();

		if GHI_MiscData["tooltip_version"] and unit and UnitIsPlayer(unit) and not(currentName == UnitName(unit)) then
			currentName = UnitName(unit)
			if UnitIsFriend(unit, "PLAYER") then
				local ver = versionInfo.GetPlayerAddOnVer(UnitName(unit), "GHI")
				if ver then
					GameTooltip:AddLine("GHI v." .. ver, 0.2, 1.0, 0.2);
					GameTooltip:SetHeight(GameTooltip:GetHeight() + 12);
				end
			end
		end
	end

	local origShow = GameTooltip:GetScript("OnTooltipSetUnit");
	GameTooltip:SetScript("OnTooltipSetUnit", function(...)
		if origShow then origShow(...) end
		if GHI_MiscData["tooltip_version"] then
			currentName = nil
		end
	end);

	class:SetScript("OnUpdate", updateTooltip);

	return class;
end