namespace GH
{
    using BlizzardApi.Global;
    using CsLuaFramework;
    using CsLuaFramework.Attributes;
    using CsLuaFramework.Wrapping;
    using GH.Integration;
    using Lua;
    using Model;

    [CsLuaAddOn("GH", "Gryphonheart AddOns", 60200, Author = "The Gryphonheart Team", Notes = "Core addon for the Gryphonheart AddOns suite.", Version = "3.0.1", SavedVariablesPerCharacter = new []{"GH_Settings", "GH_Buttons"})]
    public class GHAddOn : ICsLuaAddOn
    {
        public void Execute()
        {
            var integration = new AddOnIntegration();
            integration.RegisterAddOn(AddOnReference.GH);
            Global.Api.SetGlobal(AddOnIntegration.GlobalReference, integration);

            var wrapper = new Wrapper();

            var model = new ModelProvider(integration, wrapper);
            Core.print("Gryphonheart AddOns loaded.");
        }
    }
}
