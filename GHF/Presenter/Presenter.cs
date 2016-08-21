

namespace GHF.Presenter
{
    using CharacterMenu;

    using GH.CommonModules.QuickButtonCluster;
    using GH.CommonModules.TargetDetails;
    using GH.Utils.AddOnIntegration;
    using GH.Utils.Modules;

    using Model;
    using Model.AdditionalFields;
    using TargetMenu;

    public class Presenter : IPresenter
    {
        private readonly IModelProvider model;
        private MainCharacterMenu characterMenu;
        private readonly SupportedFields supportedFields;

        public Presenter(IModelProvider model, SupportedFields supportedFields, QuickButtonModule buttonModule)
        {
            this.model = model;
            this.supportedFields = supportedFields;
            buttonModule.RegisterDefaultButton(new QuickButton(
                "ghfProfile",
                5,
                true,
                "GHF - My Profile",
                "Interface\\Icons\\Spell_Misc_EmotionHappy",
                ShowCharacterMenu,
                AddOnReference.GHF));

            var targetDetailsUi = ModuleFactory.GetM<TargetDetails>();
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
