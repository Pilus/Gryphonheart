
namespace GHC
{
    using BlizzardApi.EventEnums;
    using CsLuaAttributes;
    using GH.Integration;
    using GH.Misc;
    using GH.Model;
    using GH.Model.Defaults;

    [CsLuaAddOn("GHC", "Gryphonheart Crime", 60200, Author = "The Gryphonheart Team", Dependencies = new []{"GH"})]
    public class GHCAddOn : ICsLuaAddOn
    {
        public void Execute()
        {
            Misc.RegisterEvent(SystemEvent.ADDON_LOADED, this.OnAddOnLoaded);
        }

        private void OnAddOnLoaded(SystemEvent eventName, object addonName)
        {
            if (addonName.Equals("GHC"))
            {
                DefaultQuickButtons.RegisterDefaultButton(new QuickButton(
                "ghcMain",
                6,
                true,
                "Gryphonheart Crime",
                "Interface/ICONS/Ability_Stealth",
                TempShowActionBar,
                AddOnReference.GHC));
            }
        }

        private void TempShowActionBar()
        {

        }
    }
}
