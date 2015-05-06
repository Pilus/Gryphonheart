
namespace GHD.Document
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetInterfaces;
    using Lua;

    public static class TextScoper
    {
        private readonly static IFontString FontString;

        static TextScoper()
        {
            FontString = Global.UIParent.CreateFontString();
        }

        public static double GetWidth(string fontPath, int fontSize, string text)
        {
            FontString.SetFont(fontPath, fontSize);
            FontString.SetText(text);
            return FontString.GetStringWidth();
        }

        public static string GetFittingText(string fontPath, int fontSize, string text, double width)
        {
            FontString.SetFont(fontPath, fontSize);

            var words = Strings.strsplittotable(" ", text);
            var numWords = Table.getn(words);

            var resultingText = "";
            var i = 1;
            while (i <= numWords)
            {
                if (i == 1)
                {
                    FontString.SetText((string)words[1]);
                }
                else
                {
                    FontString.SetText(resultingText + " " + (string)words[1]);
                }

                if (FontString.GetStringWidth() > width)
                {
                    return resultingText;
                }
                resultingText = FontString.GetText();
            }
            return resultingText;
        }
    }
}
