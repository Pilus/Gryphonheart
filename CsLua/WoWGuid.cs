
namespace CsLua
{

    public struct WoWGuid
    {
        private string str;

        public static WoWGuid NewGuid()
        {
            return new WoWGuid(System.Guid.NewGuid().ToString());
        }

        public WoWGuid(string str)
        {
            this.str = str;
        }

        public override string ToString()
        {
            return this.str;
        }

        static public implicit operator WoWGuid(string value)
        {
            return new WoWGuid(value);
        }

        static public implicit operator string(WoWGuid value)
        {
            return value.str;
        }
    }
}
