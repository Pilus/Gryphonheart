--===================================================
--
--				GHM_BaseMenu
--  			GHM_BaseMenu.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHM_BaseMenu(owner, profile)
	assert(profile.width, "No width given")
	assert(profile.width > 40, "Width too narrow")

	local theme = profile.theme or "StdTheme";
	local class = CreateFrame("Frame", profile.name, UIParent, "GHM_" .. theme .. "_Template");

	class.Pages = Linq();

	local i = profile[0] and 0 or 1;
	while type(profile[i]) == "table" do
		table.insert(class.Pages, GHM_Page(profile[i], class, {lineSpacing = profile.lineSpacing or 0, objectSpacing = 5}));
		i = i + 1;
	end

	class.GetLabelFrame = function(label)
		GHCheck("menu.GetLabelFrame", {"string"}, {label})
		local frame;
		class.Pages.Foreach(function(page)
			frame = frame or page.GetLabelFrame(label);
		end);
		return frame;
	end;

	class.ForceLabel = function(label, ...)
		GHCheck("menu.ForceLabel", {"string", "any", "any"}, {label, ...})
		local obj = class.GetLabelFrame(label);
		if obj then
			if obj.Force then
				obj.Force(...);
			else
				print("No Force function found for object", obj:GetName(), "label", label)
			end
		else
			print("Could not force label for", label)
		end
	end
	class.SetLabel = class.ForceLabel;

	class.GetLabel = function(label)
		local obj = class.GetLabelFrame(label);
		if obj then
			if type(obj.GetValue) == "function" then
				return obj.GetValue();
			else
				print("object for", label, "does not have a GetValue function");
			end
		else
			print("Could not get label for", label)
		end
	end

	class.GetPreferredInsert = function()
		return 10, 10, 10, 10;
	end

	class.UpdatePosition = function()
		local pagesWidth, pagesHeight = 0, 0;
		class.Pages.Foreach(function(page)
			local w, h = page.GetPreferredDimensions();
			pagesWidth = math.max(pagesWidth, w or 0);
			pagesHeight = math.max(pagesHeight, h or 0);
		end);

		local left, right, top, bottom = class.GetPreferredInsert();
		class.Pages.Foreach(function(page)
			local w, h;
			if profile.width then
				w = profile.width - left - right;
			end
			if profile.height then
				h = profile.height - top - bottom;
			end
			page.SetPosition(top, top, w or pagesWidth, h or pagesHeight)
		end);

		class:SetHeight(profile.height or (pagesHeight + top + bottom));
		class:SetWidth(profile.width or (pagesWidth + left + right));
	end

	-- layer handling
	local onShow = profile.onShow or profile.OnShow;
	if onShow then
		class:SetScript("OnShow", function(f) GHM_LayerHandle(f); onShow(f); end);
	else
		class:SetScript("OnShow", function(f) GHM_LayerHandle(f); end);
	end
	class:SetScript("OnHide", function(f) GHM_LayerHandle(f); end);

	class.UpdatePosition();
	if class.Pages[1] then
		class.Pages[1]:Show();
	end

	return class;
end

function GHM_TempBG(f)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
		tile = false,
		tileSize = 0,
		edgeSize = 32,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	});
	local color = { r = math.random(100)/100, g = 0.5, b = 0.8 }
	if GHI_EffectColors then
		color = GHI_EffectColors[GHI_ColorList[random(1, 6)]];
	end
	f:SetBackdropColor(color.r, color.g, color.b, 1);
end

local highest = -10;
local layerFrames = {};

function GHM_LayerHandle(frame)
	if frame:IsShown() then
		local i = 1;
		while i <= #(layerFrames) do
			local f = layerFrames[i];
			if f == frame or not (frame:IsShown()) then
				table.remove(layerFrames, i);
			else
				i = i + 1;
			end
		end
		table.insert(layerFrames, frame);
		for i, f in pairs(layerFrames) do
			f:SetFrameLevel(i * 10)
		end
	end
end

function GHM_1IndexedTable(t)
	local r = {};
	local i = t[0] and 0 or 1;
	while (t[i]) do
		table.insert(r, t[i]);
		i = i + 1;
	end
	return r;
end

