GHP_D4 = function()
return {
	{
		guid = "9E40C9844",
		name = "Spot minerals",
		icon = "Interface\\Icons\\ability_cheapshot",
		cooldown = 5,
		version = 12,
		authorName = "Gryphonheart Team",
		authorGuid = "474850",
		shownInSpellbook = true,
		["dynamicActionSet"] = {
			["availablePorts"] = {
				"execute", -- [1]
			},
			["portInfo"] = {
				["execute"] = {
					["name"] = "Execute",
					["description"] = "This port is triggered when the item is clicked.",
				},
			},
			["portConnections"] = {
				["execute"] = {
					["instanceGuid"] = "1773_2C3556E",
					["instancePortGuid"] = "setup",
				},
			},
			["instances"] = {
				{
					["inputs"] = {
						["actionDescription"] = {
							["info"] = "In order to spot minerals, you will have to look at the rock walls of the mine and locate eventual light reflections.",
							["type"] = "static",
						},
						["actionName"] = {
							["info"] = "Spot minerals",
							["type"] = "static",
						},
					},
					["version"] = 2,
					["guid"] = "1773_2C3556E",
					["actionGuid"] = "9E7942787",
					["portConnectionsIn"] = {
						["setup"] = {
							["instanceGuid"] = "set",
							["portGuid"] = "execute",
						},
					},
					["portConnectionsOut"] = {
						["firstactionperformed"] = {
							["instanceGuid"] = "1773_2C3563F",
							["portGuid"] = "setup",
						},
					},
					["outputs"] = {
					},
				}, -- [1]
				{
					["inputs"] = {
						["duration"] = {
							["info"] = 20,
							["type"] = "static",
						},
						["name"] = {
							["info"] = "name",
							["type"] = "attribute",
						},
						["icon"] = {
							["info"] = "icon",
							["type"] = "attribute",
						},
					},
					["version"] = 3,
					["guid"] = "1773_2C3563F",
					["actionGuid"] = "cast_01",
					["portConnectionsIn"] = {
						["setup"] = {
							["instanceGuid"] = "1773_2C3556E",
							["portGuid"] = "firstactionperformed",
						},
					},
					["portConnectionsOut"] = {
						["finished"] = {
							["instanceGuid"] = "1773_2C3AFDF",
							["portGuid"] = "setup",
						},
					},
					["outputs"] = {
					},
				}, -- [2]
				{
					["inputs"] = {
						["code"] = {
							["info"] = [[
								local c = 0;
								for i=1,GetNumNearbyObjects() do
									if GetObjectGuid(i) == "9E5347E7A" then
							            local obj = GetObjectInstance(i);
							            obj.SetAttribute("visible",true);
							            c = c + 1;
									end
								end
							    DEFAULT_CHAT_FRAME:AddMessage(string.format("You spotted %s |1Iron vein;Iron veins; near you.",c),1,0.82,0);
							]],
							["type"] = "static",
						},
					},
					["version"] = 1,
					["guid"] = "1773_2C3AFDF",
					["actionGuid"] = "script_01",
					["portConnectionsIn"] = {
						["setup"] = {
							["instanceGuid"] = "1773_2C3563F",
							["portGuid"] = "finished",
						},
					},
					["portConnectionsOut"] = {
					},
					["outputs"] = {
					},
				}, -- [3]
			},
		},
	},
	{
		guid = "9E8639DF0",
		name = "Mine iron ore vein",
		icon = "Interface\\Icons\\INV_Pick_02",
		cooldown = 5,
		version = 11,
		authorName = "Gryphonheart Team",
		authorGuid = "474850",
		shownInSpellbook = true,
		abilityType = "interactionWithObjectOrItem",
		["dynamicActionSet"] = {
			["availablePorts"] = {
				"execute", -- [1]
			},
			["portInfo"] = {
				["execute"] = {
					["name"] = "Execute",
					["description"] = "This port is triggered when the item is clicked.",
				},
			},
			["portConnections"] = {
				["execute"] = {
					["instanceGuid"] = "1773_2C8CC3C",
					["instancePortGuid"] = "setup",
				},
			},
			["instances"] = {
				{
					["inputs"] = {
						["code"] = {
							["info"] = [[
								local index = GetIndexOfEquippedItemSlot("mainHand");
							    local guid = GetEquippedItemInfo(index);
							    if guid == "124AB4C" then
									dyn.TriggerOutPort("portA");
								else
									UIErrorsFrame:AddMessage(string.format("Must have a mining pick equipped in main hand slot."), 1.0, 0.0, 0.0, 53, 5);
								end
							]],
							["type"] = "static",
						},
					},
					["version"] = 2,
					["guid"] = "1773_2C8CC3C",
					["actionGuid"] = "script_01",
					["portConnectionsIn"] = {
						["setup"] = {
							["instanceGuid"] = "set",
							["portGuid"] = "execute",
						},
					},
					["portConnectionsOut"] = {
						["porta"] = {
							["instanceGuid"] = "1773_2C8CC4D",
							["portGuid"] = "setup",
						},
					},
					["outputs"] = {
					},
				}, -- [1]
				{
					["inputs"] = {
						["actionDescription"] = {
							["info"] = "Mining of the vein is performed by hacking down chunks of rock from the mine wall.",
							["type"] = "static",
						},
						["actionName"] = {
							["info"] = "name",
							["type"] = "attribute",
						},
					},
					["version"] = 1,
					["guid"] = "1773_2C8CC4D",
					["actionGuid"] = "9E7942787",
					["portConnectionsIn"] = {
						["setup"] = {
							["instanceGuid"] = "1773_2C8CC3C",
							["portGuid"] = "porta",
						},
					},
					["portConnectionsOut"] = {
						["firstactionperformed"] = {
							["instanceGuid"] = "1773_2C8CCA8",
							["portGuid"] = "setup",
						},
					},
					["outputs"] = {
					},
				}, -- [2]
				{
					["inputs"] = {
						["duration"] = {
							["info"] = 30,
							["type"] = "static",
						},
						["name"] = {
							["info"] = "name",
							["type"] = "attribute",
						},
						["icon"] = {
							["info"] = "icon",
							["type"] = "attribute",
						},
					},
					["version"] = 3,
					["guid"] = "1773_2C8CCA8",
					["actionGuid"] = "cast_01",
					["portConnectionsIn"] = {
						["setup"] = {
							["instanceGuid"] = "1773_2C8CC4D",
							["portGuid"] = "firstactionperformed",
						},
					},
					["portConnectionsOut"] = {
						["finished"] = {
							["instanceGuid"] = "1773_2C8CE11",
							["portGuid"] = "setup",
						},
						["interrupted"] = {
							["instanceGuid"] = "1773_2C8CCE1",
							["portGuid"] = "interrupt",
						},
						["onsetup"] = {
							["instanceGuid"] = "1773_2C8CCE1",
							["portGuid"] = "setup",
						},
					},
					["outputs"] = {
					},
				}, -- [3]
				{
					["inputs"] = {
						["totalDuration"] = {
							["info"] = 30,
							["type"] = "static",
						},
						["sound1"] = {
							["info"] = {
								["duration"] = 0.6,
								["path"] = "Sound\\SPELLS\\TRADESKILLS\\MiningHitA.ogg",
							},
							["type"] = "static",
						},
						["sound3"] = {
							["info"] = {
								["duration"] = 0.6,
								["path"] = "Sound\\SPELLS\\TRADESKILLS\\MiningHitC.ogg",
							},
							["type"] = "static",
						},
						["sound2"] = {
							["info"] = {
								["duration"] = 0.6,
								["path"] = "Sound\\SPELLS\\TRADESKILLS\\MiningHitB.ogg",
							},
							["type"] = "static",
						},
						["range"] = {
							["info"] = 4,
							["type"] = "static",
						},
						["sound4"] = {
							["info"] = {
								["duration"] = 0.77,
								["path"] = "Sound\\SPELLS\\TRADESKILLS\\MiningHitD.ogg",
							},
							["type"] = "static",
						},
						["delay"] = {
							["info"] = 2,
							["type"] = "static",
						},
						["sound5"] = {
							["info"] = {
								["duration"] = 0.87,
								["path"] = "Sound\\SPELLS\\TRADESKILLS\\MiningHitE.ogg",
							},
							["type"] = "static",
						},
					},
					["version"] = 5,
					["guid"] = "1773_2C8CCE1",
					["actionGuid"] = "sound_03",
					["portConnectionsIn"] = {
						["interrupt"] = {
							["instanceGuid"] = "1773_2C8CCA8",
							["portGuid"] = "interrupted",
						},
						["setup"] = {
							["instanceGuid"] = "1773_2C8CCA8",
							["portGuid"] = "onsetup",
						},
					},
					["portConnectionsOut"] = {
					},
					["outputs"] = {
					},
				}, -- [4]
				{
					["inputs"] = {
						["code"] = {
							["info"] = [[
								local _,_,_,_,objInsGuid = GetExecutionGuids();
							  	local obj = GetObjectInstance(objInsGuid);
								local size = obj.GetAttribute("size");
								local resources = obj.GetAttribute("resources");
							    local consumed = math.min(size,10);
							    local resourcesGathered = abs(math.max(1,resources*(consumed / size)));
							    obj.SetAttribute("resources",resources-resourcesGathered);
							    obj.SetAttribute("size",size - consumed);
							    if (size - consumed <= 0) then
							        obj.SetAttribute("visible",false);
							    end
							    SpawnItemAsObject("9E8BA7C5A",obj.GetPosition(),nil,resourcesGathered);

							]],
							["type"] = "static",
						},
					},
					["version"] = 1,
					["guid"] = "1773_2C8CE11",
					["actionGuid"] = "script_01",
					["portConnectionsIn"] = {
						["setup"] = {
							["instanceGuid"] = "1773_2C8CCA8",
							["portGuid"] = "finished",
						},
					},
					["portConnectionsOut"] = {
					},
					["outputs"] = {
					},
				}, -- [5]
			},
		},
	},
	{
		guid = "9E8DDB6A6",
		name = "Break iron ore",
		icon = "Interface\\Icons\\INV_Pick_02",
		cooldown = 5,
		version = 12,
		authorName = "Gryphonheart Team",
		authorGuid = "474850",
		shownInSpellbook = true,
		abilityType = "interactionWithObjectOrItem",
		initializedFrom = {
			"9E8BA7C5A",
		},
		["dynamicActionSet"] = {
			["availablePorts"] = {
				"execute", -- [1]
			},
			["portInfo"] = {
				["execute"] = {
					["name"] = "Execute",
					["description"] = "This port is triggered when the item is clicked.",
				},
			},
			["portConnections"] = {
				["execute"] = {
					["instanceGuid"] = "9E8DDD7BB",
					["instancePortGuid"] = "setup",
				},
			},
			["instances"] = {
				{
					["inputs"] = {
						["code"] = {
							["info"] = [[
								local index = GetIndexOfEquippedItemSlot("mainHand");
								local guid = GetEquippedItemInfo(index);
								if guid == "124AB4C" then
									dyn.TriggerOutPort("portA");
								else
									UIErrorsFrame:AddMessage(string.format("Must have a mining pick equipped in main hand slot."), 1.0, 0.0, 0.0, 53, 5);
								end
							]],
							["type"] = "static",
						},
					},
					["version"] = 2,
					["guid"] = "9E8DDD7BB",
					["actionGuid"] = "script_01",
					["portConnectionsIn"] = {
						["setup"] = {
							["instanceGuid"] = "set",
							["portGuid"] = "execute",
						},
					},
					["portConnectionsOut"] = {
						["porta"] = {
							["instanceGuid"] = "1773_2C8CC4D",
							["portGuid"] = "setup",
						},
					},
					["outputs"] = {
					},
				}, -- [1]
				{
					["inputs"] = {
						["actionDescription"] = {
							["info"] = "The Iron ore chunks can be broken into smaller pieces with an iron pick.",
							["type"] = "static",
						},
						["actionName"] = {
							["info"] = "name",
							["type"] = "attribute",
						},
					},
					["version"] = 1,
					["guid"] = "1773_2C8CC4D",
					["actionGuid"] = "9E7942787",
					["portConnectionsIn"] = {
						["setup"] = {
							["instanceGuid"] = "9E8DDD7BB",
							["portGuid"] = "porta",
						},
					},
					["portConnectionsOut"] = {
						["firstactionperformed"] = {
							["instanceGuid"] = "9E8DDD7BC",
							["portGuid"] = "setup",
						},
					},
					["outputs"] = {
					},
				}, -- [2]
				{
					["inputs"] = {
						["duration"] = {
							["info"] = 30,
							["type"] = "static",
						},
						["name"] = {
							["info"] = "name",
							["type"] = "attribute",
						},
						["icon"] = {
							["info"] = "icon",
							["type"] = "attribute",
						},
					},
					["version"] = 3,
					["guid"] = "9E8DDD7BC",
					["actionGuid"] = "cast_01",
					["portConnectionsIn"] = {
						["setup"] = {
							["instanceGuid"] = "1773_2C8CC4D",
							["portGuid"] = "firstactionperformed",
						},
					},
					["portConnectionsOut"] = {
						["finished"] = {
							["instanceGuid"] = "1773_2C8CE11",
							["portGuid"] = "setup",
						},
						["interrupted"] = {
							["instanceGuid"] = "9E8DDD7BD",
							["portGuid"] = "interrupt",
						},
						["onsetup"] = {
							["instanceGuid"] = "9E8DDD7BD",
							["portGuid"] = "setup",
						},
					},
					["outputs"] = {
					},
				}, -- [3]
				{
					["inputs"] = {
						["totalDuration"] = {
							["info"] = 30,
							["type"] = "static",
						},
						["sound1"] = {
							["info"] = {
								["duration"] = 0.6,
								["path"] = "Sound\\SPELLS\\TRADESKILLS\\MiningHitA.ogg",
							},
							["type"] = "static",
						},
						["sound3"] = {
							["info"] = {
								["duration"] = 0.6,
								["path"] = "Sound\\SPELLS\\TRADESKILLS\\MiningHitC.ogg",
							},
							["type"] = "static",
						},
						["sound2"] = {
							["info"] = {
								["duration"] = 0.6,
								["path"] = "Sound\\SPELLS\\TRADESKILLS\\MiningHitB.ogg",
							},
							["type"] = "static",
						},
						["range"] = {
							["info"] = 4,
							["type"] = "static",
						},
						["sound4"] = {
							["info"] = {
								["duration"] = 0.77,
								["path"] = "Sound\\SPELLS\\TRADESKILLS\\MiningHitD.ogg",
							},
							["type"] = "static",
						},
						["delay"] = {
							["info"] = 2,
							["type"] = "static",
						},
						["sound5"] = {
							["info"] = {
								["duration"] = 0.87,
								["path"] = "Sound\\SPELLS\\TRADESKILLS\\MiningHitE.ogg",
							},
							["type"] = "static",
						},
					},
					["version"] = 5,
					["guid"] = "9E8DDD7BD",
					["actionGuid"] = "sound_03",
					["portConnectionsIn"] = {
						["interrupt"] = {
							["instanceGuid"] = "9E8DDD7BC",
							["portGuid"] = "interrupted",
						},
						["setup"] = {
							["instanceGuid"] = "9E8DDD7BC",
							["portGuid"] = "onsetup",
						},
					},
					["portConnectionsOut"] = {
					},
					["outputs"] = {
					},
				}, -- [4]
				{
					["inputs"] = {
						["code"] = {
							["info"] = [[
								local _,_,_,_,objInsGuid = GetExecutionGuids();
								local obj = GetObjectInstance(objInsGuid);
								SpawnItemAsObject("9E9D52A6E",obj.GetPosition(),nil,1);
								obj.Consume(1);

							]],
							["type"] = "static",
						},
					},
					["version"] = 1,
					["guid"] = "1773_2C8CE11",
					["actionGuid"] = "script_01",
					["portConnectionsIn"] = {
						["setup"] = {
							["instanceGuid"] = "9E8DDD7BC",
							["portGuid"] = "finished",
						},
					},
					["portConnectionsOut"] = {
					},
					["outputs"] = {
					},
				}, -- [5]
			},
		},
	},
},"GHP_AbilityList","SetAbility";
end

