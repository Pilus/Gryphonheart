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

	if profile.texture then
		local texture = frame:CreateTexture(nil,"OVERLAY");
		texture:SetPoint("CENTER", frame, "CENTER", 0, 0);
		texture:SetWidth(frame:GetWidth() - 10);
		texture:SetHeight(frame:GetHeight() - 10);
		texture:SetTexture(profile.texture);
		if profile.texCoord then
			texture:SetTexCoord(unpack(profile.texCoord));
		end

		frame:SetScript("OnMouseDown", function()
			texture:SetPoint("CENTER", 1, -1);
		end);
		frame:SetScript("OnMouseUp", function()
			texture:SetPoint("CENTER", 0, 0);
		end);

		frame.texture = texture;
	end

	if type(profile.onClick) == "function" then
		frame:SetScript("OnClick", profile.onClick);
	end

	local OrigUpdateTheme = frame.UpdateTheme;
	frame.UpdateTheme = function()
		OrigUpdateTheme();
		if frame.texture then
			frame.texture:SetVertexColor(GHM_GetButtonTextColor());
		end
	end

	frame:Show();

	return frame;
end
