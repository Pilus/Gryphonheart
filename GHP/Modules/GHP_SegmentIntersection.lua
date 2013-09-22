--===================================================
--
--				GHP_SegmentIntersection
--  			GHP_SegmentIntersection.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local IsCoordinate = function(C)
	return type(C) == "table" and type(C.x) == "number" and type(C.y) == "number";
end


function GetLineSegmentIntersection(P1,P2,P3,P4)
	-- input validation
	if not(IsCoordinate(P1) and IsCoordinate(P2) and IsCoordinate(P3) and IsCoordinate(P4)) then
		error("Incorrect input. Usage: GetLineSegmentIntersection(point,point,point,point)");
	end

	-- Same world validation
	if not(P1.world == P2.world and P2.world == P3.world and P3.world == P4.world) then
		return false,1;
	end

	-- Intersection validation X
	local xLowA,xHighA = math.min(P1.x,P2.x),math.max(P1.x,P2.x);
	local xLowB,xHighB = math.min(P3.x,P4.x),math.max(P3.x,P4.x);
	if xHighA < xLowB or xHighB < xLowA then
		return false,2; -- No intersection
	end
	
	-- Intersection validation Y
	local yLowA,yHighA = math.min(P1.y,P2.y),math.max(P1.y,P2.y);
	local yLowB,yHighB = math.min(P3.y,P4.y),math.max(P3.y,P4.y);
	if yHighA < yLowB or yHighB < yLowA then
		return false,3; -- No intersection
	end



	--Let d be the numerator of the alpha equation. ⊲See formula 2
	local d = (P3.y - P4.y)*(P1.x - P3.x) - (P3.x - P4.x)*(P1.y - P3.y);
	--Let e be the beta numerator
	local e = (P2.x - P1.x)*(P1.y - P3.y) - (P2.y - P1.y)*(P1.x - P3.x);
	--Let f be the common denominator
	local f = (P2.y - P1.y)*(P3.x - P4.x) - (P2.x - P1.x)*(P3.y - P4.y);

	-- Intersection validation alpha and beta
	if f == 0 then  -- parallel
		return false,4;
	elseif f > 0 then
		if d < 0 or d > f then
			return false,5;
		end
		if e < 0 or e > f then
			return false,6; --string.format("6 f: %s e: %s = (%s*%s) - (%s*%s)",f,e,(P2.y - P1.y),(P1.x - P3.x) , (P2.x - P1.x),(P1.y - P3.y));
		end
	else
		if d > 0 or d < f then
			return false,7;
		end
		if e > 0 or e < f then
			return false,8;
		end
	end

	-- Calculate intersection point
	local numx = d * (P2.x - P1.x)
	local offsetx;

	if (numx >= 0 and f >= 0) or (numx <= 0 and f <= 0) then -- numx have same sign as f
		offsetx = f / 2
	else
		offsetx = - f / 2
	end

	local numy = d * (P2.y - P1.y)
	local offsety;

	if (numy >= 0 and f >= 0) or (numy <= 0 and f <= 0) then -- numy have same sign as f
		offsety = f / 2
	else
		offsety = - f / 2
	end

	local x = P1.x + (numx + offsetx) / f;
	local y = P1.y + (numy + offsety) / f;
	local pos = {
		x = x,
		y = y,
		world = P1.world,
	}

	-- calculate alpha and beta value
	local alpha = d/f;
	local beta = e/f;

	local dir = -1;
	if f > 0 then
		dir = 1;
	end

	return true,pos,alpha,beta,dir;
end

