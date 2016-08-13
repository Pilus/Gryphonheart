namespace GH.Menu.Objects.EditField
{
    using BlizzardApi.WidgetInterfaces;

    public interface IEditFieldFrame : IFrame
    {
        IEditBox Text { get; }
    }
}