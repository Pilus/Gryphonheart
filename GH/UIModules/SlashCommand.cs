
namespace GH.UIModules
{
    using System;
    using BlizzardApi.Global;
    using Lua;

    public static class SlashCommand
    {
        public static void Register(string cmd, Action<string> func)
        {
            var slashCmdList = (NativeLuaTable) Global.GetGlobal("SlashCmdList");
            slashCmdList[cmd] = func;
            Global.SetGlobal("SLASH_" + cmd + "1", "/" + cmd);
        }
    }
}
