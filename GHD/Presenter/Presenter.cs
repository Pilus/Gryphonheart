
namespace GHD.Presenter
{
    using Document;

    using GH.CommonModules.QuickButtonCluster;
    using GH.Utils.AddOnIntegration;
    using GH.Menu;
    using Model;

    public class Presenter
    {
        private readonly IMenuHandler menuHandler;
        private readonly IModelProvider model;
        private DocumentMenu documentMenu;

        public Presenter(IModelProvider model, IMenuHandler menuHandler, QuickButtonModule quickButtonModule)
        {
            this.model = model;
            this.menuHandler = menuHandler;
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
                this.documentMenu = new DocumentMenu(menuHandler);
            }
            
            this.documentMenu.Test();
        }
    }
}
