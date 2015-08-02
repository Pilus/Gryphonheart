namespace CsLuaTest.Arrays
{
    using System;

    public class ArraysTests : BaseTest
    {
        public ArraysTests()
        {
            this.Name = "Arrays";
            this.Tests["ArrayInitialization"] = ArrayInitializationAndAmbigurity;
            this.Tests["ArraysAsMethodArgument"] = ArraysAsMethodArgument;
        }

        private static void ArrayInitializationAndAmbigurity()
        {
            var arrayClass = new ClassWithArrays();

            var a1 = new string[] {};   
            var a2 = new[] { "abc", "def" };
            var a3 = new[] { 1, 3 };
            var a4 = new object[] { true, 1, "ok" };
            var a5 = new[] {new AClass<int>() {Value = 4}, new AClass<int>() { Value = 6 } };
            var a6 = new[] { new AClass<string>() };
            var a7 = new AClass<string>[] {};

            Assert(0, a1.Length);

            Assert("string", arrayClass.TypeDependent(a1));
            Assert("string", arrayClass.TypeDependent(a2));
            Assert("int", arrayClass.TypeDependent(a3));
            Assert("object", arrayClass.TypeDependent(a4));
            Assert("Aint", arrayClass.TypeDependent(a5));
            Assert("Astring", arrayClass.TypeDependent(a6));
            Assert("Astring", arrayClass.TypeDependent(a7));
        }

        private static void ArraysAsMethodArgument()
        {
            var arrayClass = new ClassWithArrays();
            var array = new [] { "abc", "def"};

            Assert(2, arrayClass.GetLengthOfStringArray(array));
        }
    }
}