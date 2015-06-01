
namespace CsLua
{

    public struct CsLuaGuid
    {
        private string str;

        public static CsLuaGuid NewGuid()
        {
            return new CsLuaGuid(System.Guid.NewGuid().ToString());
        }

        public CsLuaGuid(string str)
        {
            this.str = str;
        }

        public override string ToString()
        {
            return this.str;
        }

        static public implicit operator CsLuaGuid(string value)
        {
            return new CsLuaGuid(value);
        }

        static public implicit operator string(CsLuaGuid value)
        {
            return value.str;
        }
    }
}
