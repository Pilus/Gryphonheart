--===================================================
--
--				GHI_DOC_Document
--  			GHI_DOC_Document.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local count = 1;
function GHI_DOC_Document()
	local class = GHClass("GHI_DOC_Document");
	local menuFrame;

	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				{
					align = "l",
					type = "Dummy",
					label = "anchor",
					height = 10,
					width = 10,
				},
			},

		},
		title = "Document",
		name = "GHI_Document" .. count,
		theme = "BlankTheme",
		height = 400,
		width = 380,
		useWindow = true,
		lineSpacing = 20,
		menuBar = {
			{

				{
					type = "DropDown",
					label = "fontSize",
					dataFunc = function()
						local t = {};
						for i=1,#(GHI_Fonts) do
							table.insert(t,GHI_Fonts[i].name);
						end
						return t;
					end,
					OnSelect = function(i)
						class.api.SetFontPath(GHI_Fonts[i].path)
					end,
				},
				{
					type = "Editbox",
					width = 40,
					texture = "Tooltip",
					numbersOnly = true,
					label = "fontSize",
				},
				align = "l",
			}
		},
	});
	count = count + 1;

	menuFrame:Hide();
	local scrollFrame = CreateFrame("ScrollFrame","$parentScroll",menuFrame,"GHM_ScrollFrameTemplate")
	--scrollFrame:SetAllPoints(menuFrame);
	scrollFrame:SetPoint("TOP",0,-3);
	scrollFrame:SetPoint("BOTTOM",0,-8);
	scrollFrame:SetPoint("LEFT",-3,0);
	scrollFrame:SetPoint("RIGHT",22,0);

	local docFrame = CreateFrame("Frame","$parentDoc",scrollFrame);
	scrollFrame:SetScrollChild(docFrame);

	docFrame:SetHeight(math.max(380,scrollFrame:GetHeight()));
	docFrame:SetWidth(math.max(360,scrollFrame:GetWidth()));

	--GHM_TempBG(scrollFrame);

	local selectedIndex = 0;
	local selectedIsBackwards;
	local selectedObject;
	local needContentUpdate,needLengthUpdate;
	local length = 0;
	local UpdateContent, UpdateLength, UpdateSelected, UpdateHighlight;
	local fontList = GHI_DOC_FontList();
	local font;
	local input;

	---------------------------------------------------------------------------
	-- Page setup
	---------------------------------------------------------------------------
	local pages = {};
	local pageLayout = GHI_DOC_PageLayout();
	pageLayout.SetSize(360-20,380-20)
	pageLayout.AddArea("linked",160,380-40,10,-10);

	table.insert(pages,GHI_DOC_Page(pageLayout));
	pages[1].SetAnchor(docFrame,10,-10);

	---------------------------------------------------------------------------
	-- Modification functions
	---------------------------------------------------------------------------

	--@description Inserts a given text with an (optional) given textFont.
	--@args string, GHI_DOC_Font
	--@returns
	local Insert = function(insertText,textFont)
		local count = 0;
		for i,page in pairs(pages) do
			if (selectedIndex <= count + page.GetLength()) then
				page.Insert(insertText,textFont);
				if page.needContentUpdate then
					needContentUpdate = true;
				end
				return
			end
			count = count + page.GetLength();
		end
	end

	--@description Deletes a section of text or objects (from startIndex to endIndex).
	--@args number, number
	--@returns
	local Delete = function(startIndex,endIndex)
	    startIndex = math.max(0,startIndex or 0);
		endIndex = math.min(length,endIndex or length);

		local c = 0;
		local i = 1;
		local allDeleted = false;
		while (pages[i]) do
			local page = pages[i];
			if (c <= endIndex) and ((c + page.GetLength()) > startIndex) then
				local deletePage = page.Delete(startIndex - c, endIndex - c);
				if deletePage and #(pages) > 1 then
					page.hide();
					table.remove(pages,i);
					i = i - 1;
				end
			end
			c = c + page.GetLength();
			i = i + 1;
		end
		needContentUpdate = true;

		return (startIndex == 0 and endIndex == length);
	end

	--@description Gets the font object of the selected location
	--@args
	--@returns GHI_DOC_Font
	local GetSelectedFont = function()
		if selectedObject then
			return selectedObject.GetSelectedFont();
		end
	end

	--@description Set the font object of the selected location range
	--@args GHI_DOC_Font, number, number
	--@returns
	local SetFont = function(font,fromIndex,toIndex)
		local from,to = fromIndex or 0,toIndex or class.GetLength();

		local count = 0;
		for i,page in pairs(pages) do

			if (count > to) then -- after
				return
			elseif (to > count and from <= count + page.GetLength() ) then
				page.SetFont(font,from-count,to-count);
				needContentUpdate = true;
			end
			count = count + page.GetLength();
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
		return pages[1].GetIndexAt(x,y)
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
		if Type == "documentStart" then
			return 0;
		elseif Type == "documentEnd" then
			return length;
		end

		local count = 0;
		for i,page in pairs(pages) do
			local last = not(i == #(pages));
			if (index <= count + page.GetLength() - (backwards and last and 1 or 0)) then
				return count + page.GetIndexOfLocation(Type,index - count,backwards)
			end
			count = count + page.GetLength();
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
			for i,page in pairs(pages) do
				local last = not(i == #(pages));
				local mod = (backwards and last and 1 or 0);

				if _start <= c + page.GetLength() - mod  and _end >=  c  then
					t = t..page.GetRawText(math.max(_start - c,0),math.min(_end-c,page.GetLength()),backwards);
				elseif _end <  c + page.GetLength() - mod then
					break;
				end
				c = c + page.GetLength();
			end
		end
		return t;
	end

	---------------------------------------------------------------------------
	-- Update functions
	---------------------------------------------------------------------------


	needContentUpdate = false;

	--@description Updates the content of the line
	--@args table
	--@returns table
	UpdateContent = function()
		if not(needContentUpdate) then return end;
		local info = {}

		for i,page in pairs(pages) do
			if page.needContentUpdate or info.overflowLines then
				info = page.UpdateContent(info);
			end
		end

		while (info.overflowLines) do
			GHNYI("Overflow to new page.")
		end


		needLengthUpdate = true;
		needContentUpdate = false;
		UpdateLength();
	end

	needLengthUpdate = false;

	--@description Updates the length
	--@args
	--@returns
	UpdateLength = function()
		if not(needLengthUpdate) then return end;
		local len = 0;
		for i,page in pairs(pages) do
			if page.needLengthUpdate then
				page.UpdateLength();
			end
			len = len + page.GetLength();
		end
		length = len;
		needLengthUpdate = false;
	end

	--@description Updates the index of the selection.
	--@args number
	--@returns
	UpdateSelected = function(index,backwards)
		if selectedObject then
			selectedObject.UpdateSelected();
			selectedObject = nil;
		end

		index = math.max(math.min(index,length),0);

		selectedIndex = index;
		selectedIsBackwards = backwards

		if selectedIndex then
			local c = 0;
			for i,page in pairs(pages) do
				local last = not(i == #(pages));


				if (selectedIndex - c) <= page.GetLength() - (backwards and last and 1 or 0)   then
					page.UpdateSelected(selectedIndex - c,backwards);
					selectedObject = page;
					break;
				else
					c = c + page.GetLength();
				end
			end
		end

	end

	local currentHighlight;
	local highlightCenter;

	--@description Updates the indexes of the highlight.
	--@args number, number
	--@returns
	UpdateHighlight = function(hStart,hEnd,backwards)
		if (currentHighlight) then
			local c = 0;
			local currHStart,currHEnd = unpack(currentHighlight);
			for i,page in pairs(pages) do
				local last = not(i == #(pages));
				local mod = (backwards and last and 1 or 0);

				if currHStart <= c + page.GetLength() - mod  and currHEnd >=  c  then
					page.UpdateHighlight();
				elseif currHEnd <  c + page.GetLength() - mod then
					break;
				end
				c = c + page.GetLength();
			end
		end

		if (hStart and hEnd) then
			local c = 0;
			for i,page in pairs(pages) do
				local last = not(i == #(pages));
				local mod = (backwards and last and 1 or 0);

				if hStart <= c + page.GetLength() - mod  and hEnd >=  c  then
					page.UpdateHighlight(math.max(hStart - c,0),math.min(hEnd-c,page.GetLength()));
				elseif hEnd <  c + page.GetLength() - mod then
					break;
				end
				c = c + page.GetLength();
			end
			currentHighlight = {hStart,hEnd};
		else
			highlightCenter = nil;
			currentHighlight = nil;
		end
	end


	--@description Serializes the object
	--@args
	--@returns table
	class.Serialize = function()
		local t = {type = "Document"};
		for i,page in pairs(pages) do
			t = page.Serialize(t);
		end

		-- Serialize all the used fonts.
		local usedFonts = {};
		for i,v in pairs(t) do
			if v.font then
				local font = v.font;
				v.font = font.GetGuid();
				if not(usedFonts[font.GetGuid()]) then
					usedFonts[font.GetGuid()] = font.Serialize();
				end
			end
		end


		t.pageLayout = pageLayout.Serialize();

		return t;
	end

	--
	class.api = {};

	class.api.SetFontPath = function(fontPath)
		local fontInfo = font.Serialize();
		fontInfo[1] = fontPath;
		local insertFont = fontList.GetFont(unpack(fontInfo));
		if currentHighlight then
			local hStart,hEnd = unpack(currentHighlight);
			SetFont(insertFont,hStart,hEnd);
			UpdateContent();
			UpdateSelected(selectedIndex);
			UpdateHighlight(hStart,hEnd);
		else
			font = insertFont;
		end
	end


	-- Click overlay
	local overlay = CreateFrame("Button",nil,docFrame);
	overlay:SetAllPoints(docFrame);
	overlay:RegisterForClicks("AnyUp","AnyDown")

	local GetPos = function()
		local _x, _y = GetCursorPosition();
		local s = overlay:GetEffectiveScale();
		local x,y = _x / s, _y / s;
		--print("GetPos",x-overlay:GetLeft(),(overlay:GetTop()-y));
		return x-overlay:GetLeft(),(overlay:GetTop()-y);
	end

	local dragStart = 0;
	local dragging = false;

	overlay:SetScript("OnMouseDown",function(self,button)
		if button == "LeftButton" then
			dragging = true;
			dragStart = GetTime();

			local index = class.GetIndexAt(GetPos());
			--print("setting to",index)
			UpdateSelected(index);
			if not(highlightCenter) then
				highlightCenter = selectedIndex;
			end

			if not(input.IsEnabled()) then
				input.Enable();
			end
		end
	end);

	local lastX,lastY = 0,0;
	overlay:SetScript("OnUpdate",function()
		if dragging == true then
			local x,y = GetPos();
			if dragStart + 1.0 < GetTime() and abs(lastX-x) > 1 or abs(lastY-y) > 1 then
				local index = class.GetIndexAt(GetPos());
				if not(highlightCenter) then
					highlightCenter = selectedIndex;
				end
				UpdateHighlight(math.min(index,highlightCenter),math.max(index,highlightCenter));

				lastX,lastY = x,y;
			end
		end
	end)

	overlay:SetScript("OnMouseUp",function(self,button)
		if button == "LeftButton" then
			dragging = false;

			if dragStart + 1.0 >= GetTime() then
				UpdateHighlight();
			end

			local index = class.GetIndexAt(GetPos());
			if not(selectedIndex == index) then
				UpdateSelected(index);
				if not(highlightCenter) then
					highlightCenter = selectedIndex;
				end
				if not(input.IsEnabled()) then
					input.Enable();
				end
			end
		end
	end);

	input = GHI_DOC_Input(
	function()
		if currentHighlight then
			return class.GetRawText(unpack(currentHighlight));
		end
		return "";
	end,

	function(cmd,arg1,arg2)

		if cmd == "insert" and  arg2 then
			if currentHighlight then
				local hStart,hEnd = unpack(currentHighlight);
				Delete(hStart,hEnd);
				UpdateHighlight();
				UpdateSelected(hStart);
			end

			Insert(arg2,font);
			UpdateContent();
			UpdateSelected(selectedIndex + strlenutf8(arg2));
		elseif cmd == "insert" then
			--
			if arg1 == "F1" then --todo: remove. Temp test of font change
				font = fontList.GetFont(nil,nil,nil,{r=(random(10)/10),g=(random(10)/10),b=(random(10)/10)});
			elseif arg1 == "F2" then --todo: remove. Temp test of font change
				local insertFont = fontList.GetFont(nil,nil,nil,{r=(random(10)/10),g=(random(10)/10),b=(random(10)/10)});
				if currentHighlight then
					local hStart,hEnd = unpack(currentHighlight);
					SetFont(insertFont,hStart,hEnd);
					UpdateContent();
					UpdateSelected(selectedIndex);
					UpdateHighlight(hStart,hEnd);
				else
					font = insertFont;
				end
			elseif arg1 == "F5" then --todo: remove. Temp test of font change
				local insertFont = fontList.GetFont(nil,nil,nil,nil,true);
				SetFont(insertFont,5,10);
				UpdateContent();
				UpdateSelected(selectedIndex);
			elseif arg1 == "LEFT" then
				if IsShiftKeyDown() then
					if not(highlightCenter) then
						highlightCenter = selectedIndex;
					end
					UpdateHighlight(math.min(selectedIndex - 1,highlightCenter),math.max(selectedIndex - 1,highlightCenter));
				else
					UpdateHighlight();
				end
				UpdateSelected(selectedIndex - 1,true);
				font = GetSelectedFont();
			elseif arg1 == "RIGHT" then
				if IsShiftKeyDown() then
					if not(highlightCenter) then
						highlightCenter = selectedIndex;
					end
					UpdateHighlight(math.min(selectedIndex + 1,highlightCenter),math.max(selectedIndex + 1,highlightCenter));
				else
					UpdateHighlight();
				end
				UpdateSelected(selectedIndex + 1,true);
				font = GetSelectedFont();
			elseif arg1 == "UP" then
				local index = class.GetIndexOfLocation("above",selectedIndex,selectedIsBackwards);

				if IsShiftKeyDown() then
					if not(highlightCenter) then
						highlightCenter = selectedIndex;
					end
					UpdateHighlight(math.min(index,highlightCenter),math.max(index,highlightCenter));
				else
					UpdateHighlight();
				end

				UpdateSelected(index);
				font = GetSelectedFont();
			elseif arg1 == "DOWN" then
				local index = class.GetIndexOfLocation("bellow",selectedIndex,selectedIsBackwards);

				if IsShiftKeyDown() then
					if not(highlightCenter) then
						highlightCenter = selectedIndex;
					end
					UpdateHighlight(math.min(index,highlightCenter),math.max(index,highlightCenter));
				else
					UpdateHighlight();
				end

				UpdateSelected(index);
				font = GetSelectedFont();
			elseif arg1 == "BACKSPACE" then
				if currentHighlight then
					local hStart,hEnd = unpack(currentHighlight);
					Delete(hStart,hEnd);
					UpdateHighlight();
					UpdateSelected(hStart);
				else
					Delete(selectedIndex - 1,selectedIndex);
					UpdateContent();
					UpdateSelected(selectedIndex - 1,true);
				end

				font = GetSelectedFont();
			elseif arg1 == "DELETE" then
				if currentHighlight then
					local hStart,hEnd = unpack(currentHighlight);
					Delete(hStart,hEnd);
					UpdateHighlight();
					UpdateSelected(hStart);
				else
					Delete(selectedIndex,selectedIndex + 1);
					UpdateContent();
				end
				font = GetSelectedFont();
			elseif arg1 == "HOME" then
				local index = class.GetIndexOfLocation("lineStart",selectedIndex,selectedIsBackwards);

				if IsShiftKeyDown() then
					if not(highlightCenter) then
						highlightCenter = selectedIndex;
					end
					UpdateHighlight(math.min(index,highlightCenter),math.max(index,highlightCenter));
				else
					UpdateHighlight();
				end

				UpdateSelected(index,true);
				font = GetSelectedFont();
			elseif arg1 == "END" then
				local index = class.GetIndexOfLocation("lineEnd",selectedIndex,selectedIsBackwards);

				if IsShiftKeyDown() then
					if not(highlightCenter) then
						highlightCenter = selectedIndex;
					end
					UpdateHighlight(math.min(index,highlightCenter),math.max(index,highlightCenter));
				else
					UpdateHighlight();
				end

				UpdateSelected(index);
				font = GetSelectedFont();
			end
		elseif cmd == "clear" then
			GHI_DOC_CursorMarker().Hide();
			UpdateHighlight();
		end
	end);
	input.Enable();

	menuFrame:SetScript("OnHide",function()
		input.Disable();
	end)

	UpdateContent();
	UpdateSelected(0);

	class.Show = function()
		menuFrame:AnimatedShow();
	end

	return class;
end

