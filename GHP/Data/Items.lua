GHP_D5 = function()
return {
	{
		["guid"] = "000001",
		["consumed"] = false,
		["editable"] = false,
		["icon"] = "Interface\\Icons\\INV_Pick_01",
		["quality"] = 1,
		["version"] = 1,
		["itemType"] = 4,
		["stackOrder"] = "last",
		["creater"] = "Pilus",
		["name"] = "Dummy item",
		["authorName"] = "Gryphonheart Team",
		["stackSize"] = 1,
		["copyable"] = false,
		["itemComplexity"] = "advanced",
		["authorGuid"] = "474850",
	},
	{
		["guid"] = "9E9F9A25C",
		["consumed"] = true,
		["editable"] = false,
		["icon"] = "Interface\\Icons\\INV_Scroll_06",
		["quality"] = 1,
		["version"] = 5,
		["itemType"] = 4,
		["stackOrder"] = "last",
		["creater"] = "Pilus",
		["name"] = "Mining instructions",
		["white1"] = "Scroll",
		["rightClicktext"] = "Learn how to mine",
		["authorName"] = "Gryphonheart Team",
		["stackSize"] = 1,
		["copyable"] = false,
		["itemComplexity"] = "advanced",
		["authorGuid"] = "474850",
		["dynamicActionSet"] = {
			["availablePorts"] = {
				"onclick", -- [1]
			},
			["portInfo"] = {
				["onclick"] = {
					["name"] = "OnClick",
					["description"] = "This port is triggered when the item is clicked.",
				},
			},
			["portConnections"] = {
				["onclick"] = {
					["instanceGuid"] = "9E9FB25EC",
					["instancePortGuid"] = "setup",
				},
			},
			["instances"] = {
				{
					["inputs"] = {
						["code"] = {
							["info"] = [[  LearnProfession("9E37259F4","9E38B5A8C") 	]],
							["type"] = "static",
						},
					},
					["version"] = 2,
					["guid"] = "9E9FB25EC",
					["actionGuid"] = "script_01",
					["portConnectionsOut"] = {
					},
					["portConnectionsIn"] = {
						["setup"] = {
							["instanceGuid"] = "set",
							["portGuid"] = "onclick",
						},
					},
					["outputs"] = {
					},
				},
			},
		},
	},
	{
		["dynamicActionSet"] = {
			["availablePorts"] = {
				"onclick", -- [1]
			},
			["portInfo"] = {
				["onclick"] = {
					["name"] = "OnClick",
					["description"] = "This port is triggered when the item is clicked.",
				},
			},
			["portConnections"] = {
			},
			["instances"] = {
			},
		},
		["comment"] = "A simple wooden mining pick.",
		["guid"] = "124AB4C",
		["rightClicktext"] = "",
		["consumed"] = false,
		["attributes"] = {
		},
		["editable"] = false,
		["icon"] = "Interface\\Icons\\INV_Pick_01",
		["quality"] = 1,
		["updateSequences"] = {
		},
		["attributeTooltipLines"] = {
		},
		["white2"] = "",
		["version"] = 2,
		["itemType"] = 4,
		["rightClick"] = {
			["AddonReqName"] = "GHI",
			["Type"] = true,
			["CD"] = 1,
			["AddonReqData"] = "2.0.0",
			["cooldown"] = 1,
			["version"] = 1,
		},
		["stackOrder"] = "last",
		["creater"] = "Pilus",
		["white1"] = "Tool",
		["name"] = "Mining Pick",
		["authorName"] = "Gryphonheart Team",
		["stackSize"] = 1,
		["copyable"] = false,
		["itemComplexity"] = "advanced",
		["authorGuid"] = "474850",
	},
	{
		["dynamicActionSet"] = {
			["availablePorts"] = {
				"onclick", -- [1]
			},
			["portInfo"] = {
				["onclick"] = {
					["name"] = "OnClick",
					["description"] = "This port is triggered when the item is clicked.",
				},
			},
			["portConnections"] = {
			},
			["instances"] = {
			},
		},
		["comment"] = "Chunks of raw iron ore in many different sizes.",
		["guid"] = "9E8BA7C5A",
		["rightClicktext"] = "",
		["consumed"] = false,
		["attributes"] = {
			--[[{
				name = name,
				attType = attType,
				defaultValue = "",
			}  --]]
		},
		["editable"] = false,
		["icon"] = "Interface\\Icons\\INV_Ore_Iron_01",
		["quality"] = 1,
		["updateSequences"] = {
		},
		["attributeTooltipLines"] = {
		},
		["white2"] = "",
		["version"] = 4,
		["itemType"] = 4,
		["rightClick"] = {
			["AddonReqName"] = "GHI",
			["Type"] = true,
			["CD"] = 1,
			["AddonReqData"] = "2.0.0",
			["cooldown"] = 1,
			["version"] = 2,
		},
		["stackOrder"] = "last",
		["creater"] = "Pilus",
		["white1"] = "Resource",
		["name"] = "Chunks of Raw Iron Ore",
		["authorName"] = "Gryphonheart Team",
		["stackSize"] = 10,
		["copyable"] = false,
		["itemComplexity"] = "advanced",
		["authorGuid"] = "474850",
	},
	{
		["dynamicActionSet"] = {
			["availablePorts"] = {
				"onclick", -- [1]
			},
			["portInfo"] = {
				["onclick"] = {
					["name"] = "OnClick",
					["description"] = "This port is triggered when the item is clicked.",
				},
			},
			["portConnections"] = {
			},
			["instances"] = {
			},
		},
		["white1"] = "Resource",
		["name"] = "Raw iron ore",
		["comment"] = "Raw iron ore in small pieces. A mix of iron ore and gangue.",
		["guid"] = "9E9D52A6E",
		["rightClicktext"] = "",
		["consumed"] = false,
		["attributes"] = {
			--[[{
				name = name,
				attType = attType,
				defaultValue = "",
			}  --]]
		},
		["editable"] = false,
		["icon"] = "Interface\\Icons\\INV_Misc_Dust_02",
		["quality"] = 1,
		["updateSequences"] = {
		},
		["attributeTooltipLines"] = {
		},
		["white2"] = "",
		["version"] = 2,
		["itemType"] = 4,
		["rightClick"] = {
			["AddonReqName"] = "GHI",
			["Type"] = true,
			["CD"] = 1,
			["AddonReqData"] = "2.0.0",
			["cooldown"] = 1,
			["version"] = 2,
		},
		["stackOrder"] = "last",
		["creater"] = "Pilus",
		["authorName"] = "Gryphonheart Team",
		["stackSize"] = 10,
		["copyable"] = false,
		["itemComplexity"] = "advanced",
		["authorGuid"] = "474850",
	},
},"GHI_ItemInfoList","LoadItemFromTable";
end