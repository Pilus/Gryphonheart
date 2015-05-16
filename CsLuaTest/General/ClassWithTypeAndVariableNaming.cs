namespace CsLuaTest.General
{
    using System;

    public class ClassWithTypeAndVariableNaming
    {
        public Action Action;

        public void Method(Action action)
        {
            this.Action = action;
            GeneralTests.Output = "Action";
        }
    }
}