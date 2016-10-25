--
--
--				GHM_CodeField_SyntaxHighlight
--  			GHM_CodeField_SyntaxHighlight.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local class

function GHM_CodeField_SyntaxHighlight()

	if class then return class end
	
	class = {}
	
	local miscAPI = GHI_MiscAPI().GetAPI()
	
	class.DEFAULT_SYNTAX_COLORS = {
		keyword = { 0.6, 0.6, 1.0 },
		comment = { 1.0, 0.6, 0.6 },
		string = { 0.6, 1.0, 0.6 },
		boolean = { 0.5, 0.9, 1.0 },
		number = { 0.8, 0.2, 0.8 },
	};

	class.GHM_SyntaxColorList = {}

	class.GHM_GetSyntaxCatagories = function()
		local t = {};
		for key, color in pairs(class.DEFAULT_SYNTAX_COLORS) do
			table.insert(t, tostring(key));
		end
		return t;
	end

	class.GHM_GetSyntaxColor = function(cat, default)
		local t
		if not (cat) then
			t = class.DEFAULT_SYNTAX_COLORS[cat];
		elseif  default == true then
			t = class.DEFAULT_SYNTAX_COLORS[cat];
		else
			t = class.GHM_SyntaxColorList[cat];
		end	
		if t then
			return t[1] or 1, t[2] or 1, t[3] or 1;
		end	
		return 1, 1, 1;
	end

	class.GHM_SetSyntaxColor = function(cat, r, g, b)
		local t = {r,g,b}
		class.GHM_SyntaxColorList[cat] = nil
		class.GHM_SyntaxColorList[cat] = t;
	end

	class.GHM_LoadSyntaxColorList = function()
		for i ,cata in pairs(class.GHM_GetSyntaxCatagories()) do
			if GHI_MiscData.SyntaxColor then
				class.GHM_SetSyntaxColor(cata, unpack(GHI_MiscData.SyntaxColor[cata]))
			else
				class.GHM_SetSyntaxColor(cata, unpack(class.DEFAULT_SYNTAX_COLORS[cata]))
			end
		end
	end

	class.GHM_GetSyntaxColorList = function()
		--- From _DevPad so I can figure out how it works.
		local syntaxColorTable = {};
		local booleans = { "true", "false", "nil" }
		local keywordColor = strconcat("|c"..miscAPI.RGBAPercToHex(class.GHM_GetSyntaxColor("keyword")))
		local commentColor = strconcat("|c"..miscAPI.RGBAPercToHex(class.GHM_GetSyntaxColor("comment")))
		local stringColor = strconcat("|c"..miscAPI.RGBAPercToHex(class.GHM_GetSyntaxColor("string")))
		local numberColor = strconcat("|c"..miscAPI.RGBAPercToHex(class.GHM_GetSyntaxColor("number")))
		local booleanColor = strconcat("|c"..miscAPI.RGBAPercToHex(class.GHM_GetSyntaxColor("boolean")))
		local T = IndentationLib.Tokens;

		local function colorCodeTokens(colorCode, token)
			for i,v in pairs(token)do
				syntaxColorTable[v] = colorCode;
			end
		end

		colorCodeTokens(keywordColor, {T.KEYWORD})
		colorCodeTokens(keywordColor, {T.CONCAT, T.VARARG, T.ASSIGNMENT, T.SIZE}); -- T.PERIOD, T.COMMA, T.SEMICOLON, T.COLON,
		colorCodeTokens(numberColor, {T.NUMBER});
		colorCodeTokens(stringColor, {T.STRING, T.STRING_LONG});
		colorCodeTokens(commentColor, {T.COMMENT_SHORT, T.COMMENT_LONG});
		colorCodeTokens(keywordColor, {T.ADD, T.SUBTRACT, T.MULTIPLY, T.DIVIDE, T.POWER, T.MODULUS});
		colorCodeTokens(keywordColor, {T.EQUALITY, T.NOTEQUAL, T.LT, T.LTE, T.GT, T.GTE});
		colorCodeTokens(booleanColor, booleans)

		return syntaxColorTable
	end

	class.GHM_ResetSyntaxColors = function()
		for i ,cata in pairs(class.GHM_GetSyntaxCatagories()) do
				class.GHM_SetSyntaxColor(cata, unpack(class.DEFAULT_SYNTAX_COLORS[cata]))
		end
	end
	
	return class
end