namespace GH.Menu.Theme
{
    using Menus;

    public class MenuTheme : IMenuTheme
    {

        public Color TitleBarTextColor { get; set; }

        public Color TitleBarBackgroundColor { get; set; }

        public string BackgroundTexturePath { get; set; }

        public Inserts BackgroundTextureInserts { get; set; }

        public Color ButtonColor { get; set; }
    }
}