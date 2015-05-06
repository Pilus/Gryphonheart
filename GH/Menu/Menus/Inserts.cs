
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
