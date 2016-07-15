
namespace GH.Presenter
{
    using CsLuaFramework.Wrapping;
    using GH.Model;
    using GH.Presenter.ClusterButtonAnimation;

    public class Presenter
    {
        private IModelProvider model;

        private ButtonCluster buttonCluster;
        private ButtonOptionsMenu buttonOptionsMenu;

        public Presenter(IModelProvider model, IWrapper wrapper)
        {
            this.model = model;

            this.buttonCluster = new ButtonCluster(model, new ClusterButtonAnimationFactory(), wrapper);
            this.buttonOptionsMenu = new ButtonOptionsMenu(model, wrapper);
        }
    }
}
