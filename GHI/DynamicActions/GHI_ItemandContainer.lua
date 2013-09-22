--===================================================
--
--				GHI_ItemandContainer
--  			GHI_ItemandContainer.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local category = "Item and Container";

table.insert(GHI_ProvidedDynamicActions, {
	name = "Open Bag",
	guid = "bag_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 2,
	order = 1,
	category = category,
	description = "This action opens a bag",
	icon = "Interface\\Icons\\inv_misc_bag_27",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[

	 --local bagAPI = GHI_ContainerAPI().GetAPI();

      local size = dyn.GetInput("size")
      local texture = dyn.GetInput("texture") or ""

      GHI_OpenBag(stack.GetContainerGuid(),stack.GetContainerSlot(),size,texture)
      dyn.TriggerOutPort("bagOpen")


	]],
	ports = {
		bagOpen = {
			name = "Bag open",
			order = 1,
			direction = "out",
			description = "When the bag opens.",
		},
	},
	inputs = {
		size = {
			name = "size",
			description = "the size of the bag",
			type = "string",
			defaultValue = "",
			numbersOnly = true,
		},
		texture = {
			name = "bag texture",
			description = "the texture of the bag",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Open Attached Tradeable Bag",
	guid = "bag_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 2,
	order = 1,
	category = category,
	description = "This action opens a bag that is tradeable. One unique bag is attached to each stack of the item. The item will be limited to a stacksize of 1.",
	icon = "Interface\\Icons\\inv_misc_bag_27",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	requiredDisabledMenuElements = {label="stackSize",value=1},
	script =
	[[

      local size = dyn.GetInput("size")
      local texture = dyn.GetInput("texture") or ""

      GHI_OpenBag(stack.GetContainerGuid(),stack.GetContainerSlot(),size,texture,true)
      dyn.TriggerOutPort("bagOpen")


	]],
	ports = {
		bagOpen = {
			name = "Bag open",
			order = 1,
			direction = "out",
			description = "When the bag opens.",
		},
	},
	inputs = {
		size = {
			name = "size",
			description = "the size of the bag",
			type = "string",
			defaultValue = "",
			numbersOnly = true,
		},
		texture = {
			name = "bag texture",
			description = "the texture of the bag",
			type = "string",
			defaultValue = "",
		},
	},
	outputs = {},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "Find GHI Item",
	guid = "bag_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	order = 2,
	category = category,
	description = "This action tries to find if you have a GHI item",
	icon = "Interface\\Icons\\inv_misc_bag_31",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
	   --local bagAPI = GHI_ContainerAPI().GetAPI();

	   local targetItem = dyn.GetInput("item")

	   local itemRes = GHI_FindOneItem(targetItem)

	   if itemRes then
	     dyn.TriggerOutPort("found")
	   else
	     dyn.TriggerOutPort("notFound")
	   end

	]],
	ports = {
		found = {
			name = "Item Found",
			order = 1,
			direction = "out",
			description = "If the item could be found",
		},
		notFound = {
			name = "Item Not Found.",
			direction = "out",
			order = 2,
			description = "If the item could not be found.",
		},
	},
	inputs = {
		item = {
			name = "GHI Item",
			description = "The item to be found",
			type = "item",
			defaultValue = "",
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Produce Item",
	guid = "prod_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 2,
	order = 2,
	category = category,
	description = "Produces a GHI item.",
	icon = "Interface\\AddOns\\GHM\\GHI_Icons\\_PlusSign_Priest",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[


	local targetItem = dyn.GetInput("item")
	local amount = dyn.GetInput("amount");
	GHI_ProduceItem(targetItem,amount);
	local text = dyn.GetInput("text")
	if type(text)=="string" and text:len() > 1 then
		GHI_Message(string.format("You %s: %s x%s.",text,GHI_GenerateLink(targetItem),amount));
	end

	]],
	inputs = {
		item = {
			name = "GHI Item",
			description = "The item to be produced",
			type = "item",
			defaultValue = "",
		},
		amount = {
			name = "Amount",
			description = "The amount to be produced",
			type = "number",
			defaultValue = 1,
		},
		text = {
			name = "Loot text",
			description = "Loot text to display",
			type = "string",
			defaultValue = "",
			specialGHM = "ghm_fromDDList",
			specialGHMScript = [[
			dataFunc = function()
				return {
					{
						value = "",
						text = "None",
					},
					{
						value = "loot",
						text = "Loot",
					},
					{
						value = "create",
						text = "Create",
					},
					{
						value = "craft",
						text = "Craft",
					},
					{
						value = "recieve",
						text = "Recieve",
					},
					{
						value = "produce",
						text = "Produce",
					},
				};
			end]],
		}
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Consume Item",
	guid = "cons_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	order = 3,
	category = category,
	description = "Consumes a GHI item.",
	icon = "Interface\\AddOns\\GHM\\GHI_Icons\\_MinusSign_Priest",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[


	local targetItem = dyn.GetInput("item")
	local amount = dyn.GetInput("amount");
	GHI_ConsumeItem(targetItem,amount);


	]],
	inputs = {
		item = {
			name = "GHI Item",
			description = "The item to be consumed",
			type = "item",
			defaultValue = "",
		},
		amount = {
			name = "Amount",
			description = "The amount to be consumed",
			type = "number",
			defaultValue = 1,
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Associate item data",
	guid = "item_x_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	order = 2,
	category = category,
	description = "Associates item data for another item with this item ",
	icon = "Interface\\AddOns\\GHM\\GHI_Icons\\_PlusSign_Shaman",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[
	]],
	inputs = {
		item = {
			name = "GHI Item",
			description = "The item to store data for",
			type = "item",
			defaultValue = "",
		},
	},
	outputs = {},
});


table.insert(GHI_ProvidedDynamicActions, {
	name = "Change stack size",
	guid = "stack_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	order = 3,
	category = category,
	description = "Changes the amount in the current stack (positively or negatively).",
	icon = "Interface\\AddOns\\GHM\\GHI_Icons\\_MinusSign_Priest",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[
		local amount = dyn.GetInput("amount");
		stack.ChangeInstanceAmount(amount);
	]],
	inputs = {
		amount = {
			name = "Amount",
			description = "The amount to change",
			type = "number",
			defaultValue = 0,
		},
	},
	outputs = {},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Use Item",
	guid = "use_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	order = 3,
	category = category,
	description = "Uses a GHI item.",
	icon = "Interface\\AddOns\\GHM\\GHI_Icons\\_AimedShot_Red",
	gotOnSetupPort = true,
	setupOnlyOnce = false,
	allowedInUpdateSequence = true,
	script =
	[[
		local targetItem = dyn.GetInput("item");
		GHI_UseItem(GHI_FindOneItem(targetItem));
	]],
	inputs = {
		item = {
			name = "GHI Item",
			description = "The item to be consumed",
			type = "item",
			defaultValue = "",
		},
	},
	outputs = {},
});