--===================================================
--
--				GHI_DOC_Area
--  			GHI_DOC_Area.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_DOC_Area(width,height)
	local class = GHClass("GHI_DOC_Area");
	local frame = CreateFrame("frame");
	local lines = {GHI_DOC_Line()};
	local selectedIndex = 0;
	local selectedObject;
	local length = 0;
	local xOff,yOff = 0,0;
	frame:SetWidth(width);
	frame:SetHeight(height);
	lines[1].SetAnchor(frame,0,0);
	lines[1].SetWidth(width);

	local background = CreateFrame("Frame",nil,frame);
	background:SetAllPoints(frame);
	background:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
		edgeFile = "edgeFile",
		tile = false,
		tileSize = 0,
		edgeSize = 32,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	});
	background:SetBackdropColor(0.7,0.7,0.7, 0.2);
	background:Hide();

	---------------------------------------------------------------------------
	-- Frame functions
	---------------------------------------------------------------------------

	--@description Sets the anchor of the frame
	--@args frame, number, number
	--@returns
	class.SetAnchor = function(parent,_xOff,_yOff)
		GHCheck("GHI_DOC_Block.SetAnchor(parent,x,y,xOff,yOff):", { "table","number","number"}, { parent,xOff,yOff});
		frame:SetParent(parent);
		xOff,yOff = _xOff,_yOff;

		frame:SetPoint("TOPLEFT",xOff,yOff);
	end

	---------------------------------------------------------------------------
	-- Modification functions
	---------------------------------------------------------------------------

	--@description Inserts a given text with an (optional) given textFont.
	--@args string, GHI_DOC_Font
	--@returns
	class.Insert = function(insertText,textFont)
		local count = 0;
		for i,line in pairs(lines) do
			if (selectedIndex <= count + line.GetLength()) then
				line.Insert(insertText,textFont);
				if line.needContentUpdate then
					class.needContentUpdate = true;
				end
				return
			end
			count = count + line.GetLength();
		end
	end

	--@description Deletes a section of text or objects (from startIndex to endIndex).
	--@args number, number
	--@returns
	class.Delete = function(startIndex,endIndex)
	    startIndex = math.max(0,startIndex or 0);
		endIndex = math.min(length,endIndex or length);

		local c = 0;
		local i = 1;

		while (lines[i]) do
			local line = lines[i];
			if (c >= startIndex) and ((c + line.GetLength()) < endIndex) then -- complete delete
				line.hide();
				table.remove(lines,i);
				i = i - 1;
			elseif (c <= endIndex) and ((c + line.GetLength()) > startIndex) then  -- partial delete
				line.Delete(startIndex - c, endIndex - c);
			end
			c = c + line.GetLength();
			i = i + 1;
		end
		class.needContentUpdate = true;
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
		for i,line in pairs(lines) do
			if (count > to) then -- after
				return
			elseif (to > count and from <= count + line.GetLength() ) then
				line.SetFont(font,from-count,to-count);
				class.needContentUpdate = true;
			end
			count = count + line.GetLength();
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
		local _xOff,_yOff = math.abs(xOff),math.abs(yOff);
		--print("Area",x,y);
		x = math.max(0,x-_xOff);
		y = math.max(0,y-_yOff);

		local delta,deltaIndex = 0,0;
		for i,line in pairs(lines) do
			if y <= line.GetHeight() + delta then
		   		return deltaIndex+line.GetIndexAt(x,y);
			end

			if not(i == #(lines)) then
				delta = delta + line.GetHeight();
				deltaIndex = deltaIndex + line.GetLength();
			end
		end
		return deltaIndex+lines[#(lines)].GetIndexAt(x,y);
	end

	--@description Gets the distance to a given position
	--@args number, number
	--@returns number
	class.GetDistanceTo = function(x,y)
		local x,y = x-xOff, y-yOff;
		if x >= 0 and x <= xOff then
			if y >= 0 and y <= yOff then  --inside
				return 0
			elseif y < 0 then   -- above
				return -y;
			else -- bellow
				return y;
			end
		elseif x < 0 then
	   		if y >= 0 and y <= yOff then  -- left
				return -x;
			elseif y < 0 then  -- topleft
				return math.sqrt(y*y + x*x);
			else -- bottomleft
		   		return math.sqrt((y+yOff)^2 + x*x);
			end
		else
			if y >= 0 and y <= yOff then -- right
				return x;
			elseif y < 0 then -- topright
				return math.sqrt(y*y + (x+xOff)^2);
			else  -- bottomright
				return math.sqrt((y+yOff)^2 + (x+xOff)^2);
			end
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
		if Type == "areaStart" then
			return 0;
		elseif Type == "areaEnd" then
			return length;
		end

		local count = 0;
		for i,line in pairs(lines) do
			local last = not(i == #(lines));
			if (index <= count + line.GetLength() - (backwards and last and 1 or 0)) then
				local x,y = line.GetCoorAt(index - count,backwards);
				if Type == "above" then
					if i == 1 then
						return nil,x,y;
					end
					local prevLine = lines[i-1];
					return count - prevLine.GetLength() + prevLine.GetIndexAt(x,y);
				elseif Type == "bellow" then
					if i == #(lines) then
						return nil,x,y;
					end
					local nextLine = lines[i+1];
					return count + line.GetLength() + nextLine.GetIndexAt(x,y);
				else
					return count + line.GetIndexOfLocation(Type,index - count,backwards)
				end
			end
			count = count + line.GetLength();
		end
		return length;
	end

	--@description Gets a raw text piece
	--@args number, number, boolean
	--@returns number
	class.GetRawText = function(_start,_end,backwards)
		local t = "";
		if (_start and _end) then
			local c = 0;
			for i,line in pairs(lines) do
				local last = not(i == #(lines));
				local mod = (backwards and last and 1 or 0);

				if _start <= c + line.GetLength() - mod  and _end >=  c  then
					t = t..line.GetRawText(math.max(_start - c,0),math.min(_end-c,line.GetLength()),backwards);
				elseif _end <  c + line.GetLength() - mod then
					break;
				end
				c = c + line.GetLength();
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
		if (info.overflowLines) then
			for i,line in pairs(info.overflowLines) do
				line.SetWidth(width);
				table.insert(lines,i,line);
			end
		end

		info.overflowLines = nil;

		local used = 0;
		for i,line in pairs(lines) do
			if line.needContentUpdate or info.overflowObjects then
				info = line.UpdateContent(info);
				line.SetAnchor(frame,0,-used);
			end
			used = used + line.GetHeight();
			if used > height then -- one too many
				info.overflowLines = info.overflowLines or {};
				table.insert(info.overflowLines,lines);
				lines[i] = nil;
			end
		end



		while info.overflowObjects and not(info.overflowLines) do
			local line = GHI_DOC_Line();
			line.SetWidth(width);
			line.SetAnchor(frame,0,-used);
			info = line.UpdateContent(info);
			used = used + line.GetHeight();
			if used > height then -- one too many
				info.overflowLines = info.overflowLines or {};
				table.insert(info.overflowLines,lines);
			else
				table.insert(lines,line);
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
		for i,line in pairs(lines) do
			if line.needLengthUpdate then
				line.UpdateLength();
			end
			len = len + line.GetLength();
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
			for i,line in pairs(lines) do
				local last = not(i == #(lines));
				if (selectedIndex - c) <= line.GetLength() - (backwards and last and 1 or 0) then
					line.UpdateSelected(selectedIndex - c,backwards);
					selectedObject = line;
					break;
				else
					c = c + line.GetLength();
				end
			end
			background:Show();
		else
			background:Hide();
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
			for i,line in pairs(lines) do
				local last = not(i == #(lines));
				local mod = (backwards and last and 1 or 0);

				if currHStart <= c + line.GetLength() - mod  and currHEnd >=  c  then
					line.UpdateHighlight();
				elseif currHEnd <  c + line.GetLength() - mod then
					break;
				end
				c = c + line.GetLength();
			end
		end

		if (hStart and hEnd) then
			local c = 0;
			for i,line in pairs(lines) do
				local last = not(i == #(lines));
				local mod = (backwards and last and 1 or 0);

				if hStart <= c + line.GetLength() - mod  and hEnd >=  c  then
					line.UpdateHighlight(math.max(hStart - c,0),math.min(hEnd-c,line.GetLength()));
				elseif hEnd <  c + line.GetLength() - mod then
					break;
				end
				c = c + line.GetLength();
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
		for i,line in pairs(lines) do
			t = line.Serialize(t);
		end
		return t;
	end

	return class;
end

