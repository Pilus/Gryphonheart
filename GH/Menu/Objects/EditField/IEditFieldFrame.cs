namespace GH.Menu.Objects.EditField
{
    using BlizzardApi.WidgetInterfaces;
    using EditBox;

    public interface IEditFieldFrame : IFrame
    {
        IEditBox Text { get; }
    }
}