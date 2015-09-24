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
        public AddOnIntegration Integration { get; set; }

        private Presenter presenter;

        public ModelProvider(AddOnIntegration integration)
        {
            this.Integration = integration;
            DefaultQuickButtons.RegisterDefaultButtons(this.Integration);

            this.ButtonStore = new ObjectStoreWithDefaults<IQuickButton, string>("GH_Buttons");
            
            this.Settings = new ObjectStoreWithDefaults<ISetting, SettingIds>("GH_Settings");
            this.Integration.SetDefaults(this.Settings);

            Misc.RegisterEvent(SystemEvent.VARIABLES_LOADED, this.OnVariablesLoaded);
        }

        private void OnVariablesLoaded(SystemEvent eventName, object _)
        {
            this.Integration.RetrieveDefaultButtons().Foreach(this.ButtonStore.SetDefault);
            DefaultSettings.AddToModel(this.Settings);

            this.ButtonStore.LoadFromSaved();
            this.Settings.LoadFromSaved();
            this.Integration.LoadSettings();
            this.presenter = new Presenter(this);
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