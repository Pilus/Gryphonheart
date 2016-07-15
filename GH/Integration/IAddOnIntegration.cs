using GH.Model;

namespace GH.Integration
{
    using System.Collections.Generic;
    using UIModules;

    public interface IAddOnIntegration
    {
        void RegisterAddOn(AddOnReference addonName);
        bool IsAddOnLoaded(AddOnReference addOnName);
        void RegisterDefaultButton(IQuickButton button);
        List<IQuickButton> RetrieveDefaultButtons();
        T GetModule<T>() where T : ISingletonModule, new();
    }
}
