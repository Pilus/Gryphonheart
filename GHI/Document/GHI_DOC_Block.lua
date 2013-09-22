--===================================================
--
--				GHI_DOC_Block
--  			GHI_DOC_Block.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_DOC_Block()
	local class = GHClass("GHI_DOC_Block");

	local frame = CreateFrame("Frame");
	local label = frame:CreateFontString();
	label:SetPoint("TOPLEFT")
	local boldLabel1 = frame:CreateFontString();
	boldLabel1:SetPoint("TOPLEFT",-0.5,0)
	local boldLabel2 = frame:CreateFontString();
	boldLabel2:SetPoint("TOPLEFT",0.5,0)
	boldLabel1:Hide();
	boldLabel2:Hide();

	local text = "";
	local font = GHI_DOC_FontList().GetStandardFont();
	font.ApplyFont(label);
	font.ApplyFont(boldLabel1);
	font.ApplyFont(boldLabel2);
	local selectedIndex;
	local length = 0;

	frame:SetWidth(100);
	frame:SetHeight(20);
	--GHM_TempBG(frame);

	local highlight = CreateFrame("Frame",nil,frame);
	highlight:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
		edgeFile = "edgeFile",
		tile = false,
		tileSize = 0,
		edgeSize = 32,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	});
	highlight:SetBackdropColor(0.7,0.7,0.7, 0.7);
	highlight:Hide();

	local ApplySpecialFontSetting = function(specialType,enabled)
		if specialType == "bold" then
			if enabled then
				boldLabel1:Show();
				boldLabel2:Show();
			else
				boldLabel1:Hide();
				boldLabel2:Hide();
			end
		else

		end

	end

	---------------------------------------------------------------------------
	-- Frame functions
	---------------------------------------------------------------------------

	--@description Sets the anchor of the frame
	--@args frame, number, number, number, number
	--@returns
	class.SetAnchor = function(parent,xOff,yOff)
		GHCheck("GHI_DOC_Block.SetAnchor(parent,x,y,xOff,yOff):", { "table","number","number" }, { parent,xOff,yOff });

		frame:SetHeight(class.GetPreferredHeight());
		frame:SetWidth(class.GetPreferredWidth());

		frame:SetParent(parent);
		frame:SetPoint("BOTTOMLEFT",xOff,yOff);
		frame:Show();
	end

	--@description Get the preferred height of the text block
	--@args
	--@returns number
	class.GetPreferredHeight = function()
		return font.GetHeight();
	end

	--@description Get the preferred width of the text block
	--@args
	--@returns number
	class.GetPreferredWidth = function()
		return label:GetWidth();
	end

	--@description Hides the block
	--@args
	--@returns number
	class.Hide = function()
		return frame:Hide();
	end

	---------------------------------------------------------------------------
	-- Get / Set functions
	---------------------------------------------------------------------------

	--@description Sets a font object
	--@args GHI_DOC_Font
	--@returns
	class.SetCurrentFont = function(_font)
		GHCheck("GHI_DOC_Block.SetCurrentFont(font):", { "GHI_DOC_Font" }, { _font });
		font = _font;
		font.ApplyFont(label,ApplySpecialFontSetting);
		font.ApplyFont(boldLabel1);
		font.ApplyFont(boldLabel2);
		class.needContentUpdate = true;
	end

	--@description Gets the font object
	--@args
	--@returns GHI_DOC_Font
	class.GetFont = function()
		return font;
	end

	--@description Gets the text
	--@args
	--@returns GHI_DOC_Font
	class.GetText = function()
		return text;
	end

	--@description Sets the text
	--@args string
	--@returns
	class.SetText = function(newText)
		GHCheck("GHI_DOC_Block.SetText(newText):", { "string" }, { newText });
		text = newText;
		class.needContentUpdate = true;
	end


	---------------------------------------------------------------------------
	-- Modification functions
	---------------------------------------------------------------------------

	--@description Inserts a given text with an (optional) given textFont. Returns 0-2 new blocks
	--@args string, GHI_DOC_Font
	--@returns GHI_DOC_Block, GHI_DOC_Block
	class.Insert = function(insertText,textFont)
		GHCheck("GHI_DOC_Block.Insert(insertText,font):", {"string", "tableNil" }, { insertText,textFont });
		if textFont and (not(textFont.IsClass) or not(textFont.IsClass("GHI_DOC_Font"))) then
			error("GHI_DOC_Block.Insert(insertText,font): Font must be either nil or a GHI_DOC_Font object");
		end
		assert(type(selectedIndex) == "number","GHI_DOC_Block.Insert called on a block that are not selected")

		if not(textFont) or (textFont.IsSame(font)) then
			text = strsubutf8(text,0,selectedIndex)..insertText..strsubutf8(text,selectedIndex+1);
			class.needContentUpdate = true;
		else
			local otherBlock = GHI_DOC_Block();
			otherBlock.SetCurrentFont(textFont);
			otherBlock.UpdateSelected(0);
			otherBlock.Insert(insertText);
			if selectedIndex == 0 then
				return otherBlock,class;
			elseif selectedIndex == class.GetLength() then
				return class,otherBlock;
			else
				local extraBlock = GHI_DOC_Block();
				extraBlock.SetCurrentFont(font);
				extraBlock.UpdateSelected(0);
				extraBlock.Insert(string.sub(text,selectedIndex+1));
				text = string.sub(text,0,selectedIndex);
				class.needContentUpdate = true;
				return class,otherBlock,extraBlock;
			end
		end

	end

	--@description Deletes a section of text or objects (from startIndex to endIndex).
	--@args number, number
	--@returns
	class.Delete = function(startIndex,endIndex)
	    startIndex = math.max(0,startIndex or 0);
		endIndex = math.min(length,endIndex or length);

		text = strsubutf8(text,0,startIndex)..strsubutf8(text,endIndex+1);
		class.needContentUpdate = true;
	end

	--@description Set the font object of the selected location range
	--@args GHI_DOC_Font, number, number
	--@returns
	class.SetFont = function(newFont,fromIndex,toIndex)
		local from,to = fromIndex or 0,toIndex or class.GetLength();
		assert(to <= class.GetLength(),"end index for SetFont is larger than block length")
		--print("obj SetFont from",from,"to",to)
		if font.IsSame(newFont) then
			return
		elseif from == 0 and to == class.GetLength() then
			class.SetCurrentFont(newFont)
			return
		elseif from == 0 then
			local effectedText = strsubutf8(text,0,to);
			text = strsubutf8(text,to+1);
			class.needContentUpdate = true;

			local effectedBlock = GHI_DOC_Block();
			effectedBlock.SetCurrentFont(newFont);
			effectedBlock.SetText(effectedText);
			return effectedBlock,class;
		elseif to == class.GetLength() then
	   		local effectedText = strsubutf8(text,from+1);
			text = strsubutf8(text,0,from);
			class.needContentUpdate = true;

			local effectedBlock = GHI_DOC_Block();
			effectedBlock.SetCurrentFont(newFont);
			effectedBlock.SetText(effectedText);
			return class,effectedBlock;
		else
			local effectedText = strsubutf8(text,from+1, to);
			local afterText = strsubutf8(text,to+1);
			text = strsubutf8(text,0,from);
			class.needContentUpdate = true;

			local effectedBlock = GHI_DOC_Block();
			effectedBlock.SetCurrentFont(newFont);
			effectedBlock.SetText(effectedText);

			local afterBlock = GHI_DOC_Block();
			afterBlock.SetCurrentFont(font);
			afterBlock.SetText(afterText);

			return class,effectedBlock,afterBlock;
		end
	end

	---------------------------------------------------------------------------
	-- Location functions
	---------------------------------------------------------------------------
	class.GetCoorAt = function(index)
		-- put input within boundries
		index = max(0,min(index,strlenutf8(text)));

		-- find the coordinate for the position

		label:SetText(strsubutf8(text,0,index));
		local x = label:GetWidth();
		local y = label:GetHeight();
		label:SetText(text);
		return x,y;
	end

	class.GetIndexAt = function(x,y)
		local fullWidth = class.GetPreferredWidth();
		local sampleEndPos = strlenutf8(text);
		local changer = sampleEndPos;
		while true do
			changer = floor(changer/2 +0.5);
			label:SetText(strsubutf8(text,0,sampleEndPos) or "");

			local sampleWidth = floor(label:GetWidth());
			--
			if sampleWidth == floor(x+0.5) then --match
				label:SetText(text);
				return sampleEndPos;
			elseif sampleWidth > x then
				sampleEndPos = sampleEndPos - changer;
			else
				sampleEndPos = sampleEndPos + changer;
			end
			if changer <= 1 then  --circa match
				label:SetText(text);
				return sampleEndPos;
			end
			if sampleEndPos > strlenutf8(text) then   --Requested coor larger than size
				label:SetText(text);
				return strlenutf8(text)
			end
		end


	end

	--@description Gets the length of the block
	--@args
	--@returns number
	class.GetLength = function()
		return length;
	end

	--@description Gets the font object
	--@args
	--@returns GHI_DOC_Font
	class.GetSelectedFont = function()
		return font;
	end

	--@description Gets the index of a location of interest.
	--@args string, number
	--@returns number
	class.GetIndexOfLocation = function(Type,index,backwards)
		return 0;
	end

	--@description Gets a raw text piece
	--@args number, number, boolean
	--@returns number
	class.GetRawText = function(_start,_end)
		return strsubutf8(text,_start+1,_end);
	end

	---------------------------------------------------------------------------
	-- Update functions
	---------------------------------------------------------------------------

	class.needContentUpdate = false;

	--@description Updates the content of the text block
	--@args table
	--@returns table
	class.UpdateContent = function(info)
		local oldText = label:GetText();
		info = info or {};
		label:SetText(text);

		-- cut off evt overflowing text and send it back up
		local overflowingText;
		if info.overflowObjects then -- at least one object is already overflowing
			table.insert(info.overflowObjects,class);
		elseif info.maxWidth then
			local x,y = class.GetCoorAt(class.GetLength());
			if x > info.maxWidth then
				local index = class.GetIndexAt(info.maxWidth,0);

				while (index > 0 and strsubutf8(text,index,index) ~= " ") do
					index = index - 1;
				end

				if (index > 0) then
					local overflowText = strsubutf8(text,index+1)
					text = strsubutf8(text,0,index);
					label:SetText(text);

					info.overflowObjects = {
						{
							text = overflowText,
							font = font,
						},
					};
				else
					info.overflowObjects = {};
					table.insert(info.overflowObjects,class);
				end
			end
		end

		frame:SetHeight(class.GetPreferredHeight());
		frame:SetWidth(class.GetPreferredWidth());

		if not(label:GetText() == oldText) then
			boldLabel1:SetText(text);
			boldLabel2:SetText(text);
			class.needLengthUpdate = true;
		end
		class.needContentUpdate = false;
		return info;
	end

	class.needLengthUpdate = false;

	--@description Updates the length info.
	--@args
	--@returns
	class.UpdateLength = function()
		length = strlenutf8(text or "");
		class.needLengthUpdate = false;
	end

	--@description Updates the index of the selection.
	--@args number
	--@returns
	class.UpdateSelected = function(index)
		selectedIndex = index;
		local marker = GHI_DOC_CursorMarker();
		if selectedIndex then
			marker.SetHeight(font.GetHeight());
			marker.SetColor(font.GetColor());
			local x,_ = class.GetCoorAt(selectedIndex);
			marker.SetAnchor(frame,x-1,0);

		else
			marker.Hide();
		end
	end

	--@description Updates the indexes of the highlight.
	--@args number, number
	--@returns
	class.UpdateHighlight = function(hStart,hEnd,backwards)
		if (hStart and hEnd) and not(hStart == hEnd) then
			highlight:SetHeight(font.GetHeight());
			local x1,_ = class.GetCoorAt(hStart);
			local x2,_ = class.GetCoorAt(hEnd);
			highlight:SetWidth(x2-x1);
			highlight:SetPoint("LEFT",x1,0);
			highlight:Show();
		else
			highlight:Hide();
		end
	end

	--@description Serializes the object
	--@args
	--@returns table
	class.Serialize = function(t)
		t = t or {};
		local last = t[#(t)];

		if last and last.type == "Block" and last.font.IsSame(font) then
			last.text = last.text..text;
		else
			table.insert(t,{
				text = text,
				font = font,
				type = "Block",
			});
		end
		return t;
	end

	return class;
end

