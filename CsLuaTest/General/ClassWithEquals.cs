
namespace CsLuaTest.General
{
    class ClassWithEquals
    {
        public int Value;

        public override bool Equals(object obj)
        {
            if (obj is ClassWithEquals)
            {
                return (obj as ClassWithEquals).Value == this.Value;
            }
            return base.Equals(obj);
        }
    }
}
