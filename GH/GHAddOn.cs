namespace GH
{
    using CsLuaAttributes;
    using Lua;
    using Model;

    [CsLuaAddOn("GH", "Gryphonheart AddOns", 60200, Author = "The Gryphonheart Team", Notes = "Core addon for the Gryphonheart AddOns suite.", Version = "3.0.1", SavedVariablesPerCharacter = new []{"GH_Settings", "GH_Buttons"})]
    public class GHAddOn : ICsLuaAddOn
    {
        public void Execute()
        {
            var model = new ModelProvider();
            Core.print("Gryphonheart AddOns loaded.");
        }
    }
}
