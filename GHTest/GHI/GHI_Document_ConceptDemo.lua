-- This is a concept test and demo

local OPEN_TAG = "\124TGH_O_%d:1:1|t";
local CLOSE_TAG = "\124TGH_C_%d:1:1|t";
local NEWLINE_TAG = "\124HGH_N\124h\n\124h";
local CURSOR_TAG = "\124TGH_CU:1:1|t";
local HIGHLIGHT_OPEN_TAG = "\124TGH_HO:1:1|t";
local HIGHLIGHT_CLOSED_TAG = "\124TGH_HC:1:1|t";


--[[
-- form http://lua-users.org/wiki/LuaXml
local function parseargs(s)
  local arg = {}
  string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
    arg[w] = a
  end)
  return arg
end

local function collect(s)
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, {label=label, xarg=parseargs(xarg), empty=1})
    elseif c == "" then   -- start tag
      top = {label=label, xarg=parseargs(xarg)}
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        error("nothing to close with "..label)
      end
      if toclose.label ~= label then
        error("trying to close "..toclose.label.." with "..label)
      end
      table.insert(top, toclose)
    end
    i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  if #stack > 1 then
    error("unclosed "..stack[#stack].label)
  end
  return stack[1]
end                  --]]

local OTag = function(i) return string.format(OPEN_TAG, i); end
local CTag = function(i) return string.format(CLOSE_TAG, i); end

local revgsub = function(text, pattern, func)
	local res = {};
	text = text.gsub(text, pattern, function(...) table.insert(res, { ... }); return "øRES" .. #(res) .. "ø"; end);

	local i = #(res);
	while i > 0 do
		text = gsub(text, "(øRES" .. i .. "ø)", function() return func(unpack(res[i])); end)
		i = i - 1;
	end

	return text;
end

local GenrateLayout = function(self)
	local text = self:GetText();

	-- 1) Replace all virtual newline tags (GH_N). with ‘ ‘
	text = gsub(text, "|HGH_N_%s|h", " ");

	-- 2) Remove redundant tags. Diff: A tag sequence, of the same tag, that is on the form OOCC.
	local tags = {};
	text = gsub(text, "|HGH_(%u)_(%d*)|h", function(Type, id)
		if Type == "O" then
			if tags[id] == true then
				return "";
			end
			tags[id] = true;
			return OTag(id);
		elseif Type == "C" then
			tags[id] = false;
			return CTag(id);
		end
	end)
	-- all values in tags that are true are now missing. Insert those at the cursor position
	for i, v in pairs(tags) do
		if v == true then
			text = gsub(text, "|HGH_C|h", "|HGH_C|h" .. CTag(i));
		end
	end

	tags = {};
	text = revgsub(text, "|HGH_(%u)_(%d*)|h", function(Type, id)
		if Type == "C" then
			if tags[id] == true then
				return "";
			end
			tags[id] = true;
			return CTag(id);
		elseif Type == "O" then
			tags[id] = false;
			return OTag(id);
		end
	end)

	-- 3) Split the text into a table where each index in the table starts with an opening or closing tag. Ignore cursor or highlight tags.
	local layoutTable = {};
	local tags = {};
	gsub(text, "([^(|HGH]*)|HGH_([OC])_(%d*)|h", function(t, tagType, id)
		if (t ~= "") then
			local tagsShort = {};
			for i, v in pairs(tags) do
				if v == true then
					table.insert(tagsShort, i);
				end
			end
			table.insert(layoutTable, {
				text = t,
				tags = tagsShort,
			});
		end
		tags[id] = (tagType == "O");
	end);

	GH_TEXT = layoutTable;
end




--local MiscAPI = GHI_MiscAPI().GetAPI();
--local strfindutf8 = MiscAPI.strfindutf8;
--local strsubutf8 = MiscAPI.strsubutf8;

local GetTextLength = function(textBox)
	return strlenutf8(textBox:GetText());
end

