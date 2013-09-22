
GHP_D1 = function()    --/script GHP_ProfessionSystemAPI("474850").LearnProfession("9E37259F4","9E38B5A8C");
return {
	{
		guid = "9E37259F4",
		version = 6,
		name = "Gryphonheart Official (alpha test)",
		type = "SkillSumRule",
		icon = "interface\\addons\\ghm\\ghi_icons\\ghicon",
		authorGuid = "474850",
		authorName = "Gryphonheart Team",
		markColor = {
			r = 1.0,
			g = 0.1,
			b = 0.1,
		},
		professions = {
			{
				guid = "9E38B5A8C",
				abilitiesKnown = { -- default abilities known in the profession
					"9E40C9844",
					"9E8639DF0",
					"9E8DDB6A6",
				},
			},
		},
	},
},"GHP_ProfessionSystemList","SetSystem";
end





