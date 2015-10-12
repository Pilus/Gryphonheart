namespace CsLuaTest.Static
{
    public class StaticTests : BaseTest
    {
        public StaticTests()
        {
            Name = "Static";
            this.Tests["TestStaticClassWithMethod"] = TestStaticClassWithMethod;
            this.Tests["TestStaticClassWithVariable"] = TestStaticClassWithVariable;
            this.Tests["TestStaticClassWithAutoProperty"] = TestStaticClassWithAutoProperty;
            this.Tests["TestStaticClassWithCustomProperty"] = TestStaticClassWithCustomProperty;
            this.Tests["TestStaticInInheritance"] = TestStaticInInheritance;
            this.Tests["TestStaticInClassWithGeneric"] = TestStaticInClassWithGeneric;
        }

        private static void TestStaticClassWithMethod()
        {
            StaticClass.Method(1);
            Assert("StaticMethodInt", Output);
        }

        private static void TestStaticClassWithVariable()
        {
            Assert(40, StaticClass.Variable);
            StaticClass.Variable = 50;
            Assert(50, StaticClass.Variable);
            Assert(50, StaticClass.GetFromInternal_Variable());
            StaticClass.SetFromInternal_Variable(60);
            Assert(60, StaticClass.Variable);
            Assert(60, StaticClass.GetFromInternal_Variable());

            Assert(0, StaticClass.VariableWithDefault);
            Assert(0, StaticClass.GetFromInternal_VariableWithDefault());
        }

        private static void TestStaticClassWithAutoProperty()
        {
            Assert(0, StaticClass.AutoProperty);
            StaticClass.AutoProperty = 20;
            Assert(20, StaticClass.AutoProperty);
        }

        private static void TestStaticClassWithCustomProperty()
        {
            Assert(0, StaticClass.PropertyWithGetSet);
            StaticClass.PropertyWithGetSet = 25;
            Assert(50, StaticClass.PropertyWithGetSet);
        }

        private static void TestStaticInInheritance()
        {
            BaseClassWithStatic.Value = "A";
            Assert("A", InheritingClass.Value);
            InheritingClass.Value = "B";
            Assert("B", BaseClassWithStatic.Value);
        }

        private static void TestStaticInClassWithGeneric()
        {
            GenericClassWithStatic<int>.StringValue = "A";
            GenericClassWithStatic<int>.GenericValue = 1;

            GenericClassWithStatic<bool>.StringValue = "B";
            GenericClassWithStatic<bool>.GenericValue = true;

            Assert("A", GenericClassWithStatic<int>.StringValue);
            Assert(1, GenericClassWithStatic<int>.GenericValue);
            Assert("B", GenericClassWithStatic<bool>.StringValue);
            Assert(true, GenericClassWithStatic<bool>.GenericValue);
        }
    }
}