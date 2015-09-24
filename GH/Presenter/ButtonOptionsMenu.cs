namespace GH.Presenter
{
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
        private bool setUp;

        public ButtonOptionsMenu(IModelProvider model)
        {
            this.model = model;
            this.profileGenerator = new ButtonOptionsMenuProfileGenerator(this.OnShow);
        }

        private void OnShow()
        {
            this.SetUp();
            var buttons = this.model.ButtonStore.GetAll()
                .OrderBy(button => button.Order);
            //this.menu.ForceLabel("test", "Something");
        }

        private void SetUp()
        {
            if (this.setUp)
            {
                return;
            }

            this.setUp = true;
            var menuProfile = this.profileGenerator.GenerateMenuProfile();

            var menuHandler = model.Integration.GetModule<MenuHandler>();
            this.menu = menuHandler.CreateMenu(menuProfile);
            this.menu.Frame["name"] = Name;
            Global.Api.InterfaceOptions_AddCategory(this.menu.Frame);
        }
    }
}