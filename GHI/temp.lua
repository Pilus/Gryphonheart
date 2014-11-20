-- File for code intended to be in new files. This is done in order to avoid having to restart the game.

-- GHI_BookEditor_InsertPage.lua
GHI_BookEditor_InsertPage = function(editor)
	local class = GHClass("GHI_BookEditor_InsertPage");

	local loc = GHI_Loc();
	local imageMenuList = GHM_ImagePickerList()
	local iconMenuList = GHM_IconPickerList()

	local GetGuildEmblemTextures = function()
		local t = {GetGuildTabardFileNames()};
		if #(t) > 0 then
			local tex = string.match(t[3],"[^_]*_[^_]*");
			return {tex, tex};
		end
		return {"Textures\\GuildEmblems\\Emblem_00", "Textures\\GuildEmblems\\Emblem_00"};
	end

	local CreateEmblemTexturedButton = function(parent, emblemId)
		local idString = emblemId < 10 and "0"..tostring(emblemId) or tostring(emblemId);
		local button = CreateFrame("Button", nil, parent);
		button:SetWidth(50);
		button:SetHeight(50);

		local left = button:CreateTexture();
		left:SetPoint("TOPLEFT", button, "TOPLEFT");
		left:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT");
		left:SetPoint("TOPRIGHT", button, "TOP");
		left:SetPoint("BOTTOMRIGHT", button, "BOTTOM");
		left:SetTexture("Textures\\GuildEmblems\\Emblem_"..idString);
		left:SetTexCoord(0.5, 0, 0.25, 0.75);

		local right = button:CreateTexture();
		right:SetPoint("TOPLEFT", button, "TOP");
		right:SetPoint("BOTTOMLEFT", button, "BOTTOM");
		right:SetPoint("TOPRIGHT", button, "TOPRIGHT");
		right:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT");
		right:SetTexture("Textures\\GuildEmblems\\Emblem_"..idString);
		right:SetTexCoord(0, 0.5, 0.25, 0.75);

		return button;
	end

	local SIZE = 40;
	local COLUMNS = 20;

	local emblemPicker;
	local ClickEmblemPicker = function(button)
		if not(emblemPicker) then
			emblemPicker = CreateFrame("Frame", nil, button);
			emblemPicker:SetWidth(SIZE*COLUMNS);
			emblemPicker:SetHeight(250);
			emblemPicker:SetPoint("TOP", button, "BOTTOM");
			emblemPicker:SetBackdrop({
				bgFile = "Interface/Tooltips/UI-Tooltip-Background",
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = true, tileSize = 16, edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 }});
			for i=0,195 do
				local column = mod(i, COLUMNS);
				local row = math.floor(i / COLUMNS)
				local b = CreateEmblemTexturedButton(emblemPicker, i);
				b:SetPoint("TOPLEFT", emblemPicker, "TOPLEFT", column * SIZE, -row * SIZE);
			end
		end
		emblemPicker:Show();
	end

	local SetUpGraphicsCat = function()
		return {
			name = "Graphics",
			{
				{
					type = "Button",
					text = "Img",
					compact = true,
					height = 48,
					width = 48,
					tooltip = loc.INSERT_IMAGE,
					onClick = function()
						imageMenuList.New(function(path, width, height)
							local imageText = string.format("[img width=%s height=%s]%s[/img]", width, height, path)
							editor.Insert(imageText);
						end);
					end,
				},
				{
					type = "Button",
					text = "Icon",
					compact = true,
					height = 48,
					width = 48,
					tooltip = loc.INSERT_ICON,
					onClick = function()
						iconMenuList.New(function(icon)
							local imageText = string.format("[img width=%s height=%s]%s[/img]", 32, 32, icon)
							editor.Insert(imageText);
						end);
					end,
				},
				{
					type = "StandardButtonWithTexture",
					tooltip = "Guild Emblem",
					height = 48,
					width = 48,
					texture = GetGuildEmblemTextures(),
					texCoord = {{0.5, 0, 0.25, 0.75}, {0, 0.5, 0.25, 0.75}},
					onClick = ClickEmblemPicker,
				},
			}
		}
	end

	local SetUpInteractiveObjectsCat = function()
		return {
			name = "Interactive Objects",
			{
				{
					type = "Button",
					text = "Link",
					compact = true,
					height = 24,
					width = 24,
					onClick = function() end,
				},
			}
		}
	end

	class.GetProfile = function()
		return	{
			name = "Insert",
			SetUpGraphicsCat(),
			SetUpInteractiveObjectsCat(),
		};
	end

	return class;
end