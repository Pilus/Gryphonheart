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
            var attribute = csLuaAddOnAtttribute.OfType<CsLuaAddOnAttribute>().First();
            
            this.Name = attribute.Name;
            this.SavedVariables = attribute.SavedVariables ?? new string[] { };
            this.SavedVariablesPerCharacter = attribute.SavedVariablesPerCharacter ?? new string[] { };
            
        }

        public void Execute()
        {
            this.csLuaAddOn.Execute();
        }

        public string Name { get; private set; }

        public string[] SavedVariables { get; private set; }

        public string[] SavedVariablesPerCharacter { get; private set; }
    }
}