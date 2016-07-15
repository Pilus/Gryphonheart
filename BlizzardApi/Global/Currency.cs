

namespace BlizzardApi.Global
{
    using CsLuaFramework.Wrapping;

    public partial interface IApi
    {
        /// <summary>
        /// Breaks down money and inserts separator strings.
        /// </summary>
        /// <param name="amount">The amount of money in copper (for example, the return value from GetMoney)</param>
        /// <param name="seperator">A string to insert between the formatted amounts of currency, if there is more than one type</param>
        /// <returns>A (presumably localized) string suitable for printing or displaying</returns>
        string GetCoinText(int amount, string seperator);

        /// <summary>
        /// Breaks down an amount of money into gold/silver/copper, inserts appropriate "|T" texture strings for coin icons, and returns the resulting string.
        /// </summary>
        /// <param name="amount">The amount of money in copper (for example, the return value from GetMoney)</param>
        /// <param name="fontHeight">The height of the coin icon; if not specified, it defaults to 14.</param>
        /// <returns>A string suitable for printing or displaying</returns>
        string GetCoinTextureString(int amount, int fontHeight);

        /// <summary>
        /// Breaks down an amount of money into gold/silver/copper, inserts appropriate "|T" texture strings for coin icons, and returns the resulting string.
        /// </summary>
        /// <param name="amount">The amount of money in copper (for example, the return value from GetMoney)</param>
        /// <returns>A string suitable for printing or displaying</returns>
        string GetCoinTextureString(int amount);

        /// <summary>
        /// Retrieve Information about a currency at index including it's amount.
        /// </summary>
        /// <param name="id">Index of the currency to retrieve. Known range includes 61 to 777.</param>
        /// <returns>name, CurrentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered, ??</returns>
        IMultipleValues<string, int, string, int, int, int, bool, int> GetCurrencyInfo(int id);

        /// <summary>
        /// Returns the number of entries in the currency list.
        /// </summary>
        /// <returns>Number of entries in the player's currency list.</returns>
        int GetCurrencyListSize();

        /// <summary>
        /// Returns information about an entry in the currency list.
        /// </summary>
        /// <param name="index">Index, ascending from 1 to GetCurrencyListSize().</param>
        /// <returns>name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon, itemID</returns>
        IMultipleValues<string, bool, bool, bool, bool, int, int, string, int> GetCurrencyListInfo(int index);

        /// <summary>
        /// Alters the expanded state of a currency list header.
        /// </summary>
        /// <param name="index">Index of the header in the currency list to expand/collapse.</param>
        /// <param name="expanded">0 to set to collapsed state; 1 to set to expanded state.</param>
        void ExpandCurrencyList(int index, int expanded);

        /// <summary>
        /// Marks/unmarks a currency as unused.
        /// </summary>
        /// <param name="index">Index of the currency in the currency list to alter unused status of.</param>
        /// <param name="expanded">1 to mark the currency as unused; 0 to mark the currency as used.</param>
        void SetCurrencyUnused(int index, int expanded);

        /// <summary>
        /// Returns the number of currencies currently watched on the player's backpack.
        /// </summary>
        /// <returns>The number of watched currencies.</returns>
        int GetNumWatchedTokens();

        /// <summary>
        /// Alters the backpack tracking state of a currency.
        /// </summary>
        /// <param name="index">Index of the currency in the currency list to alter tracking of.</param>
        /// <param name="backpack">1 to track; 0 to clear tracking.</param>
        void SetCurrencyBackpack(int index, int backpack);
    }
}
