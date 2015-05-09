namespace GH.Menu.Theme
{
    public static class ThemeHandler
    {
        private static readonly IMenuTheme defaultTheme = new MenuTheme()
        {
            TitleBarTextColor = new Color(1.0, 1.0, 1.0),
            TitleBarBackgroundColor = new Color(0.5, 0.1, 0.1),
            BackgroundTexturePath = "INTERFACE\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains"
        };
        
        private static IMenuTheme currentTheme;

        public static IMenuTheme GetTheme()
        {
            return currentTheme ?? defaultTheme;
        }

    }
}