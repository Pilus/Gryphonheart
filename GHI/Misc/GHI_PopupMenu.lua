--===================================================
--
--				GHI_PopupMenu
--  			GHI_PopupMenu.lua
--
--	A popup menu system displaying popups in GHM style,
--		using the same information as StaticPopup.
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

--[[
--	Syntax:
data = {
	title = "Name of the popup",
	text = "Text in the popup",
	buttons = {
		OKAY,
	},
	gotCancel = true, -- automatically inserts a cancel button as well
}
-- ]]

function GHI_PopupMenu(data)
	GHCheck("GHI_PopupMenu", { "table" }, { data });
	local guidGen = GHI_GUID();
	local class = GHClass("GHI_PopupMenu");

	local ghmTable = {
		title = data.title,
		theme = "BlankTheme",
		width = 300,
		useWindow = true,
		{
			{
				{
					align = "c",
					type = "Text",
					text = data.text,
					fontSize = 11,
					color = "white",
					width = 240
				},
			},
		},
	};

	local createdFrames;
	local numButtons = #(data.buttons or {});

	if (numButtons == 1) then

	elseif numButtons == 2 then

	elseif numButtons == 3 then
	end


	class.Show = function(...)
		for _, frame in pairs(createdFrames) do
			if not (frame:IsShown()) then
				frame.functions = { ... };
				frame:AnimatedShow();
				return;
			end
		end
		ghmTable.name = guidGen.MakeGUID();

		local frame = GHM_NewFrame(class, ghmTable);
		frame.functions = { ... }
		table.insert(createdFrames, frame);
		frame:AnimatedShow();
	end


	return class;
end

