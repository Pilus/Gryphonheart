

namespace GHF.Presenter
{
    using CharacterMenu;
    using GH.Integration;
    using GH.Model.QuickButtons;
    using GH.UIModules.TargetDetails;
    using Model;
    using Model.AdditionalFields;
    using TargetMenu;

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

            var targetDetailsUi = this.model.Integration.GetModule<TargetDetails>();
            new TargetProfileMenu(this.model, targetDetailsUi);
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
