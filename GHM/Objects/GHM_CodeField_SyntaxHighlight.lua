--===================================================
--
--				GHM_CodeField_SyntaxHighlight
--  			GHM_CodeField_SyntaxHighlight.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================


local keywords = { "and", "break", "do", "else", "elseif", "end", "for", "function", "if", "in", "local", "not", "or", "return", "then", "while" };
local booleans = { "true", "false", "nil" };

local DEFAULT_SYNTAX_COLORS = {
	keyword = { 0.6, 0.6, 1.0 },
	comment = { 1.0, 0.6, 0.6 },
	string = { 0.6, 1.0, 0.6 },
	boolean = { 0.5, 0.9, 1.0 },
	number = { 0.8, 0.2, 0.8 },
};

local syntaxColorList = {};


function GHM_GetSyntaxColorList()
 --- From _DevPad so I can figure out how it works.
 	local syntaxColorTable = {};
	local function RGBPercToHex(r,g,b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return strconcat(string.format("%02x%02x%02x", r*255, g*255, b*255))
	end
	local keywordColor = strconcat("|c00"..RGBPercToHex(GHM_GetSyntaxColor("keyword")))
	local commentColor = strconcat("|c00"..RGBPercToHex(GHM_GetSyntaxColor("comment")))
	local stringColor = strconcat("|c00"..RGBPercToHex(GHM_GetSyntaxColor("string")))
	local numberColor = strconcat("|c00"..RGBPercToHex(GHM_GetSyntaxColor("number")))
	local booleanColor = strconcat("|c00"..RGBPercToHex(GHM_GetSyntaxColor("boolean")))
	--print(keywordColor.."TestText")
	local T = IndentationLib.Tokens;
	local function color ( Code, token )
		for i,v in pairs(token)do
			syntaxColorTable[v] = Code;
		end
	end
	color(keywordColor, {T.KEYWORD})
	color(keywordColor, {T.CONCAT, T.VARARG, T.ASSIGNMENT, T.SIZE}); -- T.PERIOD, T.COMMA, T.SEMICOLON, T.COLON,
	color(numberColor, {T.NUMBER});
	color(stringColor, {T.STRING, T.STRING_LONG});
	color(commentColor, {T.COMMENT_SHORT, T.COMMENT_LONG});
	color(keywordColor, {T.ADD, T.SUBTRACT, T.MULTIPLY, T.DIVIDE, T.POWER, T.MODULUS});
	color(keywordColor, {T.EQUALITY, T.NOTEQUAL, T.LT, T.LTE, T.GT, T.GTE});
	color(booleanColor, booleans)
	return syntaxColorTable
end

for i, v in pairs(DEFAULT_SYNTAX_COLORS) do
	local t = {};
	for i2, v2 in pairs(v) do
		t[i2] = v2;
	end
	syntaxColorList[i] = t;
end


local time = 0;
local Start = function()
	time = GetTime();
end
local Check = function()
	if GetTime() - time > 2 then
		error("GHI. Syntax highlight caught in loop!")
	end
end
local lastText = "";

local ColorString = function(s, r, g, b)
	if not (s) or s == "" then return ""; end;
	if not (r) or not (g) or not (b) then return ""; end;
	return "|CFF" .. string.format("%.2x", r * 255) .. string.format("%.2x", g * 255) .. string.format("%.2x", b * 255) .. s .. "|r";
end

function GHM_GetSyntaxCatagories()
	local t = {};
	for i, _ in pairs(DEFAULT_SYNTAX_COLORS) do
		table.insert(t, i);
	end
	return t;
end

function GHM_GetSyntaxColor(catagory, default)
	local t = syntaxColorList[catagory];
	if not (t) or default then
		t = DEFAULT_SYNTAX_COLORS[catagory];
	end
	if t then
		return t[1] or 0, t[2] or 0, t[3] or 0;
	end
	return 0, 0, 0;
end

function GHM_SetSyntaxColor(catagory, r, g, b)
	syntaxColorList[catagory] = syntaxColorList[catagory] or {};
	syntaxColorList[catagory][1] = r;
	syntaxColorList[catagory][2] = g;
	syntaxColorList[catagory][3] = b;

	GHI_MiscData.SyntaxColor = syntaxColorList;
	GHM_CodeField_UpdateColors()
end

function GHM_DisableSyntaxColor(catagory, disabled)
	syntaxColorList[catagory] = syntaxColorList[catagory] or {};
	syntaxColorList[catagory].disabled = disabled;
	lastText = "";
	GHM_OptionsData.SyntaxColor = syntaxColorList;
	GHM_CodeField_UpdateColors()
end

function GHM_IsSyntaxColorDisabled(catagory)
	return (syntaxColorList[catagory] or {}).disabled;
end

local f = CreateFrame("Frame");
f:SetScript("OnEvent", function(...)
	if GHM_OptionsData and type(GHM_OptionsData.SyntaxColor) == "table" then
		for i, v in pairs(GHM_OptionsData.SyntaxColor) do
			syntaxColorList[i] = v;
		end
	end
end)
f:RegisterEvent("VARIABLES_LOADED")


GHM_ColorSyntax = function(s, catagory)
	if GHM_IsSyntaxColorDisabled(catagory) then
		return s;
	end
	return ColorString(s, GHM_GetSyntaxColor(catagory));
end


local ValidateKeyword = function(word)
	if tContains(keywords,word) then
		return true, "keyword";
	elseif tContains(booleans, word) then
		return true, "boolean";
	end
	return false;
end

local toF1 = '[a-zA-Z_]';

local states = {
	none = {
		['-'] = {
			next = 'c1',
		},
		[toF1] = {
			next = 'f1',
		},
		['['] = {
			next = 's3',
		},
		["'"] = {
			next = 's2',
			highlight = {
				offset = 0,
				type = "start",
				category = "string",
			},
		},
		['"'] = {
			next = 's1',
			highlight = {
				offset = 0,
				type = "start",
				category = "string",
			},
		},
		['[0-9]'] = {
			next = 'n1',
			highlight = {
				offset = 0,
				type = "start",
				category = "number",
			},
		},
		['else'] = {
			next = 'none',
		},
	},

	-- Comment
	c1 = {
		['-'] = {
			next = 'c2',
			highlight = {
				offset = -1,
				type = "start",
				category = "comment",
			},
		},
		[toF1] = {
			next = 'f1',
		},
		['['] = {
			next = 's3',
		},
		["'"] = {
			next = 's2',
			highlight = {
				offset = 0,
				type = "start",
				category = "string",
			},
		},
		['"'] = {
			next = 's1',
			highlight = {
				offset = 0,
				type = "start",
				category = "string",
			},
		},
		['[0-9]'] = {
			next = 'n1',
			highlight = {
				offset = 0,
				type = "start",
				category = "number",
			},
		},
		['else'] = {
			next = 'none',
		},
	},
	c2 = {
		['['] = {
			next = 'c4',
		},
		['else'] = {
			next = 'c3',
		},
	},
	c3 = {
		['\n'] = {
			next = 'none',
			highlight = {
				offset = 0,
				type = "end",
				category = "comment",
			},
		},
		['else'] = {
			next = 'c3',
		},
	},
	c4 = {
		['['] = {
			next = 'c5',
		},
		['else'] = {
			next = 'c3',
		},
	},
	c5 = {
		[']'] = {
			next = 'c6',
		},
		['else'] = {
			next = 'c5',
		},
	},
	c6 = {
		[']'] = {
			next = 'none',
			highlight = {
				offset = 1,
				type = "end",
				category = "comment",
			},
		},
		['else'] = {
			next = 'c5',
		},
	},

	-- String
	s1 = {
		['\n'] = {
			next = 'none',
			highlight = {
				offset = 1,
				type = "end",
				category = "string",
			},
		},
		['"'] = {
			next = 'none',
			highlight = {
				offset = 1,
				type = "end",
				category = "string",
			},
		},
		['else'] = {
			next = 's1',
		},
	},
	s2 = {
		['\n'] = {
			next = 'n1',
			highlight = {
				offset = 1,
				type = "end",
				category = "string",
			},
		},
		["'"] = {
			next = 'none',
			highlight = {
				offset = 1,
				type = "end",
				category = "string",
			},
		},
		['else'] = {
			next = 's2',
		},
	},
	s3 = {
		[toF1] = {
			next = 'f1',
		},
		['['] = {
			next = 's4',
			highlight = {
				offset = -1,
				type = "start",
				category = "string",
			},
		},
		["'"] = {
			next = 's2',
			highlight = {
				offset = 0,
				type = "start",
				category = "string",
			},
		},
		['"'] = {
			next = 's1',
			highlight = {
				offset = 0,
				type = "start",
				category = "string",
			},
		},
		['-'] = {
			next = 'c1',
		},
		['[0-9]'] = {
			next = 'n1',
			highlight = {
				offset = 0,
				type = "start",
				category = "number",
			},
		},
		['else'] = {
			next = 'none',
		},
	},
	s4 = {
		[']'] = {
			next = 's5',
		},
		['else'] = {
			next = 's4',
		},
	},
	s5 = {
		[']'] = {
			next = 'none',
			highlight = {
				offset = 1,
				type = "end",
				category = "string",
			},
		},
		['else'] = {
			next = 's4',
		},
	},

	-- Number
	n1 = {
		['[0-9\.]'] = {
			next = 'n1',
		},
		['-'] = {
			next = 'c1',
			highlight = {
				offset = 0,
				type = "end",
				category = "number",
			},
		},
		['['] = {
			next = 's3',
			highlight = {
				offset = 0,
				type = "end",
				category = "number",
			},
		},
		['else'] = {
			next = 'none',
			highlight = {
				offset = 0,
				type = "end",
				category = "number",
			},
		},
	},
	f1 = {
		['-'] = {
			next = 'c1',
		},
		['[A-Za-z]'] = {
			next = 'f2',
			highlight = {
				offset = -1,
				type = "start",
				category = "keyword",
			},
		},

		["'"] = {
			next = 's2',
			highlight = {
				offset = 0,
				type = "start",
				category = "string",
			},
		},
		['"'] = {
			next = 's1',
			highlight = {
				offset = 0,
				type = "start",
				category = "string",
			},
		},
		['['] = {
			next = 's3',
		},
		['else'] = {
			next = 'none',
		},
	},
	f2 = {

		['[A-Za-z0-9]'] = {
			next = 'f2',
		},
		['-'] = {
			next = 'c1',
			highlight = {
				offset = 0,
				type = "end",
				category = "keyword",
				validate = ValidateKeyword,
			},
		},
		['else'] = {
			next = 'none',
			highlight = {
				offset = 0,
				type = "end",
				category = "keyword",
				validate = ValidateKeyword,
			},
		},
	},
};

local HighlighKeywords;
local highlightBuffer = {};
local prevReturned = "";
function GHM_HighlightKeywords(text)
	-- check the buffer for fitting text

	local lastBufferFittingBefore,firstBufferFittingAfter;
	local textBefore,textMiddle,textAfter;
	local textBeforeColored,textAfterColored;

	-- Buffer comparison before
	local compareText = "";
	local i = 1;
	while (i <= #(highlightBuffer) and compareText == text:sub(0,compareText:len())) do
		local buffer = highlightBuffer[i];
		compareText = compareText..buffer.raw;
		i=i+1;
	end

	lastBufferFittingBefore = math.max(0,i - 2);
	--GHI_BUFFER_FITTING = {};
	textBefore,textBeforeColored = "","";
	if #(highlightBuffer) > 0 then
		for i = 1,lastBufferFittingBefore do
			--GHI_BUFFER_FITTING[i] = textBefore;
			local buffer = highlightBuffer[i];
			textBefore = textBefore..buffer.raw;
			textBeforeColored = textBeforeColored..buffer.colored;
		end
	end

	if (compareText == text:sub(0,compareText:len())) then -- Before contains the whole old buffer
		local textMiddle = text:sub(textBefore:len()+1);
		local done,textMiddleColored,middleBuffer = HighlighKeywords(textMiddle);

		local colored = textBeforeColored..textMiddleColored;

		local newBuffer = {};
		for i=1,lastBufferFittingBefore do
			table.insert(newBuffer,highlightBuffer[i]);
		end
		for i=1,#(middleBuffer) do -- insert new buffers
			table.insert(newBuffer,middleBuffer[i]);
		end
		highlightBuffer = newBuffer;
		return colored
	end

	-- Buffer comparison after
	local compareText = "";
	local bufferTextLen = text:len();
	local i = #(highlightBuffer);
	while (i > 0 and compareText == text:sub(bufferTextLen-compareText:len()+1)) do
		local buffer = highlightBuffer[i];
		compareText = buffer.raw..compareText;
		i=i-1;
	end
	--print("'",compareText,"' len:",compareText:len())
	--print("'",text:sub(bufferTextLen-compareText:len()+1),"' len:",text:sub(bufferTextLen-compareText:len()+1):len())
	--print(i > 0 ,'and', compareText == text:sub(bufferTextLen-compareText:len()+1))
	firstBufferFittingAfter = math.min(#(highlightBuffer)+1,i + 2);
	textAfter,textAfterColored = "","";
	if #(highlightBuffer) > 0 then
		for i = firstBufferFittingAfter,#(highlightBuffer) do
			local buffer = highlightBuffer[i];
			textAfter = textAfter..buffer.raw;
			textAfterColored = textAfterColored..buffer.colored;
		end
	end

	--print(0,"-",lastBufferFittingBefore,"&",firstBufferFittingAfter,"-",#(highlightBuffer))
	--assert(firstBufferFittingAfter >= lastBufferFittingBefore,"err",text)

	local textMiddle = text:sub(textBefore:len()+1,text:len()-textAfter:len())

	local done,textMiddleColored,middleBuffer = HighlighKeywords(textMiddle);

	local colored = textBeforeColored..textMiddleColored..textAfterColored;
	--print("Middle:")
	--print(remainingText);
	--print("end middle");
	--print("Middle:",#(middleBuffer),"chunks. Len:",textMiddle:len())

	local newBuffer = {};
	for i=1,lastBufferFittingBefore do
		table.insert(newBuffer,highlightBuffer[i]);
	end            --print("A:",#(newBuffer))
	for i=1,#(middleBuffer) do -- insert new buffers
		table.insert(newBuffer,middleBuffer[i]);
	end  			--print("B:",#(newBuffer))
	for i=firstBufferFittingAfter,#(highlightBuffer) do
		table.insert(newBuffer,highlightBuffer[i]);
	end      --print("C:",#(newBuffer)," -> ",firstBufferFittingAfter)
	highlightBuffer = newBuffer;
	prevReturned = colored;
	return colored;
end


HighlighKeywords = function(text)
	assert(type(text)=="string","HighlighKeywords(string)")
	local highlights = {};
	local currentHighlight;
	local state = 'none';

	local chars = {};
	for i=1,string.len(text) do
		chars[i] = string.sub(text,i,i);
	end
	--print(text);
	for i=1,#(chars) do
		local char = chars[i];
		--print(state);
		local info = (states[state][char]);

		if not(info) then
			for pattern,pInfo in pairs(states[state]) do
				if string.len(pattern) > 1 and not(pattern == "else") then
					if string.match(char,pattern) then
						info = pInfo;   --print(char,"matches",pattern)
					else
						--print(char,"no match",pattern)
					end
				end
			end
		end

		if not(info) then
			info = states[state]["else"];
		end

		if (info.highlight) then
			local hl = info.highlight;
			assert((currentHighlight and hl.type == "end" and hl.category == currentHighlight.category) or hl.type == "start","Incorrect type match",state,char)

			if hl.type == "start" then
				currentHighlight = {
					hstart = i+hl.offset,
					category = hl.category,
				}
			elseif hl.type == "end" then
				currentHighlight.hend = i+hl.offset;
				currentHighlight.validate = hl.validate;
				table.insert(highlights,currentHighlight);
				currentHighlight = nil;
			end
		end

		state = info.next;
	end

	--print(state,currentHighlight and currentHighlight.category);
	local done = true;
	if currentHighlight then
		done = false;
		currentHighlight.hend = #(chars)+1;
		if state == "f2" then
			currentHighlight.validate = ValidateKeyword;
		end
		table.insert(highlights,currentHighlight);
	end

	local coloredText = "";
	local chunks = {};
	local currentChunk = "";
	local currentChunkRaw = "";
	local prevIndex = 0;

	for _,highlight in pairs(highlights) do
		currentChunk = currentChunk..strsubutf8(text,prevIndex,highlight.hstart-1);
		currentChunkRaw = currentChunkRaw..strsubutf8(text,prevIndex,highlight.hstart-1);
		if highlight.validate then
			local text2 = strsubutf8(text,highlight.hstart,highlight.hend-1);
			local isHighlight,category = highlight.validate(text2)
			if isHighlight then
				currentChunk = currentChunk..GHM_ColorSyntax(text2,category);
				currentChunkRaw = currentChunkRaw..text2;
			else
				currentChunk = currentChunk..text2;
				currentChunkRaw = currentChunkRaw..text2
			end
			prevIndex = highlight.hend;
		else

			currentChunk = currentChunk..GHM_ColorSyntax(strsubutf8(text,highlight.hstart,highlight.hend-1),highlight.category);
			currentChunkRaw = currentChunkRaw..strsubutf8(text,highlight.hstart,highlight.hend-1);
			prevIndex = highlight.hend;
		end

		-- Save the chunk
		if (currentChunkRaw:len() > 128) then
			table.insert(chunks,{
				colored = currentChunk,
				raw = currentChunkRaw,
			});
			coloredText = coloredText..currentChunk;
			currentChunk = "";
			currentChunkRaw = "";
		end

	end

	currentChunk = currentChunk..strsubutf8(text,prevIndex);
	currentChunkRaw = currentChunkRaw..strsubutf8(text,prevIndex);
	coloredText = coloredText..currentChunk;
	if currentChunkRaw:len() > 0 then
		table.insert(chunks,{
			colored = currentChunk,
			raw = currentChunkRaw,
		});
	end

	return done,coloredText,chunks;
end


