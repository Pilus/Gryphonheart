namespace GH.Model
{
    using ObjectHandling;
    using Misc;
    using Presenter;

    using GH.Model.Defaults;
    using BlizzardApi.EventEnums;

    public class ModelProvider : IModelProvider
    {
        private Presenter presenter;

        public ModelProvider()
        {
            this.ButtonList = new IdObjectListWithDefaults<IQuickButton, string>("GH_Buttons");
            
            this.Settings = new IdObjectListWithDefaults<ISetting, SettingIds>("GH_Settings");

            Misc.RegisterEvent(SystemEvent.VARIABLES_LOADED, this.OnVariablesLoaded);
        }

        private void OnVariablesLoaded(SystemEvent eventName, object _)
        {
            DefaultQuickButtons.AddToModel(this.ButtonList);
            DefaultSettings.AddToModel(this.Settings);

            this.ButtonList.LoadFromSaved();
            this.Settings.LoadFromSaved();
            this.presenter = new Presenter(this);
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