--===================================================
--
--				GHI_DOC_Font
--  			GHI_DOC_Font.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_DOC_Font(_fontPath,_height,_shadow,_color,_bold)
	local class = GHClass("GHI_DOC_Font");
   	local guid = GHI_GUID().MakeGUID();
	-- input validation
	assert(not(_fontPath) or type(_fontPath)=="string","FontPath must be a string.",_fontPath);
	assert(not(_height) or type(_height)=="number","Height must be a number.",_height);
	assert(not(_shadow) or type(_shadow)=="table","Shadow must be a tabe.",_shadow);
	assert(not(_color) or type(_color)=="table","Color must be a table.",_color);
	assert(not(_bold) or type(_bold)=="boolean","Outline must be a boolean.",_bold);

	-- detailed validation
	if _color then
		assert(type(_color.r)=="number" and type(_color.g) == "number" and type(_color.b)=="number" ,"Color must be specified as a table with color.r, color.g and color.b as value.",_color);
	end
	if _shadow then
		local s = "Shadow must be specified as a table with color.r, color.g, color.b and color.a as color value and shadow.x, shadow.y as offset value.";
		assert(type(_shadow.r)=="number" and type(_shadow.g) == "number" and type(_shadow.b)=="number" and type(_shadow.a)=="number",s,_shadow);
		assert(type(_shadow.x)=="number" and type(_shadow.y) == "number",s,color);
	end



	-- Setup
	local fontPath		= _fontPath 							or "Fonts\\MORPHEUS.TTF";
	local height		= _height 								or 15;
	local shadow 		= _shadow 								or {x=1,y=-1,r=0.4,g=0.4,b=0.4,a=0.75};
	local color  		= (not(_color) and {r=0,g=0,b=0,a=1}) 	or {r=_color.r,   g=_color.g,     b=_color.b,     a = _color.a or 1};
	local bold  		= _bold	                              	or false;


	------------------------------------------------------------------------------------------
	--     Functions
	------------------------------------------------------------------------------------------

	class.Matches = function(_fontPath,_height,_shadow,_color,_bold)
		local x_fontPath		= _fontPath 							or "Fonts\\MORPHEUS.TTF";
		if not(x_fontPath == fontPath) then return false end;
		local x_height		= _height 								or 15;
		if not(x_height == height) then return false end;
		local x_shadow 		= _shadow 								or {x=1,y=-1,r=0.4,g=0.4,b=0.4,a=0.75};
		if not(x_shadow.r == shadow.r and x_shadow.g == shadow.g and x_shadow.b == shadow.b and x_shadow.a == shadow.a) then return false end;
		local x_color  		= (not(_color) and {r=0,g=0,b=0,a=1}) 	or {r=_color.r,   g=_color.g,     b=_color.b,     a = _color.a or 1};
		if not(x_color.r == color.r and x_color.g == color.g and x_color.b == color.b and x_color.a == color.a) then return false end;
		local x_bold  		= _bold                              or false;
		if not(x_bold == bold) then return false end;
		return true;
	end

	-- _function for comparing with another font class
	class.IsSame = function(other)
		if other == class then return true; end
		local res = true;
		res = res and (class.GetType() 								== other.GetType());
		res = res and (class.GetHeight() 							== other.GetHeight());
		res = res and (class.GetPath()								== other.GetPath());
		for i=1,4 do res = res and (({class.GetShadowColor()})[i] 	== ({other.GetShadowColor()})[i]);end
		for i=1,2 do res = res and (({class.GetShadowOffset()})[i] 	== ({other.GetShadowOffset()})[i]); end
		for i=1,4 do res = res and (({class.GetColor()})[i] 		== ({other.GetColor()})[i]); end
		res = res and (class.IsBold() 								== other.IsBold());
		return res;
	end

	-- Get functions
	class.GetHeight 		= function() return height end
	class.GetPath 			= function() return fontPath end
	class.GetShadowColor    = function() return shadow.r,shadow.g,shadow.b,shadow.a; end
	class.GetShadowOffset 	= function() return shadow.x,shadow.y; end
	class.GetColor 			= function() return color.r,color.g,color.b,color.a; end
	class.IsBold 		= function() return bold; end

	class.GetFont 			= function() return fontPath,height; end

	class.Serialize = function()
		return {fontPath,height,shadow,color,outline,thickOutline,monochrome};
	end

	class.GetGuid = function()
		return guid;
	end

	class.ApplyFont = function(textObj,specialFunc)
		assert(type(textObj)=="table" and textObj.GetObjectType and (textObj:GetObjectType() == "EditBox" or textObj:GetObjectType() == "FontString"),"TextObj must be either an Editbox or a FontString widget object got "..textObj:GetObjectType() );

		textObj:SetFont(fontPath,height);

		textObj:SetShadowColor(shadow.r,shadow.g,shadow.b,shadow.a);
		textObj:SetShadowOffset(shadow.x,shadow.y);

		textObj:SetTextColor(color.r,color.g,color.b,color.a);

		if specialFunc then
			specialFunc("bold",bold);
		end
	end


	return class;
end