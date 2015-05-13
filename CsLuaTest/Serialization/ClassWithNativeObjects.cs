namespace CsLuaTest.Serialization
{
    using System;

    [Serializable]
    public class ClassWithNativeObjects
    {
        public string AString;
        public int ANumber;


        public ClassWithNativeObjects()
        {
            this.AString = "TheString";
            this.ANumber = 10;
        }
    }
}