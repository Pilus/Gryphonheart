namespace GH.Menu.Theme
{
    using Menus;

    public static class ThemeHandler
    {
        private static readonly IMenuTheme defaultTheme = new MenuTheme()
        {
            TitleBarTextColor = new Color(1.0, 1.0, 1.0),
            TitleBarBackgroundColor = new Color(0.5, 0.1, 0.1),
            BackgroundTexturePath = "Interface/Achievementframe/UI-Achievement-AchievementBackground.",
            BackgroundTextureInserts = new Inserts(0.5, 1.0, 0.0, 1.0),
        };

        public static IMenuTheme GetTheme()
        {
            return defaultTheme;
        }

    }
}