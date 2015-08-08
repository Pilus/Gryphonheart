namespace CsLuaTest.Arrays
{
    using System;

    public class ArraysTests : BaseTest
    {
        public ArraysTests()
        {
            this.Name = "Arrays";
            this.Tests["ArrayInitializationAndAmbigurity"] = ArrayInitializationAndAmbigurity;
            this.Tests["ArraysAsMethodArgument"] = ArraysAsMethodArgument;
        }

        private static void ArrayInitializationAndAmbigurity()
        {
            var arrayClass = new ClassWithArrays();

            var a1 = new string[] {};
            Assert("string", arrayClass.TypeDependent(a1));
            Assert(0, a1.Length);

            var a2 = new[] { "abc", "def" };
            Assert("string", arrayClass.TypeDependent(a2));

            var a3 = new[] { 1, 3 };
            Assert("int", arrayClass.TypeDependent(a3));

            var a4 = new object[] { true, 1, "ok" };
            Assert("object", arrayClass.TypeDependent(a4));

            var a5 = new[] {new AClass<int>() {Value = 4}, new AClass<int>() { Value = 6 } };
            Assert("Aint", arrayClass.TypeDependent(a5));

            var a6 = new[] { new AClass<string>() };
            Assert("Astring", arrayClass.TypeDependent(a6));

            var a7 = new AClass<string>[] {};
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