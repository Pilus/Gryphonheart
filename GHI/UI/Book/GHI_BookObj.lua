--===================================================
--
--				GHI_BookObj
--  			GHI_BookObj.lua
--
--	      Main class for book objects.
--    A book object should be implemented with the following:
--     - It should have the naming: GHI_BookObj_NameOfObject
--     - It should take two different constructor argument sets:
--        * height, width, arg1, arg2, arg3 etc
--        * bookObjClass, nil, arg1, arg2, arg3 etc
--     - It should implement .GetData, which returns arg1, arg2, arg3 etc
--     - It should implement .GetFrame
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_BookObj(...)
    local class = GHClass("GHI_BookObj");

    local height,width,objType = ...;

    class.GetData = function()
        -- This function should be overridden by the class inheriting this class.
        error((objType or "nil").." have not implemented .GetData");
    end

    class.GetFrame = function()
        -- This function should be overridden by the class inheriting this class.
        error((objType or "nil").." have not implemented .GetFrame");
    end

    class.InitializeFromTextCode = function(code)
        -- Format: \124T:width:height:GHI;TYPE;DATA1;DATA2\124t
        local data;
        width,height,objType,data = string,match(code,"^\124T:(%d):(%d):GHI;(%a*);(.*)\124t$");
        assert(height and width,"Could not initialize from code");

        if _G["GHI_BookObj_"..objType] then
            _G["GHI_BookObj_"..objType](class,nil,strsplit(";",data))
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

