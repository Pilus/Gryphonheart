namespace GH.Menu.Objects
{
    using BlizzardApi.WidgetInterfaces;

    public interface ITextLabelWithTooltip : IFrame
    {
        IFontString Label { get; }
        string Tooltip { get; set; }
    }
}