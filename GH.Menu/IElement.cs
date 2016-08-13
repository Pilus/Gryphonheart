namespace GH.Menu
{
    using BlizzardApi.WidgetInterfaces;
    using GH.Menu.Theme;

    public interface IElement
    {
        IFrame Frame { get; }
        void ApplyTheme(IMenuTheme theme);
        void Prepare(IElementProfile profile, IMenuHandler handler);
        void Recycle();
        void Clear();
    }
}
