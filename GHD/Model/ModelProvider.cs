
namespace GHD.Model
{
    using GH.Integration;
    using Presenter;

    public class ModelProvider : IModelProvider
    {
        public ModelProvider()
        {
            new Presenter(this);
            AddOnRegister.RegisterAddOn(AddOnReference.GHD);    
        }
    }
}
