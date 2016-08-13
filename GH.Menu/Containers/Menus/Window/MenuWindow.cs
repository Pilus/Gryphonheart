namespace GH.Menu.Containers.Menus.Window
{
    using BlizzardApi.WidgetInterfaces;

    using GH.Menu.Theme;

    public class MenuWindow
    {
        private readonly ContentContainer contentContainer;
        private readonly TitleBar titleBar;

        public MenuWindow(IFrame content)
        {
            this.contentContainer = new ContentContainer(content);
            this.titleBar = new MinimizeableTitleBar(this.contentContainer);
        }

        public void Show()
        {
            this.titleBar.Show();
        }

        public void SetTitle(string title)
        {
            this.titleBar.SetTitle(title);
        }

        public void SetIcon(string icon)
        {
            this.titleBar.SetIcon(icon);
        }

        public void ApplyTheme(IMenuTheme theme)
        {
            this.titleBar.ApplyTheme(theme);
            this.contentContainer.ApplyTheme(theme);
        }
    }
}