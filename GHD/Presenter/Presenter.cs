
namespace GHD.Presenter
{
    using Document;
    using GH.Integration;
    using GH.Model.QuickButtons;
    using GH.Utils.AddOnIntegration;
    using Model;

    public class Presenter
    {
        private readonly IModelProvider model;
        private DocumentMenu documentMenu;

        public Presenter(IModelProvider model, IAddOnIntegration integration)
        {
            this.model = model;
            integration.RegisterDefaultButton(new QuickButton(
                "ghdDocument",
                6,
                true,
                "Documents",
                "Interface\\Icons\\INV_Misc_Book_08",
                ShowDocumentMenu,
                AddOnReference.GHD));

            integration.RegisterAddOn(AddOnReference.GHD);
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
