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
        private ButtonWithDropDownProfile profile;

        public ButtonWithDropDownObject() : base()
        {
            this.button = (IButtonTemplate)this.Frame;
            this.menuHandler = new EasyMenuHandler();
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            this.profile = (ButtonWithDropDownProfile)profile;
            this.button.SetScript(ButtonHandler.OnClick, this.OnClick);
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