


GHI_MapData = {
	{["y"]=-1724,["x"]=654,["order"]=2,["height"]=2306,["path"]="Interface/WorldMap/Kalimdor/Kalimdor2",["texCoord"]={[1]=0,[2]=1,[3]=0,[4]=1,},["width"]=2306,},
	{["y"]=-1724,["x"]=2960,["order"]=2,["height"]=2306,["path"]="Interface/WorldMap/Kalimdor/Kalimdor3",["texCoord"]={[1]=0,[2]=1,[3]=0,[4]=1,},["width"]=2306,},
	{["y"]=-4030,["x"]=654,["order"]=2,["height"]=2306,["path"]="Interface/WorldMap/Kalimdor/Kalimdor6",["texCoord"]={[1]=0,[2]=1,[3]=0,[4]=1,},["width"]=2306,},
	{["y"]=-4030,["x"]=2960,["order"]=2,["height"]=2306,["path"]="Interface/WorldMap/Kalimdor/Kalimdor7",["texCoord"]={[1]=0,[2]=1,[3]=0,[4]=1,},["width"]=2306,},
	{["y"]=-6336,["x"]=654,["order"]=2,["height"]=2306,["path"]="Interface/WorldMap/Kalimdor/Kalimdor10",["texCoord"]={[1]=0,[2]=1,[3]=0,[4]=1,},["width"]=2306,},
	{["y"]=-6336,["x"]=2960,["order"]=2,["height"]=2306,["path"]="Interface/WorldMap/Kalimdor/Kalimdor11",["texCoord"]={[1]=0,[2]=1,[3]=0,[4]=1,},["width"]=2306,},

}

-- Automatic calculations for the background
local azerothBgScale = {x = 14545.7650/3.910, y = 9697.1767/2.605}
for i=1,3 do
	for j=1,4 do
		table.insert(GHI_MapData,{
			texCoord = { 0, 1, 0, 1},
			x = azerothBgScale.x*(j-1),
			y = -azerothBgScale.y*(i-1),
			height = azerothBgScale.y,
			width = azerothBgScale.x,
			path = "Interface\\WorldMap\\World\\World"..((i-1)*4+j),
			order = 1,
		}) --]]
	end
end