

local zoneData = {
	[0] = {
		[0] = { -- World (Azeroth)
			scaleX = 14545.759,
			scaleY = 9697.186,
			offsetX = -2822.734,
			offsetY = -409.958,
		},
	},
	[1] = {
		[8] = { -- Darkshore
			scaleX = 1579.120,
			scaleY = 1052.915,
			offsetX = -1040.751,
			offsetY = 2422.741,
		},
	},
	[2] = {

		--[[ Lower Eastern Kingdom
		[3] = { -- Badlands
			scaleX = 772.852,
			scaleY = 501.613,
			offsetX = 9468.255,
			offsetY = 5054.806,
		},
		[4] = { -- Blasted Lands
			scaleX = 897.999,
			scaleY = 598.666,
			offsetX = 9294.582,
			offsetY = 6214.340,
		},
		[5] = { -- Burning Steppes
			scaleX = 772.852,
			scaleY = 514.895,
			offsetX = 9115.799,
			offsetY = 5332.174,
		},
		[7] = { -- Deadwind Pass
			scaleX = 612.966,
			scaleY = 408.642,
			offsetX = 9206.213,
			offsetY = 6038.623,
		},
		[9] = { -- Dun Morogh
			scaleX = 1200.907,
			scaleY = 800.436,
			offsetX = 8477.802,
			offsetY = 4585.855,
		},
		[10] = { -- Duskwood
			scaleX = 662.006,
			scaleY = 441.336,
			offsetX = 8797.566,
			offsetY = 6001.845,
		},
		[12] = { -- Elwynn Forest
			scaleX = 851.007,
			scaleY = 567.508,
			offsetX = 8625.424,
			offsetY = 5566.124,
		},
		[19] = { --Loch Modan
			scaleX = 676.309,
			scaleY = 451.044,
			offsetX = 9490.732,
			offsetY = 4719.716,
		},
		[21] = { -- Northern Stranglethorn
			scaleX = 1005.270,
			scaleY = 670.180,
			offsetX = 8574.343,
			offsetY = 6320.587,
		},
		[23] = { -- Redridge Mountains
			scaleX = 629.824,
			scaleY = 419.884,
			offsetX = 9364.562,
			offsetY = 5707.107,
		},
		[26] = { -- Searing Gorge
			scaleX = 547.076,
			scaleY = 364.716,
			offsetX = 9081.064,
			offsetY = 5115.082,
		},
		[33] = { -- Swamp of Sorrows
			scaleX = 615.010,
			scaleY = 410.178,
			offsetX = 9512.187,
			offsetY = 5957.404,
		},
		[34] = { -- Northern Stranglethorn
			scaleX = 967.472,
			scaleY = 645.152,
			offsetX = 8484.951,
			offsetY = 6688.369,
		},
		[39] = { -- Twilight Highlands
			scaleX = 1292.342,
			scaleY = 861.732,
			offsetX = 9599.534,
			offsetY = 4148.123,
		},
		[43] = { -- Westfall
			scaleX = 858.156,
			scaleY = 572.104,
			offsetX = 8262.241,
			offsetY = 5924.201,
		},
		[44] = { -- Wetlands
			scaleX = 1013.951,
			scaleY = 675.798,
			offsetX = 9097.411,
			offsetY = 4146.080,
		},--]]
	},
}

local GenerateTexture = function(frame,width,height,x,y,texCoord,path)
	local texture = frame:CreateTexture(nil,"BACKGROUND")
	texture:SetWidth(width);
	texture:SetHeight(height);
	texture:SetTexCoord(unpack(texCoord));
	texture:SetPoint("TOPLEFT", x,y);
	texture:SetTexture(path);
	texture:Show();
end

local MapData;
local FromZone = function()
	local currentZoneData = zoneData[GetCurrentMapContinent()][GetCurrentMapZone()] or {};

	for i=1, GetNumMapOverlays() do
		local textureName, textureWidth, textureHeight, offsetX, offsetY = GetMapOverlayInfo(i);
		if ( textureName and textureName ~= "" ) then
			local numTexturesWide = ceil(textureWidth/256);
			local numTexturesTall = ceil(textureHeight/256);

			local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight;
			for j=1, numTexturesTall do
				if ( j < numTexturesTall ) then
					texturePixelHeight = 256;
					textureFileHeight = 256;
				else
					texturePixelHeight = mod(textureHeight, 256);
					if ( texturePixelHeight == 0 ) then
						texturePixelHeight = 256;
					end
					textureFileHeight = 16;
					while(textureFileHeight < texturePixelHeight) do
						textureFileHeight = textureFileHeight * 2;
					end
				end
				for k=1, numTexturesWide do

					if ( k < numTexturesWide ) then
						texturePixelWidth = 256;
						textureFileWidth = 256;
					else
						texturePixelWidth = mod(textureWidth, 256);
						if ( texturePixelWidth == 0 ) then
							texturePixelWidth = 256;
						end
						textureFileWidth = 16;
						while(textureFileWidth < texturePixelWidth) do
							textureFileWidth = textureFileWidth * 2;
						end
					end


					local t = {
						width = texturePixelWidth,
						height = texturePixelHeight,
						texCoord = {0, texturePixelWidth/textureFileWidth, 0, texturePixelHeight/textureFileHeight},
						x =  offsetX + (256 * (k-1)),
						y = -(offsetY + (256 * (j - 1))),
						path = textureName..(((j - 1) * numTexturesWide) + k);
					};
					--print( currentZoneData.offsetX)
					local scale = 10;
					t.width 	= (t.width 	* currentZoneData.scaleX/100) / (1.0*scale);
					t.height 	= (t.height * currentZoneData.scaleY/(100/1.5)) / (1.0*scale);
					t.x = 	(currentZoneData.offsetX + (  	t.x  * currentZoneData.scaleX/1000))/(0.10*scale);
					t.y = -	(currentZoneData.offsetY + (  -	t.y  * currentZoneData.scaleY/(1000/1.5)))/(0.10*scale);       --]]

					table.insert(MapData,t);
					--print(t.width,t.height,t.x,t.y);
					--GenerateTexture(mapFrame,t.width,t.height,t.x,t.y,t.texCoord,t.path)
				end
			end
		end
	end
