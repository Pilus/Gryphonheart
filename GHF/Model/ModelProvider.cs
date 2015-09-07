namespace GHF.Model
{
    using BlizzardApi.EventEnums;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CsLua.Collection;
    using GH.Integration;
    using GH.Misc;
    using GH.ObjectHandling;
    using Presenter;

    public class ModelProvider : IModelProvider
    {

        public ModelProvider()
        {
            var formatter = new TableFormatter<Profile>();
            this.AccountProfiles = new IdObjectList<Profile, string>(formatter, new SavedDataHandler("GHF_AccountProfiles", Global.Api.GetRealmName()));

            Misc.RegisterEvent(SystemEvent.VARIABLES_LOADED, this.OnVariablesLoaded);

            new Presenter(this);
            AddOnRegister.RegisterAddOn(AddOnReference.GHF);
        }

        private void SetPlayerProfileIfMissing()
        {
            var playerName = Global.Api.UnitName(UnitId.player);
            var ownProfile = this.AccountProfiles.Get(playerName);
            if (ownProfile != null)
            {
                return;
            }

            var profile = new Profile(playerName);

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