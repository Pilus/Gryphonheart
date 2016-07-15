namespace BlizzardApi.WidgetInterfaces
{
    using CsLuaFramework.Attributes;
    using WidgetEnums;

    [ProvideSelf]
    public interface IFontInstance
    {
        /// <summary>
        /// Sets the font to use for text, returns 1 if the path was valid, nil otherwise (no change occurs).
        /// </summary>
        /// <param name="path"></param>
        /// <param name="height"></param>
        void SetFont(string path, double height);
        /// <summary>
        /// Sets the font to use for text, returns 1 if the path was valid, nil otherwise (no change occurs).
        /// </summary>
        /// <param name="path"></param>
        /// <param name="height"></param>
        /// <param name="flags"></param>
        void SetFont(string path, double height, string flags);

        /// <summary>
        /// Sets horizontal text justification.
        /// </summary>
        /// <param name="justifyH"></param>
        void SetJustifyH(JustifyH justifyH);

        /// <summary>
        /// Sets vertical text justification
        /// </summary>
        /// <param name="justifyV"></param>
        void SetJustifyV(JustifyV justifyV);

        /// <summary>
        /// Sets the default text color.
        /// </summary>
        void SetTextColor(double r, double g, double b);

        /// <summary>
        /// Sets the default text color.
        /// </summary>
        void SetTextColor(double r, double g, double b, double a);

        /*
        GetFont() - Return the font file, height, and flags.
        GetFontObject() - Return the 'parent' Font object, or nil if none.
        GetJustifyH() - Return the horizontal text justification.
        GetJustifyV() - Return thevertical text justification.
        GetShadowColor() - Returns the color of text shadow (r, g, b, a).
        GetShadowOffset() - Returns the text shadow offset (x, y).
        GetSpacing() - Returns the text spacing.
        GetTextColor() - Returns the default text color.
        SetFontObject(fontObject) - Sets the 'parent' Font object from which this object inherits properties.
        SetJustifyH("justifyH") - Sets horizontal text justification ("LEFT","RIGHT", or "CENTER")
        SetJustifyV("justifyV") - Sets vertical text justification ("TOP","BOTTOM", or "MIDDLE")
        SetShadowColor(r, g, b[, a]) - Sets the text shadow color.
        SetShadowOffset(x, y) - Sets the text shadow offset.
        SetSpacing(spacing) - Sets the spacing between lines of text in the object.
        SetTextColor(r, g, b[, a]) - Sets the default text color.
         */
    }
}