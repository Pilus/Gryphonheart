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
		title = "Map",
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

	local mapFrame = CreateFrame("Frame","$parentDoc",scrollFrame);
	scrollFrame:SetScrollChild(mapFrame);

	mapFrame:SetHeight(300);
	mapFrame:SetWidth(300);

	local GenerateTexture = function(frame,width,height,x,y,texCoord,path)
		local texture = frame:CreateTexture(nil,"BACKGROUND")
		texture:SetWidth(width);
		texture:SetHeight(height);
		texture:SetTexCoord(unpack(texCoord));
		texture:SetPoint("TOPLEFT", x,y);
		texture:SetTexture(path);
		texture:Show();
	end
	for index,v in pairs(GHI_MapData) do
		for i,t in pairs(v) do
			GenerateTexture(mapFrame,t.width,t.height,t.x,t.y,t.texCoord,t.path);
		end
	end

	mapFrame:SetScale(0.05)

	class.New = function()
		menuFrame:AnimatedShow();
	end

	class.Edit = function()
	end

	class.IsInUse = function()
		return false;
	end

	return class;
end

