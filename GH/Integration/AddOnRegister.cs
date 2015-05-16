

namespace GH.Integration
{
    using CsLua;
    using CsLua.Collection;

    public static class AddOnRegister
    {
        private static CsLuaDictionary<AddOnReference, string> addOns = new CsLuaDictionary<AddOnReference, string>();

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
