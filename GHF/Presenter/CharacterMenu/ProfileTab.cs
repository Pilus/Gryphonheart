

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
            menu.ForceLabel(ProfileTabLabels.FirstName, profile.FirstName);
            menu.ForceLabel(ProfileTabLabels.MiddleNames, profile.MiddleNames);
            menu.ForceLabel(ProfileTabLabels.LastName, profile.LastName);
            menu.ForceLabel(ProfileTabLabels.Appearance, profile.Appearance);
        }

        public void Save()
        {
            this.currentProfile.Appearance = this.loadedMenu.GetLabel(ProfileTabLabels.Appearance) as string;
        }
    }
}
