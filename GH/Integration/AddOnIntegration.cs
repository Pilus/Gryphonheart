

namespace GH.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using GH.Model;
    using GH.Utils.AddOnIntegration;
    using GH.Utils.Entities.Storage;

    using UIModules;

    public class AddOnIntegration : IAddOnIntegration
    {
        public static string GlobalReference = "GH_AddOnIntegration";

        private readonly List<AddOnReference> addOns = new List<AddOnReference>();

        private readonly List<IQuickButton> quickButtons = new List<IQuickButton>();

        private bool quickButtonsRetrieved;

        private readonly List<ISingletonModule> singletonModules = new List<ISingletonModule>();

        private IObjectStoreWithDefaults<ISetting, SettingIds> settings;

        private bool settingsLoaded;

        public void LoadSettings()
        {
            this.settingsLoaded = true;
            this.singletonModules.ForEach(module => module.LoadSettings(this.settings));
        }

        public void SetDefaults(IObjectStoreWithDefaults<ISetting, SettingIds> settings)
        {
            // TODO: Remove and change this for two reasons: The singleton modules are loaded on demand, so they are not available when doing set defaults. Also the integration should not have a dependency on IObjectStoreWithDefaults.
            this.settings = settings;
            this.singletonModules.ForEach(module => module.SetDefaults(this.settings));
        }

        public void RegisterAddOn(AddOnReference addonName)
        {
            if (addOns.Contains(addonName))
            {
                throw new Exception("AddOn already registered");
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

        public List<IQuickButton> RetrieveDefaultButtons()
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
