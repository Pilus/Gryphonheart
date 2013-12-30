--===================================================
--									
--					GHI Update Notification
--				GHI_UpdateNotificationUI.lua
--
--			Notifies the user if a new version is available.
--	
-- 				(c)2013 The Gryphonheart Team
--						All rights reserved
--===================================================	

GHI_MiscData = GHI_MiscData or {};

if GHI_MiscData["notify_update"] == true then
	GHI_UpdateNotify = true
else
	GHI_UpdateNotify = false
end

local versionInfo
function GHI_UpdateNotification()
	local class = GHClass("GHI_UpdateNotification");
	
	if not(versionInfo) then
		versionInfo = GHI_VersionInfo();
	end
		
	StaticPopupDialogs["GHI_NEWVERSION"] = {
		text = "There is a new version of GHI Available.\n\nThe current version is: ",
		button1 = OKAY,
		OnAccept = function(self)
			GHI_UpdateNotify = true
		end,
		OnShow = function(self)
			self.editBox:SetWidth(self:GetWidth()-64)
			self.editBox:SetText("http://www.curse.com/addons/wow/ghi")
			self.editBox:HighlightText()
		end,
		hasEditBox = 1,
		showAlert = true,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	
	local DisplayUpdateWindow = function(version)
		StaticPopupDialogs["GHI_NEWVERSION"].text =  StaticPopupDialogs["GHI_NEWVERSION"].text.."|cffffff00"..version.."|r"
		StaticPopup_Show("GHI_NEWVERSION")
	end
	
	class.CheckForUpdate = function(player)
		local log = GHI_Log();
		local ver, dev = versionInfo.GetPlayerAddOnVer(player, "GHI")
		local currVersion = GetAddOnMetadata("GHI","Version")
		local v1 = {strsplit(".",currVersion)}
		local v2 = {strsplit(".",ver)}
		local newVersion = false
		
		for i,v in pairs(v1) do
			if tonumber(v1[i]) < tonumber(v2[i]) then
				newVersion = true
			else
				newVersion = false
			end
		end

		if newVersion == true then
			log.Add(3,"New version detected: "..ver,nil)
			if InCombatLockdown() then 
				return;
			else
				if GHI_UpdateNotify ~= true then
					if dev == "false" then
						DisplayUpdateWindow(ver)
					elseif dev == false then
						DisplayUpdateWindow(ver)
					elseif dev == nil then
						DisplayUpdateWindow(ver)
					elseif dev == "true" or true then
						return
					end
				end
			end
		end	
	end
	
	return class;
end