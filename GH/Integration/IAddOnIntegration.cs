using CsLua.Collection;
using GH.Model;

namespace GH.Integration
{
    using ObjectHandling.Storage;
    using UIModules;

    public interface IAddOnIntegration
    {
        void RegisterAddOn(AddOnReference addonName);
        bool IsAddOnLoaded(AddOnReference addOnName);
        void RegisterDefaultButton(IQuickButton button);
        CsLuaList<IQuickButton> RetrieveDefaultButtons();
        T GetModule<T>() where T : ISingletonModule, new();
    }
}
