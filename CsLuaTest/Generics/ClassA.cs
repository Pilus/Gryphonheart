namespace CsLuaTest.Generics
{
    public class ClassA
    {
        private readonly string value;

        public ClassA(string value)
        {
            this.value = value;
        }

        public override string ToString()
        {
            return this.value;
        }
    }
}