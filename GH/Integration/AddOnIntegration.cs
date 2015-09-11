

namespace GH.Integration
{
    using System;
    using CsLua;
    using CsLua.Collection;
    using GH.Model;

    public class AddOnIntegration : IAddOnIntegration
    {
        public static string GlobalReference = "GH_AddOnIntegration";

        private CsLuaList<AddOnReference> addOns = new CsLuaList<AddOnReference>();

        private CsLuaList<IQuickButton> quickButtons = new CsLuaList<IQuickButton>();

        private bool quickButtonsRetrieved;

        public void RegisterAddOn(AddOnReference addonName)
        {
            if (addOns.Contains(addonName))
            {
                throw new CsException("AddOn already registered");
            }
            addOns.Add(addonName);
        }

        public bool IsAddOnLoaded(AddOnReference addOnName)
        {
            return addOnName.Equals(AddOnReference.None) || addOns.Contains(addOnName);
        }

        public void RegisterDefaultButton(IQuickButton button)
        {
            if (this.quickButtonsRetrieved)
            {
                throw new IntegrationException("Default quick buttons have already been retrieved and are thus considered read only.");
            }
            this.quickButtons.Add(button);
        }

        public CsLuaList<IQuickButton> RetrieveDefaultButtons()
        {
            this.quickButtonsRetrieved = true;
            return this.quickButtons;
        }
    }
}
