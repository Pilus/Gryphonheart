namespace MenuTest
{
    using Lua;
    using CsLuaAttributes;
    using GH.UIModules;

    [CsLuaAddOn("MenuTest", "Menu test", 60200, Author = "The Gryphonheart Team", Notes = "Test addon for testing GH menu. Not intended for release.")]
    public class MenuTestAddOn : ICsLuaAddOn
    {
        public void Execute()
        {
            SlashCommand.Register("menu", SlashCmd);
        }

        private static void SlashCmd(string fullCmd, NativeLuaTable _)
        {
            new MainTest();
        }
    }
}
