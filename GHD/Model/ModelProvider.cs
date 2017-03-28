
namespace GHD.Model
{
    using GH.CommonModules.QuickButtonCluster;
    using GH.Utils.AddOnIntegration;
    using GH.Utils.Modules;
    using GH.Menu;

    using Presenter;

    public class ModelProvider : IModelProvider
    {
        public ModelProvider()
        {
            var addonRegistry = ModuleFactory.GetM<AddOnRegistry>();
            var quickButtonModule = ModuleFactory.GetM<QuickButtonModule>();
            var menuHandler = ModuleFactory.GetM<MenuHandler>();

            new Presenter(this, menuHandler, quickButtonModule);
            addonRegistry.RegisterAddOn(AddOnReference.GHD);
        }
    }
}
