--===================================================
--
--				GHM_StandardButtonWithTexture
--				GHM_StandardButtonWithTexture.lua
--
--	A standard button with a texture applied on top
--	of it instead of text.
--
-- 		(c)2014 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;
function GHM_StandardButtonWithTexture(profile, parent, settings)
	local frame = CreateFrame("Button","GHM_StandardButtonWithTexture" .. count, parent, "GHM_Button_Template");
	count = count + 1;

	frame:SetHeight(profile.height or 24);
	frame:SetWidth(profile.width or 24);

	local textures = {};

	local CreateTexture = function(width, height, texturePath, x, y, texCoord)
		local texture = frame:CreateTexture(nil,"OVERLAY");
		texture:SetWidth(width);
		texture:SetHeight(height);
		texture:SetTexture(texturePath);
		if texCoord then
			texture:SetTexCoord(unpack(texCoord));
		end

		texture:SetPoint("CENTER", frame, "CENTER", x, y);
		frame:SetScript("OnMouseDown", function()
			texture:SetPoint("CENTER", frame, "CENTER", x + 1, y - 1);
		end);
		frame:SetScript("OnMouseUp", function()
			texture:SetPoint("CENTER", frame, "CENTER", x, y);
		end);

		table.insert(textures, texture)
	end

	if type(profile.texture) == "string" then
		CreateTexture(frame:GetWidth() - 10, frame:GetHeight() - 10, profile.texture, 0, 0, profile.texCoord);
	elseif type(profile.texture) == "table" then
		local coords = profile.texCoord or {};
		if #(profile.texture) == 2 then
			local w = frame:GetWidth();
			local h = frame:GetHeight();
			CreateTexture((w - 10)/2, (h - 10), profile.texture[1], -(w - 10)/4, 0, coords[1]);
			CreateTexture((w - 10)/2, (h - 10), profile.texture[2], (w - 10)/4, 0, coords[2]);  --]]
		end
	end

	if type(profile.onClick) == "function" then
		frame:SetScript("OnClick", profile.onClick);
	end

	local OrigUpdateTheme = frame.UpdateTheme;
	frame.UpdateTheme = function()
		OrigUpdateTheme();
		for _,tex in pairs(textures) do
			tex:SetVertexColor(GHM_GetButtonTextColor());
		end
	end

	frame:SetScript("OnEnter", function(self)
		if profile.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			GameTooltip:ClearLines()
			GameTooltip:AddLine(profile.tooltip, 1, 0.8196079, 0);
			GameTooltip:Show()
		end
	end);
	frame:SetScript("OnLeave", function(self)
		if profile.tooltip then
			GameTooltip:Hide();
		end
	end);

	frame:Show();

	return frame;
end
