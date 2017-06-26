
namespace GHC
{
    using BlizzardApi.EventEnums;
    using BlizzardApi.Global;
    using CsLuaFramework;
    using CsLuaFramework.Attributes;
    using CsLuaFramework.Wrapping;

    using GH.CommonModules.QuickButtonCluster;
    using GH.Utils;
    using GH.Utils.AddOnIntegration;
    using GH.Utils.Modules;

    using Lua;
    using Modules.AbilityActionBar;

    [CsLuaAddOn("GHC", "Gryphonheart Crime", 70200, Author = "The Gryphonheart Team", Dependencies = new []{"GH"})]
    public class GHCAddOn : ICsLuaAddOn
    {
        private readonly IWrapper wrapper;

        public GHCAddOn(IWrapper wrapper)
        {
            this.wrapper = wrapper;
        }

        public GHCAddOn()
        {
            this.wrapper = new Wrapper();
        }

        public void Execute()
        {
            var eventListener = ModuleFactory.GetM<GameEventListener>();
            eventListener.RegisterEvent(SystemEvent.ADDON_LOADED, this.OnAddOnLoaded);

            var quickButtonCluster = ModuleFactory.GetM<QuickButtonModule>();
            quickButtonCluster.RegisterDefaultButton(new QuickButton(
                "ghcMain",
                6,
                true,
                "Gryphonheart Crime",
                "Interface/ICONS/Ability_Stealth",
                TempShowActionBar,
                AddOnReference.GHC));
        }

        private void OnAddOnLoaded(SystemEvent eventName, object addonName)
        {
            if (addonName.Equals("GHC"))
            {
                var addonRegistry = ModuleFactory.GetM<AddOnRegistry>();
                addonRegistry.RegisterAddOn(AddOnReference.GHC);
            }
        }

        private void TempShowActionBar()
        {
            var duration = 5;
            double? castTime = null;
            var bar = new ActionBar((frame) => new ActionButtonProxy(frame, this.wrapper));
            bar.AddButton("test", "Interface/ICONS/INV_Misc_Bag_11", s =>
            {
                castTime = Global.Api.GetTime();
                Core.print("test");
            }, 
            (s, tooltip) => { tooltip.AddLine("Test"); },
                (s) => new CooldownInfo()
                {
                    Active = castTime != null && Global.Api.GetTime() < castTime + duration,
                    Duration = duration,
                    StartTime = castTime
                });
            bar.Show();
        }
    }
}
