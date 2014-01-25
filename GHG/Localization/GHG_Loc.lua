--===================================================
--
--				GHG_Loc
--  			GHG_Loc.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHG_Loc()
	if class then
		return class;
	end
	class = {};
	local locale = GetLocale();

	local locs = {
	-- Rooster

		NAME = {
			enUS = "Name",
		},
		ZONE = {
			enUS = "Zone",
		},
		RACE = {
			enUS = "Race",
		},
		RANK = {
			enUS = "Rank",
		},
		LVL = {
			enUS = "Lvl",
		},
		CLS = {
			enUS = "Cls",
		},
		MSP_NAME = {
			enUS = "Flag/MRP Name",
		},
		MSP_TITLE = {
			enUS = "Flag/MRP Title",
		},
		GUILD = {
			enUS = "Guild",
		},
		GROUPCONTROL = {
			enUS = "Group control",
		},
		ADDGROUPMEMBER = {
			enUS = "Add member",
		},
		GROUP_INFORMATION = {
			enUS = "Group information",
		},
		GROUP_ROSTER_VIEW = {
			enUS = "View:",
		},
		SHOW_OFFLINE_GROUP_MEMBERS = {
		 	enUS = "Show Offline Members",
		},
		STATUS = {
			enUS = "Status",
		},
		ONLINE = {
			enUS = "Online",
		},
		LAST_ONLINE = {
			enUS = "Last Online",
		},
		UNKNOWN = {
			enUS = "Unknown",
		},
	-- Group info

		ADD_MEMBER = {
			enUS = "Add Member",
		},
		ADD_MEMBER_TEXT = {
			enUS = "Add Group Member:",
		},
		VIEW_LOG = {
			enUS = "View Log",
		},
		LEAVE_GROUP = {
			enUS = "Leave Group",
		},


	-- Group
		CREATE_NEW_GROUP = {
			enUS = "Create new group",
		},
		CREATE_GROUP_TEXT = {
			enUS = "Write a name of the group you would like to create",
		},
		ROSTER = {
			enUS = "Roster",
		},
		INFO = {
			enUS = "Info",
		},
		ADMIN = {
			enUS = "Admin",
		},

	-- chat config
		GENERAL = {
			enUS = "General",
		},
		GHG_GROUP_ADMIN = {
			enUS = "Group Administration",
		},
		GROUP_CHATS = {
			enUS = "Group Chats",
		},
		GHG_DEBUG = {
			enUS = "Debug Text",
		},
		GHG_GROUP_TOASTS = {
			enUS = "Group Toasts",
		},

	-- General
		GHG_LOADED = {
			enUS = "Gryphonheart Groups loaded.",
		},

		GHG = {
			enUS = "Gryphonheart Groups",
		},

	-- Invite
		INVITE_SEND = {
			enUS = "Group invite for %s send to %s.",
		},
		INVITE_RECEIVED = {
			enUS = "%2$s invited you to join the GH group %1$s.",
		},
		SEND_INVITE_ACCEPTED = {
			enUS = "%s accepted your group invitation.",
		},
		SEND_INVITE_DECLINED = {
			enUS = "%s declined your group invitation.",
		},
		PLAYER_JOINED = {
			enUS = "%s joined %s.",
		},
		INVITATION_TEXT = {
			enUS = "%2$s invites you to join the group: %1$s.",
		},
		PLAYER_REMOVED = {
			enUS = "%3$s have kicked %1$s from the group: %2$s",
		},

		-- Admin
		GROUP_NAME = {
			enUS = "Group Name",
		},
		GROUP_ICON = {
			enUS = "Icon",
		},
		RANKS = {
			enUS = "Group Ranks",
		},
		RANK_NAME = {
	   		enUS = "Rank name",
		},
		PERMISSONS = {
			enUS = "Permissions",
		},
		PROMOTE = {
			enUS = "Promote",
		},
		DEMOTE = {
			enUS = "Demote",
		},
		EDIT_RANK = {
			enUS = "Edit rank",
		},
		DELETE_RANK = {
			enUS = "Delete rank",
		},
		CAN_RANKS_PERM = {
			enUS = "Can edit ranks and permissions",
		},
		CAN_INVITE = {
			enUS = "Can invite to group",
		},
		CAN_KICK = {
			enUS = "Can kick player",
		},
		CAN_PROMOTE_DEMOTE = {
			enUS = "Can promote and demote",
		},
		CAN_EDIT_OFFICER_NOTE = {
			enUS = "Can edit officers note",
		},
		CAN_VIEW_OFFICER_NOTE = {
			enUS = "Can view officers note",
		},
		CAN_EDIT_PUBLIC_NOTE = {
			enUS = "Can edit public note",
		},
		CAN_VIEW_PUBLIC_NOTE = {
			enUS = "Can view public note",
		},
		CAN_TALK_IN_CHAT = {
			enUS = "Can talk in chat",
		},
		CAN_HEAR_CHAT = {
			enUS = "Can hear chat",
		},
		NEW_RANK = {
			enUS = "Add New Rank",
		},
		MOVE_UP = {
			enUS = "Move up",
		},
		MOVE_DOWN = {
			enUS = "Move down",
		},
		CHAT_NAME = {
			enUS = "Chat name",
		},
		CHAT_HEADER = {
			enUS = "Chat header",
		},
		CHAT_COLOR = {
			enUS = "Chat color",
		},
		CHAT_SLASH = {
			enUS = "Chat slash cmd",
		},
		CHAT_INFO_TEXT = {
			enUS = "Group chat (%s) accessible through /%s",
		},

		-- Promote demote
		PLAYER_PROMOTED = {
			enUS = "%2$s: %1$s have promoted %3$s to %4$s.",
		},
		PLAYER_DEMOTED = {
			enUS = "%2$s: %1$s have demoted %3$s to %4$s.",
		},

		REMOVE_MEMBER = {
			enUS = "Do you want to remove %s from the group %s",
		},
		LEAVE_CONFIRM = {
			enUS = "Are you sure that you want to leave the group: %s.",
		},

		-- Event log
		LOG = {
			enUS = "Log",
		},
		CLOSE = {
			enUS = "Close",
		},
		LOGEVENT_GROUP_CREATED = {
			enUS = "%s: %s created the group.",
		},
		LOGEVENT_MEMBER_INVITED = {
			enUS = "%s: %s invited %s to the group.",
		},
		TIME_AGO = {
			enUS = "%s ago",
		},
		JUST_NOW = {
			enUS = "Just now",
		},

	}


	local meta = getmetatable(class) or {};
	meta.__index = function(self,key)


		local texts = locs[key]
		if not(texts) then
			print("GHG Unknown localization:",key)
			return "UNKNOWN"
		end

		return texts[locale] or texts.enUS;
	end
	setmetatable(class,meta);
	return class;
end

