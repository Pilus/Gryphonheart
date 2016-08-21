namespace GHF.Model
{
    using AdditionalFields;
    using BlizzardApi.EventEnums;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CsLuaFramework;
    using CsLuaFramework.Wrapping;

    using GH.CommonModules.QuickButtonCluster;
    using GH.Utils;
    using GH.Utils.AddOnIntegration;
    using GH.Utils.Entities.Storage;
    using GH.Utils.Entities.Subscriptions;
    using Lua;
    using MSP;
    using Presenter;

    public class ModelProvider : IModelProvider
    {
        public const string SavedAccountProfiles = "GHF_AccountProfiles";

        public MSPProxy Msp { get; private set; }

        public IEntityStore<Profile, string> AccountProfiles { get; private set; }

        public ModelProvider(ISerializer serializer, IWrapper wrapper, GameEventListener eventListener, IAddOnRegistry addOnRegistry, QuickButtonModule buttonModule)
        {
            var subscriptionCenter = new EntityUpdateSubscriptionCenter<Profile, string>();
            this.AccountProfiles = new EntityStore<Profile, string>(serializer, new SavedDataHandler(SavedAccountProfiles, Global.Api.GetRealmName()), subscriptionCenter);

            eventListener.RegisterEvent(SystemEvent.VARIABLES_LOADED, this.OnVariablesLoaded);
            addOnRegistry.RegisterAddOn(AddOnReference.GHF);

            var playerName = Global.Api.UnitName(UnitId.player);
            var version = Global.Api.GetAddOnMetadata(Strings.tostring(AddOnReference.GH), "Version");
            var supportedFields = new SupportedFields();
            this.Msp = new MSPProxy(new ProfileFormatter(), version, supportedFields, wrapper);

            subscriptionCenter.SubscribeForUpdates(this.Msp.Set, profile => profile.Id.Equals(playerName));

            var requestStrategy = new MspRequestStrategy();
            var activityScanner = new PlayerActivityScanner((name, activity) => { this.Msp.Request(name, requestStrategy.GetFieldsToRequest(activity)); }, eventListener);

            new Presenter(this, supportedFields, buttonModule);
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

            this.AccountProfiles.Set(profile);
        }

        private void OnVariablesLoaded(SystemEvent eventName, object _)
        {
            this.AccountProfiles.LoadFromSaved();
            this.SetPlayerProfileIfMissing();
        }

        public PublicProfile GetPublicProfile(string characterName)
        {
            return this.Msp.Get(characterName);
        }
    }
}