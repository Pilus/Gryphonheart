namespace CsLuaTest.TypeMethods
{
    public class Class1
    {
        public string Value;

        public override bool Equals(object obj)
        {
            if (obj is Class1)
            {
                var otherClass = ((Class1) obj);
                return otherClass.Value.Equals(this.Value);
            }
            return false;
        }

        public override string ToString()
        {
            return this.Value;
        }
    }
}