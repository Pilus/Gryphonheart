namespace CsLuaTest.Params
{
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
    }
}