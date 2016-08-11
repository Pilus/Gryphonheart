
namespace GHD.Model
{
    using BlizzardApi.Global;
    using GH.Integration;
    using GH.Utils.AddOnIntegration;
    using Presenter;

    public class ModelProvider : IModelProvider
    {
        public ModelProvider()
        {
            var integration = (IAddOnIntegration)Global.Api.GetGlobal(AddOnIntegration.GlobalReference);
            new Presenter(this, integration);
            integration.RegisterAddOn(AddOnReference.GHD);
        }
    }
}
