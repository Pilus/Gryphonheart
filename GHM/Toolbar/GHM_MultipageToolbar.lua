--===================================================
--
--				GHM_MultiPageToolbar
--  			GHM_MultiPageToolbar.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;
function GHM_MultiPageToolbar(parent, main, profile)
	local frame = CreateFrame("Frame", "GHM_MultiPageToolbar" .. count, parent);
	count = count + 1;

	local height,width = 0,0;
	local pages = {};

	local lastClicked;
	local TogglePage = function(self)
		if lastClicked then
			lastClicked:Enable();
			pages[lastClicked.id]:Hide();
		end
		self:Disable();
		pages[self.id]:Show();
		lastClicked = self;
	end

	local buttonRowProfile = {};
	local firstButton
	for i = 1,#(profile) do
		table.insert(buttonRowProfile,{
			type = "Button",
			text = profile[i].text,
			align = "l",
			compact = true,
			OnClick = function(self)
				TogglePage(self);
			end,
			OnLoad = function(self)
				self:SetDisabledTexture(self:GetPushedTexture());
				self.id = i;
				if i == 1 then
					firstButton = self;
				end
			end,
		})
	end

	local buttonRow = GHM_ToolbarObjectRow(frame, main, buttonRowProfile);

	for i=1,#(profile) do
		local page = GHM_ToolbarObjectRow(frame, main, profile[i]);
		page:SetPoint("TOPRIGHT","TOPRIGHT");

		width = math.max(width, page:GetWidth());
		height = math.max(height, page:GetHeight());

		table.insert(pages, page)
	end

	local h, text = GHM_Text(frame, main, {
		text = profile.name,
		align = "c",
	})
	text:ClearAllPoints();
	text:SetPoint("BOTTOM","BOTTOM");

	frame:SetHeight(height);
	frame:SetWidth(width);

	GHM_FramePositioning(frame,profile,parent);

	TogglePage(firstButton);

	return frame;
end

