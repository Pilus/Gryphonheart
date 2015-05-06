
namespace GHF.External
{
    using Model;
    using Presenter;

    public static class FlagQuickButtonInterface
    {
        private static IModelProvider model;
        private static IPresenter presenter;

        public static void SetContext(IModelProvider modelProvider, IPresenter flagPresenter)
        {
            model = modelProvider;
            presenter = flagPresenter;
        }

        public static void DisplayProfileMenu()
        {
            
        }
    }
}
