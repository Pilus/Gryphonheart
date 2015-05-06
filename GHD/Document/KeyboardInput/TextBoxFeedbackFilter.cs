


namespace GHD.Document.KeyboardInput
{
    using System;

    /// <summary>
    /// Filters away direct feedback of SetText and SetCursorPosition calls.
    /// </summary>
    public class TextBoxFeedbackFilter : TextBoxBase
    {
        private string currentText;
        private int currentPosition;
        public TextBoxFeedbackFilter()
        {
            base.OnTextChanged = this.OnTextChangedHandler;
            base.OnCursorChanged = this.OnCursorChangedHandler;
        }

        public override void SetText(string text)
        {
            this.currentText = text;
            base.SetText(text);
        }

        public override void SetCursorPosition(int position)
        {
            var len = Lua.Strings.strlen(this.currentText);
            this.currentPosition = Lua.LuaMath.min(position, len);
            base.SetCursorPosition(this.currentPosition);
        }

        new public Action OnTextChanged { get; set; }
        private void OnTextChangedHandler()
        {
            var text = this.GetText();
            if (text != this.currentText)
            {
                this.OnTextChanged();
            }
        }

        new public Action OnCursorChanged { get; set; }

        private void OnCursorChangedHandler()
        {
            var position = this.GetCursorPosition();
            if (position != this.currentPosition)
            {
                this.OnCursorChanged();
            }
        }
    }
}
