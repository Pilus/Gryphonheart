namespace MenuTest
{
    using BlizzardApi.Global;
    using CsLuaAttributes;

    using GH.CommonModules;
    using GH.Menu;
    using GH.Utils.Modules;

    using Lua;

    [CsLuaAddOn("MenuTest", "Menu test", 70000, Author = "The Gryphonheart Team", Notes = "Test addon for testing GH menu. Not intended for release.")]
    public class MenuTestAddOn : ICsLuaAddOn
    {
        public void Execute()
        {
            var slashCommandHandler = ModuleFactory.GetM<SlashCommand>();
            slashCommandHandler.Register("menu", SlashCmd);
        }

        private static void SlashCmd(string fullCmd, NativeLuaTable _)
        {
            var menuHandler = ModuleFactory.GetM<MenuHandler>();
            new MainTest(menuHandler);
        }
    }
}
