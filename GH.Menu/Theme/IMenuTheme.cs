namespace GH.Menu.Theme
{
    using GH.Menu.Containers.Menus;

    public interface IMenuTheme
    {
        Color TitleBarTextColor { get;}

        Color TitleBarBackgroundColor { get; }

        string BackgroundTexturePath { get; }

        Inserts BackgroundTextureInserts { get; }

        Color ButtonColor { get; }
    }
}