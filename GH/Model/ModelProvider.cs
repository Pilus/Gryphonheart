namespace GH.Model
{
    using ObjectHandling;
    using Misc;
    using Presenter;

    using GH.Model.Defaults;
    using BlizzardApi.EventEnums;
    using GH.Integration;
    using ObjectHandling.Storage;

    public class ModelProvider : IModelProvider
    {
        private readonly AddOnIntegration integration;
        private Presenter presenter;

        public ModelProvider(AddOnIntegration integration)
        {
            this.integration = integration;
            DefaultQuickButtons.RegisterDefaultButtons(this.integration);

            this.ButtonStore = new ObjectStoreWithDefaults<IQuickButton, string>("GH_Buttons");
            
            this.Settings = new ObjectStoreWithDefaults<ISetting, SettingIds>("GH_Settings");
            this.integration.SetDefaults(this.Settings);

            Misc.RegisterEvent(SystemEvent.VARIABLES_LOADED, this.OnVariablesLoaded);
        }

        private void OnVariablesLoaded(SystemEvent eventName, object _)
        {
            this.integration.RetrieveDefaultButtons().Foreach(this.ButtonStore.SetDefault);
            DefaultSettings.AddToModel(this.Settings);

            this.ButtonStore.LoadFromSaved();
            this.Settings.LoadFromSaved();
            this.integration.LoadSettings();
            this.presenter = new Presenter(this);
        }

        public bool IsAddOnLoaded(AddOnReference addonReference)
        {
            return this.integration.IsAddOnLoaded(addonReference);
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