end

local FromAllZones = function()
	MapData = {};

	for i=0,2 do
		for j=0,50 do
			if zoneData[i] and zoneData[i][j] then
				print(i,j);
				SetMapZoom(i,j);
				FromZone();

			end
		end
	end
	-- /script for i = 1,30 do SetMapZoom(2,i);

end

local count = 1;
function GHI_MapTest()
	local menuFrame;

	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				{
					align = "l",
					type = "Dummy",
					label = "anchor",
					height = 10,
					width = 10,
				},
			},

		},
		title = "Map",
		name = "GHI_Map" .. count,
		theme = "BlankTheme",
		height = 500,
		width = 900,
		useWindow = true,
		lineSpacing = 20,
	});
	count = count + 1;

	menuFrame:Hide();
	local scrollFrame = CreateFrame("ScrollFrame","$parentScroll",menuFrame,"GHM_ScrollFrameTemplate")
	--scrollFrame:SetAllPoints(menuFrame);
	scrollFrame:SetPoint("TOP",0,-3);
	scrollFrame:SetPoint("BOTTOM",0,-8);
	scrollFrame:SetPoint("LEFT",-3,0);
	scrollFrame:SetPoint("RIGHT",22,0);

	local mapFrame = CreateFrame("Frame","$parentDoc",scrollFrame);
	scrollFrame:SetScrollChild(mapFrame);

	mapFrame:SetHeight(300);
	mapFrame:SetWidth(300);

	--local t = mapFrame:CreateTexture(nil,"BACKGROUND")
	--t:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Factions")
	--[[
	t:SetTexture("Interface\\WorldMap\\Westfall\\TheJansenStead1");
	t:SetWidth(100);
	t:SetHeight(100);
	t:SetPoint("TOPLEFT",0,0);
	t:SetAllPoints(mapFrame);--]]

	FromAllZones();
	GHI_MiscData.Map = MapData;
	for i,t in pairs(MapData) do    print(t.x,t.y,t.path)
		GenerateTexture(mapFrame,t.width,t.height,t.x,t.y,t.texCoord,t.path);
	end

	local player = mapFrame:CreateTexture(nil,"OVERLAY")
	player:SetWidth(32);
	player:SetHeight(32);
	player:SetTexture("Interface\\MINIMAP\\TRACKING\\Repair");
	player:Show();

	GHI_Timer(function()
		local pos = GHI_Position();
		local x,y = pos.GetCoor("player",3);
		player:SetPoint("TOPLEFT", x,-y);
	end,1);

	menuFrame:AnimatedShow();
end


-- ==========  Get the maps from current zone ========
function GHI_MapsFromCurrentZone()
	SetMapToCurrentZone();
	MapData = {};
	FromZone();
	GHI_MiscData.Map = GHI_MiscData.Map or {};
	GHI_MiscData.Map[GetZoneText()] = MapData;
	print("Map data for",GetZoneText(),"saved")
end


-- /script GHI_MapTest()

local GetCurrentZoneCoor = function()
	SetMapToCurrentZone();
	return GetPlayerMapPosition("player");
end

-- world.x = zone.x * scaleX + offX
-- world.y = zone.y * scaleY + offY

--[[
	world.x1 = (zone.x1 * scaleX) + offX

	offX = world.x1 - (zone.x1 * scaleX)

	worldX2 = (zone.x2 * scaleX) + offX
	(world.x2 - offX) = zone.x2 * scaleX
	scaleX = (world.x2 - offX) / zone.x2

	scaleX = (worldX2 - (worldX1 - (zoneX1 * scaleX))) / zoneX2
	scaleX * zoneX2 = (worldX2 - (worldX1 - (zoneX1 * scaleX)))


	offX = worldX1 - (zoneX1 * scaleX)

--]]





local worldX1,worldY1,zoneX1,zoneY1,zone1;

local First = function()
	local pos = GHI_Position();
	zoneX1,zoneY1 = GetCurrentZoneCoor();
	worldX1,worldY1 = pos.GetCoor("player",3);


	zone1 = GetRealZoneText();
	local z = GetCurrentMapZone();
	print("First calculation done in zone",zone1,"(",z,")")
end

function GHI_Map_ZoneCalc()
	local zone = GetRealZoneText();
	if zone1 == nil then
		First();
		return
	end
	if not(zone1 == zone) then
		print("warning, other zone than first measure point")
	end

	local zoneX2,zoneY2 = GetCurrentZoneCoor();
	local pos = GHI_Position();
	local worldX2,worldY2 = pos.GetCoor("player",3);


	local scaleX = (worldX1-worldX2)/(zoneX1-zoneX2);
	local offX = worldX2-zoneX2*(worldX1-worldX2)/(zoneX1-zoneX2);
	print(string.format("Scale X: %.3f Offset X: %.3f",scaleX,offX));
	local scaleY = (worldY1-worldY2)/(zoneY1-zoneY2);
	local offY = worldY2-zoneY2*(worldY1-worldY2)/(zoneY1-zoneY2);
	print(string.format("Scale Y: %.3f Offset Y: %.3f",scaleY,offY));


	worldX1,worldY1,zoneX1,zoneY1,zone1 = nil,nil,nil,nil,nil;
end