local expectedTextChanged = 0;
local UpdateHighlightedTextInfo = function(textBox)
	print("UpdateHighlightInfo", textBox:GetCursorPosition())

	local curPos = textBox:GetCursorPosition(); print("save pos", curPos)
	local len = textBox:GetTextLength();
	local text = textBox:GetText();

	local HIGHLIGHT_TEST_STRING = "øøøHIGHLIGHTøøø";
	textBox:Insert(HIGHLIGHT_TEST_STRING); print("inserted")
	expectedTextChanged = expectedTextChanged + 1;

	textBox.highlightAnalysisFunc = function()
		local isHighlighted, highlightStart, highlightEnd;

		print(textBox:GetTextLength(), " < ", strlenutf8(HIGHLIGHT_TEST_STRING) + len);
		print(textBox:GetText())
		if textBox:GetTextLength() < strlenutf8(HIGHLIGHT_TEST_STRING) + len then -- there is a highlight if the text box text have not grown with the length of the test string.

			local hLightLength = strlenutf8(HIGHLIGHT_TEST_STRING) + len - textBox:GetTextLength();

			local highlightStartUTF8 = strfindutf8(textBox:GetText(), HIGHLIGHT_TEST_STRING);
			if highlightStartUTF8 then

				local highlightEndUTF8 = highlightStartUTF8 + hLightLength;

				-- convert the highlight positions from utf8 to normal
				highlightStart = strlen(strsubutf8(text, 0, highlightStartUTF8));
				highlightEnd = strlen(strsubutf8(text, 0, highlightEndUTF8));
				isHighlighted = true;
			end
		else
			isHighlighted = false;
		end

		-- Reset everything
		textBox:SetText(text);
		expectedTextChanged = expectedTextChanged + 1;
		textBox:SetCursorPosition(curPos);
		if isHighlighted then
			textBox:HighlightText(highlightStart, highlightEnd);
		end
		textBox.highlightInfo = { isHighlighted, highlightStart, highlightEnd };
	end

	return
end

local SaveTextBoxInfo = function(textBox)
	local text = textBox:GetText();
	textBox.length = textBox:GetTextLength();
	textBox.cursorPos = textBox:GetUTF8CursorPosition();
	textBox:Insert("");
--if strlen(textBox:GetText()) < textBox.length then
end

local cursorChangeTime = 0;
local cursorChangeValue = nil;
local OnCursorChanged = function(textBox)
	if GetTime() - cursorChangeTime > 0.05 and cursorChangeValue ~= textBox:GetUTF8CursorPosition() then
		cursorChangeTime = GetTime();
		cursorChangeValue = textBox:GetUTF8CursorPosition();
		UpdateHighlightedTextInfo(textBox);
	end
end

local OnTextChanged = function(textBox, autoUpdate)
	if expectedTextChanged > 0 then
		if expectedTextChanged == 1 then
			if textBox.highlightAnalysisFunc then
				textBox.highlightAnalysisFunc();
				textBox.highlightAnalysisFunc = nil;
			end;
		end
		expectedTextChanged = expectedTextChanged - 1;
		return
	end

	if not (autoUpdate) then
		-- it is now safe to assume that there is no highlight
		textBox.highlightInfo = { false };
	end
end

local updateTime = 0;
local OnUpdate = function(textBox)
	if (GetTime() - updateTime) > 0.4 then
		updateTime = GetTime();
		OnTextChanged(textBox, true);
	end
end

