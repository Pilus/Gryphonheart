

namespace GHF.Presenter.CharacterMenu
{
    using CsLua;
    using GH.Menu;
    using GH.Menu.Menus;
    using GH.Menu.Objects.Page;
    using GHF.View;
    using Lua;
    using Model;
    using View.CharacterMenuProfile;

    public class ProfileTab : ICharacterMenuTab
    {
        private readonly ProfileTabProfileGenerator profileGenerator;
        private IProfile currentProfile;
        private IMenu loadedMenu;

        public ProfileTab()
        {
            this.profileGenerator = new ProfileTabProfileGenerator();
        }

        public PageProfile GetGeneratedProfile()
        {
            return this.profileGenerator.GenerateProfile(this.UpdateValue);
        }

        private void UpdateValue(string key, object obj)
        {
            if (this.currentProfile == null)
            {
                throw new CsException("No profile data loaded.");
            }

            switch (key)
            {            
                case ProfileTabLabels.FirstName:
                    this.currentProfile.FirstName = (string) obj;
                    break;
                case ProfileTabLabels.MiddleNames:
                    this.currentProfile.MiddleNames = (string) obj;
                    break;
                case ProfileTabLabels.LastName:
                    this.currentProfile.LastName = (string) obj;
                    break;
                default:
                    throw new CsException("Unknown menu label key " + key);
            }
        }

        public void Load(IMenu menu, IProfile profile)
        {
            this.loadedMenu = menu;
            this.currentProfile = profile;
            menu.SetValue(ProfileTabLabels.FirstName, profile.FirstName);
            menu.SetValue(ProfileTabLabels.MiddleNames, profile.MiddleNames);
            menu.SetValue(ProfileTabLabels.LastName, profile.LastName);
            menu.SetValue(ProfileTabLabels.Appearance, profile.Appearance);
        }

        public void Save()
        {
            this.currentProfile.Appearance = this.loadedMenu.GetValue(ProfileTabLabels.Appearance) as string;
        }
    }
}
