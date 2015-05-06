namespace GH.Presenter
{
    using System;
    using System.Linq;
    using BlizzardApi.Global;
    using Menu;
    using Menu.Menus;
    using Model;
    using View;

    public class ButtonOptionsMenu
    {
        public const string Name = "Gryphonheart AddOns";
        private IModelProvider model;
        private IMenuProfileGenerator profileGenerator;
        private IMenu menu;

        public ButtonOptionsMenu(IModelProvider model)
        {
            this.model = model;
            this.profileGenerator = new ButtonOptionsMenuProfileGenerator(this.OnShow);

            this.SetUp();
        }

        private void OnShow()
        {
            var buttons = this.model.ButtonList.GetAll()
                .OrderBy(button => button.Order);
            //this.menu.ForceLabel("test", "Something");
        }

        private void SetUp()
        {
            var menuProfile = this.profileGenerator.GenerateMenuProfile();
            this.menu = BaseMenu.CreateMenu(menuProfile);
            this.menu["name"] = Name;
            Global.InterfaceOptions_AddCategory(this.menu.Frame);
        }
    }
}