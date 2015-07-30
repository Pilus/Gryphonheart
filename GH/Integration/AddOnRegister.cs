

namespace GH.Integration
{
    using CsLua;
    using CsLua.Collection;

    public static class AddOnRegister
    {
        private static CsLuaList<AddOnReference> addOns = new CsLuaList<AddOnReference>();

        public static void RegisterAddOn(AddOnReference addonName)
        {
            if (addOns.Contains(addonName))
            {
                throw new CsException("AddOn already registered");
            }
            addOns.Add(addonName);
        }

        public static bool AddOnLoaded(AddOnReference addOnName)
        {
            return addOnName.Equals(AddOnReference.None) || addOns.Contains(addOnName);
        }
    }
}
