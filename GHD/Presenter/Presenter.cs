
namespace GHD.Presenter
{
    using Document;

    using GH.CommonModules.QuickButtonCluster;
    using GH.Utils.AddOnIntegration;
    using Model;

    public class Presenter
    {
        private readonly IModelProvider model;
        private DocumentMenu documentMenu;

        public Presenter(IModelProvider model, QuickButtonModule quickButtonModule)
        {
            this.model = model;
            quickButtonModule.RegisterDefaultButton(new QuickButton(
                "ghdDocument",
                6,
                true,
                "Documents",
                "Interface\\Icons\\INV_Misc_Book_08",
                ShowDocumentMenu,
                AddOnReference.GHD));
        }

        private void ShowDocumentMenu()
        {
            if (this.documentMenu == null)
            {
                this.documentMenu = new DocumentMenu();
            }
            
            this.documentMenu.Test();
        }
    }
}
