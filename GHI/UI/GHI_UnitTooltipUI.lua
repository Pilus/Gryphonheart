--===================================================
--									
--								GHI Unit Tooltip
--									GHI_UnitTooltipUI.lua
--
--	Adds information to the tooltip of a unit
--	
-- 						(c)2013 The Gryphonheart Team
--								All rights reserved
--===================================================	

local versionInfo
function GHI_UnitTooltip()
	local class = GHClass("GHI_UnitTooltip","frame");

	if not(versionInfo) then
		versionInfo = GHI_VersionInfo();
	end

	local update;
	local updateTooltip = function()
		if GameTooltip:GetOwner() then
			local unit = GameTooltip:GetOwner().unit or "MOUSEOVER";
			local legalPlayerUnit = not (strlower(unit) == "player") and UnitIsPlayer(unit);
			local factionAvailability = UnitIsFriend(unit, "PLAYER") or (UnitIsPlayer(unit) and #(versionInfo.GetPlayerAddOns(UnitName(unit))) > 0);
			local isNotItem = (GameTooltip:GetOwner().hasItem == nil)
			if legalPlayerUnit and factionAvailability and not (GameTooltip:GetOwner() == GHU_MainTargetButton) and isNotItem then
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
	--class:RegisterEvent("UPDATE_MOUSEOVER_UNIT");

	class:SetScript("OnUpdate", function(...)
		if update == true then
			updateTooltip();
		end
	end);

	return class;
end