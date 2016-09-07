namespace GH.Menu.EasyMenu
{
    using Lua;

    public interface IEasyDropDownMenuContent
    {
        NativeLuaTable GenerateMenuTable();
    }
}