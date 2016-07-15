namespace BlizzardApi.WidgetInterfaces
{
    using CsLuaFramework.Attributes;
    using CsLuaFramework.Wrapping;
    using WidgetEnums;

    [ProvideSelf]
    public interface IEditBox : IFrame, IFontInstance, IScript<EditBoxHandler, IEditBox>
    {
        void SetText(string text); // - Set the text contained in the edit box.
        void AddHistoryLine(string text); // - Add text to the edit history.
        void ClearFocus();

        string GetText(); // - Get the current text contained in the edit box.

        void Insert(string text); // - Insert text into the edit box.

        void SetFocus(); // - Move input focus (the cursor) to this editbox

        void SetMultiLine(bool state); // - Set the EditBox's multi-line state (added 1.11)

        bool GetAltArrowKeyMode(); // - Return whether only alt+arrow keys work for navigating the edit box, not arrow keys alone.
        object GetBlinkSpeed(); // - Gets the blink speed of the EditBox in seconds (added 1.11)
        int GetCursorPosition(); // - Gets the position of the cursor inside the EditBox (added 2.3)
        int GetHistoryLines(); // - Get the number of history lines for this edit box
        bool GetHyperlinksEnabled();
        string GetInputLanguage(); // - Get the input language. locale based, not in-game.
        int GetMaxBytes(); // - Gets the maximum number bytes allowed in the EditBox (added 1.11)
        int GetMaxLetters(); // - Gets the maximum number of letters allowed in the EditBox (added 1.11)
        int GetNumLetters(); // - Gets the number of letters in the box.
        double GetNumber();

        IMultipleValues<double,double, double, double> GetTextInsets(); // - Gets the text display insets for the EditBox (added 1.11)
        void HighlightText(); // - Set the highlight to all of the edit box text.
        void HighlightText(double startPos, double endPos); // - Set the highlight to some of the edit box text.

        bool IsAutoFocus(); // - Determine if the EditBox has autofocus enabled (added 1.11)
        bool IsMultiLine(); // - Determine if the EditBox accepts multiple lines (added 1.11)
        bool IsNumeric(); // - Determine if the EditBox only accepts numeric input (added 1.11)
        bool IsPassword(); // - Determine if the EditBox performs password masking (added 1.11)
        void SetAltArrowKeyMode(bool enable); // - Make only alt+arrow keys work for navigating the edit box, not arrow keys alone.
        void SetAutoFocus(bool state); // - Set whether or not the editbox will attempt to get input focus when it gets shown. default: true (added 1.11)
        void SetBlinkSpeed(object speed);
        void SetCursorPosition(int position); // - Set the position of the cursor within the EditBox (added 2.3)

        bool SetHistoryLines(); // - Set the number of history lines to remember.
        void SetHyperlinksEnabled(bool enableFlag);
        void SetMaxBytes(int maxBytes); // - Set the maximum byte size for entered text.
        void SetMaxLetters(int maxLetters); // - Set the maximum number of letters for entered text.

        void SetNumber(double number);
        void SetNumeric(bool state); // - Set if the EditBox only accepts numeric input (added 1.11)
        void SetPassword(bool state); // - Set the EditBox's password masking state (added 1.11)

        void SetTextInsets(double l, double r, double t, double b);
        void ToggleInputLanguage();
    }
}