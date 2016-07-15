
namespace BlizzardApi.Global
{
    using CsLuaFramework.Wrapping;
    using MiscEnums;

    public partial interface IApi
    {
        string UnitName(UnitId index);
        IMultipleValues<string, string, int> UnitClass(UnitId index);

        /// <summary>
        /// Returns the GUID as a string for the specified unit matching the GUIDs used by the new combat logs
        /// </summary>
        /// <param name="unit"></param>
        /// <returns></returns>
        string UnitGUID(UnitId unit);
        /// <summary>
        /// Returns the race (Tauren, Orc, etc) of the specified unit. 
        /// </summary>
        /// <param name="unit"></param>
        /// <returns>1: The localized race of the specified unit as a string. e.g. Tauren, Orc etc. 
        /// 2: The race in english as a string. e.g Tauren, Orc etc. </returns>
        IMultipleValues<string, string> UnitRace(UnitId unit);
        /// <summary>
        /// Returns the gender of the specified unit. 
        /// </summary>
        /// <param name="unit"></param>
        /// <returns>Number: 1 = Neutrum / Unknown, 2 = Male, 3 = Female</returns>
        int UnitSex(UnitId unit);

        /// <summary>
        /// Returns true if the specified unit is a player character, false otherwise.
        /// </summary>
        /// <param name="unit"></param>
        /// <returns></returns>
        bool UnitIsPlayer(UnitId unit);

        /// <summary>
        /// Returns true if the specified units are friends(PC of same faction or friendly NPC), false otherwise.
        /// </summary>
        /// <param name="unit"></param>
        /// <param name="otherUnit"></param>
        /// <returns></returns>
        bool UnitIsFriend(UnitId unit, UnitId otherUnit);

        /// <summary>
        /// Returns 1 if the specified unit exists, nil otherwise.
        /// </summary>
        /// <param name="unit"></param>
        /// <returns></returns>
        bool UnitExists(UnitId unit);

