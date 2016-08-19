
namespace GH.CommonModules
{
    using System;
    using BlizzardApi.Global;
    using GH.Utils.Modules;
    using Lua;

    public class SlashCommand : SingletonModule
    {
        public void Register(string cmd, Action<string, NativeLuaTable> func)
        {
            var slashCmdList = (NativeLuaTable) Global.Api.GetGlobal("SlashCmdList");

            // TODO: Throw if command is already registered.

            slashCmdList[cmd] = func;
            Global.Api.SetGlobal("SLASH_" + cmd + "1", "/" + cmd);
        }
    }
}
