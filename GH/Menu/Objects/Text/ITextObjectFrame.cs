namespace GH.Menu.Objects.Text
{
    using BlizzardApi.WidgetInterfaces;

    public interface ITextObjectFrame : IFrame
    {
        IFontString Label { get; }
    }
}