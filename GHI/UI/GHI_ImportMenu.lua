--===================================================
--
--				GHI_ImportMenu
--  			GHI_ImportMenu.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;

function GHI_ImportMenu()
	if class then
		return class;
	end
     local loc = GHI_Loc()
	class = GHClass("GHI_ImportMenu");
	local menuFrame;
	local miscAPI = GHI_MiscAPI().GetAPI();
	local containerAPI = GHI_ContainerAPI().GetAPI();

	class.ImportCode = function(code)
		containerAPI.GHI_ImportItemFromCode(code);
	end

	class.Show = function()
		menuFrame:AnimatedShow();
	end

	local OnOk = function()
		local main = menuFrame;
		menuFrame.ForceLabel("code", "")
		main:Hide()
	end

	local OnShow = function()
	--SetDefaultValues();

		menuFrame.ForceLabel("code", "")
	end



	-- Menu setup
	local icon = "Interface\\Icons\\INV_Crate_04";
	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				{
					align = "c",
					type = "Text",
					text = loc.IMPORT_INSTRUCTION,
					fontSize = 11,
					color = "white",
					width = 240
				},
			},
			{
				{
					align = "c",
					label = "code",
					type = "EditField",
					width = 300,
					height = 359,
				},
			},
			{
				{
					height = 12,
					type = "Dummy",
					align = "c",
					width = 10,
				},
			},
			{
				{
					align = "c",
					type = "Button",
					text = loc.IMPORT,
					label = "import",
					onclick = function()
						local code = menuFrame.GetLabel("code")
						if not (code == "") then
							code = gsub(code, "||", strchar(124));
							class.ImportCode(code)
						end
					end,
				},
			},
		},
		title = loc.IMPORT,
		--height = 435,
		name = "GHI_ImportMenuUI",
		theme = "BlankTheme",
		width = 350,
		useWindow = true,
		--background = "INTERFACE\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains",
	});
	_G[menuFrame.GetLabelFrame("code"):GetName() .. "AreaScrollText"]:SetMaxLetters(50000)

	return class;
end