
--===================================================
--
--				Loc
--  			Loc.lua
--
--	Holds the localization strings for GHI
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
local ss = "\195\159"; -- �
	local aa = "\195\164"; -- �
	local aaa = "\195\132"; -- �
	local uu = "\195\188"; -- �
	local uuu = "\195\156"; -- �
	local oo = "\195\182"; -- �
	local ooo = "\195\150"; -- �
function GHI_Loc()
	if class then
		return class;
	end
	class = {};

	local locale = GetLocale();
	
	local textsContainer = {
		BAG_BNT = {
			enUS = "GHI Backpack",
			deDE = "GHI Rucksack",
			frFR = "Sac GHI",
		},
		BAG_DRAG = {
			enUS = "Shift + click to drag the button.",
			deDE = "Shift-Klick zum verschieben.",
			frFR = "Maintenez Shift+click pour déplacer.",
		},
		NEW_ITEM = {
			enUS = "New Item",
			deDE = "Neues Item",
			frFR = "Nouvel objet",
		},
		NEW_MACRO = {
			enUS = "Item Macro",
		},
		NEW_ITEM_1LETTER = {
			enUS = "N",
			deDE = "N",
			frFR = "N",
		},
		NEW_ITEM_DETAILS = {
			enUS = "Open the menu for creation of a new item.",
		},
		EDIT_ITEM = {
			enUS = "Edit Item",
			deDE = "Item editieren",
			frFR = "Éditer l'objet",
		},
		EDIT_ITEM_1LETTER = {
			enUS = "E",
			deDE = "E",
			frFR = "E",
		},
		EDIT_ITEM_DETAILS = {
			enUS = "Edit one of your items.",
		},
		COPY_ITEM = {
			enUS = "Copy Item",
			deDE = "Item kopieren",
			frFR = "Copier l'objet",
		},
		COPY_ITEM_1LETTER = {
			enUS = "C",
			deDE = "K",
			frFR = "C",
		},
		COPY_ITEM_DETAILS = {
			enUS = "Create new copies of an existing item.",
		},
		HELP_OPTIONS = {
			enUS = "GHI Info and Options",
			deDE = "GHI Infos und Optionen",
			frFR = "Section d'aide de GHI, Infos et Options",
		},
		HELP_OPTIONS_DETAILS = {
			enUS = "Change options and settings for GHI.",
		},
		PREV_PAGE = {
			enUS = "Previous Backpack Page",
			deDE = "Vorherige Tasche",
			frFR = "Sac précédent",
		},
		PREV_PAGE_DETAILS = {
			enUS = "Change to the previous backpack page.",
		},
		NEXT_PAGE = {
			enUS = "Next Backpack Page",
			deDE = "Nächste Tasche",
			frFR = "Sac suivant",
		},
		NEXT_PAGE_DETAILS = {
			enUS = "Change to the next backpack page.",
		},
		COPY = { -- Button when the stack split frame is used for copying items
			enUS = "Copy",
			deDE = "Kopieren",
			frFR = "Copier",
		},
		CANNOT_COPY = {
			enUS = "You can not copy this item.",
		},
		EXPORT_ITEM = {
			enUS = "Export Item",
			deDE = "Exportiere Item",
			frFR = "Exporter l'objet",
		},
		EXPORT_ITEM_1LETTER = {
			enUS = "Ex",
			deDE = "Ex",
			frFR = "Ex",
		},
		EXPORT_ITEM_DETAILS = {
			enUS = "Exports an item into a code that can be copied and shared.",
		},
		IMPORT_ITEM = {
			enUS = "Import Item",
			deDE = "Importiere Item",
			frFR = "Importer l'objet",
		},
		IMPORT_ITEM_1LETTER = {
			enUS = "Im",
			deDE = "Im",
			frFR = "Im",
		},
		IMPORT_ITEM_DETAILS = {
			enUS = "Import an item from an import code from forums or given to you from other users.",
		},
		INSPECT_ITEM = {
			enUS = "Inspect Item",
		},
		INSPECT_ITEM_1LETTER = {
			enUS = "In",
		},
		INSPECT_ITEM_DETAILS = {
			enUS = "Display technical details of any item.",
		},
		EQD = {
			enUS = "GHI Equipment Display",
		},
		EQD_1LETTER = {
			enUS = "Eq",
		},
		EQD_DETAILS = {
			enUS = "Display the equipment display, allowing you to show what GHI items your character are wearing."
		},
		NEW_STD_ITEM = {
			enUS = "Standard Item",
		},
		NEW_ADV_ITEM = {
			enUS = "Advanced Item",
		},
		NEW_SIMP_ITEM = {
			enUS = "Simple Item Wizard",
		},
	};

	local textsOptionsMain = {
		FULL_NAME = {
			enUS = "Gryphonheart Items",
			deDE = "Gryphonheart Items",
			frFR = "Gryphonheart Items",
		},
		CREDITS = {
			enUS = "By The Gryphonheart Team.\nhttp://www.pilus.info",
			deDE = "Von die Gryphonheart Team.\nhttp://www.pilus.info",
			frFR = "Par the Gryphonheart Team.\nhttp://www.pilus.info",
		},
		ADDON_INFO = {
			enUS = "Information, tips, updates, ideas and feedback \ncan be found and given on the forum: \nhttp://www.pilus.info/forum",
			deDE = "Informationen, Tipps, Updates, Ideen und Rückmeldungen \nkönnt ihr im Forum finden und abgeben: \nhttp://www.pilus.info/forum",
			frFR = "Des informations, astuces, mise-à-jours, idées\n et reports \nPeuvent être trouvés et donnés sur le forum: \nhttp://www.pilus.info/forum",
		},
		BLOCK_STD_EMOTE = {
			enUS = "Hide next std emote after emote with \"   \"",
			deDE = "Verstecke nächstes Emote nach einem Emote mit \"   \"",
			frFR = "Cacher la prochaine émote std après une émote en \" \"",
		},
		CENTER_BUFFS = {
			enUS = "Center Buffs",
		},
		HIDE_EMPTY_SLOTS = {
			enUS = "Hide empty slots in Equipment Display",
		},
		REMOVE_BUFFS = {
			enUS = "Clear all buffs",
		},
		BLOCK_AREA_SOUND = {
			enUS = "Block all area sounds",
		},
		BLOCK_AREA_BUFFS = {
			enUS = "Block all area buffs",
		},
		TARGET_ICON = {
			enUS = "Target button display",
		},
		TARGET_ICON_FRIENDLY = {
			enUS = "All friendly",
		},
		TARGET_ICON_CONFIRMED = {
			enUS = "All confirmed GHI users",
		},
		TARGET_ICON_HIDE = {
			enUS =  "Always hide",
		},
		SHOW_AREA_SOUND_SENDER = {
			enUS = "Show sender of Area Sounds",
		},
		SOUND_PERMISSONS = {
			enUS = "Permissions for Area Sounds.",
		},
		CHAT_PERMISSONS = {
			enUS = "Permissions for Say, Emote, Etc.",
		},
		CHAT_PERMISSONS_ALLOW = {
			enUS = "Allow All",
		},
		CHAT_PERMISSONS_PROMT = {
			enUS = "Prompt First",
		},
		CHAT_PERMISSONS_BLOCK = {
			enUS = "Block All" ,
		},
		STICK_PLAYER_BUFFS = {
			enUS = "Show player buffs in the blizzard buffs frame",
		},
		STICK_TARGET_BUFFS = {
			enUS = "Show target buffs in the blizzard buffs frame",
		},
		NO_CHANNEL_COMM = {
			enUS = "Do not use channel for communication",
		},
		TOOLTIP_VERSION = {
			enUS = "Show the GHI version of other players in tooltip",
		},
		ONLINE_PLAYERS = {
			enUS = "Currenly detected amount of GHI users online on %s (%s):",
		},
		HIDE_MOD_ATT_TOOLTIP = {
			enUS = "Hide modify attribute text in the item tooltip",
		},
	};

	local textsOptionsWhitelist = {
		PERSONAL_SCRIPT_WHITELIST = {
			enUS = "Personal Script Whitelist",
		},
		PERSONAL_WHITELIST_INFO = {
			enUS = "Non whitelisted global variables can be whitelisted by adding them to this list. The white list is personal, a script with a non whitelisted function can only run as intended by players with the function on their whitelist.",
		},
		WHITELIST_RELOAD_WARN = {
			enUS = "A reload of the UI might be required for changes to take effect. Only one variable pr line.\nBe cautious, as some non whitelisted functions can be dangerous and open access to damaging items.",
		},
		WHITELIST_TITLE = {
			enUS = "Personal Whitelist",
		},
	};

	local textsOptionsDebug = {
		DEBUG_EVENT_LOG = {
			enUS = "GHI Debug Event Log",
		},
	};
	local textsOptionsBag = {
		BACKPACK_ICON = {
			enUS = "GHI Backpack Icon",
			deDE = "GHI Rucksack Icon",
			frFR = "Icon du sac GHI",
		},
		ICON_SHAPE = {
			enUS = "Icon Shape",
		},
		ICON_SHAPE_SQUARED = {
			enUS = "Squared",
		},
		ICON_SHAPE_ROUND = {
			enUS = "Round",
		},
		ICON = {
			enUS = "Icon:",
			deDE = "Icon:",
			frFR = "Icône:",
		},
		SCALE = {
			enUS = "Scale:",
			deDE = "Größe:",
			frFR = "Échelle:",
		},
		CENTER_ICON = {
			enUS = "Reset Icon Position",
			deDE = "Zentriere Icon",
			frFR = "Centrer l'icône",
		},
	};

	local textsOptionsAppearance = {
		CLASSIC_THEME = {
			enUS = "GHI Classic Theme",
		},
		THEME_2_0 = {
			enUS = "GHI 2.0 Theme",
		},
		NEW_THEME = {
			enUS = "New Theme",
		},
		PRESET_THEME = {
			enUS = "Preset Theme:",
		},
		LOAD_THEME = {
			enUS = "Load",
		},
		SAVE_THEME = {
			enUS = "Save",
		},
		DELETE_THEME = {
			enUS = "Delete",
		},
		BACKGROUND = {
			enUS = "Background:",
		},
		ANIMATION = {
			enUS = "Show animation when opening menus",
		},
		MENU_UNIFY_TEXT = {
			enUS = "Unify Text Colors",
		},
		MENU_UNIFY_TEXT_TT = {
			enUS = "Unifies all text to match the Main Text color.",
		},
		MENU_UNIFY_WINDOW = {
			enUS = "Unify Window Colors",
		},
		MENU_UNIFY_WINDOW_TT = {
			enUS = "Unifies all window colors to match the Window Header color.",
		},
		MENU_BG_ALPHA = {
			enUS = "BG Alpha:",
		},
		MENU_COLORS = {
			enUS = "Colors",
		},
		MENU_COLORS_U = {
			enUS = "Colors:",
		},
		MENU_WINDOW_COLORS = {
			enUS = "Window Colors:",
		},
		MENU_WARN_RELOG = {
			enUS = "Some changes might first apply after a reload or relog.",
		},
		MENU_APPEARANCE = {
			enUS = "Menu Appearance",
		},
		MENU_APPEARANCE_TEXT = {
			enUS = "Customize the look of all the GHI menus with the options below, or select one of the preset setups.",
		},
		TITLE_BAR_COLOR = {
			enUS = "Title bar color",
		},
		TITLE_BAR_TEXT_COLOR = {
			enUS = "Title Bar Text Color",
		},
		BACKGROUND_COLOR = {
			enUS = "Background Color",
		},
		BUTTON_COLOR = {
			enUS = "Button Color"
		},
		MAIN_TEXT_COLOR = {
			enUS = "Main Text Color",
		},
		DETAILS_TEXT_COLOR = {
			enUS = "Details Text Color",
		},
		THEME_NAME = {
			enUS = "Please enter a name for the theme.",
		},
		TITLE_BAR_COLOR_TT = {
			enUS = "Sets the color of the title bar.",
		},
		TITLE_BAR_TEXT_COLOR_TT = {
			enUS = "Sets the color of the text in the title bar.",
		},
		BACKGROUND_COLOR_TT = {
			enUS = "Sets the background color of the frame, visible where no background texture is.",
		},
		BUTTON_COLOR_TT = {
			enUS = "Sets the color of buttons."
		},
		MAIN_TEXT_COLOR_TT = {
			enUS = "Sets the color of the widget labels.",
		},
		DETAILS_TEXT_COLOR_TT = {
			enUS = "Sets the color of details text.",
		},
	};

	local textsDynamicActionArea = {
		CONNECTION = {
			enUS = "Connection",
		},
		TEST_ACTION = {
			enUS = "Test Run Action",
		},
		DELETE_CONNECT = {
			enUS = "Delete Connection",
		},
		EDIT_CONNECT = {
			enUS = "Edit Connection",
		},
		DYN_AREA_TIPEDIT = {
			enUS = "Click to edit / delete the connection or test the actions.",

		},
		DYN_AREA_TIPADD = {
			enUS = "Click to add new action connected to this port.",
		},

	};

	local textsIconFrame = {
		ICON_SHIFT_TIP = {
			enUS = "Hold down shift to see the paths of the icons.",
		},
		ICON_CHOOSE = {
			enUS = "Choose Icon",
		},
		ICON_CATAGORY = {
			enUS = "Category:",
		},
		ICON_SUBCAT = {
			enUS = "Subcategory:",
		},
		ICON_SEARCH = {
			enUS = "Search text:",
		},
		ICON_SEARCH_TT = {
			enUS = "Press Enter to search.",
		},
		ICON_UNDO = {
			enUS = "Undo",
		},
		ICON_CLOSE = {
			enUS = "Close",
		},
		ICON_TEXT = {
			enUS = "Icon",
		},
		ICON_TYPE_SHOWN = {
			enUS = "Icon Types Shown"
		},
		ICON_TYPE_1 = {
			enUS="All Icons",
		},
		ICON_TYPE_2 = {
			enUS = "WoW Icons",
		},
		ICON_TYPE_3 = {
			enUS= "Custom GHI Icons",
		},
		ICON_OR = {
			enUS = "OR",
		},
	};

	local textsBookUI = {
		EDIT_TEXT = {
			enUS = "Edit Text",
			deDE = "Text editieren",
			frFR = "Éditer le texte",
		},
		EDIT_BOOK = {
			enUS = "Edit Book",
		},
		EDIT_INFO_TEXT = {
			enUS = "The book information can only be edited by you, unless the item is flagged as 'Editable by others",
		},
		MARK_TEXT = {
			enUS = "Mark Text",
			deDE = "Text markieren",
			frFR = "Marquer le texte",
		},
		VIEW_TEXT = {
			enUS = "View Text",
			deDE = "Text zeigen",
			frFR = "Voir le texte",
		},
		UNDO_CHANGES = {
			enUS = "Undo Changes",
			deDE = "R" .. uu .. "ckg" .. aa .. "ngig",
			frFR = "Annuler les changements",
		},
		TITLE = {
			enUS = "Book Title:",
			deDE = "Titel:",
			frFR = "Titre:",
		},
		DELETE_PAGE = {
			enUS = "Delete Page",
			deDE = "Seite l" .. oo .. "schen",
			frFR = "Supprimer la page",
		},
		INSERT_BEFORE = {
			enUS = "Before This",
			deDE = "Vor dieser",
			frFR = "Avant ça...",
		},
		INSERT_AFTER = {
			enUS = "After This",
			deDE = "Nach dieser",
			frFR = "Après ça...",
		},
		INSERT_PAGE = {
			enUS = "Insert Page:",
			deDE = "Seite einf" .. uu .. "gen:",
			frFR = "Insérer la page :",
		},
		INSERT_PAGE_BEFORE = {
			enUS = "Insert page before this page",
		},
		INSERT_PAGE_AFTER = {
			enUS = "Insert page after this page",
		},
		MATERIAL = {
			enUS = "Material:",
			deDE = "Material:",
			frFR = "Matière :",
		},
		PARCHMENT = {
			enUS = "Parchment",
			deDE = "Pergament",
			frFR = "Parchemin",
		},
		STONE = {
			enUS = "Stone",
			deDE = "Stein",
			frFR = "Pierre",
		},
		BRONZE = {
			enUS = "Bronze",
			deDE = "Bronze",
			frFR = "Bronze",
		},
		MARBLE = {
			enUS = "Marble",
			deDE = "Marmor",
			frFR = "Marbre",
		},
		SILVER = {
			enUS = "Silver",
			deDE = "Silber",
			frFR = "Argent",
		},
		VALENTINE = {
			enUS = "Valentine",
			deDE = "Valentinskarte",
			frFR = "St Valentin",
		},
		HEADLINE_1 = {
			enUS = "Headline 1",
			deDE = "" .. uuu .. "berschrift 1",
			frFR = "Gros titre 1",
		},
		HEADLINE_2 = {
			enUS = "Headline 2",
			deDE = "" .. uuu .. "berschrift 2",
			frFR = "Gros titre 2",
		},
		FRONT = {
			enUS = "Font:",
			deDE = "Schriftart:",
			frFR = "Police :",
		},
		H1 = {
			enUS = "H1:",
			deDE = "" .. uuu .. "bers.1:",
			frFR = "H1 :",
		},
		H2 = {
			enUS = "H2:",
			deDE = "" .. uuu .. "bers.2:",
			frFR = "H2 :",
		},
		NORMAL = {
			enUS = "Normal",
			deDE = "Normal",
			frFR = "Normal",
		},
		FONT_SIZE2 = {
			enUS = "Font Size:",
			deDE = "Schriftgr" .. oo .. "" .. ss .. "e",
			frFR = "Taille de la police :",
		},

		INSERT_LINK = {
			enUS = "Insert Link",
			deDE = "Link einf" .. uu .. "gen",
			frFR = "Insérer un lien",
		},
		INSERT_LOGO = {
			enUS = "Insert Logo",
			deDE = "Logo einf" .. uu .. "gen",
			frFR = "Insérer un logo",
		},
		INSERT_IMAGE = {
			enUS = "Insert Image",
		},
		INSERT_ICON = {
			enUS = "Insert Icon",
		},
		ALIGNMENT = {
			enUS = "Text Alignment",
		},
		LOGO = {
			enUS = "Logo:",
			deDE = "Logo:",
			frFR = "Logo :",
		},
		ALLIGNMENT = {
			enUS = "Alignment:",
			deDE ="Ausrichtung:",
			frFR = "Alignement :",
		},
		LEFT = {
			enUS = "Left",
			deDE = "links",
			frFR = "Gauche",
		},
		CENTER = {
			enUS = "Center",
		},
		RIGHT = {
			enUS = "Right",
		},
		INSERT = {
			enUS = "Insert",
			deDE = "einf" .. uu .. "gen",
			frFR = "Insérer",
		},
		TRANSCRIBE = {
			enUS = "Transcribe to GHI",
			deDE = "" .. uuu .. "bertragen zu GHI",
			frFR = "Retranscrire dans GHI",
		},
		NEW_TITLE = {
			enUS = "New title",
			deDE = "neuer Titel",
			frFR = "Nouveau titre",
		},

		TRANSCRIBED = {
			enUS = "Transcribed",
			deDE =  "" .. uu .. "bertragen",
			frFR = "Retranscrit!",
		},
		LETTER = {
			enUS = "Letter",
			deDE = "GHI Brief",
			frFR = "Lettre",
		},
		READ_LETTER = {
			enUS = "Read the letter",
			deDE = "Brief lesen",
			frFR = "Lire la lettre",
		},
		INSCRIPTION = {
			enUS = "Inscription",
			deDE = "Inschrift",
			frFR = "Inscription",
		},
		READ_INCRIPTION = {
			enUS = "Read the inscription",
			deDE = "Inschrift lesen",
			frFR = "Lire l'inscription",
		},
		FROM = {
			enUS = "From",
			deDE = "von",
			frFR = "de",
		},
		CONFIRM_DELETE_PAGE ={
			enUS = "Delete this page?",
			deDE = "Diese Seite l" .. oo .. "schen?",
			frFR = "Êtes-vous sûr de vouloir supprimer cette page?",
		},
		ENTER_PAGE_NUMBER = {
			enUS = "Enter pagenumber to link to",
			deDE = "Trage die zu verlinkende Seitennummer ein.",
			frFR = "Indiquer le numéro de la page à lier à",
		},

		ENTER_LINK_TEXT ={
			enUS = "Enter link text",
			deDE = "F" .. uu .. "ge Linktext ein",
			frFR = "Indiquer le lien textuel",
		},
		PAGE_OF_PAGES = {
			enUS = "%s of %s"
		},
		NEXT_BOOK_PAGE = {
			enUS = "Go to next page",
		},
		PREV_BOOK_PAGE = {
			enUS = "Go to previous page",
		},
	};

	local textsPosInput = {--GHM_Position
		SET_CURRENT = {
			enUS = "Set to current loc.",
		},
	};

	local textsSoundSelection = {
		SOUND = {
			enUS = "Sound",
		},
		SOUND_EX = {
			enUS = "Enter a sound filepath and a delay. \nE.g.   Sound\\Creature\\Murloc\\mMurlocAggroOld.wav",
		},
		SELECT_SOUND = {
			enUS = "Select sound",
		},
		NO_SOUND_SELECTED = {
			enUS = "No sound selected",
		},
		SOUND_SEL = {
			enUS = "Please select the sound file you want to be played for the user of the item.",
		},
		SELECT_SOUND_INSTRUCTION = {
			enUS = "Please select a sound to use.",
		},
		CURRENTLY_SELECTED = {
			enUS = "Currently Selected:",
		},
		SEARCH_TEXT = {
			enUS = "Search text:",
		},
		SELECT_ICON = {
			enUS = "Select icon",
		},
}

	local textsVarAttInput = {--ghm_VarAttInput
		ADD_NEW_ATT = {
			enUS = "< Add new attribute >",
		},
		TAB_ATT = {
			enUS = "Att",
		},
		ATT_TIP = {
			enUS = "Use an attribute as input.",
		},
		TAB_STAT = {
			enUS = "Static",
		},
		STATIC_TIP = {
			enUS = "Use a static input.",
		},
		TAB_VAR = {
			enUS = "Var",
		},
		VAR_TIP = {
			enUS = "Use a variable as input.",
		},
	};


	local textsImportExport = {
		CAN_NOT_EXPORT = {
			enUS = "You do not have permission or access to export this item.",
			deDE = "Du kannst dieses item nicht importieren.",
			frFR = "Vous n'avez pas la permission ou les accès pour exporter cet objet, petit sacripant.",
		},
		EXPORT ={
			enUS = "Export Item",
			deDE = "Exportiere Item",
			frFR = "Exporter l'objet",
		},
		EXPORT_TEXT ={
			enUS ="You can copy the code by marking it all (alt+a) and then press alt+c to copy it.\nYou can then paste it where you want to distribute it: On forums, over instant messengers to friends or on another character.",
			deDE = "Du kannst den Text kopieren, indem du ihn markierst(alt+a) und dann alt+c dr" .. uu .. "ckst um ihn zu kopieren.\nDu kannst ihn dann mit alt+v einf" .. uu .. "gen, wo du m" .. oo .. "chtest: In Forums, " .. uu .. "ber Instant Messengers deinen Freunden oder an andere Charaktere.",
			frFR = "Vous pouvez copier le code en surlignant tout (CTRL+A) et en appuyant sur CTRL+C pour le copier.\n Vous pouvez ensuite le coller où vous voulez pour le distribuer au bon peuple : sur des forums, sur MSN, ou même à d'autres personnages!",
		},

		CAN_NOT_PRODUCE_OFFICIAL ={
			enUS = "You can not produce an official GHI item.",
			deDE = "Du kannst kein offizielles GHI Item erstellen.",
			frFR = "Vous ne pouvez pas produire un objet officiel de GHI.",
		},
		CAN_NOT_PRODUCE_ITEM ={
			enUS = "You can not produce the item.",
			deDE ="Du kannst das Item nicht erstellen.",
			frFR = "Vous ne pouvez pas produire l'objet!",
		},
		CAN_NOT_FIND_ITEM ={
			enUS = "The item could not be found. GUID: %s.",
			deDE = "Das Item wurde nicht gefunden. GUID: %s.",
			frFR = "L'objet n'a pas pu être trouvé. GUID: %s.",
		},

		CAN_NOT_IMPORT ={
			enUS = "Can not import item.",
			deDE = "Du kannst dieses item nicht importieren.",
			frFR = "N'a pas pu importer l'objet.",
		},
		EXPORT_1LETTER ={
			enUS = "Ex",
			deDE = "Exp",
			frFR = "Ex",
		},
		IMPORT_1LETTER ={
			enUS = "Im",
			deDE = "Imp",
			frFR = "Im",
		},

		TOTAL_PR_CHAR ={
			enUS = "Total per char.",
			deDE = "Gesammt pro Charakter",
			frFR = "Total pr. char.",
		},
		NONE ={
			enUS = "None",
			deDE = "nichts",
			frFR = "Aucun",
		},
		CHARS ={
			enUS = "Character(s)",
			deDE ="Charakter(e)",
			frFR = "Personnage(s)",
		},
		GUILDS ={
			enUS = "Guild(s)",
			deDE = "Gilde(n)",
			frFR = "Guilde(s)",
		},
		ACCOUNTS ={
			enUS = "Account(s)",
			deDE = "Account(s)",
			frFR = "Compte(s)",
		},
		REALMS ={
			enUS = "Realm(s)",
			deDE = "Realm(s)",
			frFR = "Royaume(s)",
		},
		LIMITED_TO ={
			enUS = "Limited to:",
			deDE = "Beschr" .. aa .. "nkt auf:",
			frFR = "Limité à :",
		},
		NAMES ={
			enUS = "Name(s):",
			deDE = "Name(n):",
			frFR = "Nom(s) :",
		},
		CHANGE_ID ={
			enUS = "Give the item a new GUID",
			deDE = "Gib dem Item eine neue GUID",
			frFR = "Donner un nouvel GUID à l'objet",
		},
		CHANGE_USER ={
			enUS = "Change author to be the importing user",
			deDE = "" .. aaa .. "ndere Ersteller auf den importierenden Nutzer",
			frFR = "Remplacer le créateur par l'utilisateur qui est en train d'importer",
		},
		EXPORT_LIMITATION_TEXT ={
			enUS = "Several names of limitations can be entered by seperating them with a comma.",
			deDE = "Mehrere Namen als Limitierung k" .. oo .. "nnen angegeben werden(komma separiert).",
			frFR = "Plusieurs noms de limitations peuvent être entrés en les séparant par des virgules.",
		},
		ITEM_INFO ={
			enUS = "Item Info:",

		},

		IMPORT ={
			enUS = "Import Item",
			deDE = "Importiere Item",
			frFR = "Importer l'objet",

		},
		IMPORT_INSTRUCTION ={
			enUS ="Please paste the item code into the field and press import to import the item.",
			deDE = "Bitte f" .. uu .. "ge den Item Code in das Feld ein und dr" .. uu .. "cke Import um das Item zu importieren.",
			frFR = "Collez ici le code de l'objet et appuyez sur le bouton Importer pour importer l'objet.",
		},
		IMPORT_REPORT ={
			enUS = "Imported: %sx %s.",
			deDE = "Importiert: %sx %s.",
			frFR = "Importé : %sx %s.",
		},
		EXPORT_LUA_STATEMENT = {
			enUS = "Lua-statement",
		},
		AMOUNT = {
			enUS = "Amount:",
			deDE = "Anzahl:",
			frFR =  "Quantité:",

		},
		AMOUNT_INSTRUCTION = {
			enUS = "~Description here, wasn't in locale and i am not good at them sometimes~"
		},

	};

	local textsWizard = {
		BACK = {
			enUS = "< Back",
		},
		NEXT = {
			enUS = "Next \62",
		},
		FINISH = {
			enUS = "Finish",
		},
		TIME = {
			enUS = "Time:",
		},

	};

	local textsStandardMenu = {
		HELP = {
			enUS = "Help",
		},
		NAME = {
			enUS = "Name:",
			deDE = "Name:",
			frFR = "Nom:",
		},
		NAME_TT = {
			enUS = "Enter a name for the item.",
		},
		QUALITY = {
			enUS ="Quality:",
			deDE = "Qualit" .. aa .. "t:",
			frFR = "Qualité:",
		},

		QUALITY_TT = {
			enUS ="Quality Color of the item.",
		},

		WHITE_TEXT_1 = {
			enUS = "White text 1:",
			deDE = "Wei" .. ss .. "er Text 1:",
			frFR = "Texte en blanc 1:",
		},

		WHITE_TEXT_1_TT = {
			enUS = "White text 1, EX: Soulbound, Hat,Pants,Armor",
		},
		WHITE_TEXT_2 ={
			enUS="White text 2:",
			deDE = "Wei" .. ss .. "er Text 2:",
			frFR = "Texte en blanc 2:",
		},

		WHITE_TEXT_2_TT = {
			enUS = "White text 2, EX: Soulbound, Hat,Pants,Armor, Made up stats",
		},
		YELLOW_QUOTE = {
			enUS = "Yellow quoted text:",
			deDE = "Gelb gef" .. aa .. "rbter Text:",
			frFR = "Texte de citation en jaune:",
		},
		YELLOW_QUOTE_TT = {
			enUS = "Yellow quoted text for 'flavor' or description.",
		},

		STACK_SIZE = {
			enUS = "Stack Size:",
			deDE = "Stapelgr" .. oo .. "" .. ss .. "e:",
			frFR = "Quantité max:",
		},

		STACK_SIZE_TT = {
			enUS = "Stack Size, How high the item can stack, 1 means non stackable.",

		},
		COPYABLE = {
			enUS = "Copyable by others",
			deDE = "kopierbar von Anderen",
			frFR = "Peut être copié par les autres",
		},

		COPYABLE_TT = {
			enUS = "Sets if the Item is copyable by other users.",
		},
		EDITABLE = {
			enUS = "Editable by others",
		},
		EDITABLE_TT = {
			enUS = "Sets if item can be EDITED By users other then you.",
		},
		USE = {
			enUS = "Use:",
			deDE = "Benutzen:",
			frFR = "Utiliser:",
		},
		USE_TT = {
			enUS = "The use Text (such as Use:Equip), Can be left blank.",

		},
		MADE_BY = {
			enUS = "Made by",
		},
		ITEM_CD = {
			enUS = "Item cooldown:",
			deDE = "Abklingzeit:",
			frFR = "Temps de recharge de l'objet:",
		},
		ITEM_CD_TT = {
			enUS = "The cooldown before the item can be used again.",

		},
		CD_LEFT = {
			enUS = "Cooldown remaining:",
			deDE = "Verbleibende Abklingzeit:",
			frFR = "Temps de recharge restant:",
		},
		CONSUMED ={
			enUS = "Consumed",
			deDE = "Wird verbraucht",
			frFR = "Consommé",
		},
		CONSUMED_TT ={
			enUS = "Sets if item is consumed on use.",

		},
		MENU_ERR = {
			enUS = "Menu for %s not found.",
		},
		CONVERT_ADV_ITEM = {
			enUS = "Convert to \nadvanced item",

		},
		NEW_ACTION = {
			enUS = "Add new action",
			deDE = "Neue hinzuf" .. uu .. "gen",
			frFR = "Ajouter nouveau",
		},
		DELETE_ACTION = {
			enUS = "Delete",
			deDE = "L" .. oo .. "schen",
			frFR = "Supprimer",
		},
		EDIT_ACTION = {
			enUS = "Edit",
			deDE = "Editieren",
			frFR = "Éditer",
		},
		DETAILS = {
			enUS = "Details",
			deDE = "Details",
			frFR = "Détails",
		},
		TYPE_U = {
			enUS = "Type",
			deDE = "Art",
			frFR = "Type",
		},
		CREATE_TITLE = {
			enUS = "Create new GHI item",
			deDE = "Erstelle neues GHI Item",
			frFR = "Créer un nouvel objet",
		},
		CAN_NOT_EDIT = {
			enUS = "You do not have permission to edit that item.",
		},
		PREVIEW = {
			enUS = "Item Preview:",
		},
		ITEMTYPE_CUSTOM_MADE = {
			enUS = "Custom Made Item",
		},
		ITEMTYPE_CONTRIBUTE = {
			enUS = "~Contributing Item~",
		},
		ITEMTYPE_OLD = {
			enUS = "Item from old version",
		},
		ITEMTYPE_OFFICAL = {
			enUS = "Offcial Item",
		},
		ACTION_NOTE = {
			enUS = "Press 'Add new action' to add one or more actions to the item.",
		},
	};
	local textsSTDBagMenu = {
		BAG = {
			enUS = "Bag",
			deDE = "Tasche",
			frFR = "Sac",

		},
		NORMAL = {
			enUS = "Normal",
			deDE = "Normal",
			frFR = "Normal",

		},
		BANK = {
			enUS = "Bank",
			deDE = "Bank",
			frFR = "Banque",

		},
		KEYRING = {
			enUS = "Keyring",
			deDE = "Schl" .. uu .. "sselring",
			frFR = "Trousseau de clés",

		},
		SLOTS_NUMBER = {
			enUS = "%s slots",


		},
		BAG_TEXT = {
			enUS = "Makes the item serve like a bagpack of the defined size, allowing you to organise and store other items in it.",

		},
		BAG_TRADEABLE = {
			enUS = "Tradeable bag, (stacksize limited to 1).",
		},
		TRADE_BAG_VERSION_ERROR = {
			enUS = "You can only trade bags to players with GHI v.2.1.2 or newer.",
		},
		SLOTS = {
			enUS = "Slots",
			deDE = "Pl" .. aa .. "tze:",
			frFR = "Emplacements :",
		},
		TEXTURE = {
			enUS = "Texture",
			deDE = "Aussehen:",
			frFR = "Texture :",
		},
		STACK_ORDER_TEXT = {
			enUS = "Item instance placed on top:",
		},
		STACK_ORDER_LAST = {
			enUS = "last instance placed",
		},
		STACK_ORDER_FIRST = {
			enUS = "first instance placed",
		},
		STACK_ORDER_BIGGEST = {
			enUS = "biggest instance",
		},
		STACK_ORDER_SMALLEST = {
			enUS = "smallest instance",
		},
	};
	local textsBookMenu = {
		BOOK = {
			enUS = "Book",
			deDE = "Buch",
			frFR = "Livre",
		},
		TITLE = {
			enUS = "Title:",
			deDE = "Titel:",
			frFR = "Titre:",

		},
		TITLE_TEXT = {
			enUS = "The action shows a book. You can edit the book by clicking the item and running the action.",
			deDE = "Bitte trage oben einen Titel ein. Der Titel und viele weitere Buchbezogene Informationen, k" .. oo .. "nnen sp" .. aa .. "ter im Buch-Editieren-Men" .. uu .. " ge" .. aa .. "ndert werden.",
			frFR = "Vous être prié d'entrer un titre ci-dessus. Les titres et de nombreuses autres informations liées aux livres pourront être changées plus tard dans le menu d'édition.",
		},
	};

	local textsBuffMenu = {
		BUFF = {
			enUS = "Buff",
			deDE = "Buff",
			frFR = "",
		},
		BUFF_TEXT = {
			enUS = "This action casts a buff on yourself or your target. The buff is visible to all other users of GHI.\nIf a range is defined, it will be cast on all GHI users around you.",
			deDE = "",
			frFR = "",
		},
		BUFF_NAME = {
			enUS = "Buff Name:",
			deDE = "BuffName:",
			frFR = "Nom du Buff:",
		},
		BUFF_DETAILS = {
			enUS = "Buff Details:",
			deDE = "Buffdetails:",
			frFR = "Détails sur le Buff:",
		},
		BUFF_DURATION = {
			enUS = "Buff Duration:",
			deDE = "Buffwirkungsdauer:",
			frFR = "Durée du Buff:",
		},
		BUFF_UNTIL_CANCELED = {
			enUS = "Last Until Canceled",
			deDE = "H" .. aa .. "lt bis er abgebrochen wird",
			frFR = "Restant avec annulation",
		},
		BUFF_ON_SELF = {
			enUS = "Cast On Self",
			deDE = "Immer auf einen selbst wirken",
			frFR = "Toujours lancer sur soi-même",
		},
		BUFF_DEBUFF = {
			enUS = "Buff / Debuff",
			deDE = "Buff / Debuff:",
			frFR  = "Buff / Debuff :",

		},
		HELPFUL = {
			enUS = "Helpful",
			deDE = "Hilfreich",
			frFR = "Bénéfique",

		},
		HARMFUL = {
			enUS = "Harmful",
			deDE = "Sch" .. aa .. "dlich",
			frFR = "Néfaste",

		},
		STACKABLE = {
			enUS = "Stackable",
			deDE = "Stapelbar",
			frFR = "Empilable",

		},
		BUFF_TYPE = {
			enUS = "Buff Type",
			deDE = "Buffart:",
			frFR = "Type de Buff :",

		},
		DELAY = {
			enUS = "Delay",
			deDE = "Verz" .. oo .. "gerung:",
			frFR = "Délais :",
		},
		RANGE = {
			enUS = "Range",
		},
		TYPE_CURSE = {
			enUS = "Curse",
		},
		TYPE_MAGIC = {
			enUS = "Magic",
		},
		TYPE_DISEASE = {
			enUS = "Disease",

		},
		TYPE_POISON = {
			enUS = "Poison",

		},
		TYPE_PHYSICAL = {
			enUS = "Physical",
		},
	};

	local textsEquipItem = {
		EQUIP_ITEM = {
			enUS = "Equip Item",
			deDE = "Item anlegen",
			frFR = "Équiper l'objet",
		},
		EQUIP_ITEM_TEXT = {
			enUS = "Please enter the EXACT name of an real item in your bags to equip.\n if you wish to delay equipping enter a delay in seconds.",
			frFR = "",
		},
		ITEM_NAME = {
			enUS = "Item Name:",

			frFR = "Nom de l'objet:",
		},

	};

	local textsConsumeItem = {
		CONSUME = {
			enUS = "Consume Item",
			deDE = "Verbrauche Item",
			frFR = "Consommer l'objet",
		},
		NO_ITEM_SELECTED = {
			enUS = "No item selected",
			deDE = "kein Item gew" .. aa .. "hlt",
			frFR = "Aucun objet sélectionné",
		},
		CONSUME_TEXT = {
			enUS = "Please enter the amount to be consumed. Select the item by pressing the \"Choose Item\" button and select the desired GHI item.",
			deDE = "Bitte gib die Anzahl an die verbraucht wird. W" .. aa .. "hle ein Item durch dr" .. uu .. "cken des \"Item w" .. aa .. "hlen.\" Knopfes and w" .. aa .. "hle das gew" .. uu .. "nschte Item in deinem GHI Rucksack.",
			frFR = "Entrez ici le montant d'objets consommés. Sélectionnez un objet en appuyant sur le bouton \"Choisir objet.\" et sélectionnez l'objet souhaité dans votre sac GHI.",
		},
		CHOOSE_ITEM = {
			enUS = "Choose Item",
			deDE = "Item w" .. aa .. "hlen",
			frFR = "Choisir un objet",
		},
		NO_ITEM_CHOOSEN = {
			enUS = "No item choosen",
		},
		NOT_SOURCE_ID = {
			enUS = "Could Note Identify Source ID.",
			deDE = "Konnte Quell ID nicht identifizieren.",
			frFR = "N'a pas pu identifier la source ID.",

		},

	};

	local textsExpressionMenu = {
		TEXT = {
			enUS = "Text:",
			deDE = "Text:",
			frFR = "Texte :",
		},
		TYPE = {
			enUS = "Type:",
			deDE = "Art:",
			frFR = "Type:",
		},

		SAY ={
			enUS = "Say",
			deDE = "Sagen",
			frFR = "Dire",
		},
		EMOTE = {
			enUS = "Emote",
			deDE = "Emote",
			frFR = "Émote",
		},
		EXPRESSION_TEXT = {
			enUS = "The expression action makes your character say the text or do an emote.",
			deDE = "Bitte trage die Ausdrucksart, dessen Text und eventuell eine Abklingzeit/Pausezeit zwischen den Ausdr" .. uu .. "cken/Emotes (in Sek.) ein. \nSchreibe %L, um einen Link eines Items einzuf" .. uu .. "gen.",
			frFR = "Vous êtes prié d'entrer un type d'expression, son texte et son éventuel délais en secondes. \nÉcrire %L pour insérer un lien vers l'objet.",
		},
		EXPRESSION = {
			enUS = "Expression",
			deDE = "Ausdruck",
			frFR = "Expression",
		},
		EXPRESSIONS = {
			enUS = "Expressions",
			deDE = "Ausdr" .. uu .. "cke",
			frFR = "Expressions",
		},
		RANDOM_EXPRESSION = {
			enUS = "Random Expression",
			deDE = "zuf" .. aa .. "llige Ausdr" .. uu .. "cke",
			frFR = "Expression aléatoire",
		},
		RANDOM_EXPRESSION_TEXT = {
			enUS = "Please choose the expression types and enter their text. Each will be randomly chosen and run. Empty fields will be ignored.",
			deDE = "Bitte w" .. aa .. "hle die Ausdrucksarten und trage ihren Text ein. Jeder Ausdruck wird zuf" .. aa .. "llig gew" .. aa .. "hlt und ausgef" .. uu .. "hrt. Leere Felder werden ignoriert.",
			frFR = "Vous être prié de choisir les types d'expression et leurs textes. L'un d'eux sera choisit aléatoirement et déclenché. Les emplacements vides seront ignorés.",
		},
		RANDOM_EXPRESSION_ALLOW_SAME = {
			enUS = "Allow the same outcome twice in a row.",
			deDE = "Erlaube den selben Ausdruck zweimal hinter einander.",
			frFR = "Autoriser le même résultat deux fois de suite.",
		},
		EXPRESSION_TIP = {
			enUS = "|CFFFFD100Tip:|R Using %t in the text will show up as the name of your target and %L will show up as a link for the item.\n\n|CFFFFD100Tip:|R When making items to be used by others, consider using the Message action instead. E.g. |CFF999999'The soup is burning in your mouth'|R. This can be used to give the player instructions on which they can write their own reaction.",

		},
	};

	local textsMessageMenu = {
		MESSAGE_TEXT_U = {
			enUS = "Message",
			deDE = "nachricht",
			frFR = "Message",
		},
		OUTPUT_TYPE = {
			enUS = "Output Type:",
			deDE = "Anzeigeart:",
			frFR = "Type de sortie :",

		},
		CHAT_FRAME = {
			enUS = "Chat Frame",
			deDE = "Chat Frame",
			frFR = "Fenêtre de discussion",
		},
		ERROR_MSG_FRAME = {
			enUS = "Error Message Frame",
			deDE = "Fehler Meldung",
			frFR = "Message d'erreur",
		},
		MSG_TEXT = {
			enUS = "The message entered will be printed in your own chatlog or errorframe.",
			deDE = "Bitte gib den Ausgabe Typ, das Zeit Format, den Text und eine eventl. Verz" .. oo .. "gerung (in Sek.) an.\nSchreibe TIME in den Text wo die Zeit dargestellt werden soll.",
			frFR = "Entrez ici votre type de sortie, format d'heure, le texte qui va avec et le délais éventuel (en secondes). \nEcrivez TEMPS là ou l'heure doit être indiquée.",
		},
		COLOR = {
			enUS = "Color:",
			deDE = "Farbe:",
			frFR = "Couleur:",
		},
		ALPHA = {
			enUS = "Alpha:",
		},
	};

	local textsProduceItemMenu = {
		PRODUCE_ITEM = {
			enUS = "Produce Item",
			frFR = "Produire un objet",

		},
		PRODUCE_TEXT = {
			enUS = "Please enter the amount and text of the received item. Select the item by pressing the \"Choose Item\" button and select the desired GHI item.",
			deDE = "Bitte trage die Anzahl und einen Text ein f" .. uu .. "r den Fall, dass man das Item erh" .. aa .. "lt. W" .. aa .. "hle ein Item druch Dr" .. uu .. "cken des \"Item w" .. aa .. "hlen.\" Schalters und w" .. aa .. "hle das gew" .. uu .. "nschte Item aus deinem GHI Rucksack.",
			frFR = "Entrez ici le montant et le texte de réception de l'objet. Sélectionnez l'objet en pressant le bouton \"Choisir l'objet.\" et sélectionnez l'objet souhaité dans votre sac GHI.",
		},
		MESSAGE_TEXT = {
			enUS = "Message:",
			deDE = "Nachricht:",
			frFR = "Message:",
		},
		NOT_BY_YOU = {
			enUS = " is not made by you.",
			deDE = " wurde nicht von dir hergestellt.",
			frFR = " N'a pas été fait par vous.",
		},
		LOOT = {
			enUS = "Loot",
			deDE = "Beute",
			frFR = "Butin!",
		},
		GET_LOOT = {
			enUS = "You recieve loot:",
			deDE = "Du erh" .. aa .. "lst Beute:",
			frFR = "Vous avez reçu du butin :",
		},
		CREATE = {
			enUS = "Create",
			deDE = "Erstellen",
			frFR = "Créer",
		},
		GET_CREATE = {
			enUS = "You create:",
			deDE = "Du erstellst:",
			frFR = "Vous avez créé :",
		},
		CRAFT = {
			enUS = "Craft",
			deDE = "Herstellen",
			frFR = "Fabriquer",
		},
		GET_CRAFT = {
			enUS = "You craft:",
			deDE = "Du stellst her:",
			frFR = "Vous avez fabriqué :",
		},

		RECIEVE = {
			enUS = "Recieve",
			deDE = "Erhalten",
			frFR = "Reçu",
		},
		GET_RECIEVE = {
			enUS = "You recieve:",
			deDE = "Du Erh" .. aa .. "lst:",
			frFR = "Vous avez reçu :",
		},

		PRODUCE = {
			enUS = "Produce",
			deDE = "Produzieren",
			frFR = "Produit",
		},
		GET_PRODUCE = {
			enUS = "You produce:",
			deDE = "Du Produzierst:",
			frFR = "Vous avez produit :",
		},

	};

	local textsRemoveBuffMenu = {
		REMOVE_BUFF = {
			enUS = "Remove Buff",
			deDE = "Entferne Buff",
			frFR = "Retirer un buff",
		},
		REMOVE_BUFF_TEXT = {
			enUS = "Please enter the name, amount and type of the buff or debuff to remove.",
			deDE = "Bitte gib den Namen, die Anzahl und den Typ des Buffs o. Debuffs an der entfernt werden soll.",
			frFR = "Entrez ici le nom, le nombre et le type de buff ou de débuff à retirer.",
		},
	};

	local textsScreenEffectMenu = {
		SCREEN_EFFECT = {
			enUS = "Screen Effect",
		},
		SCREEN_EFFECT_TEXT = {
			enUS = "Use this action to set up a colored screen flashing effect.\n Pick a color, fade in time, fade out time, and duration.",

		},
		SCREEN_EFFECT_FADEIN = {
			enUS = "Fade In Time:",
		},
		SCREEN_EFFECT_FADEOUT = {
			enUS = "Fade Out Time:",
		},
		DURATION = {
			enUS = "Duration:",
		},

	};

	local textsScriptMenu = {
		SCRIPT = {
			enUS = "Script",
			deDE = "Skript",
			frFR = "Script",
		},
		SCRIPT_DISABLE_SYNTAX = {
			enUS = "Disable Syntax Highlighting",
		},
		SCRIPT_TEXT = {
			enUS = "Scripts may consist of any LUA code, except restricted functions/commands.",
			deDE = "Skripte bestehen zumeist aus LUA-Codes. Ausgenommen sind eingeschr" .. aa .. "nkte Funktionen. / Kommandos sind nicht erlaubt.",
			frFR = "Les Scripts peuvent être de n'importe quel type de code LUA, excepté les fonctions restreintes. Les / commands ne sont pas autorisées.",
		},
		SCRIPT_OPTIONS_NL = {
			enUS = "Editor options",
		},
		SCRIPT_TEST = {
			enUS = "Test run script",
		},
		SCRIPT_RELOAD_ENV = {
			enUS = "Reload scripting environment",
		},
		SCRIPT_CODE_EDITOR_SETTINGS = {
			enUS = "Code Editor Settings",
		},
		SCRIPT_CODE_EDITOR = {
			enUS = "Code Editor",
		},
		SCRIPT_RESET_COLORS = {
			enUS = "Reset Colors",
		},
		SCRIPT_USE_WIDE = {
			enUS = "Use wide editor (applies for next script editor opened)",
		},
		SCRIPT_INSERT_SOUND = {
			enUS = "Insert sound path",
		},
		SCRIPT_INSERT_ICON = {
			enUS = "Insert icon path",
		},
		OPT_SYNTAX_HIGHLIGHT_COLOR = {
			enUS = "Syntax Highlight Color",
		},
		OPT_SYNTAX_PREVIEW = {
			enUS = "Preview:",
		},
		SYNTAX_STRING = {
			enUS = "String",
		},
		SYNTAX_COMMENT = {
			enUS = "Comment",
		},
		SYNTAX_BOOLEAN = {
			enUS = "Boolean",
		},
		SYNTAX_KEYWORD = {
			enUS = "Keyword",
		},
		SYNTAX_NUMBER = {
			enUS = "Number",
		},
		  SYNTAX_TT_1 = {
			enUS = "Sets the color to highlight ",
		  },
		  SYNTAX_TT_2 = {
			enUS = " elements in.",
		  },
	};

	local textsErr = { --error or general messages here
		ACTION_BEING_EDITED = {
			enUS = "Action is already being edited",
		},
		ERR_MSG_BLOCK = {
			enUS = "One or more chat messages were blocked."
		},
		ERR_SPAM_BLOCK = {
			enUS = "GHI spam limit reached. Say and emote messages done with GHI will be blocked for up to one minute.",
			deDE = "GHI Spamlimit erreicht. Sagen- und Emotenachrichten durch GHI, werden eine Minute lang geblockt.",
			frFR = "Limite de spam de GHI atteinte. Les messages en /s et émotes envoyés avec GHI vont être bloqués pendant une minute. Vous l'avez bien mérité gros malin.",

		},

		LOADED = {
			enUS = "Gryphonheart Items loaded.",
		},

	};

	local textsTime = {
		SECS = {
			enUS = "secs",
		},
		SEC = {
			enUS = "sec",
		},
		MIN = {
			enUS = "min",
		},
		MINS = {
			enUS = "mins",
		},
		HOUR = {
			enUS = "hour",
		},
		HOURS = {
			enUS = "hours",
		},
		DAY = {
			enUS = "day",
		},
		DAYS = {
			enUS = "days",
		},
	};

	local textsColors = {
		COLOR_RED = {
			enUS = "Red",
		},
		COLOR_YELLOW = {
			enUS = "Yellow",
		},
		COLOR_GOLD = {
			enUS = "Gold",
		},
		COLOR_GREEN = {
			enUS ="Green",
		},
		COLOR_GREEN2 = {
			enUS ="Dark Green",
		},
		COLOR_BLUE = {
			enUS ="Blue",
		},
		COLOR_BLUE2 = {
			enUS ="Dark Blue",
		},
		COLOR_PURPLE = {
			enUS ="Violet",
		},
		COLOR_TEAL = {
			enUS ="Teal",
		},
		COLOR_ORANGE = {
			enUS ="Orange",
		},
		COLOR_LGREEN = {
			enUS ="Light Green",
		},
		COLOR_LBLUE = {
			enUS ="Light Blue",
		},
		COLOR_DGREEN = {
			enUS ="Ocean Green",
		},
		COLOR_PINK = {
			enUS ="Pink",
		},
		COLOR_DBLUE = {
			enUS ="Purple",
		},
		COLOR_BROWN = {
			enUS ="Brown",
		},
		COLOR_GRAY = {
			enUS ="Gray",
		},
		COLOR_WHITE = {
			enUS ="White",
		},
		COLOR_BLACK = {
			enUS ="Black",
		},
		COLOR_CUSTOM = {
			enUS = "Custom Color",
		},
		COLOR_PALADIN = {
			enUS = "Paladin",
		},
		COLOR_MAGE = {
			enUS = "Mage",
		},
		COLOR_WARRIOR = {
			enUS = "Warrior",
		},
		COLOR_HUNTER = {
			enUS = "Hunter",
		},
		COLOR_ROGUE = {
			enUS = "Rogue",
		},
		COLOR_MONK = {
			enUS = "Monk",
		},
		COLOR_SHAMAN = {
			enUS = "Shaman",
		},
		COLOR_PRIEST = {
			enUS = "Priest",
		},
		COLOR_DRUID = {
			enUS = "Druid",
		},
		COLOR_WARLOCK = {
			enUS = "Warlock",
		},
		COLOR_DEATHKNIGHT = {
			enUS = "Death knight",
		},
		COLOR_POOR = {
			enUS = "Poor",
		},
		COLOR_COMMON = {
			enUS = "Common",
		},
		COLOR_UNCOMMON = {
			enUS = "Uncommon",
		},
		COLOR_RARE = {
			enUS = "Rare",
		},
		COLOR_EPIC = {
			enUS = "Epic",
		},
		COLOR_LEGENDARY = {
			enUS = "Legendary",
		},
		COLOR_ALLIANCE = {
			enUS = "Alliance",
		},
		COLOR_HORDE = {
			enUS = "Horde",
		},
		COLOR_HEIRLOOM = {
			enUS = "Heirloom",
		},
	};

	local textsPing = {
		PING_REPLY = {
			enUS = "Ping reply from ",
		},
		VERSION = {
			enUS = "Version ",
		},
	};

	local textsTrade = {
		TRADE_NO_GHI = {
			enUS = "The Trade recipient doesn't have GHI or is using an out of date GHI version.",
		},
		TRADE_BUSY = {
			enUS = "The Trade recipient is busy, or is under heavy addon communication traffic. Wait a moment and try again.",
		},
		TRADE_DATA_WAIT = {
			enUS = "Waiting for item data",
		},
		TRADE_BAG = {
			enUS = "Warning: Trade of the content of the bag is currently not supported.",
		},

	};

	local textsTargetUI = {
		BTN_TOGGLE = {
			enUS = "Click to toggle buttons.",
		},
	};

	local textsADVItemMenu = {
		ADV_DESCRIPTIONS = {
			enUS = "Advanced items allow for more dynamic use and advanced details, but can not be used by GHI users with GHI v.1.4 or lower.",
		},
		DYN_ACTIONS = {
			enUS = "Dynamic Actions:",
		},
		DYN_ACTIONS_TEXT = {
			enUS = "Dynamic actions can be used to create networks of action that trigger eachother. Press the empty slot to add the first action.",
		},
		ITEM_ATTRI = {
			enUS = "Item Attributes:",
		},
		ATTRI_NAME = {
			enUS = "Name",
		},
		ATTRI_TYPE = {
			enUS = "Type",
		},
		ATTRI_DVAL = {
			enUS = "Defualt Value",
		},
		ATTRI_EDIT_TIP = {
			enUS = "Edit Attribute",
		},
		ATTRI_DELETE_TIP = {
			enUS = "Delete Attribute",
		},
		ATTRI_ADD = {
			enUS = "Add Attribute",
		},
		TIP_ALIGN = {
			enUS = "Align",
		},
		TIP_DETAIL = {
			enUS = "Detail",
		},
		TIP_LINE_RAISE_TEXT = {
			enUS = "Raise the tooltip line",
		},
		TIP_LINE_LOWER_TEXT = {
			enUS = "Lower the tooltip line",
		},
		TIP_LINE_EDIT_TEXT = {
			enUS = "Edit the tooltip line",
		},
		TIP_LINE_DELETE_TEXT = {
			enUS = "Delete the tooltip line",
		},
		SEQ_FREQUENCY = {
			enUS = "Frequency",
		},
		SEQ_FREQUENCY_1 = {
			enUS = "Every 1 sec",
		},
		SEQ_FREQUENCY_60 = {
			enUS = "Every 1 min",
		},
		SEQ_FREQUENCY_600 = {
			enUS = "Every 10 mins",
		},
		SEQ_FREQUENCY_LOGIN = {
			enUS = "On Login",
		},
		SEQ_FREQUENCY_CONTAINERCHANGE = {
			enUS = "On Container Change",
		},
		SEQ_FREQUENCY_TRADERECIEVE = {
			enUS = "On recieved by trade",
		},
		SEQ_EDIT_TIP = {
			enUS = "Edit Update Sequence",
		},
		SEQ_DELETE_TIP = {
			enUS = "Delete Update Sequence",
		},
		SEQ_ADD_TOOLTIP = {
			enUS = "Add Tooltip",
		},
		SEQ_ADD_UPDATE = {
			enUS = "Add Update Sequence",
		},
		ATTRI_TEXT = {
			enUS = "Attributes is additional data that is stored in each item stack. This can be used to change properties and behavoir of them seperatly.",
		},
		CREATE_TITLE_ADV = {
			enUS = "Create Advanced Item"
		},
		ATTYPE_TIME = {
			enUS = "Time",
		},
		ATTYPE_BOOK = {
			enUS = "Book",
			deDE = "Buch",
			frFR = "Livre",
		},
		ATTYPE_IMAGE = {
			enUS = "Image",
		},
		ATTYPE_STRING = {
			enUS = "String",
		},
		ATTYPE_NUMBER ={
			enUS = "Number",
		},
		ATTYPE_BOOLEAN = {
			enUS = "Boolean",
		},
		ATTYPE_TABLEOFSTRINGS = {
			enUS = "Table of Strings",
		},
		ATTYPE_ICON = {
			enUS = "Icon",
		},
		ATTYPE_COLOR = {
			enUS = "Color",
		},
		ATTYPE_CODE = {
			enUS = "Code",
		},
		ATTYPE_TEXT = {
			enUS = "Text",
		},
		ATTYPE_POSITION = {
			enUS = "Position",
		},
		ATTYPE_SOUND = {
			enUS = "Sound",
		},
		ATTYPE_ITEM = {
			enUS = "Item",
		},
		ATTYPE_IMAGE = {
			enUS = "Image",
		},
		TT_OVERWRITE = {
			enUS = "Overwriting %s",
		},
		TT_NEXT_TO = {
			enUS = "Next to %s",
		},

		DYN_PORT_ONCLICK_NAME = {
			enUS = "OnClick",
		},
		DYN_PORT_ONCLICK_DESCRIPTION = {
			enUS = "This port is triggered when the item is clicked.",
		},
		DYNAMIC_ACTION_TIP = {
			enUS = "Click the empty slot to add the first action to the set.",
		},
		DYN_PORT_ONUPDATE_NAME = {
			enUS = "OnUpdate",
		},
		DYN_PORT_ONUPDATE_DESCRIPTION = {
			enUS = "This port is triggered when the update sequence is run.",
		},
	};

	local textsAttributeMenu = {
		MODIFY_BY = {
			enUS = "Value can be modified:",
		},
		MODIFY_ALL_ITEMS = {
			enUS = "By everyone",
		},
		MODIFY_OWN_ITEMS = {
			enUS = "Only by my items",
		},
		ATTRIBUTE_TITLE = {
			enUS = "Attribute",
		},
		TEXT_MERGE_RULE = {
			enUS = "Merge Rule",
		},
		MODRULE_ERR = {
			enUS = "Incorrect modification rule",
		},
	};

	local textsTTMenu = {
		TT_TEXT = {
			enUS =  "~Description and instructions for the tooltip~",
		},
		TT_TITLE = {
			enUS = "Custom Tooltip",
		},
	};

	local textsSeqMenu = {
		SEQM_TEXT = {
			enUS = "The update sequence is a sequence of actions that is run at a given frequency. This can be used to update values.\nThey have extra security limitations but are able to run even without the item being clicked.",
		},
		SEQM_TITLE = {
			enUS = "Update Attribute Sequence",
		},
}

	local textsMergeRule = {

		MERGE_RULE_NONE = {
			enUS = "none",
		},
		MERGE_RULE_CONCAT = {
			enUS = "concat",
		},
		MERGE_RULE_AVERAGE = {
			enUS = "average",
		},
		MERGE_RULE_AVERAGE_ROUNDED = {
			enUS = "average rounded",
		},
		MERGE_RULE_SUM= {
			enUS = "sum",
		},
		MERGE_RULE_MIN = {
			enUS = "min",
		},
		MERGE_RULE_MAX = {
			enUS = "max",
		},
		MERGE_RULE_AND = {
			enUS = "and",
		},
		MERGE_RULE_OR = {
			enUS = "or",
		},
		MERGE_RULE_NOR = {
			enUS = "nor",
		},
		MERGE_RULE_MAJORITY = {
			enUS = "majority",
		},
		MERGE_RULE_MINORITY = {
			enUS = "minority",
		},
	};

	local textsChatConfirm = {
		CHATCONFIRM = {
			enUS = "Confirm Chat Permission",
		},

		CHATCONFIRM_INSTRUCTION_TOP = {
			enUS = "GHI is calling a function that will make you say or emote the following text:",
		},
		CHATCONFIRM_INSTRUCTION_BOTTOM ={
			enUS = "Do you wish to continue?",
		},

		CHATCONFIRM_TYPE = {
			enUS = "Message type",
		},

	};

	local textsSoundConfirm = {
		SOUNDCONFIRM = {

			enUS = "Confirm Area Sound Permission",
		},


		SOUNDCONFIRM_INSTRUCTION_TOP = {

			enUS = "GHI is calling a function that play the following sound:",

		},

		SOUNDCONFIRM_INSTRUCTION_BOTTOM ={
			enUS = "Do you wish to continue?",

		},
		SOUNDCONFIRM_SEND_BY = {
			enUS = "Send by: %s",
		},


	};
	local textsSimpleItemMenu = {
		SM_SAY = {
			enUS = "This action causes the user to speak when the item is used.",
		},
		SM_EMOTE = {
			enUS = "This action causes the user to preform an emote when the item is used.",
		},
		SM_SOUND = {
			enUS = "This action plays a sound when the item is used.",
		},
		SM_NONE = {
			enUS = "This is an item that has no actions.",
		},
		SM_SELECT = {
			enUS = "The Simple Item Wizards is designed to streamline creation of simple GHI items. Please choose one of the item types on the right and click next to create an item with that action.",
		},
		SM_BAG_SET = {
			enUS = "Edit Bag Settings:",
		},
		SM_BOOK_SET = {
			enUS = "Edit Book Setting:",
		},
		SM_SPEACH_SET = {
			enUS = "Edit Speach Settings:",
		},
		SM_SPEACH_TEXT = {
			enUS = "Please be considerate of the people using your items and around you when making an item that causes them to speak. Please refrain from language that would violate the World of Warcraft TOS.",
		},
		SM_EMOTE_SET = {
			enUS = "Edit Emote Settings:",
		},
		SM_STD_EMOTE = {
			enUS = "Standard Emotes",
		},
		SM_SOUND_SET = {
			enUS = "Edit Sound Settings:",
		},
		SM_MESS_SET = {
			enUS = "Edit Message Settings:",
		},
		SM_BUFF_SET = {
			enUS = "Edit Buff Settings:",
		},
		SM_EQUIP_SET = {
			enUS = "Edit Equip Item Settings:",
		},
		SM_SCREEN_EFF_SET = {
			enUS = "Edit Screen Effect Settings:",
		},
	};

	local textsStdEmoteMenu = {
		STD_EMO_APPLAUD = {
			enUS = "applaud",
		},
		STD_EMO_BEG = {
			enUS = "beg",
		},
		STD_EMO_BOW = {
			enUS = "bow",
		},
		STD_EMO_CHICKEN = {
			enUS = "chicken",
		},
		STD_EMO_CRY = {
			enUS = "cry",
		},
		STD_EMO_DANCE = {
			enUS = "dance",
		},
		STD_EMO_EAT = {
			enUS = "eat",
		},
		STD_EMO_FLEX = {
			enUS = "flex",
		},
		STD_EMO_KISS = {
			enUS = "kiss",
		},
		STD_EMO_KNEEL = {
			enUS = "kneel",
		},
		STD_EMO_LAUGH = {
			enUS = "laugh",
		},
		STD_EMO_POINT = {
			enUS = "point",
		},
		STD_EMO_ROAR = {
			enUS = "roar",
		},
		STD_EMO_RUDE = {
			enUS = "rude",
		},
		STD_EMO_SALUTE = {
			enUS = "salute",
		},
		STD_EMO_SHY = {
			enUS = "shy",
		},
		STD_EMO_SIT = {
			enUS = "sit",
		},
		STD_EMO_SLEEP = {
			enUS = "sleep",
		},
		STD_EMO_TALK = {
			enUS = "talk",
		},
		STD_EMO_WAVE = {
			enUS = "wave",
		},
		STD_EMO_FACEPALM = {
			enUS = "facepalm",
		},
		STD_EMO_DRINK = {
			enUS = "drink",
		},
		STD_EMO_TRAIN = {
			enUS = "train",
		},
	};

	local textsEquipmentDisplay = {
		SLOT_NAME = {
			enUS = "Slot Name:",
		},
		SCALE = {
			enUS = "Scale:",
		},
		NEW_CUSTOM_SLOT = {
			enUS = "New Custom Slot",
		},
		NEW_CUSTOM_SLOT_SHORT = {
			enUS = "New",
		},
		SELECT_DISPLAYED_SLOTS = {
			enUS = "Select Displayed Slots",
		},
		SELECT_DISPLAYED_SLOTS_SHORT = {
			enUS = "Slots",
		},
		BACKGROUND = {
			enUS = "Figure Background",
		},
		BACKGROUND_SHORT = {
			enUS = "Bkrd",
		},
		TOGGLE_TARGET_EQD = {
			enUS = "Toggle Equipment Display for target player.",
		},
		HIDE_EMPTY_SLOTS = {
			enUS = "Hide empty slots in Equipment Display",
		},

		SLOT_NAMES_BELT = {
			enUS = "Belt",
		},
		SLOT_NAMES_NECK = {
			enUS = "Neck",
		},
		SLOT_NAMES_LEFT_FOOT = {
			enUS = "Left Foot",
		},
		SLOT_NAMES_RIGHT_FOOT = {
			enUS = "Right Foot",
		},
		SLOT_NAMES_LEFT_RING = {
			enUS = "Left Hand",
		},
		SLOT_NAMES_RIGHT_RING = {
			enUS = "Right Hand",
		},
		SLOT_NAMES_CHEST = {
			enUS = "Chest",
		},
		SLOT_NAMES_FACE = {
			enUS = "Face",
		},
		SLOT_NAMES_HEAD = {
			enUS = "Head",
		},
		SLOT_NAMES_BACK = {
			enUS = "Back",
		},
		SLOT_NAMES_LEG_LEFT_SIDE = {
			enUS = "Left Leg",
		},
		SLOT_NAMES_LEG_RIGHT_SIDE = {
			enUS = "Right Leg",
		},
		CUSTOM = {
			enUS = "Custom",
		},
		STANDARD = {
			enUS = "Standard",
		},
		NO_GHI_DETECTED = {
			enUS = "No GHI detected.",
		},
		EQD_SCRIPT = {
			enUS = "The script can be used to control when the equipment display should be showed. If the script changes the value of SHOW to true, it is shown.",
		},
		EDIT = {
			enUS = "Edit",
		},

	};

	local textsViewAttributeMenu = {
		ID = {
			enUS = "ID:",
		},
		VIEW = {
			enUS = "View",
		},
		INSTANCE_MENU_TEXT = {
			enUS = "The stack contains %s item instances sorted by the stack order: %s first.",
		},
		INSTANCE_MENU_TITLE = {
			enUS = "Item instances in stack",
		},
		VIEW_MODIFY = {
			enUS = "View/Modify",
		},
		VIEW_ATTRIBUTE_MENU_TITLE = {
			enUS = "View and modify attributes",
		},
		VIEW_ATTRIBUTE_MENU_TEXT = {
			enUS = "The item instance contains %s identical items.",
		},
		VALUE = {
			enUS = "Value:"
		},
		MODIFY_ATTRIBUTE_MENU_TITLE = {
			enUS = "Modify attribute value - %s",
		},
		MODIFY_ATTRIBUTE_MENU_TITLE_VIEW = {
			enUS = "View attribute value - %s",
		},
		VIEW_ATTRIBUTE_SHORTCUT = {
			enUS = "Control + right click to view or modify the attributes of this item.",
		},
	};
	local textsMacroMenu = {
		MACRO_MENU_TEXT = {
			enUS = "Use this window to easily create a macro to use a GHI Item that is in your GHI Bag.\nOnly standard game icons can be used for macros.",
		},
		MACRO_MENU_MACRO = {
			enUS = "Macro:",
		},
		MACRO_MENU_ERROR = {
			enUS = "This icon is not valid for use in a Macro. Please choose another.",
		},
		MACRO_CREATE_MACRO = {
			enUS = "Create Macro"
		},
	};
	local textsPronouns = {
		PRONOUN_IT = {
			enUS = "it",
		},
		PRONOUN_ITS = {
			enUS = "its",
		},
		PRONOUN_HE = {
			enUS = "he",
		},
		PRONOUN_HIS = {
			enUS = "his",
		},
		PRONOUN_SHE ={
			enUS = "she",
		},
		PRONOUN_HER = {
			enUS = "her",
		},
	};


    local LocalizeFrame;
	LocalizeFrame = function(frame)
		local t = frame:GetObjectType();
		if t == "Button" or t == "FontString" then
			local text = frame:GetText() or "";
			if text == string.upper(text) and string.len(text) > 3 then
				frame:SetText(class[text]);
			end
		end
		if frame.GetChildren then
			for _,f in pairs({frame:GetChildren()}) do
				LocalizeFrame(f);
			end
			for _,f in pairs({frame:GetRegions()}) do
				LocalizeFrame(f);
			end
		end
	end

	local meta = getmetatable(class) or {};
	meta.__index = function(self,key)
		if key == "LocalizeFrame" then
			return LocalizeFrame;
		end

		-- Add lookups to new table below this

		local texts = textsContainer[key] or textsOptionsMain[key] or textsOptionsBag[key] or textsOptionsAppearance[key] or textsDynamicActionArea[key]
			or textsIconFrame[key] or textsPosInput[key] or textsVarAttInput[key] or textsBookUI[key] or textsSoundSelection[key]
			or textsImportExport[key] or textsWizard[key] or textsStandardMenu[key] or textsSTDBagMenu[key] or textsBookMenu[key]
			or textsBuffMenu[key] or textsConsumeItem[key] or textsEquipItem[key] or textsExpressionMenu[key] or textsMessageMenu[key]
			or textsProduceItemMenu[key] or textsRemoveBuffMenu[key] or textsScreenEffectMenu[key] or textsScriptMenu[key] or textsErr[key]
			or textsTime[key] or textsColors[key] or textsPing[key] or textsTrade[key] or textsTargetUI[key]
			or textsOptionsDebug[key] or textsOptionsWhitelist[key] or textsADVItemMenu[key] or textsAttributeMenu[key]
			or textsSeqMenu[key] or textsTTMenu[key] or textsMergeRule[key] or textsChatConfirm[key] or textsSimpleItemMenu[key] or textsStdEmoteMenu[key]
			or textsEquipmentDisplay[key] or textsViewAttributeMenu[key] or textsSoundConfirm[key] or textsMacroMenu[key] or textsPronouns[key];
		if not(texts) then
			print("Unknown localization:",key)
			return "UNKNOWN"
		end

		return texts[locale] or texts.enUS;
	end
	setmetatable(class,meta);
	return class;
end

--- /script Loc().LocalizeFrame(ItemTextFrame);