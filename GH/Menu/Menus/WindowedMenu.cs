
namespace GH.Menu.Menus
{
    using System;
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua;
    using CsLua.Collection;
    using Debug;
    using Theme;
    using Window;

    public class WindowedMenu : BaseMenu
    {
        private const double BorderSize = 10;
        private readonly MenuWindow window;

        public WindowedMenu(MenuProfile profile) : base(profile)
        {
            this.Inserts.Top = BorderSize;
            this.Inserts.Bottom = BorderSize;
            this.Inserts.Left = BorderSize;
            this.Inserts.Right = BorderSize;

            this.window = new MenuWindow(this.Frame);
            this.window.SetTitle(profile.title);
            this.window.SetIcon(profile.icon);
            this.window.ApplyTheme(ThemeHandler.GetTheme());
        }

        public override void Show()
        {
            this.window.Show();
        }

        public void SetTitle(object _, string title)
        {
            this.window.SetTitle(title);
        }

        public override void AnimatedShow()
        {
            this.window.Show();
        }

        
    }
}

