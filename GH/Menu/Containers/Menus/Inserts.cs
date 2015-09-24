
namespace GH.Menu.Menus
{
    using CsLua.Collection;
    using Lua;

    public class Inserts
    {
        public double Top = 0;
        public double Bottom = 0;
        public double Left = 0;
        public double Right = 0;

        public Inserts()
        {
            
        }

        public Inserts(double top, double buttom, double left, double right)
        {
            this.Top = top;
            this.Bottom = buttom;
            this.Left = left;
            this.Right = right;
        }

        public NativeLuaTable ToNativeLuaTable()
        {
            return new CsLuaDictionary<string,double>()
            {
                { "Top", this.Top },
                { "Bottom", this.Bottom },
                { "Left", this.Left },
                { "Right", this.Right },
            }.ToNativeLuaTable();
        }
    }
}
