

namespace GHF.Presenter
{
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CharacterMenu;
    using GH.Integration;
    using GH.Model.Defaults;
    using GH.Model.QuickButtons;
    using Model;
    using Model.AdditionalFields;

    public class Presenter : IPresenter
    {
        private readonly IModelProvider model;
        private MainCharacterMenu characterMenu;
        private readonly SupportedFields supportedFields;

        public Presenter(IModelProvider model, SupportedFields supportedFields)
        {
            this.model = model;
            this.supportedFields = supportedFields;
            this.model.Integration.RegisterDefaultButton(new QuickButton(
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
                this.characterMenu = new MainCharacterMenu(this.model, this.supportedFields);
            }
            
            this.characterMenu.Show();
        }
    }
}
