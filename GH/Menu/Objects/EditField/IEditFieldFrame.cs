namespace GH.Menu.Objects.EditField
{
    using BlizzardApi.WidgetInterfaces;

    public interface IEditFieldFrame : IFrame
    {
        ITextLabelWithTooltip Text { get; }
        //IEditBoxWithFilters Box { get; }
    }
}