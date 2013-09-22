--===================================================
--
--				GHP_BuildingData
--  			GHP_BuildingData.lua
--
--	  Building template data for floor detection
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

GHP_BUILDING_DATA = {
	["HUMAN_INN"] = {
		offset = {
		    x = 9207.136,
		    y = 4552.558,
		    world = 1,
		},
		ref1 = {
		    x = 0,
		    y = 0,
		    world = 1,
		},
		ref2 = {
		    x = -4.582,
		    y = 5.844,
		    world = 1,
		},
		ZONE = {
			{
				startPoint = {
					x = -0.734,
					y = -2.334,
					world = 1,
				},
				endPoint = {
					x = 0.056,
					y = -2.330,
					world = 1,
				},
				direction = 1,
				target = "%s_FloorA",
			},
		},
		["%s_FloorA"] = {
			{
				startPoint = {
					x = -0.734,
					y = -2.334,
					world = 1,
				},
				endPoint = {
					x = 0.056,
					y = -2.330,
					world = 1,
				},
				direction = -1,
				target = "ZONE",
			},
			{
				startPoint = {
				    x = -3.52,
				    y = 3.404,
				    world = 1,
				},
				endPoint = {
				    x = -4.503,
				    y = 3.505,
				    world = 1,
				},
				direction = -1,
				target = "%s_FloorB",
			},
			{
				startPoint = {
				    x = 0.879,
				    y = 7.632,
				    world = 1,
				},
				endPoint = {
					x = 0.069,
					y = 7.651,
					world = 1,
				},
				direction = -1,
				target = "%s_FloorD",
			},
			{
				startPoint = {
				    x = 0.045,
				    y = 10.144,
				    world = 1,
				},
				endPoint = {
					x = 0.069,
					y = 7.651,
					world = 1,
				},
				direction = 1,
				target = "%s_FloorD",
			},
			name = "%s ground floor",
		},
		["%s_FloorB"] = {
			{
				startPoint = {
					x = -3.52,
					y = 3.404,
					world = 1,
				},
				endPoint = {
					x = -4.503,
					y = 3.505,
					world = 1,
				},
				direction = 1,
				target = "%s_FloorA",
			},
			{
				startPoint = {
					x = -3.52,
					y = 3.404,
					world = 1,
				},
				endPoint = {
				    x = -3.475,
				    y = 4.117,
				    world = 1,
				},
				direction = -1,
				target = "%s_FloorA",
			},
			{
				startPoint = {
					x = -2.386,
					y = 3.718,
					world = 1,
				},
				endPoint = {
				    x = -3.545,
				    y = 3.733,
				    world = 1,
				},
				direction = 1,
				target = "%s_FloorC",
			},
			name = "%s stairs",
		},
		["%s_FloorC"] = {
			{
				startPoint = {
				    x = -2.386,
				    y = 3.718,
				    world = 1,
				},
				endPoint = {
				    x = -4.631,
				    y = 3.791,
				    world = 1,
				},
				direction = -1,
				target = "%s_FloorB",
			},
			name = "%s first floor",
		},
		["%s_FloorD"] = {
			{
				startPoint = {
					x = 0.879,
					y = 7.632,
					world = 1,
				},
				endPoint = {
					x = 0.069,
					y = 7.651,
					world = 1,
				},
				direction = 1,
				target = "%s_FloorA",
			},
			{
				startPoint = {
				    x = 0.062,
				    y = 8.88,
				    world = 1,
				},
				endPoint = {
					x = 0.069,
					y = 7.651,
					world = 1,
				},
				direction = -1,
				target = "%s_FloorA",
			},
			{
				startPoint = {
				    x = 0.001,
				    y = 11.414,
				    world = 1,
				},
				endPoint = {
				    x = 0.006,
				    y = 9.177,
				    world = 1,
				},
				direction = -1,
				target = "%s_FloorE",
			},
			name = "%s basement stairs",
		},
		["%s_FloorE"] = {
			{
				startPoint = {
					x = 0.001,
					y = 11.414,
					world = 1,
				},
				endPoint = {
					x = 0.006,
					y = 9.177,
					world = 1,
				},
				direction = 1,
				target = "%s_FloorD",
			},
			name = "%s basement",
		},

	},
	["MINE_A"] = { -- Azurelode mine. Unique?
		offset = {
		    x = 8952.434,
		    y = 3827.75,
		    world = 1,
		},
		ref1 = {
			x = 0,
			y = 0,
			world = 1,
		},
		ref2 = {
		    x = 40.407,
		    y = -35.753,
		    world = 1,
		},
		ZONE = {
			{
				startPoint = {
				    x = -0.839,
				    y = 1.793,
				    world = 1,
				},
				endPoint = {
				    x = 0.765,
				    y = 2.876,
				    world = 1,
				},
				direction = -1,
				target = "%s_TopLevel",
			},
			{
				startPoint = {
					x = 0.765,
					y = 2.876,
					world = 1,
				},
				endPoint = {
				    x = 2.305,
				    y = 1.38,
				    world = 1,
				},
				direction = -1,
				target = "%s_TopLevel",
			},
			{
				startPoint = {
				    x = -3.11,
				    y = -1.259,
				    world = 1,
				},
				endPoint = {
				    x = -2.458,
				    y = 0.124,
				    world = 1,
				},
				direction = -1,
				target = "%s_BottomLevel",
			},
		},
		["%s_TopLevel"] = {
			{
				startPoint = {
					x = -0.839,
					y = 1.793,
					world = 1,
				},
				endPoint = {
					x = 0.765,
					y = 2.876,
					world = 1,
				},
				direction = 1,
				target = "ZONE",
			},
			{
				startPoint = {
					x = 0.765,
					y = 2.876,
					world = 1,
				},
				endPoint = {
					x = 2.305,
					y = 1.38,
					world = 1,
				},
				direction = 1,
				target = "ZONE",
			},
			{
				startPoint = {
				    x = 27.395,
				    y = -23.307,
				    world = 1,
				},
				endPoint = {
				    x = 27.448,
				    y = -28.345,
				    world = 1,
				},
				direction = 1,
				target = "%s_BottomLevel"
			},
			{
				startPoint = {
				    x = 23.427,
				    y = -11.439,
				    world = 1,
				},
				endPoint = {
				    x = 27.287,
				    y = -16.891,
				    world = 1,
				},
				direction = 1,
				target = "%s_BottomLevel"
			},
			name = "%s upper level",
		},
		["%s_BottomLevel"] = {
			{
				startPoint = {
					x = -3.11,
					y = -1.259,
					world = 1,
				},
				endPoint = {
					x = -2.458,
					y = 0.124,
					world = 1,
				},
				direction = 1,
				target = "ZONE",
			},
			{
				startPoint = {
					x = 27.395,
					y = -23.307,
					world = 1,
				},
				endPoint = {
					x = 27.448,
					y = -28.345,
					world = 1,
				},
				direction = -1,
				target = "%s_TopLevel"
			},
			name = "%s lower level",
		}

	},
}

