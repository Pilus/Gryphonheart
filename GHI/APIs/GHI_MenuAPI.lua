--
--
--				GHI_MenuAPI
--				GHI_MenuAPI.lua
--
--		API for creation of GHM menus
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local class;
function GHI_MenuAPI()
	if class then
		return class;
	end
	class = GHClass("GHI_MenuAPI");

	local api = {};

	local StripTableForClassesAndFrames;
	StripTableForClassesAndFrames = function(t)
		if not(type(t)=="table" or type(t)=="function") then
			return t;
		end

		if type(t) == "function" then
			return function(...)
				local args = StripTableForClassesAndFrames({...});
				local returns = {t(unpack(args))};
				return unpack(StripTableForClassesAndFrames(returns));
			end
		end

		if t.IsClass and t.GetType then
			return "GH Class <"..t.GetType()..">";
		end

		if t.GetObjectType then
			return "Frame <"..t:GetObjectType()..">";
		end

		local new = {};
		for i,v in pairs(t) do
			new[i] = StripTableForClassesAndFrames(v);
		end
		return new;
	end

	local CreateShadowFrame = function(frame)
		local f = CreateFrame("Frame",nil,frame)
		f:SetAllPoints(frame);
		f.GetPoint = function() return end
		f.GetParent = function() return end
		return f;
	end

	api.CreateMenu = function(menuProfile)
		local menuFrame = GHM_NewFrame(class,StripTableForClassesAndFrames(menuProfile));
		menuFrame:AnimatedShow();

		local f = CreateShadowFrame(menuFrame);
		f.ForceLabel = menuFrame.ForceLabel;
		f.GetLabelFrame = function(label)
			local frame = menuFrame.GetLabelFrame(label);
			if frame then
				local f = CreateShadowFrame(frame);

				return f;
			end
		end
		f.GetLabel = function(label)
			return StripTableForClassesAndFrames(menuFrame.GetLabel(label));
		end
		f.Show = function()
			menuFrame:Show();
		end
		f.Hide = function()
			menuFrame:Hide();
		end
		f.IsShown = function()
			return menuFrame:IsShown();
		end

		return f;
	end

	class.GetAPI = function()
		local a = {};
		for i, f in pairs(api) do
			a[i] = f;
		end
		return a;
	end

	return class;
end

