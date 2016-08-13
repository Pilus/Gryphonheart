namespace GH.Menu.Objects.Button
{
    using BlizzardApi.WidgetInterfaces;

    public interface IButtonTemplate : IButton
    {
         IFontString Text { get; }
    }
}