---[[
if true then return end



local Update = function()
	local s = "";

	s = s.."offset = {\n\t";
	s = s.."x = "..REF_POINT.x..",\n\t";
	s = s.."y = "..REF_POINT.y..",\n\t";
	s = s.."world = "..REF_POINT.world..",\n\t";
	s = s.."},\n";

	if ROTATION then
		s = string.format("%srotation = %.2f\n",s,ROTATION);
	end

	for _,point in pairs(POINTS) do
		s = s.."{\n\t";
		s = s.."x = "..point.x..",\n\t";
		s = s.."y = "..point.y..",\n\t";
		s = s.."world = "..point.world..",\n\t";
		s = s.."},\n";
	end
	UI.ForceLabel("out",s);
end


local SetNewRefPoint = function()
	REF_POINT = GHI_Position().GetPlayerPos(3)
	POINTS = {};
	print("New reference point set");
end

local Round = function(num,decimals)
	if decimals then
		return tonumber(string.format("%."..decimals.."f",num));
	end
	return num;
end


local SetVector1 = function()
	if POINTS[1] then
		stack.SetAttribute("vectorA",POINTS[1]);
	end
end

local SetVector2 = function()
	local v = POINTS[1];
	local u = stack.GetAttribute("vectorA");
	if u and v then
		ROTATION = acos(
			(u.x*v.x + u.y*v.y)
			/
			( math.sqrt((u.x)^2 + (u.y)^2  ) * math.sqrt((v.x)^2 + (v.y)^2 ) )
		)
		Update();
	end
end

if not(UI) then
	POINTS = {}
	UI = CreateMenu({
		onOk = function(self) end,
		{
			{
				{
					type = "CodeField",
					align = "c",
					label = "out",
					width = 250,
					height = 350,
				},
			},
			{
				{
					type = "Button",
					align = "l",
					width = 100,
					label = "anchor",
					text = "Add point",
					OnClick = function()
						if not(REF_POINT) then
							SetNewRefPoint()
						end
						local pos = GHI_Position().GetPlayerPos(3);
						table.insert(POINTS,{
							x = Round(pos.x - REF_POINT.x,3),
							y = Round(pos.y - REF_POINT.y,3),
							world = pos.world,
						});
						Update();
					end,
				},
				{
					type = "Button",
					align = "l",
					width = 100,
					label = "anchor",
					text = "Reset points",
					OnClick = function()
						POINTS = {};
						Update();
					end,
				},
				{
					type = "Button",
					align = "l",
					width = 100,
					label = "anchor",
					text = "Reset ref",
					OnClick = function()
						SetNewRefPoint();
						Update();
					end,
				},
			},
			{
				{
					type = "Button",
					align = "l",
					width = 130,
					label = "anchor",
					text = "Set Building Anchor",
					OnClick = function()
						SetVector1();
					end,
				},
				{
					type = "Button",
					align = "l",
					width = 100,
					label = "anchor",
					text = "Calc rotation",
					OnClick = function()
						SetVector2();
					end,
				},
			},
		},
		title = "Meassurement controller",
		name = "test",
		theme = "BlankTheme",
		width = 300,
		useWindow = true,
		icon = "",
		lineSpacing = 20,
	});
else
	UI:Show();
end









--]]