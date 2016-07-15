namespace BlizzardApi.WidgetInterfaces
{
    using CsLuaFramework.Attributes;
    using CsLuaFramework.Wrapping;
    using WidgetEnums;

    [ProvideSelf]
    public interface IButton : IScript<ButtonHandler, IButton>, IFrame 
    {
        /// <summary>
        ///     Execute the click action of the button.
        /// </summary>
        
        void Click();

        /// <summary>
        ///     Disable the button so that it cannot be clicked.
        /// </summary>
        
        void Disable();

        /// <summary>
        ///     Return the current buttonState of the button.
        /// </summary>
        
        /// <returns></returns>
        ButtonState GetButtonState();

        /// <summary>
        ///     Return the font object for the button when disabled.
        /// </summary>
        
        /// <returns></returns>
        IFontString GetDisabledFontObject();

        /// <summary>
        ///     Get the color of this button's text when disabled.
        /// </summary>
        /// <returns></returns>
        IMultipleValues<double, double, double, double> GetDisabledTextColor();

        /// <summary>
        ///     Get the texture for this button when disabled.
        /// </summary>
        
        /// <returns></returns>
        ITexture GetDisabledTexture();

        /// <summary>
        ///     Get this button's label <see cref="IFontString" />.
        /// </summary>
        
        /// <returns></returns>
        IFontString GetFontString();

        /// <summary>
        ///     Return the font object for the button when highlighted.
        /// </summary>
        
        /// <returns></returns>
        IFontString GetHighlightFontObject();

        /// <summary>
        ///     Get the color of this button's text when highlighted.
        /// </summary>
        /// <returns></returns>
        IMultipleValues<double, double, double, double> GetHighLightTextColor();

        /// <summary>
        ///     Get the texture for this button when highlighted.
        /// </summary>
        /// <returns></returns>
        ITexture GetHighlightTexture();

        /// <summary>
        ///     Get the normal texture for this button.
        /// </summary>
        /// <returns></returns>
        ITexture GetNormalTexture();

        /// <summary>
        ///     Get the normal font object of the button.
        /// </summary>
        /// <returns></returns>
        IFontString GetNormalFontObject();

        /// <summary>
        ///     Get the texture for this button when pushed.
        /// </summary>
        /// <returns></returns>
        IMultipleValues<double, double> GetPushedTextOffset();

        /// <summary>
        ///     Get the texture for this button when pushed.
        /// </summary>
        /// <returns></returns>
        ITexture GetPushedTexture();

        /// <summary>
        ///     Get the text label for the button.
        /// </summary>
        /// <returns></returns>
        string GetText();

        /// <summary>
        ///     Get the height of the Button's text.
        /// </summary>
        /// <returns></returns>
        double GetTextHeight();

        /// <summary>
        ///     Get the width of the button's text.
        /// </summary>
        /// <returns></returns>
        double GetTextWidth();

        /// <summary>
        ///     Determine whether the button is enabled.
        /// </summary>
        /// <returns></returns>
        bool IsEnabled();

        /// <summary>
        ///     Set the button to always be drawn highlighted.
        /// </summary>
        void LockHighlight();

        void RegisterForClicks(ClickType clickType);
        void RegisterForClicks(ClickType clickType, ClickType clickType2);

        /// <summary>
        ///     Set the state of the Button.
        /// </summary>
        /// <param name="state"></param>
        void SetButtonState(ButtonState state);

        /// <summary>
        ///     Set the state of the Button and whether it is locked.
        /// </summary>
        /// <param name="state"></param>
        /// <param name="locked"></param>
        void SetButtonState(ButtonState state, bool locked);

        void SetDisabledFontObject();

        /// <summary>
        ///     Set the font object for settings when disabled
        /// </summary>
        /// <param name="font"></param>
        void SetDisabledFontObject(IFontString font);

        /// <summary>
        ///     Set the disabled texture for the Button.
        /// </summary>
        /// <param name="texture"></param>
        void SetDisabledTexture(ITexture texture);

        /// <summary>
        ///     Set the disabled texture for the Button.
        /// </summary>
        /// <param name="texturePath"></param>
        void SetDisabledTexture(string texturePath);

        /// <summary>
        ///     Set the font to use for display.
        /// </summary>
        /// <param name="font"></param>
        /// <param name="size"></param>
        void SetFont(string font, double size);

        /// <summary>
        ///     Set the font to use for display.
        /// </summary>
        /// <param name="font"></param>
        /// <param name="size"></param>
        /// <param name="flags"></param>
        void SetFont(string font, double size, string flags);

        /// <summary>
        ///     Set the button's label FontString.
        /// </summary>
        /// <param name="fontString"></param>
        void SetFontString(IFontString fontString);

        /// <summary>
        ///     Set the formatted text label for the Button.
        /// </summary>
        /// <param name="formatstring"></param>
        void SetFormattedText(string formatstring);

        /// <summary>
        ///     Set the font object for settings when highlighted.
        /// </summary>
        void SetHighlightFontObject();

        /// <summary>
        ///     Set the font object for settings when highlighted.
        /// </summary>
        /// <param name="font"></param>
        void SetHighlightFontObject(IFontString font);

        /// <summary>
        ///     Set the normal texture for the Button.
        /// </summary>
        /// <param name="texture"></param>
        void SetHighlightTexture(ITexture texture);

        /// <summary>
        ///     Set the normal texture for the Button.
        /// </summary>
        /// <param name="texturePath"></param>
        /// <param name="alphaMode"></param>
        void SetHighlightTexture(string texturePath);

        /// <summary>
        ///     Set the normal texture for the Button.
        /// </summary>
        /// <param name="texture"></param>
        void SetHighlightTexture(ITexture texture, bool alphaMode);

        /// <summary>
        ///     Set the normal texture for the Button.
        /// </summary>
        /// <param name="texturePath"></param>
        /// <param name="alphaMode"></param>
        void SetHighlightTexture(string texturePath, bool alphaMode);

        /// <summary>
        ///     Set the normal texture for the Button.
        /// </summary>
        /// <param name="texture"></param>
        void SetNormalTexture(ITexture texture);

        /// <summary>
        ///     Set the normal texture for the Button.
        /// </summary>
        /// <param name="texturePath"></param>
        void SetNormalTexture(string texturePath);

        /// <summary>
        ///     Replaces SetTextFontObject.
        /// </summary>
        /// <param name="fontString"></param>
        void SetNormalFontObject(IFontString fontString);

        /// <summary>
        ///     Set the text offset for this button when pushed.
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        void SetPushedTextOffset(double x, double y);

        /// <summary>
        ///     Set the pushed texture for the Button.
        /// </summary>
        /// <param name="texture"></param>
        void SetPushedTexture(ITexture texture);

        /// <summary>
        ///     Set the pushed texture for the Button.
        /// </summary>
        /// <param name="texturePath"></param>
        void SetPushedTexture(string texturePath);

        /// <summary>
        ///     Set the text label for the Button.
        /// </summary>
        /// <param name="text"></param>
        void SetText(string text);

        /// <summary>
        ///     Set the Button to not always be drawn highlighted.
        /// </summary>
        void UnlockHighlight();
    }
}