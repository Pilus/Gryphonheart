namespace GHF.Model
{
    using BlizzardApi.EventEnums;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CsLua.Collection;
    using GH.Integration;
    using GH.Misc;
    using GH.Model;
    using GH.ObjectHandling;
    using Presenter;

    public class ModelProvider : IModelProvider
    {
        public const string SavedAccountProfiles = "GHF_AccountProfiles";

        public IAddOnIntegration Integration { get; private set; }

        public ModelProvider()
        {
            var formatter = new TableFormatter<Profile>();
            this.AccountProfiles = new IdObjectList<Profile, string>(formatter, new SavedDataHandler(SavedAccountProfiles, Global.Api.GetRealmName()));

            Misc.RegisterEvent(SystemEvent.VARIABLES_LOADED, this.OnVariablesLoaded);
            this.Integration = (IAddOnIntegration)Global.Api.GetGlobal(AddOnIntegration.GlobalReference);

            this.Integration.RegisterAddOn(AddOnReference.GHF);

            new Presenter(this);
        }

        private void SetPlayerProfileIfMissing()
        {
            var playerName = Global.Api.UnitName(UnitId.player);
            var className = Global.Api.UnitClass(UnitId.player).Value2;
            var ownProfile = this.AccountProfiles.Get(playerName);
            if (ownProfile != null)
            {
                return;
            }

            var profile = new Profile(playerName, className);

            this.AccountProfiles.Set(playerName, profile);
        }

        private void OnVariablesLoaded(SystemEvent eventName, object _)
        {
            this.AccountProfiles.LoadFromSaved();
            this.SetPlayerProfileIfMissing();
        }

        public IIdObjectList<Profile, string> AccountProfiles { get; private set; }
    }
}