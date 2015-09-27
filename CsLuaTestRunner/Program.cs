namespace CsLuaTestRunner
{
    using System;
    using CsLuaTest;

    /// <summary>
    /// Program for running the CsLua test in C# console.
    /// </summary>
    class Program
    {
        static void Main(string[] args)
        {
            new CsLuaTest().Execute();
            Console.ReadKey();
        }
    }
}
