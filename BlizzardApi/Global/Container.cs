namespace BlizzardApi.Global
{
    using CsLuaFramework.Wrapping;

    public partial interface IApi
    {
        /// <summary>
        /// Get the info for an item in one of the player's bags. 
        /// </summary>
        /// <param name="bag">Index of the bag to query.</param>
        /// <param name="slot">Index of the slot within the bag to query; ascending from 1.</param>
        /// <returns>texture, itemCount, locked, quality, readable, lootable, itemLink</returns>
        IMultipleValues<string, int, bool, int, bool, bool, string> GetContainerItemInfo(int bagID, int slot);

        /// <summary>
        /// Returns the item ID of the item in a particular container slot. 
        /// </summary>
        /// <param name="bag">Index of the bag to query.</param>
        /// <param name="slot">Index of the slot within the bag to query; ascending from 1.</param>
        /// <returns>Item ID of the item held in the container slot, nil if there is no item in the container slot. </returns>
        int? GetContainerItemID(int bag, int slot);

        /// <summary>
        /// Returns the total number of slots in the bag specified by the index.
        /// </summary>
        /// <param name="bagID">Index of the bag.</param>
        /// <returns>The number of slots in the specified bag, or 0 if there is no bag in the given slot.</returns>
        int GetContainerNumSlots(int bagID);

        /*
           ContainerIDToInventoryID(bagID) 
           GetBagName(bagID) - Get the name of one of the player's bags. 
           GetContainerItemCooldown(bagID, slot) 
           GetContainerItemDurability(bag, slot) - Get current and maximum durability of an item in the character's bags. 
           GetContainerItemGems(bag, slot) - Returns item IDs of gems inserted into the item in a specified container slot. 
           GetContainerItemID(bag, slot) - Returns the item ID of the item in a particular container slot. 
           
           GetContainerItemLink(bagID, slot) - Returns the itemLink of the item located in bag#, slot#. 
           
           GetContainerItemQuestInfo(bag, slot) - Returns information about quest and quest-starting items in your bags. (added 3.3.3) 
           GetContainerNumFreeSlots(bagID) - Returns the number of free slots and type of slots in the bag specified by the index. (added 2.4) 
           HasKey() - Returns 1 if the player has a keyring, nil otherwise. 
           UI OpenAllBags() - Open all bags 
           UI CloseAllBags() - Close all bags 
           PickupBagFromSlot(slot) - Picks up the bag from the specified slot, placing it in the cursor. 
           PickupContainerItem(bagID,slot) 
           PutItemInBackpack() - attempts to place item in backpack (bag slot 0). 
           PutItemInBag(inventoryId) - attempts to place item in a specific bag. 
           UI PutKeyInKeyRing() - attempts to place item in your keyring. 
           SplitContainerItem(bagID,slot,amount) 
           UI ToggleBackpack() - Toggles your backpack open/closed. 
           UI ToggleBag(bagID) - Opens or closes the specified bag. 
           PROTECTED UseContainerItem(bagID, slot[, onSelf]) - Uses an item located in bag# and slot#. Warning: If a vendor window is open, using items in your pack may sell them - 'onSelf'! Protected situationally? (added 1.12) 
         */
    }
}