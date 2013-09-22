--===================================================
--
--				GHI_DOC_Line
--  			GHI_DOC_Line.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_DOC_Line()
	local class = GHClass("GHI_DOC_Line");
	local objects = {GHI_DOC_Block()};
	local selectedIndex;
	local selectedObject;
	local frame = CreateFrame("frame");
	local width = 20;
	local length = 0;
	local height = 10;
	local xOff,yOff = 0,0;
	frame:SetWidth(width);

	objects[1].SetAnchor(frame,0,0);
	objects[1]:SetWidth(10)
	frame:SetHeight(objects[1]:GetPreferredHeight());

	--GHM_TempBG(frame);

	--@description Gets the objects
	--@args
	--@returns table
	class.GetAllObjects = function()
		return objects;
	end

	---------------------------------------------------------------------------
	-- Frame functions
	---------------------------------------------------------------------------

	--@description Sets the anchor of the frame
	--@args frame, number, number
	--@returns
	class.SetAnchor = function(parent,_xOff,_yOff)
		GHCheck("GHI_DOC_Line.SetAnchor(parent,x,y,xOff,yOff):", { "table","number","number"}, { parent,xOff,yOff});
		frame:SetParent(parent);
		xOff,yOff = _xOff,_yOff;

		frame:SetPoint("TOPLEFT",xOff,yOff);
	end

	--@description Sets the anchor of the frame
	--@args frame, number, number
	--@returns
	class.SetWidth = function(_width)
		GHCheck("GHI_DOC_Line.SetWidth(width):", { "number"}, {_width});
		width = _width;
		frame:SetWidth(width);
	end


   	---------------------------------------------------------------------------
	-- Modification functions
	---------------------------------------------------------------------------

	--@description Inserts a given text with an (optional) given textFont.
	--@args string, GHI_DOC_Font
	--@returns
	class.Insert = function(insertText,textFont)
		GHCheck("GHI_DOC_Line.Insert(insertText,font):", {"string", "tableNil" }, { insertText,textFont });
		if textFont and (not(textFont.IsClass) or not(textFont.IsClass("GHI_DOC_Font"))) then
			error("GHI_DOC_Line.Insert(insertText,font): Font must be either nil or a GHI_DOC_Font object");
		end
		assert(type(selectedIndex) == "number","GHI_DOC_Line.Insert called on a line that are not selected")

		local c = 0;
		for i,object in pairs(objects) do
			local last = not(i == #(objects));
			if selectedIndex >= c and selectedIndex <= c + object.GetLength() - (last and 1 or 0) then

				local result = {object.Insert(insertText,textFont)};
				if (object.needContentUpdate) or #(result)> 0 then
					class.needContentUpdate = true;
				end

				-- insert the returned objects into the objects list
				for j,newObject in pairs(result) do
					newObject.needContentUpdate = true;
					class.needContentUpdate = true;
					if j == 1 then
						objects[i] = newObject; -- overwrite current instead of insert
					else
						table.insert(objects,i+j-1,newObject);
					end
				end
				break;
			else
				c = c + object.GetLength();
			end
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
		while (objects[i]) do
			local object = objects[i];
			if (c >= startIndex) and ((c + object.GetLength()) < endIndex) then -- complete delete
				object.Hide();
				table.remove(objects,i);
				i = i - 1;
			elseif (c <= endIndex) and ((c + object.GetLength()) > startIndex) then  -- partial delete
				object.Delete(startIndex - c, endIndex - c);
			end
			c = c + object.GetLength();
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
		for i,object in pairs(objects) do
			if (count > to) then -- after
				return
			elseif (to > count and from < count + object.GetLength() ) and object.SetFont then-- print("set font at obj",i,"from",from,"to",to,"Object limit from",count,"to",count+object.GetLength())
				local result = {object.SetFont(font,math.max(fromIndex-count,0),math.min(toIndex-count, object.GetLength()))};
				--print("Result:",#(result or {}),"new objects")

				-- insert the returned objects into the objects list
				if result then
					for j,newObject in pairs(result) do  -- print("new object",j)

						newObject.needContentUpdate = true;
						class.needContentUpdate = true;
						if j == 1 then
							objects[i] = newObject; -- overwrite current instead of insert
						else
							table.insert(objects,i+j-1,newObject);
						end
					end
				end
			end
			count = count + object.GetLength();
		end
	end

	---------------------------------------------------------------------------
	-- Location functions
	---------------------------------------------------------------------------

	--@description Gets the coordinate at a given index
	--@args number
	--@returns number, number
	class.GetCoorAt = function(index,backwards)
		local count = 0;
		for i,object in pairs(objects) do
			local last = not(i == #(objects));
			if (index <= count + object.GetLength() - (backwards and last and 1 or 0)) then
				local x,y = object.GetCoorAt(index - count,backwards)
				return x+xOff,y-yOff;
			end
			count = count + object.GetLength();
		end
	end

	--@description Gets the index at a given coordinate
	--@args number, number
	--@returns number
	class.GetIndexAt = function(x,y)
		x = math.max(0,x-math.abs(xOff));
		y = math.max(0,y-math.abs(yOff));

		local delta,deltaIndex = 0,0;
		for i,object in pairs(objects) do
			if x <= object.GetPreferredWidth() + delta then
		   		return deltaIndex + object.GetIndexAt(x - delta, y);
			end
			if i ~= #(objects) then
				delta = delta + object.GetPreferredWidth();
				deltaIndex = deltaIndex + object.GetLength();
			end
		end
		return deltaIndex + objects[#(objects)].GetIndexAt(x - delta, y);
	end

	--@description Gets the length
	--@args
	--@returns number
	class.GetLength = function()
		return length;
	end

	--@description Gets the height
	--@args
	--@returns number
	class.GetHeight = function()
		return height;
	end

	--@description Gets the index of a location of interest.
	--@args string, number, boolean
	--@returns number
	class.GetIndexOfLocation = function(Type,index,backwards)
		if Type == "lineStart" then
			return 0;
		elseif Type == "lineEnd" then
			return length;
		end

		local count = 0;
		for i,object in pairs(objects) do
			local last = not(i == #(objects));
			if (index <= count + object.GetLength() - (backwards and last and 1 or 0)) then
				return count + object.GetIndexOfLocation(Type,index - count,backwards)
			end
			count = count + object.GetLength();
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
			for i,object in pairs(objects) do
				local last = not(i == #(objects));
				local mod = (backwards and last and 1 or 0);

				if _start <= c + object.GetLength() - mod  and _end >=  c  then
					t = t..object.GetRawText(math.max(_start - c,0),math.min(_end-c,object.GetLength()));
				elseif _end <  c + object.GetLength() - mod then
					break;
				end
				c = c + object.GetLength();
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

		if (info.overflowObjects) then
			local overflow = info.overflowObjects;
			info.overflowObjects = nil;

			local firstObjectIsRawText;
			if (overflow[1] and overflow[1].text and overflow[1].font) then
				firstObjectIsRawText = true;
			end

			local lastObj = 1;
			if firstObjectIsRawText then
				lastObj = 2;
			end

			local j = #(overflow);
			while (j >= lastObj) do
				table.insert(objects,1,overflow[j]);
				j = j - 1;
			end

			if firstObjectIsRawText then -- try to merge with the first object on the line
				local font = overflow[1].font;
				local text = overflow[1].text;
				local firstLineObj = objects[1];

				if (firstLineObj.GetFont().IsSame(font)) then
					local newText = text..firstLineObj.GetText();
					firstLineObj.SetText(newText);
				else
					local obj = GHI_DOC_Block();
					obj.SetFont(font);
					obj.SetText(text);
					if firstLineObj.GetLength() == 0 then
						objects[1] = obj;
					else
						table.insert(objects,1,obj);
					end
				end
			end

		end

		local used = 0;
		for i,object in pairs(objects) do

			if object.needContentUpdate or (used + object.GetPreferredWidth()) >= width then
				info.maxWidth = width - used;
				info = object.UpdateContent(info);
			end
			if info.overflowObjects and info.overflowObjects[#(info.overflowObjects)] == object then
				objects[i] = nil;
			else
				object.SetAnchor(frame,used,0);
			end
			used = used + math.max(0,object.GetPreferredWidth()-1.5);
		end

		local h = 0;
		for i,object in pairs(objects) do
			h = math.max(h,object.GetPreferredHeight());
		end
		height = h;
		frame:SetHeight(height);

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
		for i,object in pairs(objects) do
			if object.needLengthUpdate then
				object.UpdateLength();
			end
			len = len + object.GetLength();
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
			for i,object in pairs(objects) do
				local last = not(i == #(objects));
				if selectedIndex >= c and selectedIndex <= c + object.GetLength() - (backwards and last and 1 or 0) then
					object.UpdateSelected(selectedIndex - c);
					selectedObject = object;
					break;
				else
					c = c + object.GetLength();
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
			for i,object in pairs(objects) do
				local last = not(i == #(objects));
				local mod = (backwards and last and 1 or 0);

				if currHStart <= c + object.GetLength() - mod  and currHEnd >=  c  then
					object.UpdateHighlight();
				elseif currHEnd <  c + object.GetLength() - mod then
					break;
				end
				c = c + object.GetLength();
			end
		end

		if (hStart and hEnd) then
			local c = 0;
			for i,object in pairs(objects) do
				local last = not(i == #(objects));
				local mod = (backwards and last and 1 or 0);

				if hStart <= c + object.GetLength() - mod  and hEnd >=  c  then
					object.UpdateHighlight(math.max(hStart - c,0),math.min(hEnd-c,object.GetLength()));
				elseif hEnd <  c + object.GetLength() - mod then
					break;
				end
				c = c + object.GetLength();
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
		for i,object in pairs(objects) do
			t = object.Serialize(t);
		end
		return t;
	end


	return class;
end