function GHI_DocumentDemo()
	local mainFrame = GHM_NewFrame(CreateFrame("frame"), {
		onOk = function(self) end,
		{
			{
				{
					type = "Dummy",
					height = 600,
					width = 380,
					align = "c",
					label = "text"
				},
			},
			{
				{
					type = "Text",
					fontSize = 11,
					width = 380,
					text = "",
					color = "white",
					align = "l",
					label = "layout"
				},
			}
		},
		title = "Document",
		name = "GHI_DocumentDemoFrame",
		theme = "BlankTheme",
		width = 400,
		useWindow = true,
	});

	local textFrame = GHI_MarkupEditBox(nil, mainFrame.GetLabelFrame("text"));
	textFrame:SetAllPoints();
	textFrame:SetFont("Fonts\\FRIZQT__.TTF", 15, "MONOCHROME")
	textFrame:SetMultiLine(true);
	textFrame:SetAutoFocus(false)
	textFrame:SetMaxLetters(10000);
	textFrame:SetText("This is a testing text ÆÆÆ without any tags. " .. OTag(1) .. "this part " .. OTag(2) .. CTag(2) .. "of the text got a tag. Then there is some special text " .. OTag(3) .. "here" .. CTag(3) .. " and then back to normal" .. CTag(1) .. " No tag.")

	--[[
	--local textFrame = CreateFrame("EditBox",nil,mainFrame.GetLabelFrame("text"));
	--textFrame.GetTextLength = GetTextLength;
	--textFrame.GetHighlightedText = GetHighlightedText;
	--textFrame:SetAllPoints();
	--textFrame:SetMultiLine(true);
	--textFrame:SetFont("Fonts\\FRIZQT__.TTF",15,"MONOCHROME")
	--textFrame:SetScript("OnEscapePressed",function(self) self:ClearFocus(); end)
	--local layoutFrame = mainFrame.GetLabelFrame("layout");

	--textFrame:SetMaxLetters(10000);
	--textFrame:SetScript("OnTextChanged",OnTextChanged)
	--textFrame:SetScript("OnCursorChanged",OnCursorChanged)
	--textFrame:SetScript("OnUpdate",OnUpdate);

	--textFrame:SetText(OTag(1).."This text is normal. "..OTag(2).." Special. "..OTag(2).."But this text is special. "..CTag(2).." inc this. "..CTag(2).."Yet, this text is normal."..OTag(3).." Special text"..CTag(3).." Normal text"..CTag(1).." ");
	--textFrame:SetText("This is a testing text ÆÆÆ without any tags. "..OTag(1).."tag"..CTag(1).." No tag.")

	textFrame:SetAutoFocus(false)
	textFrame:Show();
	mainFrame.textFrame = textFrame;         --]]

	mainFrame:Show();

	GH_TEXT_F = textFrame;
end

--[[
local function ForAllCharsWithoutCharTag(self,text,func)
	local charPattern = string.format(CHAR_TAG,"%d+","%d+","%d+");

	-- first char
	local s = gsub(text,"^([^|])",function(char)
		-- get first used tag
		local firstCharTag = string.match(text,charPattern);

		-- if none, then get the first chartag of the next paragraph
		-- if still none then use the standard
		--print("no tags")
		return func(firstCharTag,char);
	end)
	s = gsub(s,"("..charPattern..")(.)([^|]+)",function(lastTag,lastChar,chars)
		local charsWithTags = gsub(chars,".",function(char)
			return func(lastTag,char);
		end);        --  print("chars after convert",charsWithTags)
		return lastTag..lastChar..charsWithTags;
	end);
	return s;
end

-- UnitTest
local i = 1;
local expected = {"l","b","a","p","d"};
local expectedTags = {"|TGH_C_2:24:54|t","|TGH_C_2:2:4|t","|TGH_C_2:2:4|t","|TGH_C_2:2:4|t","|TGH_C_2:24:54|t"}
local testS = ForAllCharsWithoutCharTag(nil,"|TGH_C_2:24:54|tH|TGH_C_2:24:54|tel|TGH_C_2:2:4|txbap|TGH_C_2:24:54|tcd",
function(prevTag,char)
	assert(char == expected[i],"Unexpected char. ",char,expected[i],i);
	assert(prevTag == expectedTags[i],"Unexpected tag.",prevTag,expectedTags[i],i);
	i = i +1;
	return "z";
end
);
assert(i==6,"ForAllCharsWithoutCharTag not executed correctly",i)
assert(testS == "|TGH_C_2:24:54|tH|TGH_C_2:24:54|tez|TGH_C_2:2:4|txzzz|TGH_C_2:24:54|tcz","Incorrect string",testS)




local function OnTextChanged(self)
	if self.updating == true or self.lastText ==  self:GetText() then return end
	self.updating = true;

	local newText = ForAllCharsWithoutCharTag(self,self:GetText(),function(tag,char) --  print("char",char,"tag",tag)
		return tag..char;
	end)
	self:SetText(newText);
	-- print("new text",newText)
	-- todo save the font of the first char (of each paragraph)

	self.updating = false;
	self.lastText = self:GetText();
end

local function SetUpDefaultText(self)
	self.Fonts = {size = 15,path = "Fonts\\FRIZQT__.TTF"};
	self:SetFont("Fonts\\FRIZQT__.TTF",15);
	self:SetText("|TGH_C_2:24:10|tH");
end

       --]]

