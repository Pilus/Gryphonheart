




local count = 1;
function GHI_MapTest()
	local menuFrame;
	local menuPage;

	local FromMapZone = function()
		local zoneOverlays = {};

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

						table.insert(zoneOverlays,t);
					end
				end
			end
		end
		return zoneOverlays;
	end

	local FromZone = function(continent, zone)
		SetMapZoom(continent, zone);
		return FromMapZone();
	end



	menuFrame = GHM_NewFrame(UIParent, {
		onOk = function(self) end,
		{
			{
				{
					align = "l",
					type = "Dummy",
					label = "anchor",
					height = 10,
					width = 900,
				},
			},

		},
		title = "Map maker - Internal GH tool",
		name = "GHI_Map" .. count,
		theme = "BlankTheme",
		height = 500,
		width = 900,
		useWindow = true,
		lineSpacing = 20,
	});
	count = count + 1;
	local anchor = menuFrame.GetLabelFrame("anchor");

	local currentContinent = 1;
	local fittingObject = {};

	local mapFrame = GHI_MapDisplayer(900 - 160, 500);
	mapFrame.SetPoint("TOPLEFT", menuFrame, "TOPLEFT")

	local Insert = function(continent, zone)
		local textures = FromZone(continent, zone)

	end

	local continents = {"Kalimdor", "Azeroth", "Expansion01", "Northrend", "TheMaelstromContinent", "Pandaria"}

	local InsertContinent = function(continent)
		if fittingObject and fittingObject.frame then
			fittingObject.frame:Hide();

		end

		fittingObject = {
			x = 3000,
			y = 3000,
			scale = 1,
			textures = Linq(),
			order = 2,
		}

		local name = continents[continent];
		local frame = CreateFrame("Button");
		frame.x = 256*4;
		frame.y = 256*3;
		frame:SetWidth(frame.x);
		frame:SetHeight(frame.y);
		frame:SetAlpha(0.5)

		for i=1,3 do
			for j=1,4 do
				local texture = frame:CreateTexture(nil,"BACKGROUND")
				texture:SetWidth(256);
				texture:SetHeight(256);
				texture.xOff = (256 * (j-1));
				texture.yOff = -(256 * (i-1));
				texture:SetPoint("TOPLEFT", texture.xOff, texture.yOff);
				texture.path = "Interface/WorldMap/"..name.."/"..name..((i-1)*4 + j);
				texture:SetTexture(texture.path);
				texture:Show();
				table.insert(fittingObject.textures, texture);
			end
		end

		frame:SetScript("OnMouseWheel",function(self, dir)
			local scale = fittingObject.scale;

			local modifier = 0.01;
			if IsShiftKeyDown() then
				modifier = 0.001;
			end
			local newScale = scale + scale*modifier*dir;

			frame:SetWidth(frame.x * newScale);
			frame:SetHeight(frame.y * newScale);
			fittingObject.textures.Foreach(function(tex)
				tex:SetWidth(256 * newScale);
				tex:SetHeight(256 * newScale);
				tex:SetPoint("TOPLEFT", tex.xOff * newScale, tex.yOff * newScale)
			end)

			fittingObject.scale = newScale;
		end)

		fittingObject.frame = frame;

		mapFrame.AddFrameToMap(frame, fittingObject.x, fittingObject.y, true, function(posX, posY)
			fittingObject.x = posX;
			fittingObject.y = posY;
		end)

	end

	local resultFrame;

	menuPage = GHM_Page({
		{
			{
				type = "Button",
				text = "Toggle element",
				align = "c",
				label = "hide",
				compact = false,
				OnClick = function()
					if fittingObject and fittingObject.frame then
						if fittingObject.frame:IsShown() then
							fittingObject.frame:Hide();
						else
							fittingObject.frame:Show();
						end
					end
				end,
			},
		},
		{
			{
				type = "CustomDD",
				texture = "Tooltip",
				width = 150,
				label = "continents",
				align = "c",
				text = "Continent:",
				data = { GetMapContinents() },
				OnSelect = function(i)
					currentContinent = i;
					if menuPage then
						menuPage.GetLabelFrame("zones").Force(1);
					end
				end,
				returnIndex = true,
			},
		},
		{
			{
				type = "CustomDD",
				texture = "Tooltip",
				width = 150,
				label = "zones",
				align = "c",
				text = "Zone:",
				dataFunc = function()
					return {GetMapZones(currentContinent)};
				end,
				OnSelect = function(i)
					Insert(currentContinent, i)
				end,
				returnIndex = true,
			},
		},
		{
			{
				type = "Button",
				text = "Continent",
				align = "c",
				label = "insertContinent",
				compact = false,
				OnClick = function()
					InsertContinent(currentContinent)
				end,
			},
		},
		{
			{
				type = "Button",
				text = "Export",
				align = "c",
				label = "toCode",
				compact = false,
				OnClick = function()
					local t = {};
					local scale = fittingObject.scale;

					fittingObject.textures.Foreach(function(tex)
						table.insert(t, {
							x = math.floor(fittingObject.x + (tex.xOff * scale)),
							y = math.floor(fittingObject.y + (tex.yOff * scale)),
							path = tex.path,
							texCoord = { 0, 1, 0, 1},
							width = math.floor(tex:GetWidth());
							height = math.floor(tex:GetHeight());
							order = fittingObject.order;
						});
					end);

					local s = GHI_Packer().TableToString(t, false, true);
					s = string.sub(string.gsub(s, "},{", "},\n{"), 2, -2);
					resultFrame.GetFieldFrame():SetMaxLetters(string.len(s));
					resultFrame.Force(s);
				end,
			},
		},
		{
			{
				type = "EditField",
				height = 280,
				width = 160,
				text = "",
				label = "result",
				align = "c",
			},
		},
	}, menuFrame, {objectSpacing = 5, lineSpacing = 0});

	resultFrame = menuPage.GetLabelFrame("result");


	menuPage.SetPosition(900 - 160, 0, 160, 500)
	menuPage:Show();

	menuFrame:AnimatedShow();
end

