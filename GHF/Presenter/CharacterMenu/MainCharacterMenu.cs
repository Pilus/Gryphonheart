


namespace GHF.Presenter.CharacterMenu
{
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CsLua.Collection;
    using GH.Menu;
    using GH.Menu.Menus;
    using Model;
    using View.CharacterMenu;
    using View.CharacterMenuProfile;

    public class MainCharacterMenu
    {
        private CsLuaList<ICharacterMenuTab> tabs;
        private IMenu menu;
        private IProfile profile;
        private IModelProvider model;
        private CharacterListToggleObject listToggle;

        public MainCharacterMenu(IModelProvider model)
        {
            this.model = model;
            this.tabs = new CsLuaList<ICharacterMenuTab>()
                {
                    new ProfileTab(),
                    new DetailsTab(),
                };

            var pages = this.tabs.Select(tab => tab.GetGeneratedProfile());

            var characterMenuProfileGenerator = new CharacterMenuProfileGenerator(pages, this.Save);
            var menuProfile = characterMenuProfileGenerator.GenerateMenuProfile();

            this.menu = BaseMenu.CreateMenu(menuProfile);

            this.listToggle = new CharacterListToggleObject(this.menu.Frame, this.menu.GetFrameById(ProfileTabLabels.ToggleCharacterList).Frame,
                () => { });
        }

        public void Show()
        {
            this.profile = this.model.AccountProfiles.Get(Global.Api.UnitName(UnitId.player));

            foreach (var characterMenuTab in this.tabs)
            {
                characterMenuTab.Load(this.menu, this.profile);
            }

            this.menu.AnimatedShow();
        }

        private void Save()
        {
            foreach (var characterMenuTab in this.tabs)
            {
                characterMenuTab.Save();
            }

            this.model.AccountProfiles.Set(Global.Api.UnitName(UnitId.player), this.profile);
        }
    }
}
