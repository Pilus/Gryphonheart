--===================================================
--
--				GHI_TooltipMenu
--  			GHI_TooltipMenu.lua
--
--		Menu for creation of custom tooltips
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
 local loc = GHI_Loc();
local ALIGNS_LOC = { loc.LEFT, loc.RIGHT };
local ALIGNS = { "left", "right" };

local count = 1;
function GHI_TooltipMenu()
	local class = GHClass("GHI_TooltipMenu");

	local menuFrame;
	local OnOk;
	local set;

	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				{
					align = "l",
					type = "Editbox",
					text = loc.NAME;
					label = "name",
					texture = "Tooltip",
					width = 200,
				},
				{
					align = "r",
					type = "RadioButtonSet",
					text = loc.TIP_ALIGN;
					label = "align",
					returnIndex = true,
					dataFunc = function()
						return ALIGNS_LOC;
					end,
				},
			},
			{
				{
					type = "DynamicActionArea",
					align = "c",
					label = "updateSequence",
					width = 360,
					height = 180,
					isUpdateSequence = true,
					specialActionCategory = "tooltip",
				},
			},
			{
				{
					type = "Text",
					text = loc.TT_TEXT,
					align = "c",
					color = "white",
					width = 340,
				},
			},
			{
				{
					type = "Dummy",
					height = 10,
					width = 100,
					align = "l",
				},
				{
					type = "Button",
					text = OKAY,
					align = "l",
					label = "ok",
					compact = false,
					OnClick = function() if OnOk then OnOk() end end,
				},
				{
					type = "Dummy",
					height = 10,
					width = 100,
					align = "r",
				},
				{
					type = "Button",
					text = CANCEL,
					align = "r",
					label = "cancel",
					compact = false,
					OnClick = function(obj)
						menuFrame:Hide();
					end,
				},
			},
		},
		title = loc.TT_TITLE,
		name = "GHI_TooltipMenu" .. count,
		theme = "BlankTheme",
		width = 380,
		useWindow = true,
		lineSpacing = 20,
	});
	count = count + 1;

	menuFrame:Hide();

	local SetMenu = function(item, editSeq, editName, editAlign, editOrder)

		if editSeq then
			local setData = editSeq.Serialize();
			set = GHI_DynamicActionInstanceSet(item, "OnTooltipUpdate")
			set.SetIsUpdateSequence(true);
			set.Deserialize(setData);
			for i, alignName in pairs(ALIGNS) do
				if alignName == editAlign then
					menuFrame.ForceLabel("align", i);
				end
			end
			menuFrame.ForceLabel("name", editName);
			menuFrame.editOrder = editOrder;
			menuFrame.editSeq = editSeq;
		else
			set = GHI_DynamicActionInstanceSet(item, "OnTooltipUpdate")
			set.SetIsUpdateSequence(true);
			menuFrame.ForceLabel("name", "");
			menuFrame.ForceLabel("align", 1)
		end

		menuFrame.GetLabelFrame("updateSequence").SetDynamicActionInstanceSet(set);
	end

	class.New = function(parentItem, createdFeedbackFunc)
		menuFrame:AnimatedShow();
		OnOk = function()

			menuFrame:Hide();
			local name = menuFrame.GetLabel("name");
			local align = ALIGNS[menuFrame.GetLabel("align") or 1];
			parentItem.AddTooltip(name, set, align, nil)
			if createdFeedbackFunc then
				createdFeedbackFunc(name, set, align)
			end
		end
		SetMenu(parentItem);
	end

	class.Edit = function(parentItem, editSeq, editName, editAlign, editOrder, createdFeedbackFunc)
		menuFrame:AnimatedShow();
		OnOk = function()

			menuFrame:Hide();
			local name = menuFrame.GetLabel("name");
			local align = ALIGNS[menuFrame.GetLabel("align") or 1];
			parentItem.RemoveTooltip(editSeq);
			parentItem.AddTooltip(name, set, align, editOrder)
			if createdFeedbackFunc then
				createdFeedbackFunc(name, set, align, order)
			end
		end
		SetMenu(parentItem, editSeq, editName, editAlign);
	end

	return class;
end

