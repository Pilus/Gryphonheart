--===================================================
--
--				GHP_Loc
--  			GHP_Loc.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHP_Loc()
	if class then
		return class;
	end
	class = {};
	local locale = GetLocale();


	local ability = {
		DYN_PORT_ABILITY_RUN_NAME = {
			enUS = "Ability run",
		},
		DYN_PORT_ABILITY_RUN_DESCRIPTION = {
			enUS = "Executed when the ability is run.",
		},
		ABILITY_NOT_READY_YET = {
			enUS = "Ability not ready yet."
		},
		ABILITY_TYPE_ = {
			enUS = "",
		},
		ABILITY_TYPE_interactionWithObjectOrItem = {
			enUS = "Through object",
		},
		ABILITY_TYPE_passive = {
			enUS = "Passive",
		},
	};

	local ui = {
		QUICK_NEARBY_OBJECTS = {
			enUS = "Nearby objects:",
		},
		QUICK_EQUIPPED_OBJECTS = {
			enUS = "Equipped objects:",
		},
		QUICK_WEIGHT = {
			enUS = "Weight:\n%.1f %s",
		},
		PERFORM_TEXT = {
			enUS = "Perform: %s",
		},
		DELAY_AUTO = {
			enUS = "Automatic delay"
		},
		DELAY_SEC = {
			enUS = "%s sec delay",
		},
		PERFORM_ADD = {
			enUS = "Add an additional expression to this performance [TAB].",
		},

	}

	local equip = {
		GHP_EQUIP_SLOT_NAME_MAINHAND = {
			enUS = "Main hand",
		},
		GHP_EQUIP_SLOT_NAME_OFFHAND = {
			enUS = "Offhand",
		},
		GHP_EQUIP_SLOT_NAME_SHEATH = {
			enUS = "Sheathed item",
		},
		GHP_EQUIP_SLOT_NAME_BAG = {
			enUS = "Bag",
		},
		GHP_EQUIP_SLOT_NAME_BELT = {
			enUS = "Item at belt",
		},

		PLAYER_NO_GHP = {
			enUS = "%s does not have GHP",
		},
		ACCEPT = {
			enUS = "Accept",
		},
		DENY = {
			enUS = "Deny",
		},
		HAND_TO = {
			enUS = "Hand item to",
		},
		HAND_ITEM = {
			enUS = "%s would like to hand you %sx%s%s. You must have your main hand GHP slot free",
		},
		GIVE_RECIEVER_HAND_ITEM = {
			enUS = "Please enter the nearby player you would like to hand the item to.",
		},
		HAND_TO_RECIEPENT_REJECTED = {
			enUS = "%s rejected the item.",
		},
		HAND_TO_RECIEPENT_ACCEPTED = {
			enUS = "%s accepted the item.",
		},
		HANDING_ITEM = {
			enUS = "Handing %s to %s...",
		},
		PICK_UP_ITEM = {
			enUS = "Pick up item",
		}
	}

	local meta = getmetatable(class) or {};
	meta.__index = function(self,key)


		local texts = ability[key] or ui[key] or equip[key];
		if not(texts) then
			print("GHP Unknown localization:",key)
			return "UNKNOWN"
		end

		return texts[locale] or texts.enUS;
	end
	setmetatable(class,meta);
	return class;
end

