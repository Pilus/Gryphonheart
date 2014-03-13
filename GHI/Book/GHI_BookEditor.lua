--===================================================
--
--				GHI_BookEditor
--  			GHI_BookEditor.lua
--
--	 Toggled by  /script GHI_MenuList("GHI_BookEditor").New();
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 0;
function GHI_BookEditor()
	local class = GHClass("GHI_BookEditor");
	count = count + 1;

	local inUse = false;
	local menuFrame
	local loc = GHI_Loc();
	local converter = GHI_BBCodeConverter();
	local itemList = GHI_ItemInfoList();

	local action, textFrame, info, item, currentPageShown;

	local SaveCurrentPage = function()
		if currentPageShown then
			info[currentPageShown] = info[currentPageShown] or {};
			local bbcode = textFrame.GetValue();
			local simpleHtml = converter.ToSimpleHtml(bbcode);
			info[currentPageShown].text1 = simpleHtml;
		end
	end

	local ShowPage = function(i)
		SaveCurrentPage();
		currentPageShown = i;

		local mockup = converter.ToMockup(info[i].text1);
		textFrame.Force(mockup);
	end

	class.New = function(...)
		--inUse = true;
		--menuFrame:AnimatedShow();
	end

	class.Edit = function(bookAction, _item, ...)
		action = bookAction;
		item = _item;
		info = action.GetInfo();
		inUse = true;
		ShowPage(1);
		menuFrame:AnimatedShow();
	end

	local OnOk = function()
		SaveCurrentPage();
		action.UpdateInfo(info);
		item.IncreaseVersion(true);
		itemList.UpdateItem(item);
		GHI_MiscData.lastUpdateItemTime = GetTime();

		menuFrame:Hide();
	end

	class.IsInUse = function() return inUse; end

	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				{
					type = "MultiPageToolbar",
					align = "l",
					{
						name = "Page A",
						{
							name = "Category B",
							{
								{
									type = "TextButton",
									text = "H1",
								},
								{
									type = "TextButton",
									text = "H2",
								},
							},
						},
						{
							name = "Cat 2",
							{
								{
									type = "TextButton",
									text = "H3",
								},
								{
									type = "TextButton",
									text = "H4",
								},
							},
							{
								{
									type = "TextButton",
									text = "H5",
								},
							},
						},
						{
							name = "Cat 3",
							{
								{
									type = "TextButton",
									text = "X",
								},
							}
						},
					},
					{
						name = "Some other page",
						{
							name = "Category X",
							{
								{
									type = "TextButton",
									text = "H1",
								},
							}
						}
					}
				}
			},
			{
				{
					type = "EditField",
					align = "c",
					width = 400,
					height = 400,
					label = "text",
				},
			},
			{
				{
					type = "Button",
					text = OKAY,
					align = "c",
					label = "ok",
					compact = false,
					OnClick = OnOk,
					xOff = -100,
				},
				{
					type = "Button",
					text = CANCEL,
					align = "c",
					label = "cancel",
					compact = false,
					xOff = 100,
					OnClick = function(obj)
						menuFrame:Hide();
					end,
				},
			},
		},
		title = loc.BOOK,
		name = "GHI_BookEditor" .. count,
		theme = "BlankTheme",
		width = 400,
		height = 600,
		useWindow = true,
		icon = "Interface\\Icons\\INV_Misc_Book_09",
		lineSpacing = 0,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	});

	textFrame = menuFrame.GetLabelFrame("text");

	return class;
end

