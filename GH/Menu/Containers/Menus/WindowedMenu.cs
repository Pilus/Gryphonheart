
namespace GH.Menu.Menus
{
    using CsLuaFramework.Wrapping;
    using Theme;
    using Window;

    public class WindowedMenu : BaseMenu
    {
        private const double BorderSize = 10;
        private readonly MenuWindow window;

        public WindowedMenu(IWrapper wrapper) : base(wrapper)
        {
            this.Inserts.Top = BorderSize;
            this.Inserts.Bottom = BorderSize;
            this.Inserts.Left = BorderSize;
            this.Inserts.Right = BorderSize;

            this.window = new MenuWindow(this.Frame);
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            var menuProfile = (MenuProfile)profile;
            this.window.SetTitle(menuProfile.title);
            this.window.SetIcon(menuProfile.icon);
        }

        public override void ApplyTheme(IMenuTheme theme)
        {
            base.ApplyTheme(theme);
            this.window.ApplyTheme(theme);
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

