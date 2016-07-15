namespace BlizzardApi.WidgetInterfaces
{
    using CsLuaFramework.Attributes;
    using WidgetEnums;

    [ProvideSelf]
    public interface IGameTooltip : IFrame
    {
        void AddDoubleLine(string textL, string textR , double rL , double gL , double bL , double rR , double gR , double bR );

        /// <summary>
        /// Dynamically expands the size of a tooltip (added 1.11)
        /// </summary>
        /// <param name="leftstring"></param>
        /// <param name="rightstring"></param>
        void AddFontStrings(string leftstring, string rightstring);
        /// <summary>
        /// Appends a new line to the tooltip.
        /// </summary>
        /// <param name="text"></param>
        void AddLine(string text);

        /// <summary>
        /// Appends a new line to the tooltip.
        /// </summary>
        /// <param name="text"></param>
        /// <param name="red"></param>
        /// <param name="green"></param>
        /// <param name="blue"></param>
        void AddLine(string text, double red, double green, double blue);

        /// <summary>
        /// Appends a new line to the tooltip.
        /// </summary>
        /// <param name="text"></param>
        /// <param name="red"></param>
        /// <param name="green"></param>
        /// <param name="blue"></param>
        /// <param name="wrapText"></param>
        void AddLine(string text, double red, double green, double blue, bool wrapText);

        /// <summary>
        /// Add a texture to the last line added.
        /// </summary>
        /// <param name="texture"></param>
        void AddTexture(string texture);

        /// <summary>
        /// Append text to the end of the first line of the tooltip.
        /// </summary>
        /// <param name="text"></param>
        void AppendText(string text);

        /// <summary>
        /// Clear all lines of tooltip (both left and right ones).
        /// </summary>
        void ClearLines();

        void FadeOut();
        /// <summary>
        /// Returns the current anchoring type.
        /// </summary>
        /// <returns></returns>
        TooltipAnchor GetAnchorType();

        void SetOwner(IFrame owner, TooltipAnchor anchor);

        void SetOwner(IFrame owner, TooltipAnchor anchor, double x, double y);

        IFrame GetOwner();

        /*
        GameTooltip:GetItem() - Returns name, link.
        GameTooltip:GetMinimumWidth() -
        GameTooltip:GetSpell() - Returns name, rank.
        GameTooltip:GetOwner() - Returns owner frame, anchor.
        GameTooltip:GetUnit() - Returns unit name, unit id.
        GameTooltip:IsUnit("unit") - Returns bool.
        GameTooltip:NumLines() - Get the number of lines in the tooltip.
        GameTooltip:SetAction(slot) - Shows the tooltip for the specified action button.
        GameTooltip:SetAuctionCompareItem("type", index[, offset])
        GameTooltip:SetAuctionItem("type", index) - Shows the tooltip for the specified auction item.
        GameTooltip:SetAuctionSellItem
        GameTooltip:SetBackpackToken(id) -
        GameTooltip:SetBagItem(bag, slot)
        GameTooltip:SetBuybackItem
        REMOVED GameTooltip:SetCraftItem (removed 3.0.2)
        REMOVED GameTooltip:SetCraftSpell (removed 3.0.2)
        GameTooltip:SetCurrencyToken(tokenId) - Shows the tooltip for the specified token
        GameTooltip:SetFrameStack(showhidden) - Shows the mouseover frame stack, used for debugging.
        GameTooltip:SetGlyph(id) -
        GameTooltip:SetGuildBankItem(tab, id) - Shows the tooltip for the specified guild bank item
        GameTooltip:SetHyperlink("itemString" or "itemLink") - Changes the item which is displayed in the tooltip according to the passed argument.
        GameTooltip:SetHyperlinkCompareItem("itemLink", index) - Sets a comparison tooltip for the index. returns true if comparison. [index 1 .. 3]
        GameTooltip:SetInboxItem(index) - Shows the tooltip for the specified mail inbox item.
        GameTooltip:SetInventoryItem(unit, slot[, nameOnly])
        GameTooltip:SetLootItem
        GameTooltip:SetLootRollItem(id) - Shows the tooltip for the specified loot roll item.
        GameTooltip:SetMerchantCompareItem("slot"[, offset])
        GameTooltip:SetMerchantItem
        GameTooltip:SetMinimumWidth(width) - (Formerly SetMoneyWidth)
        GameTooltip:SetOwner(owner, "anchor"[, +x, +y])
        GameTooltip:SetPadding
        GameTooltip:SetPetAction(slot) - Shows the tooltip for the specified pet action.
        REMOVED GameTooltip:SetPlayerBuff(buffIndex) - Direct the tooltip to show information about a player's buff. (removed 3.0.2)
        GameTooltip:SetQuestItem
        GameTooltip:SetQuestLogItem
        GameTooltip:SetQuestLogRewardSpell - Shows the tooltip for the spell reward of the currently selected quest.
        GameTooltip:SetQuestRewardSpell
        GameTooltip:SetSendMailItem
        GameTooltip:SetShapeshift(slot) - Shows the tooltip for the specified shapeshift form.
        GameTooltip:SetSpell(spellId, bookType) - Shows the tooltip for the specified spell.
        GameTooltip:SetTalent(tabIndex, talentIndex) - Shows the tooltip for the specified talent.
        GameTooltip:SetText("text"[, red, green, blue[, alpha[, textWrap]]]) - Set the text of the tooltip.
        GameTooltip:SetTracking
        GameTooltip:SetTradePlayerItem
        GameTooltip:SetTradeSkillItem
        GameTooltip:SetTradeTargetItem
        GameTooltip:SetTrainerService
        GameTooltip:SetUnit
        GameTooltip:SetUnitAura("unitId", auraIndex[, filter]) - Shows the tooltip for a unit's aura. (Exclusive to 3.x.x / WotLK)
        GameTooltip:SetUnitBuff("unitId", buffIndex[, raidFilter]) - Shows the tooltip for a unit's buff.
        GameTooltip:SetUnitDebuff("unitId", buffIndex[, raidFilter]) - Shows the tooltip for a unit's debuff. 
         */
    }
}