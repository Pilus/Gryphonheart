
namespace GH.Menu.Containers.Menus
{
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
            var t = new NativeLuaTable();
            t["Top"] = this.Top;
            t["Bottom"] = this.Bottom;
            t["Left"] = this.Left;
            t["Right"] = this.Right;

            return t;
        }
    }
}
