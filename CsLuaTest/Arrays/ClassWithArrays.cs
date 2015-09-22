namespace CsLuaTest.Arrays
{
    using System;

    public class ClassWithArrays
    {
        public int GetLengthOfStringArray(string[] args)
        {
            return args.Length;
        }

        public string TypeDependent(object[] args)
        {
            return "object";
        }

        public string TypeDependent(string[] args)
        {
            return "string";
        }

        public string TypeDependent(int[] args)
        {
            return "int";
        }

        public string TypeDependent(long[] args)
        {
            return "long";
        }

        public string TypeDependent(double[] args)
        {
            return "double";
        }

        public string TypeDependent(AClass<int>[] args)
        {
            return "Aint";
        }

        public string TypeDependent(AClass<string>[] args)
        {
            return "Astring";
        }
    }
}