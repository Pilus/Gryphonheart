
namespace GH.Presenter
{
    using GH.Model;
    using GH.Presenter.ClusterButtonAnimation;

    public class Presenter
    {
        private IModelProvider model;

        private ButtonCluster buttonCluster;
        private ButtonOptionsMenu buttonOptionsMenu;

        public Presenter(IModelProvider model)
        {
            this.model = model;

            this.buttonCluster = new ButtonCluster(model, new ClusterButtonAnimationFactory());
            this.buttonOptionsMenu = new ButtonOptionsMenu(model);
        }
    }
}
