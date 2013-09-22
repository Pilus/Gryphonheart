--===================================================
--
--				GHI_DOC_PageLayout
--  			GHI_DOC_PageLayout.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_DOC_PageLayout()
	local class = GHClass("GHI_DOC_PageLayout");
	local width,height;
	local areas = {linked={},floating={},};

	class.SetSize = function(x,y)
		width = x;
		height = y;
	end

	class.AddArea = function(areaType,width,height,xOff,yOff)
		if areaType == "linked" then
			table.insert(areas.linked,{width,height,xOff,yOff});
		elseif areaType == "floating" then
			table.insert(areas.floating,{width,height,xOff,yOff});
		else
			error("Unknown area type",areaType);
		end

	end

	class.ApplyAreas = function(page)
		assert(page and page.IsClass and page.IsClass("GHI_DOC_Page"),"Can only apply page layout to a page",page.GetType and page.GetType())
		assert(page.GetNumAreas() == 0,"Page is not empty");

		page.SetSize(width,height);

		for areaType,t in pairs(areas) do
			for areaType,list in pairs(t) do
				local width,height,xOff,yOff = unpack(list);

				local area = GHI_DOC_Area(width,height);
				page.InsertArea(area,xOff,yOff,areaType);

			end
		end


	end

	class.Serialize = function()
		-- todo: serialize the info
		return {};
	end


	return class;
end

