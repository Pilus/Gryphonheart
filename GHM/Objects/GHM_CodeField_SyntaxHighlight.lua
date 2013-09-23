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

local DEFAULT_SYNTAX_COLORS = {
	keyword = { 0.6, 0.6, 1.0 },
	comment = { 1.0, 0.6, 0.6 },
	string = { 0.6, 1.0, 0.6 },
	boolean = { 0.5, 0.9, 1.0 },
	number = { 0.8, 0.2, 0.8 },
};

GHM_SyntaxColorList = {}

function GHM_GetSyntaxCatagories()
	local t = {};
	for key, color in pairs(DEFAULT_SYNTAX_COLORS) do
		table.insert(t, tostring(key));
	end
	return t;
end

function GHM_GetSyntaxColor(cat, default)
	local t
	if not (cat) then
		t = DEFAULT_SYNTAX_COLORS[cat];
	elseif  default == true then
		t = DEFAULT_SYNTAX_COLORS[cat];
	else
		t = GHM_SyntaxColorList[cat];
	end	
	if t then
		return t[1] or 1, t[2] or 1, t[3] or 1;
	end	
	return 1, 1, 1;
end

function GHM_SetSyntaxColor(cat, r, g, b)
	local t = {r,g,b}
	GHM_SyntaxColorList[cat] = nil
	GHM_SyntaxColorList[cat] = t;
end

function GHM_LoadSyntaxColorList()
	for i ,cata in pairs(GHM_GetSyntaxCatagories()) do
		if GHI_MiscData.SyntaxColors[cata] then
			GHM_SetSyntaxColor(cata, unpack(GHI_MiscData.SyntaxColors[cata]))
		else
			GHM_SetSyntaxColor(cata, unpack(DEFAULT_SYNTAX_COLORS[cata]))
		end
	end
end

function GHM_ResetSyntaxColors()
	for i ,cata in pairs(GHM_GetSyntaxCatagories()) do
			GHM_SetSyntaxColor(cata, unpack(DEFAULT_SYNTAX_COLORS[cata]))
	end
end