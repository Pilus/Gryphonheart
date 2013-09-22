function GHI_LocalizeDE()

	local ss = "\195\159"; -- �
	local aa = "\195\164"; -- �
	local aaa = "\195\132"; -- �
	local uu = "\195\188"; -- �
	local uuu = "\195\156"; -- �
	local oo = "\195\182"; -- �
	local ooo = "\195\150"; -- �

	-- Bag buttons
	GHI_NEW = "Neues Item ";
	GHI_NEW_1LETTER = "N";
	GHI_EDIT = "Item editieren";
	GHI_EDIT_1LETTER = "E";
	GHI_COPY = "Item kopieren";
	GHI_COPY_1LETTER = "K";
	GHI_HELP = "GHI Hilfe, Infos und Optionen.";
	GHI_PRE = "Vorherige Tasche.";
	GHI_NE = "N" .. aa .. "chste Tasche.";

	GHI_BAG_BNT = "GHI Rucksack";
	GHI_BAG_DRAG = "Shift-Klick zum verschieben.";

	-- Tooltip
	GHI_MADE_BY = "Erstellt von";
	GHI_CD_LEFT = "Verbleibende Abklingzeit:";
	GHI_DURATION = "Lebensdauer:";
	GHI_NOT_TRANSFERED = "noch nicht " .. uu .. "bertragen";
	GHI_TRANSFER_TIME = "" .. uuu .. "bertragungszeit kleiner %s Minute(n).";
	GHI_CUSTOM_MADE = "Nutzer erstelltes Item";
	GHI_OFFICIAL_MADE = "Offizielles GH item";
	GHI_REQUIRES = "Ben" .. oo .. "tigt:";
	GHI_REMAINING = "verbleibend";

	--   book
	GHI_EDIT_TEXT = "Text editieren";
	GHI_MARK_TEXT = "Text markieren";
	GHI_VIEW_TEXT = "Text zeigen";
	GHI_UNDO_CHANGES = "R" .. uu .. "ckg" .. aa .. "ngig";
	GHI_EDIT_TITLE = "Titel editieren";
	GHI_DELETE_PAGE = "Seite l" .. oo .. "schen";
	GHI_INSERT_BEFORE = "Vor dieser";
	GHI_INSERT_AFTER = "Nach dieser";
	GHI_INSERT_PAGE = "Seite einf" .. uu .. "gen:";
	GHI_MATERIAL = "Material:";
	GHI_PARCHMENT = "Pergament";
	GHI_STONE = "Stein";
	GHI_BRONZE = "Bronze";
	GHI_MARBLE = "Marmor";
	GHI_SILVER = "Silber";
	GHI_VALENTINE = "Valentinskarte";
	GHI_HEADLINE_1 = "" .. uuu .. "berschrift 1";
	GHI_HEADLINE_2 = "" .. uuu .. "berschrift 2";
	GHI_FRONT = "Schriftart:";
	GHI_H1 = "" .. uuu .. "bers.1:";
	GHI_H2 = "" .. uuu .. "bers.2:";
	GHI_NORMAL = "Normal:";
	GHI_FONT_SIZE = "Schriftgr" .. oo .. "" .. ss .. "e";
	GHI_INSERT_LINK = "Link einf" .. uu .. "gen";
	GHI_INSERT_LOGO = "Logo einf" .. uu .. "gen";
	GHI_LOGO = "Logo:";
	GHI_ALLIGNMENT = "Ausrichtung:";
	GHI_LEFT = "links";
	GHI_INSERT = "einf" .. uu .. "gen";
	GHI_CLOSE = "schlie" .. ss .. "en";
	GHI_TRANSCRIBE = "" .. uuu .. "bertragen zu GHI";
	GHI_NEW_TITLE = "neuer Titel";

	GHI_TRANSCRIBED = "" .. uu .. "bertragen";
	GHI_LETTER = "GHI Brief";
	GHI_READ_LETTER = "Brief lesen";
	GHI_INSCRIPTION = "Inschrift";
	GHI_READ_INCRIPTION = "Inschrift lesen";
	GHI_FROM = "von";

	-- Binding Variables
	BINDING_HEADER_GHI = "GHI";
	BINDING_NAME_GHI_TOGGLE = "W" .. aa .. "hle GHI Tasche";

	-- Book
	GHI_LOADED = "Gryphonheart Items erfolgreich geladen.";
	GHI_MANUAL_CREATED = "GHI Buch erstellt.";
	GHI_IN_COMBAT_ERROR = "Du kannst dies nicht w" .. aa .. "hrend des Kampfes tun.";
	GHI_CONFIRM_DELETE_PAGE = "Diese Seite l" .. oo .. "schen?";
	GHI_ENTER_PAGE_NUMBER = "Trage die zu verlinkende Seitennummer ein.";
	GHI_ENTER_LINK_TEXT = "F" .. uu .. "ge Linktext ein";

	GHI_DISABLE_BUFF_QUESTION = "Aus einem Fahrzeug w" .. aa .. "hrend des Kampfes auszusteigen, f" .. uu .. "hrt zu einer Verriegelung des Interfaces. \nEs wird empfohlen w" .. aa .. "hrend der Fahrzeugnutzung die GHI Buffs zu deaktiverien. Die Buffs k" .. oo .. "nnen im GHI Optionsmen" .. uu .. " wieder aktiviert werden (dr" .. uu .. "cke '?'). \nM" .. oo .. "chtest du die Buffs jetzt deaktivieren? (Das Interface wird neu geladen)?";
	GHI_DISABLE_BUFF_RELOAD = "Die Buffs werden erst deaktiviert, wenn das Interface neu geladen wurde. Interface jetzt neu laden?";
	GHI_SEC = "Sekunde";
	GHI_SEC_S = "Sek.";
	GHI_SECS = "Sekunden";
	GHI_SECS_S = "Sek.";
	GHI_MIN = "Minute";
	GHI_MIN_S = "Min.";
	GHI_MINS = "Minuten";
	GHI_MINS_S = "Min.";
	GHI_HOUR = "Stunde";
	GHI_HOUR_S = "Std.";
	GHI_HOURS = "Stunden";
	GHI_HOURS_S = "Std.";
	GHI_DAY = "Tag";
	GHI_DAY_S = "Tag";
	GHI_DAYS = "Tage";
	GHI_DAYS_S = "Tage";

	GHI_SPAM_LIMIT_REACHED = "GHI Spamlimit erreicht. Sagen- und Emotenachrichten durch GHI, werden eine Minute lang geblockt.";

	--   Help Menu
	GHI_HELP_TITLE = "GHI Hilfe, Infos und Optionen";
	GHI_HELP_CREDITS = "Von Pilus. Scarshield Legion - EU. \nhttp://www.pilus.info";
	GHI_HELP_ADD_INFO = "Informationen, Tipps, Updates, Ideen und R" .. uu .. "ckmeldungen \nk" .. oo .. "nnt ihr im Forum finden und abgeben: \nhttp://www.pilus.info/forum";
	GHI_HELP_BACKPACK_ICON = "GHI Rucksack Icon";
	GHI_SCALE = "Gr" .. oo .. "" .. ss .. "e:";
	GHI_CENTER_ICON = "zentriere Icon";
	GHI_DISABLE_BUFFS = "deaktiviere Buffs";
	GHI_SHOW_WARNING = "Zeige Warnung, wenn ein Fahrzeug benutzt wird";
	GHI_BLOCK_STD_EMOTE = "Verstecke n" .. aa .. "chstes Emote nach einem Emote mit \"   \"";

	-- Create item menu
	GHI_CREATE_TITLE = "Erstelle neues GHI Item";
	GHI_GENERAL_ITEM_INFO = "generelle Item Information";
	GHI_NAME = "Name:";
	GHI_QUALITY = "Qualit" .. aa .. "t:";
	GHI_ICON = "Icon:";
	GHI_WHITE_TEXT_1 = "Wei" .. ss .. "er Text 1:";
	GHI_WHITE_TEXT_2 = "Wei" .. ss .. "er Text 2:";
	GHI_YELLOW_QUOTE = "Gelb gef" .. aa .. "rbter Text:";
	GHI_AMOUNT = "Anzahl:";
	GHI_STACK_SIZE = "Stapelgr" .. oo .. "" .. ss .. "e:";
	GHI_COPYABLE = "kopierbar von Anderen";
	GHI_ITEM_DURATION = "Lebensdauer:";
	GHI_DURATION_WHEN_TRADED = "Beginne Lebensdauer beim Handeln";
	GHI_USE_REAL_TIME = "Benutze Echtzeit, anstelle von Spielzeit Lebensdauer.";

	GHI_RIGHT_CLICK = "Rechtsklick-Aktionen";
	GHI_DETAILS = "Details";
	GHI_RUN_REQ = "Bei Bedingung aktivieren.";
	GHI_RUN_ALWAYS = "Immer aktivieren";
	GHI_IS_FORFILLED = "ist erf" .. uu .. "llt";
	GHI_BEFORE_REQ = "vor Bedingung";
	GHI_IS_NOT_FORFILLED = "ist nicht erf" .. uu .. "llt";
	GHI_NEW_RIGHT_CLICK = "Neue Rechtsklick-Aktion:";
	GHI_ADD_NEW = "Neue hinzuf" .. uu .. "gen";
	GHI_DELETE = "L" .. oo .. "schen";
	GHI_EDIT = "Editieren";
	GHI_RIGHT_CLICK_HELP = "W" .. aa .. "hle den gew" .. uu .. "nschten Typ f" .. uu .. "r eine Rechtsklick-Aktion und dr" .. uu .. "cke Neue hinzuf" .. uu .. "gen, um eine neue Rechtsklick-Aktion zu erstellen. \nBenutze die \"Aktivieren wenn erf" .. uu .. "llt\" Schalter, um eine Aktion auszuf" .. uu .. "hren, wenn eine Sache vorhanden sein muss (ist erf" .. uu .. "llt), nicht vorhanden sein darf (ist nicht erf" .. uu .. "llt) oder um sie immer auszuf" .. uu .. "hren (Immer aktivieren).";
	GHI_USE = "Benutzen:";
	GHI_ITEM_CD = "Abklingzeit:";
	GHI_CONSUMED = "Wird verbraucht";


	GHI_ONE_TYPE_WARNING = "Jedes Item kann immer nur eine dieser Rechtsklick-Aktionen haben:"
	GHI_GHR_WARNING = "Du ben" .. oo .. "tigst GHR und musst ein Fraktions-Offizier oder hochrangiger sein, um ein Item zu erstellen, welches Ruf gew" .. aa .. "hrt.";



	-- right click actions
	GHI_TYPE = "Art:";
	GHI_TYPE_U = "Art";
	GHI_DELAY = "Verz" .. oo .. "gerung:";
	GHI_TEXT = "Text:";

	GHI_SAY = "Sagen";
	GHI_EMOTE = "Emote";

	GHI_EXPRESSION_TEXT = "Bitte trage die Ausdrucksart, dessen Text und eventuell eine Abklingzeit/Pausezeit zwischen den Ausdr" .. uu .. "cken/Emotes (in Sek.) ein. \nSchreibe %L, um einen Link eines Items einzuf" .. uu .. "gen.";
	GHI_EXPRESSION = "Ausdruck";
	GHI_EXPRESSIONS = "Ausdr" .. uu .. "cke";
	GHI_RANDOM_EXPRESSION = "zuf" .. aa .. "llige Ausdr" .. uu .. "cke";
	GHI_RANDOM_EXPRESSION_TEXT = "Bitte w" .. aa .. "hle die Ausdrucksarten und trage ihren Text ein. Jeder Ausdruck wird zuf" .. aa .. "llig gew" .. aa .. "hlt und ausgef" .. uu .. "hrt. Leere Felder werden ignoriert.";
	GHI_RANDOM_EXPRESSION_ALLOW_SAME = "Erlaube den selben Ausdruck zweimal hinter einander.";

	GHI_SCRIPT = "Skript";
	GHI_SCRIPT_TEXT = "Skripte bestehen zumeist aus LUA-Codes. Ausgenommen sind eingeschr" .. aa .. "nkte Funktionen. / Kommandos sind nicht erlaubt.";

	--
	GHI_BOOK = "Buch";
	GHI_TITLE = "Titel:";
	GHI_TITLE_TEXT = "Bitte trage oben einen Titel ein. Der Titel und viele weitere Buchbezogene Informationen, k" .. oo .. "nnen sp" .. aa .. "ter im Buch-Editieren-Men" .. uu .. " ge" .. aa .. "ndert werden.";

	GHI_BUFF = "Buff";
	GHI_BUFF_NAME = "Buffname:";
	GHI_BUFF_DETAILS = "Buffdetails:";
	GHI_BUFF_DURATION = "Buffwirkungsdauer:";
	GHI_BUFF_UNTIL_CANCELED = "H" .. aa .. "lt bis er abgebrochen wird";
	GHI_BUFF_ON_SELF = "Immer auf einen selbst wirken";
	GHI_STACKABLE = "Stapelbar";
	GHI_BUFF_DEBUFF = "Buff / Debuff:";
	GHI_BUFF_TYPE = "Buffart:";

	GHI_SOUND = "Sound";
	GHI_SOUNDFILEPATH = "Pfad zur Sound-Datei:";
	GHI_SOUND_EX = "Trage einen Sound-Dateipfad und ein Verz" .. oo .. "gerung ein. \nBeisp.:   Sound\\Creature\\Murloc\\mMurlocAggroOld.wav ";

	GHI_EQUIP_ITEM = "Item anlegen";
	GHI_EQUIP_ITEM_TEXT = "Please enter the EXACT name of an real item in your bags to equip.\n if you wish to delay equiping enter a delay in seconds."
	GHI_ITEM_NAME = "Item Name:";

	GHI_BAG = "Tasche";
	GHI_SLOTS = "Pl" .. aa .. "tze:";
	GHI_TEXTURE = "Aussehen:";
	GHI_NORMAL = "Normal";
	GHI_BANK = "Bank";
	GHI_KEYRING = "Schl" .. uu .. "sselring";

	GHI_GHR = "GHR Ruf";
	GHI_REP_WITH = "Ruf bei";
	GHI_FACTION = "Fraktion:";

	GHI_REQUIREMENT = "Vorraussetzung";
	GHI_REQ_TYPE = "Vorraussetzungsart:";
	GHI_REQ_FILTER = "Vorraussetzungsfilter:";
	GHI_REQ_TOOLTIP = "Hilfstext (optional):";
	GHI_REQ_TEXT1 = "Im Vorraussetzungsfilter kannst Du entweder einen einzelnen Namen/Wert oder mehrere Namen/Werte eintragen und mit einem Komma unterteilen. \nDu kannst auch Intervalle definieren, indem Du \"-\" benutzt und \"+\" als einen offenen Intervallwert.";
	GHI_REQ_TEXT2 = "Beispiel: Setze \"Level\" als einen Typ und \"10-20,25,40-42,68+\". Dies besagt, dass die ben" .. oo .. "tigte Vorraussetzung erf" .. uu .. "llt ist, wenn der Level des Spielers zwischen 10 und 20 liegt, 25 ist, sich zwischen 40 und 42 befindet oder h" .. oo .. "her als 68 ist.";
	GHI_REQ_TEXT3 = "Einige Vorraussetzungsarten ben" .. oo .. "tigen mehrere Dinge als Vorraussetzung, trenne diese druch eine Leerstelle.";
	GHI_REQ_TEXT4 = "Beispiel: Setze \"Skill\" als eine Vorraussetzung mit \"Schmiedekunst 120+\". Dies besagt, dass die Vorraussetzung eine Schmiedefertigkeit von " .. uu .. "ber 120 ist, um das Item zu benutzen.";
	GHI_REQ_TEXT5 = "Falls der Tooltip nich leer gelassen wird, wird er als Vorraussetzungstext an Stelle des Standard Textes dargestellt, ist der Text \"nil\", wird nichts dargestellt.";
	GHI_REQ = {
		["Name"] = "Name",
		["Level"] = "Level",
		["Zone"] = "Gebiet",
		["SubZone"] = "Position",
		["Guild"] = "Gilde",
		["Class"] = "Klasse",
		["Race"] = "Rasse",
		["Gender"] = "Geschlecht",
		["Normal Item"] = "Normales Item",
		["Base Stats"] = "Grundwerte",
		["Skill"] = "F" .. aa .. "higkeit",
		["Reputation"] = "Ruf",
		["Honor Kills"] = "Ehrenhafte Siege",
		["Normal Buff"] = "Normaler Buff",
		["GHI Buff"] = "GHI Buff",
		["LUA Statement"] = "LUA Befehl"
	};

	GHI_TIME = "Zeit";
	GHI_OUTPUT_TYPE = "Anzeigeart:";
	GHI_TIME_FORMAT = "Zeitformat:";
	GHI_TIME_TEXT = "Bitte trage eine Anzeigeart, das Zeitformat, den Text und eventuell eine Abklingzeit/Pause (in Sek.) ein. \nSchreibe TIME an die Textstelle, in der die Zeit eingef" .. uu .. "gt werden soll.";
	GHI_GREEN_TEXT = "Gr" .. uu .. "ner Text";
	GHI_BLUE_TEXT = "Blauer Text"

	-- produce item
	GHI_PRODUCE = "Item herstellen";
	GHI_OF = "von";
	GHI_CHOOSE_ITEM = "Item w" .. aa .. "hlen";
	GHI_MESSAGE_TEXT = "Nachricht:";
	GHI_PRODUCE_TEXT = "Bitte trage die Anzahl und einen Text ein f" .. uu .. "r den Fall, dass man das Item erh" .. aa .. "lt. W" .. aa .. "hle ein Item druch Dr" .. uu .. "cken des \"Item w" .. aa .. "hlen.\" Schalters und w" .. aa .. "hle das gew" .. uu .. "nschte Item aus deinem GHI Rucksack.";
	GHI_NOT_BY_YOU = " wurde nicht von dir hergestellt.";
	GHI_LOOT = "Beute";
	GHI_GET_LOOT = "Du erh" .. aa .. "lst Beute:";
	GHI_CREATE = "Erstellen";
	GHI_GET_CREATE = "Du erstellst:";
	GHI_CRAFT = "Herstellen";
	GHI_GET_CRAFT = "Du stellst her:";
	GHI_RECIEVE = "Erhalten";
	GHI_GET_RECIEVE = "Du Erh" .. aa .. "lst:";
	GHI_PRODUCE = "Produzieren";
	GHI_GET_PRODUCE = "Du Produzierst:";

	-- consume item
	GHI_CONSUME = "Verbrauche Item";
	GHI_NOT_SOURCE_ID = "Konnte Quell ID nicht identifizieren.";
	GHI_NO_ITEM_SELECTED = "kein Item gew" .. aa .. "hlt";
	GHI_CONSUME_TEXT = "Bitte gib die Anzahl an die verbraucht wird. W" .. aa .. "hle ein Item durch dr" .. uu .. "cken des \"Item w" .. aa .. "hlen.\" Knopfes and w" .. aa .. "hle das gew" .. uu .. "nschte Item in deinem GHI Rucksack.";

	-- message
	GHI_MESSAGE_TEXT_U = "nachricht"
	GHI_CHAT_FRAME = "Chat Frame";
	GHI_ERROR_MSG = "Fehler Meldung";
	GHI_MSG_TEXT = "Bitte gib den Ausgabe Typ, das Zeit Format, den Text und eine eventl. Verz" .. oo .. "gerung (in Sek.) an.\nSchreibe TIME in den Text wo die Zeit dargestellt werden soll.";
	GHI_COLOR = "Farbe:";
	GHI_COLOR_NAMES = {};
	GHI_COLOR_NAMES["red"] = "Rot";
	GHI_COLOR_NAMES["yellow"] = "Gelb";
	GHI_COLOR_NAMES["gold"] = "Gold";
	GHI_COLOR_NAMES["green"] = "Gr" .. uu .. "n";
	GHI_COLOR_NAMES["green2"] = "Dunkelgr" .. uu .. "n";
	GHI_COLOR_NAMES["blue"] = "Blau";
	GHI_COLOR_NAMES["blue2"] = "Dunkelblau";
	GHI_COLOR_NAMES["purple"] = "Violet";
	GHI_COLOR_NAMES["teal"] = "Teal";
	GHI_COLOR_NAMES["orange"] = "Orange";
	GHI_COLOR_NAMES["Lgreen"] = "Hellgr" .. uu .. "n";
	GHI_COLOR_NAMES["Lblue"] = "Hellblau";
	GHI_COLOR_NAMES["Dgreen"] = "Ozeangr" .. uu .. "n";
	GHI_COLOR_NAMES["Pink"] = "Pink";
	GHI_COLOR_NAMES["Dblue"] = "Lila";
	GHI_COLOR_NAMES["brown"] = "Braun";
	GHI_COLOR_NAMES["gray"] = "Grau";
	GHI_COLOR_NAMES["white"] = "Whei" .. ss .. "";

	-- Remove buff
	GHI_REMOVE_BUFF = "Entferne Buff";
	GHI_REMOVE_BUFF_TEXT = "Bitte gib den Namen, die Anzahl und den Typ des Buffs o. Debuffs an der entfernt werden soll.";
	GHI_HELPFUL = "Hilfreich";
	GHI_HARMFUL = "Sch" .. aa .. "dlich";

	-- Export
	GHI_CAN_NOT_EXPORT = "Du kannst dieses Item nicht exportieren.";
	GHI_EXPORT = "Exportiere Item"
	GHI_EXPORT_TEXT = "Du kannst den Text kopieren, indem du ihn markierst(alt+a) und dann alt+c dr" .. uu .. "ckst um ihn zu kopieren.\nDu kannst ihn dann mit alt+v einf" .. uu .. "gen, wo du m" .. oo .. "chtest: In Forums, " .. uu .. "ber Instant Messengers deinen Freunden oder an andere Charaktere.";

	GHI_CAN_NOT_PRODUCE_OFFICIAL = "Du kannst kein offizielles GHI Item erstellen.";
	GHI_CAN_NOT_PRODUCE_ITEM = "Du kannst das Item nicht erstellen.";
	GHI_CAN_NOT_FIND_ITEM = "Das Item wurde nicht gefunden. ID: %s.";


	GHI_CAN_NOT_IMPORT = "Du kannst dieses item nicht importieren.";
	GHI_EXPORT_1LETTER = "Exp";
	GHI_IMPORT_1LETTER = "Imp";

	GHI_TOTAL_PR_CHAR = "Gesammt pro Charakter";
	GHI_NONE = "nichts";
	GHI_CHARS = "Charakter(e)";
	GHI_GUILDS = "Gilde(n)";
	GHI_ACCOUNTS = "Account(s)";
	GHI_REALMS = "Realm(s)";
	GHI_LIMITED_TO = "Beschr" .. aa .. "nkt auf:";
	GHI_NAMES = "Name(n):";
	GHI_CHANGE_ID = "Gib dem Item eine neue ID";
	GHI_CHANGE_USER = "" .. aaa .. "ndere Ersteller auf den importierenden Nutzer";
	GHI_EXPORT_LIMITATION_TEXT = "Mehrere Namen als Limitierung k" .. oo .. "nnen angegeben werden(komma separiert).";

	GHI_IMPORT = "Importiere Item";
	GHI_IMPORT_INSTRUCTION = "Bitte f" .. uu .. "ge den Item Code in das Feld ein und dr" .. uu .. "cke Import um das Item zu importieren.";
	GHI_IMPORT_REPORT = "Importiert: %sx%s.";
end

