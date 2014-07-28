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
	local theme = profile.theme or "StdTheme";
	local class = CreateFrame("Frame", profile.name, UIParent, "GHM_" .. theme .. "_Template");

	class.Pages = Linq();

	local i = 1;
	while type(profile[i]) == "table" do
		class.Pages[i] = GHM_Page(profile[i], class, {lineSpacing = profile.lineSpacing or 0, objectSpacing = 5});
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
			return obj.GetValue();
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
	if profile.onShow then
		class:SetScript("OnShow", function(f) GHM_LayerHandle(f); profile.onShow(f); end);
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

