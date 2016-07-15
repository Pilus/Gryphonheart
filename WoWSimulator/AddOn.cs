namespace WoWSimulator
{
    using System.Collections.Generic;
    using System.Linq;
    using CsLuaFramework;
    using CsLuaFramework.Attributes;

    public class AddOn
    {
        private readonly ICsLuaAddOn csLuaAddOn;
        public readonly Dictionary<string, string> TocValues = new Dictionary<string, string>();
        public AddOn(ICsLuaAddOn csLuaAddOn)
        {
            this.csLuaAddOn = csLuaAddOn;

            var addonType = csLuaAddOn.GetType();
            var csLuaAddOnAtttribute = addonType.GetCustomAttributes(false);
            var attribute = csLuaAddOnAtttribute.OfType<CsLuaAddOnAttribute>().First();
            
            this.Name = attribute.Name;
            this.SavedVariables = attribute.SavedVariables ?? new string[] { };
            this.SavedVariablesPerCharacter = attribute.SavedVariablesPerCharacter ?? new string[] { };

            this.InsertTocValue("Name", this.Name);
            this.InsertTocValue("Title", attribute.Title);
            this.InsertTocValue("Author", attribute.Author);
            this.InsertTocValue("LoadOnDemand", attribute.LoadOnDemand);
            this.InsertTocValue("Notes", attribute.Notes);
            this.InsertTocValue("Version", attribute.Version);
        }

        private void InsertTocValue(string key, object value)
        {
            this.InsertTocValue(key, value.ToString());
        }

        private void InsertTocValue(string key, string value)
        {
            if (!string.IsNullOrEmpty(value))
            {
                this.TocValues[key] = value;
            }
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