namespace GH
{
    using CsLuaFramework;
    using CsLuaFramework.Attributes;

    using GH.CommonModules.QuickButtonCluster;
    using GH.Utils.AddOnIntegration;
    using GH.Utils.Modules;
    using Lua;

    [CsLuaAddOn("GH", "Gryphonheart AddOns", 70000, Author = "The Gryphonheart Team", Notes = "Core addon for the Gryphonheart AddOns suite.", Version = "3.0.1", SavedVariablesPerCharacter = new []{"GH_Settings", "GH_Buttons"})]
    public class GHAddOn : ICsLuaAddOn
    {
        public void Execute()
        {
            var settings = ModuleFactory.GetM<Settings.Settings>();

            var registry = ModuleFactory.ModuleFactorySingleton.GetModule<AddOnRegistry>();
            registry.RegisterAddOn(AddOnReference.GH);

            var quickButtonModule = ModuleFactory.ModuleFactorySingleton.GetModule<QuickButtonModule>();
            quickButtonModule.RegisterDefaultButton(new QuickButton(
                "news", 10, true, "AddOn Features and News", "Interface\\Icons\\INV_Misc_Horn_04",
                () =>
                {

                },
                AddOnReference.GH
            ));

            quickButtonModule.RegisterDefaultButton(new QuickButton(
                "options", 20, true, "Options", "Interface\\Icons\\INV_MISC_QUESTIONMARK",
                () =>
                {

                },
                AddOnReference.GH
                ));

            Core.print("Gryphonheart AddOns loaded.");
        }
    }
}
