
namespace CsLuaTest
{
    using Lua;
    public class IndentedLineWriter
    {
        public int indent;
        public string indentChar = "   ";

        public void WriteLine(string line)
        {
            Core.print(Strings.strrep(indentChar, indent) + line);
        }
    }
}
