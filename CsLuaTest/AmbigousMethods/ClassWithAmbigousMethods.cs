namespace CsLuaTest.AmbigousMethods
{
    public class ClassWithAmbigousMethods
    {
        public void OneArg(int x)
        {
            AmbigousMethodsTests.Output = "OneArg_Int";
        }

        public void OneArg(string x)
        {
            AmbigousMethodsTests.Output = "OneArg_String";
        }

        public void OneArgWithObj(int x)
        {
            AmbigousMethodsTests.Output = "OneArgWithObj_Int";
        }

        public void OneArgWithObj(object x)
        {
            AmbigousMethodsTests.Output = "OneArgWithObj_Object";
        }

        public void OneArgWithClass(int x)
        {
            AmbigousMethodsTests.Output = "OneArgWithClass_Int";
        }

        public void OneArgWithClass(ClassA x)
        {
            AmbigousMethodsTests.Output = "OneArgWithClass_ClassA";
        }

        public void OneArgWithClass(object x)
        {
            AmbigousMethodsTests.Output = "OneArgWithClass_Object";
        }

        public void OneArgWithInterface(InterfaceB x)
        {
            AmbigousMethodsTests.Output = "OneArgWithInterface_InterfaceB";
        }

        public void OneArgWithInterface(ClassB2 x)
        {
            AmbigousMethodsTests.Output = "OneArgWithInterface_ClassB2";
        }

        public void TwoArgsWithInterface(InterfaceB x, ClassB2 y)
        {
            AmbigousMethodsTests.Output = "OneArgWithInterface_InterfaceBClassB2";
        }

        public void TwoArgsWithInterface(InterfaceB x, InterfaceB y)
        {
            AmbigousMethodsTests.Output = "OneArgWithInterface_InterfaceBInterfaceB";
        }



        public void NullPicking1(InterfaceB x)
        {
            AmbigousMethodsTests.Output = "NullPicking1_InterfaceB";
        }

        public void NullPicking1(object x)
        {
            AmbigousMethodsTests.Output = "NullPicking1_object";
        }

        public void GenericPicking(ClassWithGenerics<int> x)
        {
            AmbigousMethodsTests.Output = "GenericPicking_int";
        }

        public void GenericPicking(ClassWithGenerics<bool> x)
        {
            AmbigousMethodsTests.Output = "GenericPicking_bool";
        }
    }
}