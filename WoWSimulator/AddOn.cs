namespace WoWSimulator
{
    using System.Linq;
    using CsLuaAttributes;

    public class AddOn
    {
        private readonly ICsLuaAddOn csLuaAddOn;
        public AddOn(ICsLuaAddOn csLuaAddOn)
        {
            this.csLuaAddOn = csLuaAddOn;

            var addonType = csLuaAddOn.GetType();
            var csLuaAddOnAtttribute = addonType.GetCustomAttributes(false);
            foreach (var attribute in csLuaAddOnAtttribute.OfType<CsLuaAddOnAttribute>())
            {
                this.Name = attribute.Name;
            }

        }

        public void Execute()
        {
            this.csLuaAddOn.Execute();
        }

        public string Name { get; private set; }
    }
}