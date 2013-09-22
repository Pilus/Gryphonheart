describe("GHP_SegmentIntersection",function()
	require("StandardMock");
	require("GHP_KdTree");

	it("should implement GHP_BuildKdTree as a function",function()
		assert.are.same("function",type(GHP_BuildKdTree));
	end);

	it("should handle a leaf",function()

		local P = {
			{x=4,y=8,data={"test"}},
		};
		local c1 = {x=2,y=1};
		local c2 = {x=12,y=21};

		local T = GHP_BuildKdTree(P,c1,c2)
		assert.are.same("table",type(T));
		assert.are.same(P[1].data,T.data);
		assert.are.same(P[1].x,T.x);
		assert.are.same(P[1].y,T.y);
		assert.are.same(nil,T.p);
	end);

	local Clone = function(v)
		if type(v) == "table" then
			local t = {};
			for i,vv in pairs(v) do
				t[i] = vv;
			end
			return t;
		end
		return v;
	end

	local IsSamePoint = function(p1,p2)
		if not(type(p1) == "table") or not(type(p2) == "table") then
			return string.format("Error 1: one point not a table. %s,%s",type(p1),type(p2));
		end
		if not(p1.x == p2.x) then
			return string.format("Error 2: x not matching. %s, %s",p1.x or "nil", p2.x or "nil");
		elseif not(p1.y == p2.y) then
			return string.format("Error 3: y not matching. %s, %s",p1.y or "nil", p2.y or "nil");
		elseif not(p1.data == p2.data) then
			return string.format("Error 4: data not matching");
		end
		return true;
	end

	it("should handle a simple example",function()
		local P = {
			{x=1,y=6,data={"test1"}},
			{x=2,y=7,data={"test2"}},
			{x=9,y=7,data={"test3"}},
			{x=8,y=5,data={"test4"}},
			{x=8,y=3,data={"test5"}},
			{x=7,y=1,data={"test6"}},
		};
		local c1 = {x=0,y=0};
		local c2 = {x=10,y=8};

		local T = GHP_BuildKdTree(Clone(P),c1,c2)



		assert.are.True(IsSamePoint({x=5,y=4},T));
		assert.are.True(IsSamePoint(P[1],T.l));
		assert.are.True(IsSamePoint(P[2],T.l.r));

		assert.are.True(IsSamePoint({x=7.5,y=4},T.r));
		assert.are.True(IsSamePoint({x=7.5,y=2},T.r.l));
		assert.are.True(IsSamePoint(P[6],T.r.l.l));
		assert.are.True(IsSamePoint(P[5],T.r.l.r));

		assert.are.True(IsSamePoint(P[4],T.r.r));
		assert.are.True(IsSamePoint(P[3],T.r.r.r));

		for i=1,6 do
			assert.are.True(IsSamePoint(P[i],P[i].kdNode))
		end

	end)

	it("should handle special situations",function()
		-- points in the edge of the cells
		local P = {
			{x=10,y=6,data={"test1"}},
			{x=2,y=8,data={"test2"}},
			{x=0,y=0,data={"test3"}},
			{x=0,y=5,data={"test4"}},
			{x=8,y=3,data={"test5"}},
			{x=7,y=0,data={"test6"}},
		};
		local c1 = {x=0,y=0};
		local c2 = {x=10,y=8};

		local T = GHP_BuildKdTree(Clone(P),c1,c2)
	end);

	it("should implement GHP_SearchKdTree as a function",function()
		assert.are.same("function",type(GHP_SearchKdTree));
	end);

	it("should handle a leaf that is within range",function()
		local P = {
			{x=4,y=8,data={"test"}},
		};
		local c1 = {x=2,y=1};
		local c2 = {x=12,y=21};

		local tree = GHP_BuildKdTree(P,c1,c2);
		local R = GHP_SearchKdTree(tree,{x=5,y=7},2);
		assert.are.same(1,#(R));

	end);

	it("should handle a leaf that is not within range",function()
		local P = {
			{x=4,y=8,data={"test"}},
		};
		local c1 = {x=2,y=1};
		local c2 = {x=12,y=21};

		local tree = GHP_BuildKdTree(P,c1,c2);
		local R = GHP_SearchKdTree(tree,{x=5,y=6},2);
		assert.are.same(0,#(R));
	end);

	it("should handle search in a simple tree",function()
		local P = {
			{x=1,y=6,data={"test1"}},
			{x=2,y=7,data={"test2"}},
			{x=9,y=7,data={"test3"}},
			{x=8,y=5,data={"test4"}},
			{x=8,y=3,data={"test5"}},
			{x=7,y=1,data={"test6"}},
		};
		local c1 = {x=0,y=0};
		local c2 = {x=10,y=8};

		local tree = GHP_BuildKdTree(Clone(P),c1,c2);


		local R = GHP_SearchKdTree(tree,{x=7,y=4},1.5);
		assert.are.same(2,#(R));
		assert.are.True(IsSamePoint(P[5],R[1]));
		assert.are.True(IsSamePoint(P[4],R[2]));
	end);

	it("should implement GHP_InsertKdTree as a function",function()
		assert.are.same("function",type(GHP_InsertKdTree));
	end);

	it("should handle insertion into a leaf",function()
		local P = {
			{x=4,y=8,data={"test"}},
		};
		local c1 = {x=2,y=1};
		local c2 = {x=12,y=21};

		local tree = GHP_BuildKdTree(P,c1,c2);

		local P2 = {x=8,y=16};
		GHP_InsertKdTree(tree,P2);

		assert.are.same(tree.l,nil);
		assert.are.True(IsSamePoint(tree.r,P2));


	end);

	it("should handle insert in a simple tree",function()
		local P = {
			{x=1,y=6,data={"test1"}},
			{x=2,y=7,data={"test2"}},
			{x=9,y=7,data={"test3"}},
			{x=8,y=5,data={"test4"}},
			{x=8,y=3,data={"test5"}},
			{x=7,y=1,data={"test6"}},
		};
		local c1 = {x=0,y=0};
		local c2 = {x=10,y=8};

		local tree = GHP_BuildKdTree(Clone(P),c1,c2);

		local P2 = {x=4,y=3};
		GHP_InsertKdTree(tree,P2);
		assert.are.True(IsSamePoint(tree.l.l,P2));

		local P3 = {x=6,y=3};
		GHP_InsertKdTree(tree,P3);
		assert.are.True(IsSamePoint(tree.r.l.l.r,P3));

	end);

	it("should implement GHP_GetAllKdNodes as a function",function()
		assert.are.same("function",type(GHP_GetAllKdNodes));
	end);


	it("should handle GHP_GetAllKdNodes call on a leaf",function()
		local P = {
			{x=4,y=8,data={"test"}},
		};
		local c1 = {x=2,y=1};
		local c2 = {x=12,y=21};

		local tree = GHP_BuildKdTree(P,c1,c2);

		local nodes = GHP_GetAllKdNodes(tree)

		assert.are.same(1,#(nodes));
		assert.are.True(IsSamePoint(nodes[1],P[1]));

	end);

	it("should handle GHP_GetAllKdNodes on a simple tree",function()
		local P = {
			{x=1,y=6,data={"test1"}},
			{x=2,y=7,data={"test2"}},
			{x=9,y=7,data={"test3"}},
			{x=8,y=5,data={"test4"}},
			{x=8,y=3,data={"test5"}},
			{x=7,y=1,data={"test6"}},
		};
		local c1 = {x=0,y=0};
		local c2 = {x=10,y=8};

		local tree = GHP_BuildKdTree(Clone(P),c1,c2);

		local nodes = GHP_GetAllKdNodes(tree)

		assert.are.same(6,#(nodes));
		assert.are.True(IsSamePoint(nodes[1],P[1]));
		assert.are.True(IsSamePoint(nodes[2],P[2]));
		assert.are.True(IsSamePoint(nodes[3],P[6]));
		assert.are.True(IsSamePoint(nodes[4],P[5]));
		assert.are.True(IsSamePoint(nodes[5],P[4]));
		assert.are.True(IsSamePoint(nodes[6],P[3]));

	end);

	it("should implement GHP_RemoveKdTree as a function",function()
		assert.are.same("function",type(GHP_RemoveKdTree));
	end);


	it("should handle GHP_RemoveKdTree on a simple tree",function()
		local P = {
			{x=1,y=6,data={"test1"}},
			{x=2,y=7,data={"test2"}},
			{x=9,y=7,data={"test3"}},
			{x=8,y=5,data={"test4"}},
			{x=8,y=3,data={"test5"}},
			{x=7,y=1,data={"test6"}},
		};
		local c1 = {x=0,y=0};
		local c2 = {x=10,y=8};

		local tree = GHP_BuildKdTree(Clone(P),c1,c2);

		-- Remove a leaf
		local P6 = P[6].kdNode;
		local parent = P6.p;

		GHP_RemoveKdTree(P6);
		assert.are.same(parent.l,nil);

		-- Remove a non leaf
		local P4 = P[4].kdNode;
		local P3 = P[3].kdNode;
		local parent = P4.p;

		GHP_RemoveKdTree(P4);

		local n = GHP_GetAllKdNodes(parent.r)
		assert.are.same(1,#(n));
		assert.are.True(IsSamePoint(n[1],P[3]))

	end);


	local NativeGetPoints = function(T,p,r)
		local points = {};
		for _,v in pairs(T) do
			local dx,dy = v.x-p.x, v.y-p.y;
			if math.sqrt(dx^2 + dy^2) <= r then
				table.insert(points,v);
			end
		end
		return points;
	end

	local t;
	local timeStart = function()
		t = os.clock ()
	end
	local timeStop = function()
		return os.clock()-t;
	end

	local LoadRandomPoints = function(num)
		local numbers = {}
		for line in io.lines("Test\\kdTreeRandomPoints.csv") do
			table.insert(numbers,{
				x = tonumber(line:sub(0,line:find(';')-1)),
				y = tonumber(line:sub(line:find(';')+1,line:len())),
			});
			if #(numbers) >= num then
				return numbers;
			end
		end
		error(string.format("Not enough random numbers found %s of %s",#(numbers),num));
	end


	local SaveData = function(m)
		local file = io.open("Test\\kdTreePerformanceMeasurements.csv", "w")

		local str = "";
		for i,s in pairs(m.label) do
			str = str..s..",";
		end

		file:write(str.."\n");

		for i,v in pairs(m) do
			if not(i == "label") then
				local str = "";
				for i,s in pairs(v) do
					str = str..s..",";
				end
				file:write(str.."\n")
			end
		end

		file:close()
	end

	it("Performance meassurements",function()

		local m = {label = {}}

		local sizes = {1,10,100,500,1000,5000,10000}

		for i,numPoints in pairs(sizes) do
			local data = LoadRandomPoints(numPoints)

			m[i] = {};

			m.label[1] = "Data points:";
			m[i][1] = numPoints;

			-- Native approach
			m.label[2] = "Native:";
			timeStart();

			for i=1,100 do
				for j=1,100 do
                    NativeGetPoints(data,{x=i*10,y=j*10},15);
				end
			end

			m[i][2] = timeStop();


			--kd tree approach
			m.label[3] = "kd-Tree:";
			local tree = GHP_BuildKdTree(data,{x=0,y=0},{x=1000,y=1000});

			timeStart();

			for i=1,100 do
				for j=1,100 do
					GHP_SearchKdTree(tree,{x=i*10,y=j*10},15);
				end
			end

			m[i][3] = timeStop();


		end
		SaveData(m);
	end);


end);