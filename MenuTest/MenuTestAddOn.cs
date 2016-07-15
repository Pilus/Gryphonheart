namespace MenuTest
{
    using BlizzardApi.Global;
    using CsLuaAttributes;
    using GH.Integration;
    using GH.Menu;
    using GH.UIModules;
    using Lua;

    [CsLuaAddOn("MenuTest", "Menu test", 60200, Author = "The Gryphonheart Team", Notes = "Test addon for testing GH menu. Not intended for release.")]
    public class MenuTestAddOn : ICsLuaAddOn
    {
        public void Execute()
        {
            SlashCommand.Register("menu", SlashCmd);
        }

        private static void SlashCmd(string fullCmd, NativeLuaTable _)
        {
            var integration = (IAddOnIntegration)Global.Api.GetGlobal(AddOnIntegration.GlobalReference);
            var menuHandler = integration.GetModule<MenuHandler>();
            new MainTest(menuHandler);
        }
    }
}
