namespace CsLuaTestRunner
{
    using System;
    using CsLuaTest;

    class Program
    {
        static void Main(string[] args)
        {
            new CsLuaTest().Execute();
            Console.ReadKey();
        }
    }
}
