
namespace GHD.Model
{
    using GH.CommonModules.QuickButtonCluster;
    using GH.Utils.AddOnIntegration;
    using GH.Utils.Modules;

    using Presenter;

    public class ModelProvider : IModelProvider
    {
        public ModelProvider()
        {
            var addonRegistry = ModuleFactory.GetM<AddOnRegistry>();
            var quickButtonModule = ModuleFactory.GetM<QuickButtonModule>();
            new Presenter(this, quickButtonModule);
            addonRegistry.RegisterAddOn(AddOnReference.GHD);
        }
    }
}
