namespace GH.Model
{
    using ObjectHandling;
    using Misc;
    using Presenter;

    using GH.Model.Defaults;
    using BlizzardApi.EventEnums;
    using GH.Integration;

    public class ModelProvider : IModelProvider
    {
        private IAddOnIntegration integration;
        private Presenter presenter;

        public ModelProvider(IAddOnIntegration integration)
        {
            this.integration = integration;
            DefaultQuickButtons.RegisterDefaultButtons(this.integration);

            this.ButtonList = new IdObjectListWithDefaults<IQuickButton, string>("GH_Buttons");
            
            this.Settings = new IdObjectListWithDefaults<ISetting, SettingIds>("GH_Settings");

            Misc.RegisterEvent(SystemEvent.VARIABLES_LOADED, this.OnVariablesLoaded);
        }

        private void OnVariablesLoaded(SystemEvent eventName, object _)
        {
            this.integration.RetrieveDefaultButtons().Foreach(this.ButtonList.SetDefault);
            DefaultSettings.AddToModel(this.Settings);

            this.ButtonList.LoadFromSaved();
            this.Settings.LoadFromSaved();
            this.presenter = new Presenter(this);
        }

        public bool IsAddOnLoaded(AddOnReference addonReference)
        {
            return this.integration.IsAddOnLoaded(addonReference);
        }

        public IIdObjectListWithDefaults<IQuickButton, string> ButtonList { 
            get; 
            private set; 
        }

        public IIdObjectListWithDefaults<ISetting, SettingIds> Settings
        {
            get;
            private set; 
        }
    }
}