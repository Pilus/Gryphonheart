namespace BlizzardApi.WidgetInterfaces
{
    using CsLuaFramework.Attributes;

    [ProvideSelf]
    public interface IFontString : IFontInstance, ILayeredRegion
    {
        /// <summary>
        /// Get whether long strings without spaces are wrapped or truncated (added 1.11)
        /// </summary>
        /// <returns></returns>
        bool CanNonSpaceWrap();

        /// <summary>
        /// Returns the height in pixels of the current string in the current font, without line wrapping. (added 2.3)
        /// </summary>
        /// <returns></returns>
        double GetStringHeight();

        /// <summary>
        /// Returns the width in pixels of the current string in the current font, without line wrapping.
        /// </summary>
        /// <returns></returns>
        double GetStringWidth();

        /// <summary>
        /// Get the displayed text.
        /// </summary>
        /// <returns></returns>
        string GetText();

        /// <summary>
        /// Create or remove an alpha gradient over the text.
        /// </summary>
        /// <param name="start"></param>
        /// <param name="length"></param>
        void SetAlphaGradient(int start, int length);

        /// <summary>
        /// Set the formatted display text.
        /// </summary>
        /// <param name="formatstring"></param>
        /// <param name="arg1"></param>
        void SetFormattedText(string formatstring, object arg1);

        /// <summary>
        /// Set whether long strings without spaces are wrapped or truncated.
        /// </summary>
        /// <param name="wrapFlag"></param>
        void SetNonSpaceWrap(object wrapFlag);

        /// <summary>
        /// Set the displayed text.
        /// </summary>
        /// <param name="text"></param>
        void SetText(string text);

        /// <summary>
        /// Set the height of the text by scaling graphics Note that can distort text.
        /// </summary>
        /// <param name="pixelHeight"></param>
        void SetTextHeight(double pixelHeight);

        /// <summary>
        /// Sets whether long lines of text in the font string can wrap onto subsequent lines
        /// </summary>
        /// <param name="enable">Wheather it should be enabled or not.</param>
        void SetWordWrap(bool enable);
    }
}