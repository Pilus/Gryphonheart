namespace GH.Menu.Objects.EditBox
{
    using BlizzardApi.WidgetInterfaces;

    public interface IEditBoxFrame : IFrame
    {
        IEditBoxWithFilters Box { get; }
    }
}