--===================================================
--
--				GHI_BagOptionsMenu
--  			GHI_BagOptionsMenu.lua
--
--	Options menu for bag related options
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_BagOptionsMenu(parentName)
	if class then
		return class;
	end
	class = GHClass("GHI_BagOptionsMenu");
	local parentWidth = InterfaceOptionsFramePanelContainer:GetWidth() - 20;
	local loc = GHI_Loc();

	GHI_MiscData = GHI_MiscData or {};

	local button = GHI_ButtonUI();
	button.SetChangePositionCallbackFunction(function(x, y)
		GHI_MiscData["BackpackPos"] = { x, y };
	end);

	local UpdateButton = function()
		button.SetScale(GHI_MiscData["BackpackScale"] or 1);

		if GHI_MiscData["BackpackPos"] then
			button.SetPosition(unpack(GHI_MiscData["BackpackPos"]));
		else
			button.ResetPosition();
		end

		if GHI_MiscData["BackpackIcon"] then
			button.SetTexture(GHI_MiscData["BackpackIcon"]);
		else
			button.SetTexture("Interface\\Icons\\INV_Misc_Bag_07_Blue");
		end

		if GHI_MiscData["BackpackType"] == 2 then
			button.UseRound();
		else
			button.UseSquared();
		end
	end
	UpdateButton();

	local menuFrame = GHM_NewFrame(CreateFrame("frame"), {
		onOk = function(self) end,
		{
			{
				{
					align = "c",
					type = "Text",
					text = loc.BACKPACK_ICON,
					fontSize = 11,
				},
			},
			{
				{
					height = 20,
					type = "Dummy",
					align = "c",
					width = 10,
				},
			},
			{
				{
					height = 20,
					type = "Dummy",
					align = "l",
					width = 20,
				},
				{
					type = "RadioButtonSet",
					text = loc.ICON_SHAPE,
					align = "l",
					label = "shape",
					returnIndex = true,
					data = { loc.ICON_SHAPE_SQUARED, loc.ICON_SHAPE_ROUND },
				},
				{
					height = 20,
					type = "Dummy",
					align = "r",
					width = 60,
				},
				{
					type = "Icon",
					text = loc.ICON,
					align = "r",
					label = "icon",
					framealign = "r",
					CloseOnChoosen = true,
				},
			},
			{
				{
					height = 20,
					type = "Dummy",
					align = "c",
					width = 10,
				},
			},
			{
				{
					height = 20,
					type = "Dummy",
					align = "l",
					width = 30,
				},
				{
					type = "CustomSlider",
					values = { 0.25, 0.5, 0.75, 1.00, 1.25, 1.50, 1.75, 2.00 },
					label = "icon_scale",
					align = "l",
					text = loc.SCALE,
				},
				{
					height = 20,
					type = "Dummy",
					align = "r",
					width = 40,
				},
				{
					type = "Button",
					label = "center_icon",
					align = "r",
					text = loc.CENTER_ICON,
					compact = false,
					onclick = function(self)
						button.ResetPosition();
					end,
				},
			},
		},
		OnShow = function()
		end,
		title = "",
		height = 400,
		name = "GHI_OptionsButtonFrame",
		theme = "BlankTheme",
		width = parentWidth,
	});

	menuFrame.name = loc.BACKPACK_ICON;
	menuFrame.parent = parentName;
	menuFrame.refresh = function()
		menuFrame.ForceLabel("icon_scale", GHI_MiscData["BackpackScale"] or 1)

		if GHI_MiscData["BackpackType"] == 2 then
			menuFrame.ForceLabel("shape", 2);
		else
			menuFrame.ForceLabel("shape", 1);
		end

		if GHI_MiscData["BackpackIcon"] then
			menuFrame.ForceLabel("icon", GHI_MiscData["BackpackIcon"]);
		else
			menuFrame.ForceLabel("icon", "Interface\\Icons\\INV_Misc_Bag_07_Blue");
		end
	end
	menuFrame.okay = function()
        if GHI_OptionsButtonFrame:IsShown() then
		GHI_MiscData["BackpackScale"] = menuFrame.GetLabel("icon_scale");
		GHI_MiscData["BackpackIcon"] = menuFrame.GetLabel("icon");
		GHI_MiscData["BackpackType"] = menuFrame.GetLabel("shape");
		UpdateButton();
        end
	end;

	InterfaceOptions_AddCategory(menuFrame);

	class.Show = function(cat)
		InterfaceOptionsFrame_OpenToCategory(menuFrame);
	end

	return class;
end

