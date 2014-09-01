--===================================================
--
--				GHI_MapMenu
--  			GHI_MapMenu.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local menuIndex = 1;
function GHI_MapMenu(info)
	local class = GHClass("GHI_MapMenu");

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
		title = "Map - From static data",
		name = "GHI_MapMenu" .. menuIndex,
		theme = "BlankTheme",
		height = 500,
		width = 900,
		useWindow = true,
		lineSpacing = 20,
	});
	menuIndex = menuIndex + 1;

	menuFrame:Hide();
	local scrollFrame = CreateFrame("ScrollFrame","$parentScroll",menuFrame,"GHM_ScrollFrameTemplate")

	scrollFrame:SetPoint("TOP",0,-3);
	scrollFrame:SetPoint("BOTTOM",0,8);
	scrollFrame:SetPoint("LEFT",-3,0);
	scrollFrame:SetPoint("RIGHT",10,0);

	local mapFrame = CreateFrame("Frame","$parentMap",scrollFrame);
	scrollFrame:SetScrollChild(mapFrame);

	local mapH,mapW = 0,0;
	local GenerateTexture = function(frame,width,height,x,y,texCoord,path)
		local texture = frame:CreateTexture(nil,"BACKGROUND")
		texture:SetWidth(width);
		texture:SetHeight(height);
		texture:SetTexCoord(unpack(texCoord));
		texture:SetPoint("TOPLEFT", x,y);
		texture:SetTexture(path);
		texture:Show();
	end

	local offX,offY = 2822.734,-273.305;
	for index,v in pairs(GHI_MapData) do
		for i,t in pairs(v) do
			GenerateTexture(mapFrame, t.width, t.height, offX+t.x, offY+t.y, t.texCoord, t.path);
			mapW = math.max(mapW, -offX + t.x + t.width);
			mapH = math.max(mapH, -offY + t.y + t.height);
		end
	end
	mapFrame:SetHeight(mapH);
	mapFrame:SetWidth(mapW);

	--print("map size", mapW, mapH)

	mapFrame:SetScale(0.1)

	local player = mapFrame:CreateTexture(nil,"OVERLAY")
	player:SetWidth(16/mapFrame:GetScale());
	player:SetHeight(16/mapFrame:GetScale());
	player:SetTexture("Interface\\MINIMAP\\TRACKING\\Repair");
	player:Show();

	local UpdatePlayer = function()
		local pos = GHI_Position();
		local x,y = pos.GetCoor("player",3);
		player:SetPoint("TOPLEFT", offX + x, offY - y);
	end

	class.New = function()
		UpdatePlayer();
		GHI_Timer(UpdatePlayer,1);
		menuFrame:AnimatedShow();
	end

	class.Edit = function()
	end

	class.IsInUse = function()
		return false;
	end

	return class;
end

