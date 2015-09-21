
namespace GHG
{
    using CsLua.Collection;
    using Lua;
    using GHG.Model;

    class Program
    {
        static void Main(string[] args)
        {
            var formatter = new RecursiveTableFormatter<Group>();

            var group = new Group();
            group.AddRank("First rank");
            group.AddMember("02020202", "Member A");
            var t = formatter.Serialize(group);
        }
    }
}
