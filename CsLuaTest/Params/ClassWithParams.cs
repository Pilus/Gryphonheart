namespace CsLuaTest.Params
{
    using System;
    public class ClassWithParams
    {
        public int Method1(bool b, params object[] args)
        {
            return args.Length;
        }

        public int Method2(params object[] args)
        {
            return this.Method1(true, args);
        }

        public string Method3(params object[] args)
        {
            return "Method3_object" + args.Length;
        }

        public string Method3(params int[] args)
        {
            return "Method3_int" + args.Length;
        }

        public string Method3(params string[] args)
        {
            return "Method3_string" + args.Length;
        }

        public void MethodExpectingAction(Action<object[]> a)
        {
            a(new object[]{ true, "b", 3});
        }
    }
}