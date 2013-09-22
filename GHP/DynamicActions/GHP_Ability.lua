

local category = "GHP Ability";

table.insert(GHI_ProvidedDynamicActions, {
	name = "Perform Action",
	guid = "9E7942787",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	order = 1,
	category = category,
	description = "Displays the UI for perform action, awaiting an expression.",
	icon = "Interface\\Icons\\inv_pet_deweaonizedmechcompanion",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	script =
	[[
		DisplayPerformUI(dyn.GetInput("actionName"),function(tooltip)
			tooltip:AddLine(dyn.GetInput("actionName"));
			tooltip:AddLine(dyn.GetInput("actionDescription"),1,1,1,true);
		end,function()
			dyn.TriggerOutPort("firstActionPerformed");
		end);
	]],
	ports = {
		firstActionPerformed = {
			name = "First action performed",
			order = 1,
			direction = "out",
			description = "When the first expression for the action is performed",
		},
	},
	inputs = {
		actionName = {
			name = "Action name",
			description = "The name of the action",
			type = "string",
			defaultValue = "",
			order = 1,
		},
		actionDescription = {
			name = "Action description",
			description = "Description for the action, shown in tooltip",
			type = "text",
			defaultValue = "Describe how the action is performed in practice.",
			order = 2,
		},
	},
})

if GHI_DynamicActionList then GHI_DynamicActionList().LoadActions() end