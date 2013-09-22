--===================================================
--
--				GHI_DOC_FontList
--  			GHI_DOC_FontList.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_DOC_FontList()
	if class then
		return class;
	end

	class = GHClass("GHI_DOC_FontList");
	local standardFont = GHI_DOC_Font();
	local fonts = {standardFont};

	class.GetStandardFont = function()
		return standardFont;
	end

	class.GetFont = function(...) -- fontPath,height,shadow,color,outline,thickOutline,monochrome
		for _,font in pairs(fonts) do
			if font.Matches(...) then
				return font;
			end
		end
		local font = GHI_DOC_Font(...);
		table.insert(fonts,font);
		return font;
	end

	return class;
end

