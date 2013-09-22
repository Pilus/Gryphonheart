


local SetPoint = function(P,x,y)
	P = P or {};
	local t = {
		x = x or P.x,
		y = y or P.y,
		data = P.data,
	};
	P.kdNode = t;
	return t;
end

local AllPointsWithinRange = function(P,cStart,cEnd) -- For debug purposes
	for i,v in pairs(P) do
		if v.x < cStart.x or v.y < cStart.y then
			return false;
		elseif v.x > cEnd.x or v.y > cEnd.y then
			return false;
		end
	end
	return true;
end

local sort = function(T,func) -- bubble sort
	local sorted = {};

	for _,v in pairs(T) do
		local inserted = false;
		for i=1,#(sorted) do
			if func(v,sorted[i]) then
				table.insert(sorted,i,v);
				inserted = true;
				break;
			end
		end
		if inserted == false then
			table.insert(sorted,v);
		end
	end

	return sorted;
end

local X,Y = 1,2;


function GHP_BuildKdTree(P,cStart,cEnd)
	assert(type(P)=="table" and #(P) > 0,"No points")

	-- if P contains only one point
	if (#(P) == 1) then
		return SetPoint(P[1]);
	end

	local m,mc;
	-- If the cell x size is larger than its y size
	if ((cEnd.x - cStart.x) >= (cEnd.y - cStart.y)) then
		P = sort(P,function(v1,v2)
			return v1.x <= v2.x;
		end)

		--[[ debug. Sorted correctly?
		for i=2,#(P) do
			assert(P[i-1].x <= P[i].x,string.format("Sorted incorrectly. %s <= %s",P[i-1].x ,P[i].x))
		end --]]

		m = cStart.x + (cEnd.x - cStart.x)/2;
		mc = X;
	else
		P = sort(P,function(v1,v2)
			return v1.y <= v2.y;
		end)
		m = cStart.y + (cEnd.y - cStart.y)/2;
		mc = Y;
	end



	if (mc == X and m < P[1].x) or (mc == Y and m < P[1].y) then -- if m is on the left of P[1]
		local n = SetPoint(P[1]);
		n.l = nil;
		table.remove(P,1);
		local cStart2,cEnd2;

		if mc == X then
			cStart2 = {x=P[1].x, 	y=cStart.y};
			cEnd2 	= {x=cEnd.x,	y=cEnd.y};
		else
			cStart2 = {x=cStart.x, 	y=P[1].y};
			cEnd2 	= {x=cEnd.x,	y=cEnd.y};
		end

		if #(P) > 0 then
			--assert(AllPointsWithinRange(P,cStart2,cEnd2),"Some points are not within range 1");
			n.r = GHP_BuildKdTree(P,cStart2,cEnd2);
			n.r.p = n;
		end

		n.mc = mc;
		return n;
	elseif (mc == X and m > P[#(P)].x) or (mc == Y and m > P[#(P)].y) then -- m is on the right of P[#(P)]
		local n = SetPoint(P[#(P)]);
		n.r = nil;
		table.remove(P,#(P));
		local cStart2,cEnd2;

		if mc == X then
			cStart2 = {x=cStart.x, 	y=cStart.y};
			cEnd2 	= {x=P[#(P)].x,	y=cEnd.y};
		else
			cStart2 = {x=cStart.x, 	y=cStart.y};
			cEnd2 	= {x=cEnd.x,	y=P[#(P)].y};
		end

		if #(P) > 0 then
			--[[ assert(AllPointsWithinRange(P,cStart2,cEnd2),string.format(
				"Some points are not within range 2. #P = %s. m=%s, comparing x: %s. x={%s,%s...%s} range (%s,%s) to (%s,%s)",
				#(P),m,tostring(mc==X),(P[1] or {}).x or "nil",(P[2] or {}).x or "nil",(P[3] or {}).x or "nil",
				cStart2.x,cStart2.y,cEnd2.x,cEnd2.y
			)); --]]
			n.l = GHP_BuildKdTree(P,cStart2,cEnd2);
			n.l.p = n;
		end

		n.mc = mc;
		return n;
	else

		--[[c=c+1;
		assert(c<=1002,string.format("ran too long. (%s,%s) and (%s,%s). (%s,%s) to (%s,%s). Sorted by x: %s."
		,P[1].x,P[1].y,P[2].x,P[2].y,
		cStart.x,cStart.y,cEnd.x,cEnd.y,tostring(mc == X)));   --]]

   		-- Let i be the index of the point closest to the median line on the right side
		local i;
		for j=1,#(P) do
			if (mc == X and P[j].x >= m) or (mc == Y and P[j].y >= m) then
				i = j;
				break;
			end
		end

		-- Let the node nothing
		local n = SetPoint(nil,cStart.x + (cEnd.x - cStart.x)/2,cStart.y + (cEnd.y - cStart.y)/2);

		-- Let left be points P[1 to i-1]
		local lP = {}
		for j=1,i-1 do
			table.insert(lP,P[j]);
		end

		-- Let the left cell be the area on the left of the median
		local cStart2,cEnd2;
		if mc == X then
			cStart2 = {x=cStart.x, 	y=cStart.y};
			cEnd2 	= {x=n.x,	y=cEnd.y};
		else
			cStart2 = {x=cStart.x, 	y=cStart.y};
			cEnd2 	= {x=cEnd.x,	y=n.y};
		end

		if #(lP) > 0 then
			--assert(AllPointsWithinRange(lP,cStart2,cEnd2),"Some points are not within range 3");
			n.l = GHP_BuildKdTree(lP,cStart2,cEnd2);
			n.l.p = n;
		end

		-- Let right be points P[i to #(P)]
		local rP = {};
		for j=i,#(P) do
			table.insert(rP,P[j]);
		end

		-- Let the right cell be the area on the right side of the median
		if mc == X then
			cStart2 = {x=n.x, 	y=cStart.y};
			cEnd2 	= {x=cEnd.x,	y=cEnd.y};
		else
			cStart2 = {x=cStart.x, 	y=n.y};
			cEnd2 	= {x=cEnd.x,	y=cEnd.y};
		end

		if #(rP) > 0 then
			--assert(AllPointsWithinRange(rP,cStart2,cEnd2),"Some points are not within range 4");
			n.r = GHP_BuildKdTree(rP,cStart2,cEnd2);
			n.r.p = n;
		end

		n.mc = mc;
		return n;
	end
end


function GHP_SearchKdTree(v,p,r,T)
	T = T or {};


	-- v contains a point
	if v.data then
		-- coordinates is within range
		local dx,dy = v.x-p.x, v.y-p.y;
		if math.sqrt(dx^2 + dy^2) <= r then
			table.insert(T,v);
		end
	end

	-- v is not a leaf
	if v.l or v.r then
		-- the median is parallel to the y axis
		if v.mc == X then
			if p.x - r < v.x and v.l then
				T = GHP_SearchKdTree(v.l,p,r,T)
			end
			if p.x + r >= v.x and v.r then
				T = GHP_SearchKdTree(v.r,p,r,T)
			end
		else
			if p.y - r < v.y and v.l then
				T = GHP_SearchKdTree(v.l,p,r,T)
			end
			if p.y + r >= v.y and v.r then
				T = GHP_SearchKdTree(v.r,p,r,T)
			end

		end
	end

	return T;
end

function GHP_InsertKdTree(v,p)

	-- the median is parallel to the y axis
	if v.mc == X then
		if p.x <= v.x then
			if v.l then
				GHP_InsertKdTree(v.l,p);
			else
				v.l = SetPoint(p,p.x,p.y);
				p.p = v;
			end
		else
			if v.r then
				GHP_InsertKdTree(v.r,p);
			else
				v.r = SetPoint(p,p.x,p.y);
				p.p = v;
			end
		end
	else
		if p.y <= v.y then
			if v.l then
				GHP_InsertKdTree(v.l,p);
			else
				v.l = SetPoint(p,p.x,p.y);
				p.p = v;
			end
		else
			if v.r then
				GHP_InsertKdTree(v.r,p);
			else
				v.r = SetPoint(p,p.x,p.y);
				p.p = v;
			end
		end
	end
end

function GHP_GetAllKdNodes(v,T)
	T = T or {};

	if v.data then
		table.insert(T,v);
	end

	if v.l then
		GHP_GetAllKdNodes(v.l,T)
	end

	if v.r then
		GHP_GetAllKdNodes(v.r,T)
	end

	return T;
end


function GHP_RemoveKdTree(p)
	local parent = p.p;
	local T = {};

	if p.l then
		GHP_GetAllKdNodes(p.l,T);
	end
	if p.r then
		GHP_GetAllKdNodes(p.r,T);
	end

	-- calculate the new cell
	if #(T) > 0 then
		local cStart,cEnd = {x=T[1].x,y=T[1].y},{x=T[1].x,y=T[1].y};
		for i=2,#(T) do
			cStart.x = math.min(cStart.x,T[i].x);
			cStart.y = math.min(cStart.y,T[i].y);
			cEnd.x = math.min(cEnd.x,T[i].x);
			cEnd.y = math.min(cEnd.y,T[i].y);
		end

		if parent.l == p then
			local subTree = GHP_BuildKdTree(T,cStart,cEnd);
			parent.l = subTree
			subTree.p = parent;
		else
			local subTree = GHP_BuildKdTree(T,cStart,cEnd);
			parent.r = subTree;
			subTree.p = parent;
		end
	else
		if parent.l == p then
			parent.l = nil;
		else
			parent.r = nil;
		end
	end

end



