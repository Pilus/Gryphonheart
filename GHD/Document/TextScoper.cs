
namespace GHD.Document
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;
    using Lua;

    public class TextScoper : ITextScoper
    {
        private readonly IFontString fontString;

        public TextScoper()
        {
            this.fontString = Global.Frames.UIParent.CreateFontString();
        }

        public double GetWidth(string fontPath, int fontSize, string text)
        {
            fontString.SetFont(fontPath, fontSize);
            fontString.SetText(text);
            return fontString.GetStringWidth();
        }

        public string GetFittingText(string fontPath, int fontSize, string text, double width)
        {
            fontString.SetFont(fontPath, fontSize);

            var words = Strings.strsplittotable(" ", text);
            var numWords = Table.getn(words);

            var resultingText = "";
            var i = 1;
            while (i <= numWords)
            {
                if (i == 1)
                {
                    fontString.SetText((string)words[1]);
                }
                else
                {
                    fontString.SetText(resultingText + " " + (string)words[i]);
                }

                if (fontString.GetStringWidth() > width)
                {
                    return resultingText;
                }
                resultingText = fontString.GetText();
                i++;
            }
            return resultingText;
        }
    }
}
