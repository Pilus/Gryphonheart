


namespace GHF.Presenter.CharacterMenu
{
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CsLua.Collection;
    using GH.Menu;
    using GH.Menu.Menus;
    using GHF.View.CharacterMenuProfile.CharacterList;
    using Model;
    using Model.AdditionalFields;
    using View.CharacterMenu;
    using View.CharacterMenuProfile;

    public class MainCharacterMenu
    {
        private CsLuaList<ICharacterMenuTab> tabs;
        private IMenu menu;
        private CsLuaList<Profile> profiles;
        private Profile currentProfile;
        private IModelProvider model;
        private CharacterListToggleObject listToggle;
        private CharacterListFrame listFrame;

        public MainCharacterMenu(IModelProvider model, SupportedFields fields)
        {
            this.model = model;
            this.tabs = new CsLuaList<ICharacterMenuTab>()
                {
                    new ProfileTab(fields),
                    new DetailsTab(),
                };

            var pages = this.tabs.Select(tab => tab.GetGeneratedProfile());

            var characterMenuProfileGenerator = new CharacterMenuProfileGenerator(pages, this.Save);
            var menuProfile = characterMenuProfileGenerator.GenerateMenuProfile();

            this.menu = BaseMenu.CreateMenu(menuProfile);

            this.listFrame = new CharacterListFrame(this.menu.Frame);
            this.listToggle = new CharacterListToggleObject(this.menu.Frame, this.menu.GetFrameById(ProfileTabLabels.ToggleCharacterList).Frame, this.listFrame.Toggle);
        }

        public void Show()
        {
            var unitName = Global.Api.UnitName(UnitId.player);
            this.profiles = this.model.AccountProfiles.GetAll();

            this.listFrame.SetUp(this.profiles, unitName, this.ToggleProfile, this.Save);
            this.ToggleProfile(this.model.AccountProfiles.Get(unitName));

            this.menu.AnimatedShow();
        }

        private void ToggleProfile(string id)
        {
            this.currentProfile = profiles.FirstOrDefault(p => p.Id.Equals(id));
            foreach (var characterMenuTab in this.tabs)
            {
                characterMenuTab.Load(this.menu, this.currentProfile);
            }
        }

        private void ToggleProfile(Profile profile)
        {
            this.currentProfile = profile;
            foreach (var characterMenuTab in this.tabs)
            {
                characterMenuTab.Load(this.menu, this.currentProfile);
            }
        }

        private void Save()
        {
            foreach (var characterMenuTab in this.tabs)
            {
                characterMenuTab.Save();
            }

            this.model.AccountProfiles.Set(this.currentProfile.Id, this.currentProfile);
            this.listFrame.Update(this.currentProfile);
        }
    }
}
