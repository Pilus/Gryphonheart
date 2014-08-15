--===================================================
--
--				GHM_BaseObject
--  			GHM_BaseObject.lua
--
--	          (description)
--
-- 	  (c)2014 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHM_BaseObject(profile, parent, settings)
	local objType = profile.type;

	local obj;
	if type(_G["GHM_" .. objType]) == "function" then
		obj = _G["GHM_" .. objType](profile, parent, settings);
	else
		print(string.format("Unknown object %s",objType));
		obj = CreateFrame("Frame")
	end

	obj.GetAlignment = obj.GetAlignment or function()
		if profile.align == "c" then
			return GHM_Alignment.Center;
		elseif profile.align == "r" then
			return GHM_Alignment.Right;
		else
			return GHM_Alignment.Left;
		end
	end

	obj.SetPosition = obj.SetPosition or function(xOff, yOff, width, height)
		obj:SetWidth(width);
		obj:SetHeight(height);
		obj:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, -yOff);
		--GHM_TempBG(obj);
	end

	obj.GetPreferredDimensions = obj.GetPreferredDimensions or function()
		return math.max(obj:GetWidth(), profile.width or 0), math.max(obj:GetHeight() , profile.height or 0);
	end

	obj.GetLabel = obj.GetLabel or function()
		return profile.label;
	end

	obj.GetPreferredCenterOffset = obj.GetPreferredCenterOffset or function()
		local w, h = obj.GetPreferredDimensions();
		return 0, 0;
	end

	obj.GetLine = function()
		return parent;
	end

	obj.GetPage = function()
		return obj.GetLine().GetPage();
	end

	local origGetValue = obj.GetValue;
	if origGetValue then
		obj.GetValue = function(self)
			return origGetValue(self or obj);
		end
	end

	return obj;
end

