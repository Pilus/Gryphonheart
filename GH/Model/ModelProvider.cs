namespace GH.Model
{
    using Misc;
    using Presenter;

    using GH.Model.Defaults;
    using BlizzardApi.EventEnums;
    using CsLuaFramework;
    using CsLuaFramework.Wrapping;
    using GH.Integration;
    using ObjectHandling.Storage;

    public class ModelProvider : IModelProvider
    {
        public AddOnIntegration Integration { get; set; }

        private Presenter presenter;

        private readonly IWrapper wrapper;

        public ModelProvider(AddOnIntegration integration, IWrapper wrapper)
        {
            this.Integration = integration;
            this.wrapper = wrapper;
            DefaultQuickButtons.RegisterDefaultButtons(this.Integration);

            var serializer = new Serializer();
            var buttonSavedDataHandler = new SavedDataHandler("GH_Buttons");
            var settingsSavedDataHandler = new SavedDataHandler("GH_Settings");

            this.ButtonStore = new ObjectStoreWithDefaults<IQuickButton, string>(serializer, buttonSavedDataHandler);
            this.Settings = new ObjectStoreWithDefaults<ISetting, SettingIds>(serializer, settingsSavedDataHandler);
            this.Integration.SetDefaults(this.Settings);

            Misc.RegisterEvent(SystemEvent.VARIABLES_LOADED, this.OnVariablesLoaded);
        }

        private void OnVariablesLoaded(SystemEvent eventName, object _)
        {
            this.Integration.RetrieveDefaultButtons().ForEach(this.ButtonStore.SetDefault);
            DefaultSettings.AddToModel(this.Settings);

            this.ButtonStore.LoadFromSaved();
            this.Settings.LoadFromSaved();
            this.Integration.LoadSettings();
            this.presenter = new Presenter(this, this.wrapper);
        }

        public bool IsAddOnLoaded(AddOnReference addonReference)
        {
            return this.Integration.IsAddOnLoaded(addonReference);
        }

        public IObjectStoreWithDefaults<IQuickButton, string> ButtonStore { 
            get; 
            private set; 
        }

        public IObjectStoreWithDefaults<ISetting, SettingIds> Settings
        {
            get;
            private set; 
        }
    }
}