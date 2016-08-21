
namespace GHX
{
    using GH.CommonModules;
    using GH.Utils.Modules;

    using Lua;

    class Program
    {
        static void Main(string[] args)
        {
            var SlashCommandModule = ModuleFactory.GetM<SlashCommand>();
            SlashCommandModule.Register("GHX", SlashCmd);
        }

        private static void SlashCmd(string fullCmd, NativeLuaTable _)
        {
            var t = Strings.strsplittotable(" ", fullCmd);
            var cmd = (string) Table.remove(t, 1);
            var remainingCmd = Strings.strjoinfromtable(" ", t);

            switch (cmd)
            {
                default:
                    Core.print("Unknown command:", cmd);
                    break;
            }
            
        }
    }
}
