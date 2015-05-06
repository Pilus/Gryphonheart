namespace GH
{
    using GH.Model;
    using Lua;

    internal class Program
    {
        private static void Main(string[] args)
        {
            var model = new ModelProvider();
            Core.print("Gryphonheart AddOns loaded.");
        }
    }
}