--===================================================
--
--				GHM_Text
--  			GHM_Text.lua
--
--		Text area for GHM
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local DEFAULT_WIDTH = 300;
local DEFUALT_HEIGHT = 20;
local count = 1;

function GHM_Text(parent, main, profile)
	local frame = CreateFrame("Frame", "GHM_Text" .. count, parent, "GHM_Text_Template");
	count = count + 1;

	-- declaration and initialization
	profile = profile or {};

	-- setup
	local labelFrame = _G[frame:GetName() .. "Label"];

	local fontProperties = {
		font = "Fonts\\FRIZQT__.TTF",
		fontSize = 11,
	}
	
	local alignments = {
		c = "CENTER",
		l = "LEFT",
		r = "RIGHT",
	}

	if profile.font then
		if strfind(profile.font,".ttf") then
			fontProperties.font = profile.font
		else
			fontProperties.font = GHI_FontList[profile.font]
		end
	end
	
	if profile.fontSize then
		fontProperties.fontSize = profile.fontSize
	end
	
	if profile.outline == true then
		fontProperties.flags = "OUTLINE"
	end

	labelFrame:SetFont(fontProperties.font,fontProperties.fontSize,fontProperties.flags)	
	labelFrame:SetJustifyH(alignments[profile.align or "l"]);

	if profile.shadow == true then
		labelFrame:SetShadowColor(0,0,0,0.75)
		labelFrame:SetShadowOffset(2,-2)
	end

	frame.color = "white"; -- default
	if profile.color == "white" then
		frame.color = "white";
	elseif profile.color == "yellow" then
		frame.color = "yellow";
	elseif profile.color == "black" then
		frame.color = "black"
	end

	labelFrame:SetWordWrap(true)
	labelFrame:SetNonSpaceWrap(false)
	
	labelFrame:SetText(profile.text);
	
	if profile.width then
		frame:SetWidth(profile.width);
		labelFrame:SetWidth(profile.width);
		frame:SetHeight(labelFrame:GetHeight()+15)
	else
		frame:SetWidth(labelFrame:GetWidth());
		frame:SetHeight(labelFrame:GetHeight());
	end

	frame.Force = function(self, text, newFont)
		if self ~= frame then
			return frame.Force(frame, self);
		end

		labelFrame:SetText(text);
		
		if profile.width then
			frame:SetWidth(profile.width);
			labelFrame:SetWidth(profile.width);
			frame:SetHeight(labelFrame:GetHeight()+15)
		else
			frame:SetWidth(labelFrame:GetWidth());
			frame:SetHeight(labelFrame:GetHeight());
		end
	end

	GHM_FramePositioning(frame,profile,parent);

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame:Show();

	return frame;
end