        /*
        PROTECTED AssistUnit("unit") - Instructs your character to assist the specified unit.
        CheckInteractDistance("unit",distIndex)
        DropItemOnUnit("unit") - Drops an item from the cursor onto a unit.
        FollowUnit("unit") - Follow an ally with the specified UnitID
        PROTECTED FocusUnit("unit") - Sets your unit for focus. (protected 2.0)
        PROTECTED ClearFocus() - Removes any focus you may have set.
        UI GetUnitName("unit", showServerName) - Returns a string with the unit's name and realm name if applicable.
        GetUnitPitch("unit") - Returns the moving pitch of the unit. (added 3.0.2)
        GetUnitSpeed("unit") - Returns the moving speed of the unit. (added 3.0.2)
        InviteUnit("name" or "unit") - Invites the specified player to the group you are currently in (added 2.0)
        IsUnitOnQuest(questIndex, "unit") - Determine if the specified unit is on the given quest.
        SpellCanTargetUnit("unit") - Returns true if the spell awaiting target selection can be cast on the specified unit.
        PROTECTED SpellTargetUnit("unit") - Casts the spell awaiting target selection on the specified unit.
        PROTECTED TargetUnit("unit") - Selects the specified unit as the current target. (protected 2.0)
        UnitAffectingCombat("unit") - Determine if the unit is in combat or has aggro. returns nil if "false" and 1 if "true".
        UnitArmor("unit") - Returns the armor statistics relevant to the specified unit.
        UnitAttackBothHands("unit") - Returns information about the unit's melee attacks.
        UnitAttackPower("unit") - Returns the unit's melee attack power and modifiers.
        UnitAttackSpeed("unit") - Returns the unit's melee attack speed for each hand.
        UnitAura("unit", index [, filter]) - Returns info about buffs and debuffs of a unit.
        UnitBuff("unit", index [,raidFilter]) - Retrieves info about a buff of a certain unit. (updated 2.0)
        UnitCanAssist("unit", "otherUnit") - Indicates whether the first unit can assist the second unit.
        UnitCanAttack("unit", "otherUnit") - Returns true if the first unit can attack the second, false otherwise.
        UnitCanCooperate("unit", "otherUnit") - Returns true if the first unit can cooperate with the second, false otherwise.
        UnitClass("unit") - Returns the class name of the specified unit (e.g., "Warrior" or "Shaman").
        UnitClassification("unit") - Returns the classification of the specified unit (e.g., "elite" or "worldboss").
        UnitCreatureFamily("unit") - Returns the type of creature of the specified unit (e.g., "Crab").
        UnitCreatureType("unit") - Returns the classification type of creature of the specified unit (e.g., "Beast").
        UnitDamage("unit") - Returns the damage statistics relevant to the specified unit.
        UnitDebuff("unit", index [,raidFilter]) - Retrieves info about a debuff of a certain unit. (updated 2.0)
        UnitDefense("unit") - Returns the base defense skill of the specified unit.
        UnitDetailedThreatSituation("unit", "mob") - Returns detailed information about the specified unit's threat on a mob. (added 3.0)
        
        UnitFactionGroup("unit") - Returns the faction group id and name of the specified unit. (eg. "Alliance") - string returned is localization-independent (used in filepath)
        UnitGroupRolesAssigned("unit") - Returns the assigned role in a group formed via the Dungeon Finder Tool. (added 3.3)
        UnitGUID("unit") - Returns the GUID as a string for the specified unit matching the GUIDs used by the new combat logs. (added 2.4)
        GetPlayerInfoByGUID("guid") - returns race, class, sex about the guid. client must have seen the guid. (added 3.2)
        UnitHasLFGDeserter("unit") - Returns whether the unit is currently unable to use the dungeon finder due to leaving a group prematurely. (added 3.3.3)
        UnitHasLFGRandomCooldown("unit") - Returns whether the unit is currently under the effects of the random dungeon cooldown. (added 3.3.3)
        UnitHasRelicSlot("unit")
        UnitHealth("unit") - Returns the current health, in points, of the specified unit.
        UnitHealthMax("unit") - Returns the maximum health, in points, of the specified unit.
        UnitInParty("unit") - Returns true if the unit is a member of your party.
        UnitInRaid("unit") - Returns the unit index if the unit is in your raid/battlegroud, nil otherwise.
        UnitInBattleground("unit") - Returns the unit index if the unit is in your battleground, nil otherwise.
        UnitIsInMyGuild("unit") - Returns whether the specified unit is in the same guild as the player's character.
        UnitInRange("unit") - Returns true if the unit (party or raid only) is in range of a typical spell such as flash heal. (added 2.4))
        UnitIsAFK("unit") - Only works for friendly units.
        UnitIsCharmed("unit") - Returns true if the specified unit is charmed, false otherwise.
        UnitIsConnected("unit") - Returns 1 if the specified unit is connected or npc, nil if offline or not a valid unit.
        UnitIsCorpse("unit") - Returns true if the specified unit is a corpse, false otherwise.
        UnitIsDead("unit") - Returns true if the specified unit is dead, nil otherwise.
        UnitIsDeadOrGhost("unit") - Returns true if the specified unit is dead or a ghost, nil otherwise.
        UnitIsDND("unit") - Only works for friendly units.
        UnitIsEnemy("unit", "otherUnit") - Returns true if the specified units are enemies, false otherwise.
        UnitIsFeignDeath("unit") - Returns true if the specified unit (must be a member of your group) is feigning death. (added 2.1)
        UnitIsGhost("unit") - Returns true if the specified unit is a ghost, false otherwise.
        UnitIsPVP("unit") - Returns true if the specified unit is flagged for PVP, false otherwise.
        UnitIsPVPFreeForAll("unit") - Returns true if the specified unit is flagged for free-for-all PVP, false otherwise.
        UnitIsPVPSanctuary("unit") - Returns whether the unit is in a PvP sanctuary, and therefore cannot be attacked by other players.
        
        UnitIsPossessed("unit") - Returns whether the specified unit is currently under control of another (i.e. "pet" when casting Mind Control).
        UnitIsSameServer("unit", "otherUnit") - Returns whether the specified units are from the same server.
        UnitIsTapped("unit") - Returns true if the specified unit is tapped, false otherwise.
        UnitIsTappedByPlayer("unit") - Returns true if the specified unit is tapped by the player himself, otherwise false.
        UnitIsTappedByAllThreatList("unit") - Returns whether the specified unit is a community monster, i.e. whether all players engaged in combat with it will receive kill (quest) credit.
        UnitIsTrivial("unit") - Returns true if the specified unit is trivial (Trivial means the unit is "grey" to the player. false otherwise.
        UnitIsUnit("unit", "otherUnit") - Determine if two units are the same unit.
        UnitIsVisible("unit") - 1 if visible, nil if not
        UnitLevel("unit") - Returns the level of a unit.
        UnitMana("unit") - Returns the current mana (or energy,rage,etc), in points, of the specified unit. (replaced by 'UnitPower' 3.0.2)
        UnitManaMax("unit") - Returns the maximum mana (or energy,rage,etc), in points, of the specified unit. (replaced by 'UnitPowerMax' 3.0.2)
        UnitName("unit") - Returns the name (and realm name) of a unit.
        UnitOnTaxi("unit") - Returns 1 if unit is on a taxi.
        UnitPlayerControlled("unit") - Returns true if the specified unit is controlled by a player, false otherwise.
        UnitPlayerOrPetInParty("unit") - Returns 1 if the specified unit/pet is a member of the player's party, nil otherwise (returns nil for "player" and "pet") (added 1.12)
        UnitPlayerOrPetInRaid("unit") - Returns 1 if the specified unit/pet is a member of the player's raid, nil otherwise (returns nil for "player" and "pet") (added 1.12)
        UnitPVPName("unit") - Returns unit's name with PvP rank prefix (e.g., "Corporal Allianceguy").
        UnitPVPRank("unit") - Get PvP rank information for requested unit.
        UnitPower("unit"[,type]) - Returns current power of the specified unit. (replaced 'UnitMana' 3.0.2)
        UnitPowerMax("unit"[,type]) - Returns max power of the specified unit. (replaced 'UnitManaMax' 3.0.2)
        UnitPowerType("unit") - Returns a number corresponding to the power type (e.g., mana, rage or energy) of the specified unit.
        UnitRace("unit") - Returns the race name of the specified unit (e.g., "Human" or "Troll").
        UnitRangedAttack("unit") - Returns the ranged attack number of the unit.
        UnitRangedAttackPower("unit") - Returns the ranged attack power of the unit.
        UnitRangedDamage("unit") - Returns the ranged attack speed and damage of the unit.
        UnitReaction("unit", "otherUnit") - Returns a number corresponding to the reaction (aggressive, neutral or friendly) of the first unit towards the second unit.
        UnitResistance("unit", "resistanceIndex") - Returns the resistance statistics relevant to the specified unit and resistance type.
        UnitSelectionColor(UnitId) - Returns RGBA values for the color of a unit's name.
        UnitSex("unit") - Returns a code indicating the gender of the specified unit, if known. (1=unknown, 2=male, 3=female) (updated 1.11)
        UnitStat("unit", statIndex) - Returns the statistics relevant to the specified unit and basic attribute (e.g., strength or intellect).
        UnitThreatSituation("unit", "mob") - Returns the specified unit's threat status on a mob. (added 3.0)
        UnitUsingVehicle("unit") - Returns whether the specified unit is currently using a vehicle (including transitioning between seats).
        GetThreatStatusColor(status) - Returns RGB values for a given UnitThreatSituation return value.
        UnitXP("unit") - Returns the number of experience points the specified unit has in their current level. (only works on your player)
        UnitXPMax("unit") - Returns the number of experience points the specified unit needs to reach their next level. (only works on your player)
        SetPortraitTexture(texture,"unit") - Paint a Texture object with the specified unit's portrait.
        SetPortraitToTexture(texture or "texture", "texturePath") - Sets the texture to be displayed from a file applying a circular opacity mask making it look round like portraits.
*/
    }
}
