

namespace GH.Integration
{
    using System;
    using CsLua;
    using CsLua.Collection;
    using GH.Model;
    using ObjectHandling.Storage;
    using UIModules;

    public class AddOnIntegration : IAddOnIntegration
    {
        public static string GlobalReference = "GH_AddOnIntegration";

        private readonly CsLuaList<AddOnReference> addOns = new CsLuaList<AddOnReference>();

        private readonly CsLuaList<IQuickButton> quickButtons = new CsLuaList<IQuickButton>();

        private bool quickButtonsRetrieved;

        private readonly CsLuaList<ISingletonModule> singletonModules = new CsLuaList<ISingletonModule>();

        private IObjectStoreWithDefaults<ISetting, SettingIds> settings;

        private bool settingsLoaded;

        public void LoadSettings()
        {
            this.settingsLoaded = true;
            this.singletonModules.Foreach(module => module.LoadSettings(this.settings));
        }

        public void SetDefaults(IObjectStoreWithDefaults<ISetting, SettingIds> settings)
        {
            this.settings = settings;
            this.singletonModules.Foreach(module => module.SetDefaults(this.settings));
        }

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

        public T GetModule<T>() where T : ISingletonModule, new()
        {
            var module = this.singletonModules.FirstOrDefault(m => m is T);
            if (module != null)
            {
                return (T)module;
            }

            var newModule = new T();
            this.singletonModules.Add(newModule);

            if (this.settings != null)
            {
                newModule.SetDefaults(this.settings);
            }
            if (this.settingsLoaded)
            {
                newModule.LoadSettings(this.settings);
            }

            return newModule;
        }
    }
}
