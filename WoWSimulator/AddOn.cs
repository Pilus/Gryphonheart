namespace WoWSimulator
{
    using CsLuaAttributes;

    public class AddOn
    {
        private readonly ICsLuaAddOn csLuaAddOn;
        public AddOn(ICsLuaAddOn csLuaAddOn)
        {
            this.csLuaAddOn = csLuaAddOn;

            var addonType = csLuaAddOn.GetType();
            var csLuaAddOnAtttribute = addonType.GetCustomAttributes(typeof (CsLuaAddOnAttribute), false);

        }

        public void Execute()
        {
            this.csLuaAddOn.Execute();
        }

        public string Name { get; private set; }
    }
}