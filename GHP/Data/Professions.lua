
GHP_D2 = function()
return {
	{
		guid = "9E38B5A8C",
		name = "Mining",
		icon = "Interface\\Icons\\inv_pick_02",
		version = 11,
		authorName = "Gryphonheart Team",
		authorGuid = "474850",
		abilities = {
			{
				abilityGuid = "9E40C9844",
				skillLevels = {0,0,0,0},
			},
			{
				abilityGuid = "9E8DDB6A6",
				skillLevels = {0,0,0,0},
			},
			{
				abilityGuid = "9E8639DF0",
				skillLevels = {0,0,0,0},
			},
		},
		objectSpawners = {
			{
				guid = "9E534D5FA",
				name = "Azurelode mine",
				maxSize = 1000,
				respawnInterval = 60,
				sizeRespawnAmount = 1.0, -- one size every 30 sec. Takes 1000 min (16.66 hours) online time to rebuild
				resourceRespawnAmount = 0.075, -- contains around 7.5% resource = 75 resource points
				offlineRespawnModifer = 0.01, --
				objects = {
					{
						guid = "9E534E245",
						objectGuid = "9E5347E7A",
						position = {
							x = 8966.031,
							y = 3813.631,
							world = 1,
							level = "MINE_AZURELODE_BottomLevel",
						},
						attributes = {
					   		size = 500,
							resources = 37,
						},
					},
					{
						guid = "9E8149CA2",
						objectGuid = "9E5347E7A",
						position = {
							x = 8976.150,
							y = 3827.212,
							world = 1,
							level = "MINE_AZURELODE_BottomLevel",
						},
						attributes = {
							size = 500,
							resources = 35,
						},
					},
				},
			},

		},
		objectSpawners = {
			{
				guid = "9F4775D9E",
				name = "Jasperlode mine",
				maxSize = 1000,
				respawnInterval = 60,
				sizeRespawnAmount = 1.0, -- one size every 30 sec. Takes 1000 min (16.66 hours) online time to rebuild
				resourceRespawnAmount = 0.075, -- contains around 7.5% resource = 75 resource points
				offlineRespawnModifer = 0.01, --
				objects = {
					{
						guid = "9F47760E1",
						objectGuid = "9E5347E7A",
						position = {
							x = 9145.879,
							y = 5863.538,
							world = 1,
							level = "INDOORS",
						},
						attributes = {
							size = 500,
							resources = 37,
						},
					},
					{
						guid = "9F477622E",
						objectGuid = "9E5347E7A",
						position = {
							x = 9140.127,
							y = 5855.176,
							world = 1,
							level = "INDOORS",
						},
						attributes = {
							size = 500,
							resources = 35,
						},
					},
				},
			},

		},
	},
},"GHP_ProfessionList","SetProfession";
end
