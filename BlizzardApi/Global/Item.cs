namespace BlizzardApi.Global
{
    using CsLuaFramework.Wrapping;

    public partial interface IApi
    {
        /// <summary>
        /// Returns information about an item.
        /// </summary>
        /// <param name="itemId">The numeric ID of the item. ie. 12345 </param>
        /// <returns>itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice</returns>
        IMultipleValues<string, string, int, int, int, string, string, int, string, string, int> GetItemInfo(int itemId);

        /// <summary>
        /// Returns information about an item.
        /// </summary>
        /// <param name="itemString">The full item ID in string format, e.g. "item:12345:0:0:0:0:0:0:0". Also supports partial itemStrings, by filling up any missing ":x" value with ":0", e.g. "item:12345:0:0:0" </param>
        /// <returns>itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice</returns>
        IMultipleValues<string, string, int, int, int, string, string, int, string, string, int> GetItemInfo(string itemString);

        /// <summary>
        /// Returns count information for the item.
        /// </summary>
        /// <param name="itemId">ID of the item</param>
        /// <returns>The number of items in your possesion.</returns>
        int GetItemCount(int itemId);

        /// <summary>
        /// Returns count information for the item.
        /// </summary>
        /// <param name="itemId">ID of the item</param>
        /// <param name="includeBank">Count includes bank items.</param>
        /// <returns>The number of items in your possesion.</returns>
        int GetItemCount(int itemId, bool includeBank);

        /// <summary>
        /// Returns count information for the item.
        /// </summary>
        /// <param name="itemId">ID of the item</param>
        /// <param name="includeBank">Count includes bank items.</param>
        /// <param name="includeCharges">Count is charges if any, otherwise number of items</param>
        /// <returns>The number of items in your possesion, or charges if includeCharges is true and the item has charges.</returns>
        int GetItemCount(int itemId, bool includeBank, bool includeCharges);

        /// <summary>
        /// Returns count information for the item.
        /// </summary>
        /// <param name="itemName">ID of the item</param>
        /// <returns>The number of items in your possesion.</returns>
        int GetItemCount(string itemName);

        /// <summary>
        /// Returns count information for the item.
        /// </summary>
        /// <param name="itemName">ID of the item</param>
        /// <param name="includeBank">Count includes bank items.</param>
        /// <returns>The number of items in your possesion.</returns>
        int GetItemCount(string itemName, bool includeBank);

        /// <summary>
        /// Returns count information for the item.
        /// </summary>
        /// <param name="itemName">ID of the item</param>
        /// <param name="includeBank">Count includes bank items.</param>
        /// <param name="includeCharges">Count is charges if any, otherwise number of items</param>
        /// <returns>The number of items in your possesion, or charges if includeCharges is true and the item has charges.</returns>
        int GetItemCount(string itemName, bool includeBank, bool includeCharges);

        /*
            EquipItemByName(itemId or "itemName" or "itemLink"[, slot]) - Equips an item, optionally into a specified slot. 
            GetAuctionItemLink("type", index) - Returns an itemLink for the specified auction item. 
            GetContainerItemLink(bagID, slot) - Returns the itemLink of the item located in bag#, slot#. 
            GetItemCooldown(itemID) - Returns startTime, duration, enable. 
            GetItemCount(itemId or "itemName" or "itemLink"[, includeBank][, includeCharges]) - Returns number of such items in inventory[, or charges instead if it has charges] 
            GetItemFamily(itemId or "itemName" or "itemLink") - Returns the bag type that an item can go into, or for bags the type of items that it can contain. (added 2.4) 
            GetItemIcon(itemId or "itemString" or "itemName" or "itemLink") - Returns the icon for the item. Works for any valid item even if it's not in the cache. (added 2.4) 
            GetItemInfo(itemId or "itemString" or "itemName" or "itemLink") - Returns information about an item. 
            GetItemQualityColor(quality) - Returns the RGB color codes for a quality. 
            GetItemSpell(item) - Returns name, rank. 
            GetItemStats(itemLink, statTable) - Returns a table of stats for an item. 
            GetMerchantItemLink(index) - Returns an itemLink for the given purchasable item 
            GetQuestItemLink("type", index) - Returns an itemLink for a quest reward item. 
            GetQuestLogItemLink("type", index) - Returns an itemLink for a quest reward item. 
            GetTradePlayerItemLink(id) - Returns an itemLink for the given item in your side of the trade window (if open) 
            GetTradeSkillItemLink(index) - Returns the itemLink for a trade skill item. 
            GetTradeSkillReagentItemLink(index, reagentId) - Returns the itemLink for one of the reagents needed to craft the given item 
            GetTradeTargetItemLink(id) - Returns an itemLink for the given item in the other player's side of the trade window (if open) 
            IsUsableItem(item) - Returns usable, noMana. 
            IsConsumableItem(item) 
            IsCurrentItem(item) 
            IsEquippedItem(item) 
            IsEquippableItem(itemId or "itemName" or "itemLink") - Returns 1 or nil. 
            IsEquippedItemType("type") - Where "type" is any valid inventory type, item class, or item subclass. 
            IsItemInRange("itemName" or "itemLink", "unit") - Nil for invalid target, 0 for out of range, 1 for in range. 
            ItemHasRange(item) 
            OffhandHasWeapon() - Determine if your offhand carries a weapon. 
            SplitContainerItem(bagID,slot,amount) - Picks up part of a stack. 
            UI SetItemRef(link, text, button) - Handles item link tooltips in chat. 
         */
    }
}