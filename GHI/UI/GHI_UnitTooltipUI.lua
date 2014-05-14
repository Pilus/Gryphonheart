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

	local update;
	local updateTooltip = function()
		local _, unit = GameTooltip:GetUnit();
		if unit then
			if UnitIsPlayer(unit) and UnitIsFriend(unit, "PLAYER") then
				local ver = versionInfo.GetPlayerAddOnVer(UnitName(unit), "GHI")
				if ver then
					GameTooltip:AddLine("GHI v." .. ver, 0.2, 1.0, 0.2);
					GameTooltip:SetHeight(GameTooltip:GetHeight() + 12);
				end
			end
		end
		update = false;
	end

	local origShow = GameTooltip:GetScript("OnShow");
	GameTooltip:SetScript("OnShow", function(...)
		if origShow then origShow(...) end
		if GHI_MiscData["tooltip_version"] then
			update = true
		end
	end);

	class:SetScript("OnUpdate", function(...)
		if update == true then
			updateTooltip();
		end
	end);

	return class;
end