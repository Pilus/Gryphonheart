

namespace GHF.Presenter.CharacterMenu
{
    using GH.Menu;
    using GH.Menu.Menus;
    using GH.Menu.Objects.Page;
    using Model;

    public interface ICharacterMenuTab
    {
        PageProfile GetGeneratedProfile();

        void Load(IMenu menu, Profile profile);

        void Save();
    }
}
