

namespace GH.Integration
{
    using System.Collections.Generic;
    using CsLua;
    using CsLua.Collection;

    public static class AddOnRegister
    {
        private static IDictionary<AddOnReference, string> addOns = new CsLuaDictionary<AddOnReference, string>();

        public static void RegisterAddOn(AddOnReference addonName, string version)
        {
            if (addOns.ContainsKey(addonName))
            {
                throw new CsException("AddOn already registered");
            }
            addOns[addonName] = version;
        }

        public static bool AddOnLoaded(AddOnReference addOnName)
        {
            return addOnName.Equals(AddOnReference.None) || addOns.ContainsKey(addOnName);
        }
    }
}
