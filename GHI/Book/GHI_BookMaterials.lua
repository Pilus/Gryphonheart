--===================================================
--
--				GHI_BookMaterials
--  			GHI_BookMaterials.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_BookMaterials()
	if class then
		return class;
	end
	class = GHClass("GHI_BookMaterials");

	local mats = {};

	mats["Parchment"] = GHI_MultiTextureImage()
		.AddTexture("Interface/QuestFrame/QuestBG", 256, 256, 0, 0, {0, 0.58, 0, 0.65})

	local itemTextFrameMats = {"Bronze", "Marble", "Silver", "Stone", "Valentine"};
	for _, theme in pairs(itemTextFrameMats) do
		mats[theme] = GHI_MultiTextureImage()
			.AddTexture("Interface/ItemTextFrame/ItemText-"..theme.."-TopLeft", 256, 256, 0, 0)
			.AddTexture("Interface/ItemTextFrame/ItemText-"..theme.."-TopRight", 64, 256, 256, 0)
			.AddTexture("Interface/ItemTextFrame/ItemText-"..theme.."-BotLeft", 256, 100, 0, 256, {0, 1, 0, 0.78})
			.AddTexture("Interface/ItemTextFrame/ItemText-"..theme.."-BotRight", 64, 100, 256, 256, {0, 1, 0, 0.78})
	end

	mats["Auction"] = GHI_MultiTextureImage()
		.AddTexture("Interface/Stationery/AuctionStationery1", 256, 256, 0, 0)
		.AddTexture("Interface/Stationery/AuctionStationery2", 50, 256, 256, 0, {0, 0.78, 0, 1})
	mats["Vellum"] = GHI_MultiTextureImage()
			.AddTexture("Interface/Stationery/StationeryTest1", 256, 256, 0, 0)
			.AddTexture("Interface/Stationery/StationeryTest2", 50, 256, 256, 0, {0, 0.78, 0, 1})
	mats["Orc"] = GHI_MultiTextureImage()
			.AddTexture("Interface/Stationery/Stationery_OG1", 256, 256, 0, 0)
			.AddTexture("Interface/Stationery/Stationery_OG2", 50, 256, 256, 0, {0, 0.78, 0, 1})
	mats["Tauren"] = GHI_MultiTextureImage()
			.AddTexture("Interface/Stationery/Stationery_TB1", 256, 256, 0, 0)
			.AddTexture("Interface/Stationery/Stationery_TB2", 50, 256, 256, 0, {0, 0.78, 0, 1})
	mats["Forsaken"] = GHI_MultiTextureImage()
			.AddTexture("Interface/Stationery/Stationery_UC1", 256, 256, 0, 0)
			.AddTexture("Interface/Stationery/Stationery_UC2", 50, 256, 256, 0, {0, 0.78, 0, 1})
	mats["Illidari"] = GHI_MultiTextureImage()
			.AddTexture("Interface/Stationery/Stationery_Ill1", 256, 256, 0, 0)
			.AddTexture("Interface/Stationery/Stationery_Ill2", 50, 256, 256, 0, {0, 0.78, 0, 1})
	mats["Winter"] = GHI_MultiTextureImage()
			.AddTexture("Interface/Stationery/Stationery_Chr1", 256, 256, 0, 0)
			.AddTexture("Interface/Stationery/Stationery_Chr2", 50, 256, 256, 0, {0, 0.78, 0, 1})


	class.GetImage = function(theme, parent)
		if mats[theme] then
			return mats[theme].GenerateImageFrame(parent);
		else
			return CreateFrame("Frame");
		end
	end

	return class;
end

--[[
AA = function()
	local mats = GHI_BookMaterials();

	local f = mats.GetImage("Auction");
	f:SetParent(UIParent);
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
	f:SetWidth(500);
	--f:SetHeight(100);
	GHM_TempBG(f);
end     --]]