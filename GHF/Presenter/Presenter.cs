

namespace GHF.Presenter
{
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CharacterMenu;
    using GH.Integration;
    using GH.Model.Defaults;
    using GH.Model.QuickButtons;
    using Model;

    public class Presenter : IPresenter
    {
        private readonly IModelProvider model;
        private MainCharacterMenu characterMenu;

        public Presenter(IModelProvider model)
        {
            this.model = model;

            DefaultQuickButtons.RegisterDefaultButton(new QuickButton(
                "ghfProfile",
                5,
                true,
                "GHF - My Profile",
                "Interface\\Icons\\Spell_Misc_EmotionHappy",
                ShowCharacterMenu,
                AddOnReference.GHF));
        }

        private void ShowCharacterMenu()
        {
            if (this.characterMenu == null)
            {
                this.characterMenu = new MainCharacterMenu(this.model);
            }
            
            this.characterMenu.Show();
        }
    }
}
