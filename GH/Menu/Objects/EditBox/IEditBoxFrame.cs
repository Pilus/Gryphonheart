namespace GH.Menu.Objects.EditBox
{
    using BlizzardApi.WidgetInterfaces;

    public interface IEditBoxFrame : IFrame
    {
        ITextLabelWithTooltip Text { get; }
        IEditBoxWithFilters Box { get; }
    }
}