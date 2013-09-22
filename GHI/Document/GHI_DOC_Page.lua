--===================================================
--
--				GHI_DOC_Page
--  			GHI_DOC_Page.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_DOC_Page(pageLayout)
	local class = GHClass("GHI_DOC_Page");
	local linkedAreas = {}
	local floatingAreas = {};
	local height,width;
	local selectedFloating = nil;
	local selectedObject;
	local selectedIndex = 0;
	local length = 0;
	local xOff,yOff = 0,0;
	local frame = CreateFrame("frame");
	--GHM_TempBG(frame);

	---------------------------------------------------------------------------
	-- Area functions
	---------------------------------------------------------------------------

	--@description Get the total amount of areas on the page
	--@args
	--@returns number
	class.GetNumAreas = function()
		return #(floatingAreas) + #(linkedAreas);
	end

	--@description Inserts an area on the page
	--@args GHI_DOC_Area, number, number, string
	--@returns
	class.InsertArea = function(area,xOff,yOff,areaType)
		assert(area.IsClass and area.IsClass("GHI_DOC_Area"),"Inserted area must be of type GHU_Area",area.GetType and area.GetType());

		if areaType == "floating" then
			table.insert(floatingAreas,area);
		else
			table.insert(linkedAreas,area);
		end

		area.SetAnchor(frame,xOff,yOff)
	end

	---------------------------------------------------------------------------
	-- Frame functions
	---------------------------------------------------------------------------

	--@description Sets the anchor of the frame
	--@args frame, number, number
	--@returns
	class.SetAnchor = function(parent,_xOff,_yOff)
		GHCheck("GHI_DOC_Page.SetAnchor(parent,x,y,xOff,yOff):", { "table","number","number"}, { parent,xOff,yOff});
		frame:SetParent(parent);
		xOff,yOff = _xOff,_yOff;

		frame:SetPoint("TOPLEFT",xOff,yOff);
	end

	--@description Sets the size of the frame
	--@args number, number
	--@returns
	class.SetSize = function(x,y)
		GHCheck("GHI_DOC_Page.SetSize(x,y):", { "number","number"}, { x,y});
		width,height = x,y;
		frame:SetWidth(width);
		frame:SetHeight(height);
	end

	---------------------------------------------------------------------------
	-- Modification functions
	---------------------------------------------------------------------------

	--@description Inserts a given text with an (optional) given textFont.
	--@args string, GHI_DOC_Font
	--@returns
	class.Insert = function(insertText,textFont)
		local count = 0;
		for i,area in pairs(linkedAreas) do
			if (selectedIndex <= count + area.GetLength()) then
				area.Insert(insertText,textFont);
				if area.needContentUpdate then
					class.needContentUpdate = true;
				end
				return
			end
			count = count + area.GetLength();
		end
	end

	--@description Deletes a section of text or objects (from startIndex to endIndex).
	--@args number, number
	--@returns boolean
	class.Delete = function(startIndex,endIndex)
	    startIndex = math.max(0,startIndex or 0);
		endIndex = math.min(length,endIndex or length);

		local c = 0;
		local i = 1;
		local allDeleted = false;
		while (linkedAreas[i]) do
			local area = linkedAreas[i];
			if (c <= endIndex) and ((c + area.GetLength()) > startIndex) then
				area.Delete(startIndex - c, endIndex - c);
			end
			c = c + area.GetLength();
			i = i + 1;
		end
		class.needContentUpdate = true;

		return (startIndex == 0 and endIndex == length);
	end

	--@description Gets the font object of the selected location
	--@args
	--@returns GHI_DOC_Font
	class.GetSelectedFont = function()
		if selectedObject then
			return selectedObject.GetSelectedFont();
		end
	end

	--@description Set the font object of the selected location range
	--@args GHI_DOC_Font, number, number
	--@returns
	class.SetFont = function(font,fromIndex,toIndex)
		local from,to = fromIndex or 0,toIndex or class.GetLength();

		local count = 0;
		for i,area in pairs(linkedAreas) do
			if (count > to) then -- after
				return
			elseif (to > count and from <= count + area.GetLength() ) then
				area.SetFont(font,from-count,to-count);
				class.needContentUpdate = true;
			end
			count = count + area.GetLength();
		end

	end

	---------------------------------------------------------------------------
	-- Location functions
	---------------------------------------------------------------------------

	--@description Gets the coordinate at a given index
	--@args number
	--@returns number, number
	class.GetCoorAt = function(index,direction)

	end

	--@description Gets the index at a given coordinate
	--@args number, number
	--@returns number
	class.GetIndexAt = function(x,y)
		x,y = x-math.abs(xOff),y-math.abs(yOff);
		--print("Page",x,y);
		local closest,shortestDist,shortestDelta;
		local deltaIndex = 0;
		for _,area in pairs(linkedAreas) do
			local dist = area.GetDistanceTo(x,y);
			if not(closest) or (dist < shortestDist) then
				closest = area;
				shortestDist = dist;
				shortestDelta = deltaIndex;
			end
			deltaIndex = deltaIndex + area.GetLength();
		end

		if closest then
			return shortestDelta + closest.GetIndexAt(x,y);
		end
	end

	--@description Gets the length
	--@args
	--@returns number
	class.GetLength = function()
		return length;
	end

	--@description Gets the index of a location of interest.
	--@args string, number boolean
	--@returns number
	class.GetIndexOfLocation = function(Type,index,backwards)
		if Type == "pageStart" then
			return 0;
		elseif Type == "pageEnd" then
			return length;
		end

		local count = 0;
		for i,area in pairs(linkedAreas) do
			local last = not(i == #(linkedAreas));
			if (index <= count + area.GetLength() - (backwards and last and 1 or 0)) then
				local val,off = area.GetIndexOfLocation(Type,index - count,backwards);
				if val then
					return count + val;
				end
				--todo: other page
				return index - count;
			end
			count = count + area.GetLength();
		end
		return 0;
	end

	--@description Gets a raw text piece
	--@args number, number, boolean
	--@returns number
	class.GetRawText = function(_start,_end,backwards)
		local t = "";
		if (_start and _end) then
			local c = 0;
			for i,area in pairs(linkedAreas) do
				local last = not(i == #(linkedAreas));
				local mod = (backwards and last and 1 or 0);

				if _start <= c + area.GetLength() - mod  and _end >=  c  then
					t = t..area.GetRawText(math.max(_start - c,0),math.min(_end-c,area.GetLength()),backwards);
				elseif _end <  c + area.GetLength() - mod then
					break;
				end
				c = c + area.GetLength();
			end
		end
		return t;
	end

   	---------------------------------------------------------------------------
	-- Update functions
	---------------------------------------------------------------------------

	class.needContentUpdate = false;

	--@description Updates the content of the line
	--@args table
	--@returns table
	class.UpdateContent = function(info)
		info = info or {};

		for i,area in pairs(linkedAreas) do
			if area.needContentUpdate or info.overflowLines then
				info = area.UpdateContent(info);
			end
		end


		class.needLengthUpdate = true;
		class.needContentUpdate = false;
		return info;
	end

	class.needLengthUpdate = false;

	--@description Updates the length
	--@args
	--@returns
	class.UpdateLength = function()
		local len = 0;
		for i,area in pairs(linkedAreas) do
			if area.needLengthUpdate then
				area.UpdateLength();
			end
			len = len + area.GetLength();
		end
		length = len;
		class.needLengthUpdate = false;
	end

	--@description Updates the index of the selection.
	--@args number
	--@returns
	class.UpdateSelected = function(index,backwards)

		if selectedObject then
			selectedObject.UpdateSelected();
			selectedObject = nil;
		end
		selectedIndex = index;

		if selectedIndex then
			local c = 0;
			for i,area in pairs(linkedAreas) do
				local last = not(i == #(linkedAreas));
				if (selectedIndex - c) <= area.GetLength() - (backwards and last and 1 or 0) then -- - (backwards and 1 or 0) then
					area.UpdateSelected(selectedIndex - c,backwards);
					selectedObject = area;
					break;
				else
					c = c + area.GetLength();
				end
			end
		end

	end

	local currentHighlight;
	--@description Updates the indexes of the highlight.
	--@args number, number
	--@returns
	class.UpdateHighlight = function(hStart,hEnd,backwards)
		if (currentHighlight) then
			local c = 0;
			local currHStart,currHEnd = unpack(currentHighlight);
			for i,area in pairs(linkedAreas) do
				local last = not(i == #(linkedAreas));
				local mod = (backwards and last and 1 or 0);

				if currHStart <= c + area.GetLength() - mod  and currHEnd >=  c  then
					area.UpdateHighlight();
				elseif currHEnd <  c + area.GetLength() - mod then
					break;
				end
				c = c + area.GetLength();
			end
		end

		if (hStart and hEnd) then
			local c = 0;
			for i,area in pairs(linkedAreas) do
				local last = not(i == #(linkedAreas));
				local mod = (backwards and last and 1 or 0);

				if hStart <= c + area.GetLength() - mod  and hEnd >=  c  then
					area.UpdateHighlight(math.max(hStart - c,0),math.min(hEnd-c,area.GetLength()));
				elseif hEnd <  c + area.GetLength() - mod then
					break;
				end
				c = c + area.GetLength();
			end
			currentHighlight = {hStart,hEnd};
		else
			currentHighlight = nil;
		end
	end

	--@description Serializes the object
	--@args
	--@returns table
	class.Serialize = function(t)
		t = t or {};
		for i,areas in pairs(linkedAreas) do
			t = areas.Serialize(t);
		end
		return t;
	end

	pageLayout.ApplyAreas(class);

	return class;
end

