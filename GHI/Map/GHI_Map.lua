

local zoneData = {
	[2] = {
		[5] = {
			scaleX = 772.866,
			scaleY = 514.850,
			offsetX = 9115.787,
			offsetY = 5332.187,
		},
		[8] = {
			scaleX = 661.959,
			scaleY = 441.297,
			offsetX = 8797.567,
			offsetY = 6001.845,
		},
		[10] = {
			scaleX = 851.040,
			scaleY = 567.520,
			offsetX = 8625.378,
			offsetY = 5566.111,
		},
		[19] = {
			scaleX = 629.827,
			scaleY = 419.921,
			offsetX = 9364.542,
			offsetY = 5707.064,
		},
		[38] = {
			scaleX = 858.108,
			scaleY = 572.102,
			offsetX = 8262.245,
			offsetY = 5924.200,
		},  --]]
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

					GHI_MapData = GHI_MapData or {};
					table.insert(GHI_MapData,t);
					--print(t.width,t.height,t.x,t.y);
					--GenerateTexture(mapFrame,t.width,t.height,t.x,t.y,t.texCoord,t.path)
				end
			end
		end
	end
end

local FromAllZones = function()
	GHI_MapData = {};

    for i=1,2 do
		for j=1,50 do
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
	for i,t in pairs(GHI_MapData) do
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
	worldX1,worldY1 = pos.GetCoor("player",3);
	zoneX1,zoneY1 = GetCurrentZoneCoor();

	zone1 = GetRealZoneText();
	local z = GetCurrentMapZone();
	print("First calculation done in zone",zone1,"(",z,")")
end

function GHI_Map_ZoneCalc()
	local zone = GetRealZoneText();
	if not(zone1 == zone) then
		First();
		return
	end

	local pos = GHI_Position();
	local worldX2,worldY2 = pos.GetCoor("player",3);
	local zoneX2,zoneY2 = GetCurrentZoneCoor();

	local scaleX = (worldX1-worldX2)/(zoneX1-zoneX2);
   	local offX = worldX2-zoneX2*(worldX1-worldX2)/(zoneX1-zoneX2);
	print("Scale X:",scaleX,"Offset X:",offX,"m.");
	local scaleY = (worldY1-worldY2)/(zoneY1-zoneY2);
   	local offY = worldY2-zoneY2*(worldY1-worldY2)/(zoneY1-zoneY2);
	print("Scale Y:",scaleY,"Offset Y:",offY,"m.");


	worldX1,worldY1,zoneX1,zoneY1,zone1 = nil,nil,nil,nil,nil;
end




