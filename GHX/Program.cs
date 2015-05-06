
namespace GHX
{
    using GH.UIModules;
    using Lua;

    class Program
    {
        static void Main(string[] args)
        {
            SlashCommand.Register("GHX", SlashCmd);
        }

        private static void SlashCmd(string fullCmd)
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
