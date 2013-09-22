--===================================================
--
--				GHI_TextPositionCalculator
--  			GHI_TextPositionCalculator.lua
--
--	          Calculates the position of an object
--			inside a simpleHtml text block
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local i = 1;
function GHI_TextPositionCalculator(width, font, n, h1Font, h1, h2Font, h2)
    GHCheck("GHI_TextPositionCalculator",{"number","string","number","string","number","string","number"},{width, font, n, h1Font, h1, h2Font, h2});
	local class = GHClass("GHI_TextPositionCalculator");

	local frame = CreateFrame("ScrollFrame","GHI_TextPositionCalculatorFrame"..i,nil,"GHI_TextPositionCalculatorTemplate");
	i = i + 1;
	local page = _G[frame:GetName().."ChildPage"];
	page:SetHeight(0.0001);
	page:SetWidth(width);

	frame:SetPoint("CENTER")

	page:SetFont(font, n)
	page:SetFont("H1",h1Font,h1)
	page:SetFont("H2",h2Font,h2)


	local label = frame:CreateFontString();
	label:SetFont(font,n);


    local FindLast;
    FindLast = function(str, pattern, lastV)
        local v = strfind(str, pattern, (lastV or -1)+1);
        if v then
            return FindLast(str, pattern, v);
        end
        return lastV;
    end

    local GetLastActiveFormatTag = function(text)
        local lastTag = "P";

        if FindLast(text,"<h1>") > FindLast(text,"</h1>") then
            lastTag = "h1";
        elseif FindLast(text,"<h2>") > FindLast(text,"</h2>") then
            lastTag = "h2";
        end

        return lastTag;
	end

	local Round = function(n)
		return tonumber(string.format("%.3f",n));
	end

	local GenerateFiller = function(len)
		return string.format("|TInterface\\Icons\\INV_Misc_Coin_01:16:%d|t",len);
	end

	local busy = false;
	local queue = {};

	GHI_Timer(function()
		if #(queue) > 0 and busy == false then
		    class.CalculatePos(unpack(queue[#(queue)]));
			table.remove(queue,#(queue));
		end
	end,0.01);

	class.CalculatePos = function(text,h,w,resultFunc)
		if busy == true then
			table.insert(queue,1,{text,resultFunc});
			return
		end

		busy = true;

		local newObj = "|T:"..h..":"..w.."|t";
		local lastTag = GetLastActiveFormatTag(text);
        page:SetText(text..newObj.."</"..lastTag.."></BODY></HTML>");

        frame:Show();
        frame:UpdateScrollChildRect();

        -- Determine the coordinates
        local x, y;
        local CalcX;
        GHI_Timer(function()
			-- Determine Y
            y = frame:GetVerticalScrollRange();
			-- Prepare X for first calculation
            CalcX();
        end,0.0001,true);

		CalcX = function(modifier)
			-- Setup X calculation by using ' s to find the space left on the line
            modifier = modifier or 0;

			page:SetText(text..newObj.." "..strrep("'",modifier).."</"..lastTag.."></BODY></HTML>")
			frame:UpdateScrollChildRect();

			-- Call a delayed analysis of the result to happen in the next frame
            GHI_Timer(function()

                if frame:GetVerticalScrollRange() <= y then -- no change = The line is not yet full
					-- Run the calculations again with one more '
					CalcX(modifier + 1);
                else -- The line is full.
                	-- Get result
					label:SetText(" "..strrep("'",modifier-1))
					x = width - label:GetWidth();
					frame:Hide();
					resultFunc(Round(x),Round(y));
                end
            end,0.0001,true);

        end

	end

	return class;
end
