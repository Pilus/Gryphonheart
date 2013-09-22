
describe("GHP_SegmentIntersection",function()
	require("StandardMock");
	require("GHP_SegmentIntersection");

	it("should be a function",function()
		assert.are.same("function",type(GetLineSegmentIntersection));
	end);

	it("should throw errors on incorrect input",function()

		assert.has_error(function()
			GetLineSegmentIntersection()
		end);
		assert.has_error(function()
			GetLineSegmentIntersection(1,2)
		end);
		assert.has_error(function()
			GetLineSegmentIntersection("test","test")
		end);
		assert.has_error(function()
			GetLineSegmentIntersection({2},{1},{4},{3})
		end);
		assert.has_error(function()
			GetLineSegmentIntersection({x=1,y=2},{1},{1},{1})
		end);
		assert.has_no.error(function()
			GetLineSegmentIntersection({x=1,y=2},{x=2,y=3},{x=5,y=2},{x=7,y=4})
		end);
	end);

	it("should return false when the coordinates have different world index",function()
		assert.is_false(
			GetLineSegmentIntersection({x=1,y=2,world=1},{x=2,y=3,world=1},{x=5,y=2,world=2},{x=7,y=4,world=2})
		);
	end);

	local x = {"xref"}
	local DATA={{x,	x,	x,	x,	x,	x,	x,	x,	1,	x,	x,	x,	x,	1,	0.88,	0.77,	0.69,	x,	1,	0.75,	0.634615384615385,	0.58,	x,	x,	0.6,	0.55,	0.5},
	{x,	x,	x,	x,	x,	x,	x,	x,	1,	x,	x,	x,	x,	1,	0.8125,	0.651162790697674,	0.644444444444444,	x,	1,	0.757575757575758,	0.604651162790698,	0.54,	x,	0.75,	0.604651162790698,	0.5,	0.45},
	{x,	x,	x,	x,	x,	x,	x,	x,	1,	x,	x,	x,	x,	1,	0.739130434782609,	0.68,	0.53125,	x,	1,	0.66,	0.484848484848485,	0.45,	x,	0.697674418604651,	0.5,	0.395348837209302,	0.4},
	{x,	x,	x,	x,	x,	x,	x,	x,	1,	x,	x,	x,	x,	1,	0.5,	0.5,	x,	x,	1,	0.5,	0.33,	x,	0.767857142857143,	0.5,	0.302325581395349,	0.25,	x},
	{x,	x,	x,	x,	x,	x,	x,	x,	1,	x,	x,	x,	x,	1,	x,	x,	x,	x,	1,	x,	x,	x,	0.5,	0.25,	x,	x,	x},
	{x,	x,	x,	x,	x,	x,	x,	x,	1,	0.8,	x,	x,	x,	1,	0.810810810810811,	0.714285714285714,	0.627450980392157,	x,	1,	0.71875,	0.577777777777778,	0.5,	x,	x,	0.55,	0.46,	0.42},
	{x,	x,	x,	x,	x,	x,	x,	x,	1,	0.75,	x,	x,	x,	1,	0.777777777777778,	0.6875,	0.547619047619048,	x,	1,	0.68,	0.5,	0.422222222222222,	x,	0.67,	0.5,	0.395348837209302,	0.37},
	{x,	x,	x,	x,	x,	x,	x,	x,	1,	0.666666666666667,	x,	x,	x,	1,	0.571428571428571,	0.5,	0.357142857142857,	x,	1,	0.5,	0.32,	0.28125,	x,	0.5,	0.34,	0.242424242424242,	0.25},
	{0,	0,	0,	0,	0,	0,	0,	0,	x,	0,	0,	0,	0,	x,	0,	0,	0,	0,	x,	0,	0,	0,	0,	0,	0,	0,	0},
	{x,	x,	x,	x,	x,	0.2,	0.25,	0.333333333333333,	1,	x,	0.294117647058824,	0.476190476190476,	0.439024390243902,	1,	x,	x,	x,	0.5,	1,	x,	x,	x,	x,	x,	x,	x,	x},
	{x,	x,	x,	x,	x,	x,	x,	x,	1,	0.705882352941176,	x,	x,	x,	1,	0.714285714285714,	0.625,	0.5,	x,	1,	0.642857142857143,	0.452380952380952,	0.372549019607843,	x,	x,	0.46875,	0.355555555555556,	0.31},
	{x,	x,	x,	x,	x,	x,	x,	x,	1,	0.523809523809524,	x,	x,	x,	1,	0.6,	0.5,	0.375,	x,	1,	0.5,	0.3125,	0.285714285714286,	x,	0.5,	0.32,	0.348837209302326,	0.23},
	{x,	x,	x,	x,	x,	x,	x,	x,	1,	0.560975609756098,	x,	x,	x,	1,	0.5,	0.4,	0.285714285714286,	x,	1,	0.428571428571429,	0.222222222222222,	0.189189189189189,	x,	0.5,	0.260869565217391,	0.1875,	0.12},
	{0,	0,	0,	0,	0,	0,	0,	0,	x,	0,	0,	0,	0,	x,	0,	0,	0,	0,	x,	0,	0,	0,	0,	0,	0,	0,	0},
	{0.12,	0.1875,	0.260869565217391,	0.5,	x,	0.189189189189189,	0.222222222222222,	0.428571428571429,	1,	x,	0.285714285714286,	0.4,	0.5,	1,	x,	x,	x,	0.560975609756098,	1,	x,	x,	x,	x,	x,	x,	x,	x},
	{0.23,	0.348837209302326,	0.32,	0.5,	x,	0.285714285714286,	0.3125,	0.5,	1,	x,	0.375,	0.5,	0.6,	1,	x,	x,	x,	0.523809523809524,	1,	x,	x,	x,	x,	x,	x,	x,	x},
	{0.31,	0.355555555555556,	0.46875,	x,	x,	0.372549019607843,	0.452380952380952,	0.642857142857143,	1,	x,	0.5,	0.625,	0.714285714285714,	1,	x,	x,	x,	0.705882352941176,	1,	x,	x,	x,	x,	x,	x,	x,	x},
	{x,	x,	x,	x,	x,	x,	x,	x,	1,	0.5,	x,	x,	x,	1,	0.439024390243902,	0.476190476190476,	0.294117647058824,	x,	1,	0.333333333333333,	0.25,	0.2,	x,	x,	x,	x,	x},
	{0,	0,	0,	0,	0,	0,	0,	0,	x,	0,	0,	0,	0,	x,	0,	0,	0,	0,	x,	0,	0,	0,	0,	0,	0,	0,	0},
	{0.25,	0.242424242424242,	0.34,	0.5,	x,	0.28125,	0.32,	0.5,	1,	x,	0.357142857142857,	0.5,	0.571428571428571,	1,	x,	x,	x,	0.666666666666667,	1,	x,	x,	x,	x,	x,	x,	x,	x},
	{0.365384615384615,	0.395348837209302,	0.515151515151515,	0.67,	x,	0.422222222222222,	0.5,	0.68,	1,	x,	0.547619047619048,	0.6875,	0.777777777777778,	1,	x,	x,	x,	0.75,	1,	x,	x,	x,	x,	x,	x,	x,	x},
	{0.42,	0.46,	0.55,	x,	x,	0.5,	0.577777777777778,	0.71875,	1,	x,	0.627450980392157,	0.714285714285714,	0.810810810810811,	1,	x,	x,	x,	0.8,	1,	x,	x,	x,	x,	x,	x,	x,	x},
	{x,	x,	x,	0.232142857142857,	0.5,	x,	x,	x,	1,	x,	x,	x,	x,	1,	x,	x,	x,	x,	1,	x,	x,	x,	x,	x,	x,	x,	x},
	{x,	0.25,	0.302325581395349,	0.5,	0.75,	x,	0.33,	0.5,	1,	x,	x,	0.5,	0.5,	1,	x,	x,	x,	x,	1,	x,	x,	x,	x,	x,	x,	x,	x},
	{0.4,	0.395348837209302,	0.5,	0.697674418604651,	x,	0.45,	0.5,	0.66,	1,	x,	0.53125,	0.68,	0.739130434782609,	1,	x,	x,	x,	x,	1,	x,	x,	x,	x,	x,	x,	x,	x},
	{0.45,	0.5,	0.604651162790698,	0.75,	x,	0.54,	0.604651162790698,	0.757575757575758,	1,	x,	0.644444444444444,	0.651162790697674,	0.8125,	1,	x,	x,	x,	x,	1,	x,	x,	x,	x,	x,	x,	x,	x},
	{0.5,	0.55,	0.6,	x,	x,	0.58,	0.63,	0.75,	1,	x,	0.69,	0.77,	0.88,	1,	x,	x,	x,	x,	1,	x,	x,	x,	x,	x,	x,	x,	x},};





	local POINTS = {
		{x=0, y=0},
		{x=0, y=10},
		{x=0, y=25},
		{x=0, y=40},
		{x=0, y=50}, -- 5
		{x=10, y=0},
		{x=10, y=10},
		{x=10, y=25},
		{x=10, y=40},
		{x=10, y=50}, --10
		{x=20, y=0},
		{x=20, y=10},
		{x=20, y=15},
		{x=20, y=25},
		{x=20, y=35}, -- 15
		{x=20, y=40},
		{x=20, y=50},
		{x=30, y=0},
		{x=30, y=10},
		{x=30, y=25}, --20
		{x=30, y=40},
		{x=30, y=50},
		{x=40, y=0},
		{x=40, y=10},
		{x=40, y=25}, --25
		{x=40, y=40},
		{x=40, y=50},
	};
	local PA,PB = {x=10,y=40},{x=30,y=10};

	local almost_equal = function(val1,val2,maxdiff)
		local diff = math.max(val1,val2) - math.min(val1,val2);
		if diff < maxdiff then
			return true
		end

		error("almost_equal: Difference is "..diff);
		return false;
	end

	it("should handle large numbers",function()
		local LARGE = 100000000;
		local P1 = {x=0*LARGE+LARGE,y=0*LARGE+LARGE};
		local P2 = {x=20*LARGE+LARGE,y=20*LARGE+LARGE};
		local P3 = {x=20*LARGE+LARGE,y=0*LARGE+LARGE};
		local P4 = {x=0*LARGE+LARGE,y=20*LARGE+LARGE};
		local intersection,pos,alpha,beta,dir = GetLineSegmentIntersection(P1,P2,P3,P4);
		assert.are.same(true,intersection);
	end);

	for i=1,#(POINTS) do
		for j=1,#(POINTS) do
			it(string.format("should check collision from P%s to P%s.",i,j),function()
				local intersection,pos,alpha,beta,dir = GetLineSegmentIntersection(PA,PB,POINTS[i],POINTS[j]);
				local expected = DATA[i][j];

				if not(not(expected == x) == intersection) then -- incorrect intersection detection
					error(string.format("incorrect intersection detection. Expected %s, got %s. Pos/return code: %s",tostring(not(expected == x)),tostring(intersection),tostring(pos)));
				end

				if type(expected) == "number" then
					almost_equal(beta,expected,0.1);

					-- direction
					if i == 9 or i == 14 or i == 19 then
						if j < 9 or (j >= 11 and j <= 13) or j == 18 then
							assert.are.same(-1,dir);
						else
							assert.are.same(1,dir);
						end
					elseif i < 9 or (i >= 11 and i <= 13) or i == 18 then
						assert.are.same(1,dir);
					else
						assert.are.same(-1,dir);
					end
				end
			end);
		end
	end

end);