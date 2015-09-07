namespace GH.Menu.Objects.EditBox
{
    using BlizzardApi.WidgetInterfaces;

    public interface IEditBoxWithFilters : IEditBox
    {
        bool VariablesOnly { get; set; }

        bool NumbersOnly { get; set; }
    }
}