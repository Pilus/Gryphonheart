namespace GH.UIModules.EasyMenu
{
    using Lua;

    public interface IEasyDropDownMenuContent
    {
        NativeLuaTable GenerateMenuTable();
    }
}