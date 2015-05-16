namespace GH.Presenter
{
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;

    public interface IClusterButtonAnimation
    {
        void AnimateButtons(IButton parent, CsLuaList<IButton> buttons, bool show);
    }
}