--===================================================
--
--				GHI_BookObj
--				GHI_BookObj.lua
--
--	Main class for book objects.
--	A book object should be implemented with the following:
--		- It should have the naming: GHI_BookObj_NameOfObject
--		- It should take two different constructor argument sets:
--			* height, width, arg1, arg2, arg3 etc
--			* bookObjClass, nil, arg1, arg2, arg3 etc
--		- It should implement .GetData, which returns arg1, arg2, arg3 etc
--		- It should implement .GetFrame
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local class
function GHI_BookObjGenerator()
	if class then
		return class;
	end
	class = GHClass("GHI_BookObjGenerator");

	local deserializer = GHI_HtmlDeserializer();

	class.FromTextCode = function(code)
		GHCheck("GHI_BookObj.InitializeFromTextCode",{"string"},{code})
		-- Format: \124T:width:height:InnerHtml\124t
		local innerHtml;
		width,height,innerHtml = string.match(code,"^\124T:(%d):(%d):(.*)\124t$");
		assert(height and width and innerHtml,"Could not initialize from code. Object contains no size information.");

		local data = deserializer.HtmlToTable(innerHtml);

		if data[1] and _G["GHI_BookObj_"..data[1].tag] then
			return _G["GHI_BookObj_"..data[1].tag](data)
		else
			return nil;
		end
	end

	class.GetSize = function()
		return width,height;
	end

	class.GenerateCode = function()
		return string.format("\124T:%d:%d:GHI;%s;%s\124t", width, height, objType, string.join(";",class.GetData()));
	end

	return class;
end

