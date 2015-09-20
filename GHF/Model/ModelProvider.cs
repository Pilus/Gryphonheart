namespace GHF.Model
{
    using AdditionalFields;
    using BlizzardApi.EventEnums;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CsLua.Collection;
    using GH.Integration;
    using GH.Misc;
    using GH.Model;
    using GH.ObjectHandling;
    using GH.ObjectHandling.Storage;
    using GH.ObjectHandling.Subscription;
    using Lua;
    using MSP;
    using Presenter;

    public class ModelProvider : IModelProvider
    {
        public const string SavedAccountProfiles = "GHF_AccountProfiles";

        public IAddOnIntegration Integration { get; private set; }
        
        public IObjectStore<Profile, string> AccountProfiles { get; private set; }

        public ModelProvider()
        {
            var formatter = new TableFormatter<Profile>();
            var subscriptionCenter = new SubscriptionCenter<Profile, string>();
            this.AccountProfiles = new ObjectStore<Profile, string>(formatter, new SavedDataHandler(SavedAccountProfiles, Global.Api.GetRealmName()), subscriptionCenter);

            Misc.RegisterEvent(SystemEvent.VARIABLES_LOADED, this.OnVariablesLoaded);
            this.Integration = (IAddOnIntegration)Global.Api.GetGlobal(AddOnIntegration.GlobalReference);
            this.Integration.RegisterAddOn(AddOnReference.GHF);

            var playerName = Global.Api.UnitName(UnitId.player);
            var version = Global.Api.GetAddOnMetadata(Strings.tostring(AddOnReference.GH), "Version");
            var supportedFields = new SupportedFields();
            var msp = new MSPProxy(new ProfileFormatter(), version, supportedFields);

            subscriptionCenter.SubscribeForUpdates(msp.Set, profile => profile.Id.Equals(playerName));

            new Presenter(this, supportedFields);
        }

        private void SetPlayerProfileIfMissing()
        {
            var playerName = Global.Api.UnitName(UnitId.player);
            var ownProfile = this.AccountProfiles.Get(playerName);

            if (ownProfile != null)
            {
                return;
            }

            var className = Global.Api.UnitClass(UnitId.player).Value2;
            var gameRace = Global.Api.UnitRace(UnitId.player).Value2;
            var sex = Strings.tostring(Global.Api.UnitSex(UnitId.player));
            var guid = Global.Api.UnitGUID(UnitId.player);

            var profile = new Profile(playerName, className, gameRace, sex, guid);

            this.AccountProfiles.Set(playerName, profile);
        }

        private void OnVariablesLoaded(SystemEvent eventName, object _)
        {
            this.AccountProfiles.LoadFromSaved();
            this.SetPlayerProfileIfMissing();
        }
    }
}