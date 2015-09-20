namespace GH.Menu.Objects.DropDown.ButtonWithDropDown
{
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Button;
    using UIModules.EasyMenu;

    public class ButtonWithDropDownObject : ButtonObject
    {
        public new static string Type = "ButtonWithDropDown";
        private readonly IButtonTemplate button;
        private readonly EasyMenuHandler menuHandler;
        private readonly ButtonWithDropDownProfile profile;

        public new static ButtonWithDropDownObject Initialize(IObjectProfile profile, IMenuContainer parent, LayoutSettings settings)
        {
            return new ButtonWithDropDownObject((ButtonWithDropDownProfile)profile, parent, settings);
        }

        public ButtonWithDropDownObject(ButtonWithDropDownProfile profile, IMenuContainer parent, LayoutSettings settings) : base(profile, parent, settings)
        {
            this.profile = profile;
            this.button = (IButtonTemplate)this.Frame;
            this.button.SetScript(ButtonHandler.OnClick, this.OnClick);
            this.menuHandler = new EasyMenuHandler();
        }

        private void OnClick(INativeUIObject obj, object arg1, object arg2)
        {
            var menuList = new EasyDropDownMenuList(this.profile.dropDownTitle);
            var data = this.profile.dataFunc();

            data.Foreach(d =>
            {
                menuList.Add(new EasyDropDownMenuItem(d.text, null, d.onSelect));
            });

            this.menuHandler.Show(this.button, menuList);
        }
    }
}