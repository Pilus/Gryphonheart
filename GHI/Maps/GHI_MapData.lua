


local worldScale = 14.65; -- TODO: Adjust this number to give better acuracy to the azeroth background
GHI_MapData = {

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
			order = 0,
		})
	end
end