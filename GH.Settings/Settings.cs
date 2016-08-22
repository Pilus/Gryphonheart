namespace GH.Settings
{
    using BlizzardApi.EventEnums;
    using CsLuaFramework;
    using GH.Utils;
    using GH.Utils.Entities.Storage;
    using GH.Utils.Modules;

    public class Settings : SingletonModule
    {
        private const string SavedDataKey = "GH_Settings";

        private readonly IEntityStoreWithDefaults<ISetting, SettingIds> settingsStore;

        /// <summary>
        /// Initializes a new instance of the <see cref="Settings"/> class.
        /// </summary>
        public Settings()
        {
            // TODO: Find a good way to provide the components initialized below.
            var serializer = new Serializer();
            var settingsSavedDataHandler = new SavedDataHandler(SavedDataKey);
            this.settingsStore = new EntityStoreWithDefaults<ISetting, SettingIds>(serializer, settingsSavedDataHandler);
            var gameEventListener = ModuleFactory.ModuleFactorySingleton.GetModule<GameEventListener>();
            gameEventListener.RegisterEvent(SystemEvent.VARIABLES_LOADED, (eventName, o) => this.LoadSettings());
        }

        private void LoadSettings()
        {
            var loadedModules = ModuleFactory.ModuleFactorySingleton.GetAllLoadedModules();
            foreach (var loadedModule in loadedModules)
            {
                this.SetDefaultSettingsFromModule(loadedModule);
            }

            this.settingsStore.LoadFromSaved();

            foreach (var loadedModule in loadedModules)
            {
                this.LoadSettingsForModule(loadedModule);
            }

            ModuleFactory.ModuleFactorySingleton.RegisterForModuleLoadEvents(
                (module) =>
                {
                    this.SetDefaultSettingsFromModule(module); // TODO: It might give issues that this is called after load event.
                    this.LoadSettingsForModule(module);
                });
        }

        private void SetDefaultSettingsFromModule(IModule module)
        {
            var moduleWithSettings = module as IModuleWithSettings;
            if (moduleWithSettings == null)
            {
                return;
            }

            this.settingsStore.SetDefault(moduleWithSettings.GetDefaultSetting());
        }

        private void LoadSettingsForModule(IModule module)
        {
            var moduleWithSettings = module as IModuleWithSettings;
            if (moduleWithSettings == null)
            {
                return;
            }

            var settings = this.settingsStore.Get(moduleWithSettings.SettingId);
            moduleWithSettings.ApplySetting(settings, this.settingsStore.Set);
        }
    }
}