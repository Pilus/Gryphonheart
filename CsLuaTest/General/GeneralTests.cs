namespace CsLuaTest.General
{
    public class GeneralTests : BaseTest
    {
        public GeneralTests()
        {
            this.Tests["TestStaticClassWithMethod"] = TestStaticClassWithMethod;
            this.Tests["TestStaticClassWithVariable"] = TestStaticClassWithVariable;
            this.Tests["TestStaticClassWithAutoProperty"] = TestStaticClassWithAutoProperty;
            this.Tests["TestStaticClassWithCustomProperty"] = TestStaticClassWithCustomProperty;
            this.Tests["NonStaticClassWithStaticMethod"] = NonStaticClassWithStaticMethod;
            this.Tests["TestVariableTypeVsVariableName"] = TestVariableTypeVsVariableName;
            this.Tests["GetConstValueFromBase"] = GetConstValueFromBase;
            this.Tests["ConstructorShouldUseArgumentsOverClassElements"] = ConstructorShouldUseArgumentsOverClassElements;
            this.Tests["MethodShouldUseArgumentsOverClassElements"] = MethodShouldUseArgumentsOverClassElements;
        }

        private static void TestStaticClassWithMethod()
        {
            StaticClass.Method(1);
            Assert("StaticMethodInt", Output);
        }

        private static void TestStaticClassWithVariable()
        {
            Assert(40, StaticClass.Variable);
            Assert(0, StaticClass.VariableWithDefault);
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

        private static void NonStaticClassWithStaticMethod()
        {
            NonStaticClass.StaticMethod(1);
            Assert("StaticMethodInt", Output);
        }

        private static void TestVariableTypeVsVariableName()
        {
            var theClass = new ClassWithTypeAndVariableNaming();
            theClass.Method(() => { });
            Assert("Action", Output);
        }

        private static void GetConstValueFromBase()
        {
            Assert(50, Inheriter.GetConstValue());
        }

        private static void ConstructorShouldUseArgumentsOverClassElements()
        {
            var classA = new ClassAmb("X");
            Assert("X", classA.GetAmbValue());
        }

        private static void MethodShouldUseArgumentsOverClassElements()
        {
            var classA = new ClassAmb("X");
            classA.SetAmbValue("Y");
            Assert("Y", classA.GetAmbValue());
        }

        
    }
}