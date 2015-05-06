
namespace GHD.Presenter
{
    using Document;
    using GH.Integration;
    using GH.Model.Defaults;
    using GH.Model.QuickButtons;
    using Model;

    public class Presenter
    {
        private readonly IModelProvider model;
        private DocumentMenu documentMenu;

        public Presenter(IModelProvider model)
        {
            this.model = model;
            DefaultQuickButtons.RegisterDefaultButton(new QuickButton(
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
