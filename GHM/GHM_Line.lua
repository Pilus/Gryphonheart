--===================================================
--
--				GHM_Line
--  			GHM_Line.lua
--
--	          (description)
--
-- 	  (c)2014 The Gryphonheart Team
--			All rights reserved
--===================================================


function GHM_Line(profile, parent, settings)
	local class = GHClass("GHM_Line");

	local parentName = parent:GetName();
	local lineNumber = 1;
	while (_G[parentName.."_L".. lineNumber]) do
		lineNumber = lineNumber + 1;
	end
	local lineName = parentName.."_L".. lineNumber;

	local line = CreateFrame("Frame", lineName, parent);

	local objects = Linq();
	for i=1,#(profile) do
		objects[i] = GHM_BaseObject(profile[i], line, settings);
	end

	local objectsWithFlexibleWidth = objects.Where(function(obj) return obj.GetPreferredDimensions() == nil; end);
	local objectsWithFlexibleHeight = objects.Where(function(obj) return ({obj.GetPreferredDimensions()})[2] == nil; end);

	local leftObjects = objects.Where(function(obj) return obj.GetAlignment() == GHM_Alignment.Left; end);
	local centerObjects = objects.Where(function(obj) return obj.GetAlignment() == GHM_Alignment.Center; end);
	local rightObjects = objects.Where(function(obj) return obj.GetAlignment() == GHM_Alignment.Right; end);

	local GetTopAndBottom = function()
		local top, bottom = 0, 0;
		objects.Foreach(function(obj)
			local w, h = obj.GetPreferredDimensions();
			local ox, oy = obj.GetPreferredCenterOffset();
			top = math.max(top, (h/2) - oy);
			bottom = math.max(bottom, (h/2) + oy);
		end);
		return top, bottom;
	end

	class.GetPreferredDimensions = function()
		local objectSpacing = settings.objectSpacing;
		local width, height;

		if objectsWithFlexibleWidth.None() then
			local leftWidth = leftObjects.Sum(function(obj) return obj.GetPreferredDimensions() + objectSpacing; end);
			local centerWidth = centerObjects.Sum(function(obj) return obj.GetPreferredDimensions() + objectSpacing; end);
			local rightWidth = rightObjects.Sum(function(obj) return obj.GetPreferredDimensions() + objectSpacing; end);

			if (leftObjects.Any() and centerObjects.None() and rightObjects.None()) then
				leftWidth = leftWidth - objectSpacing;
			end

			if (centerObjects.Any()) then
				centerWidth = centerWidth - objectSpacing;
			end

			if (rightObjects.Any() and centerObjects.None()) then
				rightWidth = rightWidth - objectSpacing;
			end
			width = leftWidth + centerWidth + rightWidth;
		end

		if objectsWithFlexibleHeight.None() and objects.Any() then
			local top, bottom = GetTopAndBottom();
			height = top + bottom;
		end

		return width, height;
	end

	local GetYPosition = function(obj, top, bottom)
		local _, h = obj.GetPreferredDimensions();
		local _, oy = obj.GetPreferredCenterOffset();
		if h then
			return top + oy - (h/2);
		else
			return 0;
		end
	end

	class.SetPosition = function(xOff, yOff, width, height)
		GHCheck("Line.SetPosition", {"number", "number", "number", "number"}, {xOff, yOff, width, height})
		line:SetWidth(width);
		line:SetHeight(height);
		line:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, -yOff);
		--GHM_TempBG(line);

		local top, bottom;
		if height then
			top, bottom = height/2, height/2;
		else
			top, bottom = GetTopAndBottom();
		end

		local objectSpacing = settings.objectSpacing;

		local leftWidth = leftObjects.Sum(function(obj) return (obj.GetPreferredDimensions() or 0) + objectSpacing; end);
		local centerWidth = centerObjects.Sum(function(obj) return (obj.GetPreferredDimensions() or 0) + objectSpacing; end);
		local rightWidth = rightObjects.Sum(function(obj) return (obj.GetPreferredDimensions() or 0) + objectSpacing; end);

		if (leftObjects.Any() and centerObjects.None() and rightObjects.None()) then
			leftWidth = leftWidth - objectSpacing;
		end

		if (centerObjects.Any()) then
			centerWidth = centerWidth - objectSpacing;
		end

		if (rightObjects.Any() and centerObjects.None()) then
			rightWidth = rightWidth - objectSpacing;
		end

		if (centerObjects.Any()) then
			local leftObjectsWithFlixibleWidth = leftObjects.Intersection(objectsWithFlexibleWidth)
			local centerObjectsWithFlixibleWidth = centerObjects.Intersection(objectsWithFlexibleWidth)
			local rightObjectsWithFlixibleWidth = rightObjects.Intersection(objectsWithFlexibleWidth)
			local centerFlexUnitSize;

			if centerObjectsWithFlixibleWidth.Any() then
				local widthAvailableLeft = (width/2) - leftWidth - (centerWidth/2);
				local widthAvailableRight = (width/2) - rightWidth - (centerWidth/2);
				local leftFlexUnitSize = widthAvailableLeft / (leftObjectsWithFlixibleWidth.Count() + (centerObjectsWithFlixibleWidth.Count()/2));
				local rightFlexUnitSize = widthAvailableRight / (rightObjectsWithFlixibleWidth.Count() + (centerObjectsWithFlixibleWidth.Count()/2));
				centerFlexUnitSize = math.min(leftFlexUnitSize, rightFlexUnitSize);

				-- Update center width
				centerWidth = centerWidth + centerFlexUnitSize * centerObjectsWithFlixibleWidth.Count();
			end

			-- Position the center objects
			local x = (width - centerWidth)/2;
			centerObjects.Foreach(function(obj)
				local w, h = obj.GetPreferredDimensions();
				obj.SetPosition(x, GetYPosition(obj, top, bottom),  w or centerFlexUnitSize, h or height);
				x = x + (w or centerFlexUnitSize) + objectSpacing;
			end);

			-- Set up left side
			local widthAvailableLeft = (width - centerWidth)/2;
			local leftFlexUnitSize = (widthAvailableLeft - leftWidth) / leftObjectsWithFlixibleWidth.Count();
			local x = 0;
			leftObjects.Foreach(function(obj)
				local w, h = obj.GetPreferredDimensions();
				obj.SetPosition(x, GetYPosition(obj, top, bottom),  w or leftFlexUnitSize, h or height);
				x = x + (w or leftFlexUnitSize) + objectSpacing;
			end);

			-- Set up right side
			local widthAvailableRight = (width - centerWidth)/2;
			local rightFlexUnitSize = (widthAvailableRight - rightWidth) / rightObjectsWithFlixibleWidth.Count();
			local rightFlexSize = 0;
			if rightObjectsWithFlixibleWidth.Count() > 0 then
				rightFlexSize = rightFlexUnitSize * rightObjectsWithFlixibleWidth.Count();
			end
			local x = width - rightWidth - rightFlexSize;
			rightObjects.Foreach(function(obj)
				local w, h = obj.GetPreferredDimensions();
				obj.SetPosition(x, GetYPosition(obj, top, bottom),  w or rightFlexUnitSize, h or height);
				x = x + (w or rightFlexUnitSize) + objectSpacing;
			end);
		else
			-- set up left side and right side
			local flexUnitSize = 0;
			if objectsWithFlexibleWidth.Count() > 0 then
				flexUnitSize = (width - leftWidth - rightWidth) / objectsWithFlexibleWidth.Count();
			end
			local x = 0;
			leftObjects.Foreach(function(obj)
				local w, h = obj.GetPreferredDimensions();
				obj.SetPosition(x, GetYPosition(obj, top, bottom),  w or flexUnitSize, h or height);
				x = x + (w or flexUnitSize) + objectSpacing;
			end);

			local rightObjectsWithFlixibleWidth = rightObjects.Intersection(objectsWithFlexibleWidth)
			local x = width - rightWidth - flexUnitSize * rightObjectsWithFlixibleWidth.Count();
			rightObjects.Foreach(function(obj)
				local w, h = obj.GetPreferredDimensions();
				obj.SetPosition(x, GetYPosition(obj, top, bottom),  w or flexUnitSize, h or height);
				x = x + (w or flexUnitSize) + objectSpacing;
			end);
		end
	end

	class.GetLabelFrame = function(label)
		local frame = objects.Where(function(obj) return obj.GetLabel() == label; end).First();
		if not(frame) then
			objects.Foreach(function(obj)
				if obj.GetLabelFrame and not(frame) then
					frame = obj.GetLabelFrame(label);
				end
			end)
		end
		return frame;
	end

	class.GetPage = function()
		return parent;
	end

	return class;
end

