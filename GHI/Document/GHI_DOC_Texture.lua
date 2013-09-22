--===================================================
--
--				GHI_DOC_Texture
--  			GHI_DOC_Texture.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_DOC_Texture(_path,_width,_height,_type)
	assert(type(_path)=="string" and type(_width)=="number" and type(_height)=="number","Useage Texture(parent,path,width,height)");
	if not(type(_types)=="table") then
		_types = {"center"}; --default
	end

	assert(textureTypes[_type]==true,"Unknown type "..(_type or "nil"));


	local class = GHClass("GHI_DOC_Texture",nil);

	local path,width,height,Type = _path,_width,_height,_type;


	class.GetWidth = function() return width; end;
	class.GetHeight = function() return height; end;

	class.GetTexType = function() return Type; end;

	class.IsTexType = function(str)
		assert(type(textureTypes[str])==true,"Unknown texture type lookup");
		return str == Type;
	end;

	class.ApplyTexture = function(frame)
		if not(frame.texture) then
			frame.texture = frame:CreateTexture(nil,"BACKGROUND")
		end
		frame.texture:SetTexture(path)
		frame.texture:SetAllPoints(frame)

	end

	return class;
end

