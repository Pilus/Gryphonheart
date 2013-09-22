GHP_D3 = function()
return {
	{
		guid = "9E5347E7A",
		name = "Iron ore vein",
		icon = "Interface\\AddOns\\GHM\\GHP_Icons\\ironVein",
		version = 2,
		authorName = "Gryphonheart Team",
		authorGuid = "474850",
		rightClickText = "Mine the ore",
		attributes = {
			visible = {
				type = "boolean",
				defaultValue = false,
			},
			size = {
				type = "number",
				defaultValue = 100,
			},
			resources = {
				type = "number",
				defaultValue = 20,
			},
		},
		abilities = {
			{
				abilityGuid = "9E8639DF0",
				skillLevels = {0,5,10,20},
				shownInSpellbook = false,
			},
		},
	},
	{
		guid = "9E5347E7B",
		name = "Iron ore vein",
		icon = "Interface\\AddOns\\GHM\\GHP_Icons\\ironVein",
		version = 1,
		authorName = "Gryphonheart Team",
		authorGuid = "474850",
		rightClickText = "Mine the ore",
		attributes = {
			visible = {
				type = "boolean",
				defaultValue = false,
			},
			size = {
				type = "number",
				defaultValue = 100,
			},
			resources = {
				type = "number",
				defaultValue = 20,
			},
		},
		abilities = {
			{
				abilityGuid = "9E8639DF0",
				skillLevels = {0,5,10,20},
				shownInSpellbook = false,
			},
		},
	},
},"GHP_ObjectList","SetObject";
end

