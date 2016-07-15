
namespace GHD.Document.KeyboardInput
{
    using Lua;

    public class TextBoxWithHighlightedText : TextBoxWithMarkAllDetection
    {
        private string highlightedText;
        private string currentText;
        private int currentPos;
        private string lastCombinedText;
        
        public void SetHightlightedText(string text)
        {
            this.highlightedText = text;
            this.UpdateText();
        }
        
        public override void SetText(string text)
        {
            this.currentText = text;
            this.UpdateText();
        }

        public override string GetText()
        {
            var text = base.GetText();
            if (text == this.lastCombinedText)
            {
                return this.currentText;
            }
            
            return text;
        }

        public override void HighlightText(int startPos, int endPos)
        {
        }

        public override void SetCursorPosition(int position)
        {
            var lenCurr = Strings.strlen(this.currentText);
            var pos = Lua.LuaMath.min(position, lenCurr);
            this.currentPos = pos;
            this.UpdateCursor();
        }

        private void UpdateCursor()
        {
            var lenHighlight = Strings.strlen(this.highlightedText);
            base.SetCursorPosition(this.currentPos);
            base.HighlightText(this.currentPos, this.currentPos + lenHighlight);
        }

        private void UpdateText()
        {
            var strA = Strings.strsub(this.currentText, 0, this.currentPos);
            var strB = Strings.strsub(this.currentText, this.currentPos + 1);

            this.lastCombinedText = strA + this.highlightedText + strB;
            base.SetText(this.lastCombinedText);

            this.UpdateCursor();
        }
    }
}
