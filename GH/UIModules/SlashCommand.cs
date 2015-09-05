
namespace GH.UIModules
{
    using System;
    using BlizzardApi.Global;
    using Lua;

    public static class SlashCommand
    {
        public static void Register(string cmd, Action<string, NativeLuaTable> func)
        {
            var slashCmdList = (NativeLuaTable) Global.Api.GetGlobal("SlashCmdList");
            slashCmdList[cmd] = func;
            Global.Api.SetGlobal("SLASH_" + cmd + "1", "/" + cmd);
        }
    }
}
