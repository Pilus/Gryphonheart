namespace GHF.Model
{
    using System.Collections;
    using BlizzardApi.Events;
    using BlizzardApi.Global;
    using BlizzardApi.MiscEnums;
    using CsLua.Collection;
    using GH.Integration;
    using GH.Misc;
    using GH.ObjectHandling;
    using GHF.Presenter;
    using Lua;

    public class ModelProvider : IModelProvider
    {

        public ModelProvider()
        {
            var formatter = new TableFormatter();
            this.AccountProfiles = new IdObjectList<IProfile, string>(formatter, new SavedDataHandler("GHF_AccountProfiles", Global.GetRealmName()));

            Misc.RegisterEvent(SystemEvent.VARIABLES_LOADED, this.OnVariablesLoaded);

            new Presenter(this);
            AddOnRegister.RegisterAddOn(AddOnReference.GHF, "0.0.1");            
        }

        private void SetPlayerProfileIfMissing()
        {
            var playerName = Global.UnitName(UnitId.player);
            var ownProfile = this.AccountProfiles.Get(playerName);
            if (ownProfile != null)
            {
                return;
            }

            var profile = new Profile(playerName);

            this.AccountProfiles.Set(playerName, profile);

            
        }

        private void OnVariablesLoaded()
        {
            this.AccountProfiles.LoadFromSaved();
            this.SetPlayerProfileIfMissing();
        }

        public IIdObjectList<IProfile, string> AccountProfiles { get; private set; }
    }
}