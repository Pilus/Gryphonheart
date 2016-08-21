

namespace GHF.Presenter.CharacterMenu
{
    using GH.Menu.Containers.Menus;
    using GH.Menu.Containers.Page;

    using Model;

    public interface ICharacterMenuTab
    {
        PageProfile GetGeneratedProfile();

        void Load(IMenu menu, Profile profile);

        void Save();
    }
}
