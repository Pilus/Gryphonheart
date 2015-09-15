namespace GHF.Model.MSP
{
    public class MSPFieldNames
    {
        /// <summary>
        /// Currently should always be set to "1", i.e. VP1=1. 
        /// This may be incremented to specify an extended protocol in the future, if that is needed.
        /// </summary>
        public const string ProtocolVersion = "VP";
        /// <summary>
        /// Semicolon-separated list of Addon/Version pairs. The first should be the AddOn which is handling MSP support (i.e. you, if you set msp_RPAddOn).
        /// Example: “flagRSP2/2.5.0”, or “MyRolePlay/4.1.0.81;GHI/1.0.4”
        /// </summary>
        public const string AddOnVersions = "VA";
        /// <summary>
        /// The character’s name (including all surnames, prefixes, etc), as they wish it to be displayed. May include spaces. 
        /// Example: “Varian Wrynn”
        /// </summary>
        public const string Name = "NA";
        /// <summary>
        /// The house that the character belongs to (if any, for appropriate races). If non-empty, on display, please prepend this with “of ”. Example: “the Elvoir Family” should be displayed as “of the Elvoir Family”.
        /// </summary>
        public const string HouseName = "NH";
        /// <summary>
        /// The character’s nickname (if any). It’s up to the receiver how/when this should be displayed, if non-empty. Example: “Bob”
        /// </summary>
        public const string NickName = "NI";
        /// <summary>
        /// The line that appears below the name, often used as a sort of subtitle; RSP’s <T> field. Example: “Crystal Dragon Vampire Princess”, or “Perfectly normal cheese merchant”.
        /// </summary>
        public const string Title = "NT";
        /// <summary>
        /// The character’s race, if and only if they’re playing as a race not equal to their UnitRace (leave empty otherwise; don’t include if it’s the same, to allow for localisation). (Please try to avoid wading chest-deep in half-elves! As always, addons may choose to not support this.) (Sane) Example: “Broken”
        /// </summary>
        public const string Race = "RA";
        /// <summary>
        /// Either free-text (displayed as-is, for a custom RP style), or a number for a default FlagRSP <RPx> common/legacy one: 
        /// 0 (or empty)=undefined, 1=Normal, 2=Casual, 3=Full–time, 4=Beginner. 
        /// Note: While no value is included for 5 or beyond, you can have free text in here instead of a number.
        /// Example: “3” (meaning full-time roleplayer), or “Godmoding” (well, it would be fair warning, I suppose…).
        /// </summary>
        public const string RPStyle = "FR";
        /// <summary>
        /// Either free-text (displayed as-is, for a custom status) or a number for a default FlagRSP <CSx> common/legacy one:
        /// 0 (or empty)=undefined, 1=OOC, 2=IC, 3=Looking For Contact, 4=Storyteller
        /// Example: “2” (in character), “3” (looking for contact), “Busy(farming)”.
        /// </summary>
        public const string CharacterStatus = "FC";
        /// <summary>
        /// A short, single-line description pertaining to the character’s current (publically-visible) status. Intended to be possibly suitable 
        /// to put in tooltips (like Total RP 2 does). Useful to give an at-a-glance overview, for example, for something that should be 
        /// immediately obvious to anyone looking at someone. Keep it terse. If, for example, the character is currently covered in blood, 
        /// then “Covered in blood” would be fine (it’s suggested this is prefixed for display with Currently: or similar, but that shouldn’t 
        /// be transmitted). If you were in a text adventure, and had TERSE mode on instead of VERBOSE, this is the field you’d get your 
        /// description from.
        /// </summary>
        public const string Currently = "CU";
        /// <summary>
        /// A textual description of the character’s appearance (not life history, that’s HI). FlagRSP’s <Dxx> field. 
        /// Think how an oldschool text adventure might describe your character.Can be short, descriptive but sweet, but often edges on the 
        /// long side; some players like writing novellas in here, it's dependent on preference. There is no specific length restriction, 
        /// and you should probably try to avoid having a maximum length. Classes in creative writing are not mandatory. Caveat lector. 
        /// Other players may laugh at your crystal dragon vampire moon princess, Mary Sue.
        /// Bad examples: Roleplayer’s Lament
        /// </summary>
        public const string PhysicalDescription = "DE";
        /// <summary>
        /// Either free-text (general short description, to be displayed as-is) or a number (in years).
        /// Sensible ages for races are encouraged, but not mandatory.
        /// Note this is the age your character appears to be to other characters. Actual age may vary.
        /// Example: “450” (an elf, perhaps?), “9001”, “Young”, “Old”, …
        /// </summary>
        public const string Age = "AG";
        /// <summary>
        /// The colour of the eyes’ iris (and/or glow, for applicable races). 
        /// Example: “Blue”, “Hazel”, “Golden”, …
        /// </summary>
        public const string EyeColour = "AE";
        /// <summary>
        /// Either free-text (display as-is) or a number (which should be in centimetres, without units).
        /// If it’s a number, it’s suggested that it’s displayed in appropriate units; players may prefer ft/in, or cm, depending on locale/preference.
        /// Example: “198” (which is 198cm, or 6'5", depending on how you wish to display it), “Tall”, “Short”, …
        /// </summary>
        public const string Height = "AH";
        /// <summary>
        /// Either free-text (display as-is) or a number (which should be in kilograms, without units).
        /// If it’s a number, it’s suggested that it’s displayed in appropriate units; players may prefer st/lb, 
        /// just lb, or kg, depending on locale/preference.
        /// Example: “52” (which is 52kg, 8st 2lb, or 115lb), “Slim”, “Stocky”, …
        /// </summary>
        public const string Weight = "AW";
        /// <summary>
        /// The character’s motto or favourite saying. Please do not include any surrounding quotes in the field. You may wish to put them in for display, however. 
        /// Example: “Not all who wander are lost.”
        /// </summary>
        public const string Motto = "MO";
        /// <summary>
        /// Some background history about the character. Contents/length up to the player (another frequently lengthy field, if present).
        /// It’s suggested only things other characters might generally know or that are rumoured about the character are included here.
        /// It doesn’t necessarily have to be accurate, up-to-date, or very specific, or, like all fields, even there at all(a significant proportion of players prefer this to be discovered via RP rather than in a profile).
        /// </summary>
        public const string History = "HI";
        /// <summary>
        /// Where in the World of Warcraft does this character live at the moment (if, indeed, anywhere)?
        /// Example: “Goldshire”, “Ironforge”, “Orgrimmar”, …
        /// </summary>
        public const string Home = "HH";
        /// <summary>
        /// Where in the World of Warcraft was this character born? 
        /// Example: “Stormwind”, “Telaar, Draenor”, “Auberdine”, …
        /// </summary>
        public const string Birthplace = "HB";
        /// <summary>
        /// Not human-editable. Set it equal to your UnitGUID("player"); included to ease possible future expansion for units which are out of the Area of Interest. 
        /// Example: “0x0180000002CBBA59” …
        /// </summary>
        public const string GameGUID = "GU";
        /// <summary>
        /// Defines your in-game character’s sex. Please set it equal to tostring( UnitSex("player") ); included to ease possible future expansion for units which are out of the Area of Interest.
        /// Examples(in fact, the only values supported by WoW, but remember MSP always deals in strings): “1” (neuter), “2” (male), “3” (female)
        /// </summary>
        public const string GameSex = "GS";
        /// <summary>
        /// Not human-editable. Defines your (real) class. Set it equal to the second parameter (that is, the non-localised version, for interoperability) 
        /// of UnitClass("player") i.e. select( 2, UnitClass("player") ). Please do not change this at the user’s request; this is included so that it’s 
        /// still possible to fall back on the UnitClass if a possible future Class field (if appropriate) isn’t defined (and look up this value for 
        /// consistent localisation), even if the unit is not in the Area of Interest.
        /// Examples: “WARRIOR”, “DEATHKNIGHT”, “DRUID”, …
        /// </summary>
        public const string GameClass = "GC";
        /// <summary>
        /// Not human-editable. Set it equal to the second parameter (that is, the non-localised version, for interoperability) of UnitRace("player") i.e. 
        /// select( 2, UnitRace("player") ). Please do not change this at the user’s request; this is included so that it’s still possible to fall back 
        /// on the UnitRace if RA isn’t defined (and look up this value for consistent localisation), even if the unit is not in the Area of Interest.
        /// Example: “Human”, “Troll”, “Scourge” (this is what Forsaken return) …
        /// </summary>
        public const string GameRace = "GR";

    }
}