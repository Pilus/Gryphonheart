namespace GH.Menu.Theme
{
    using Menus;

    public interface IMenuTheme
    {
        Color TitleBarTextColor { get;}

        Color TitleBarBackgroundColor { get; }

        string BackgroundTexturePath { get; }

        Inserts BackgroundTextureInserts { get; }
    }
}