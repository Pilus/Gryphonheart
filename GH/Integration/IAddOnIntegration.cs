using CsLua.Collection;
using GH.Model;

namespace GH.Integration
{
    public interface IAddOnIntegration
    {
        void RegisterAddOn(AddOnReference addonName);
        bool IsAddOnLoaded(AddOnReference addOnName);
        void RegisterDefaultButton(IQuickButton button);
        CsLuaList<IQuickButton> RetrieveDefaultButtons();
    }
}
