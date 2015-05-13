namespace CsLuaTest.Serialization
{
    using System;

    [Serializable]
    public class ClassWithSubObject
    {
        public string[] AnArray = new[] {"1", "2"};

        public ClassWithNativeObjects AClass = new ClassWithNativeObjects();
    }
}