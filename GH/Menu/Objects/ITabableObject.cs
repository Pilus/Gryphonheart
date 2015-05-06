namespace GH.Menu.Objects
{
    using BlizzardApi.WidgetInterfaces;

    public interface ITabableObject : IEditBox
    {
        ITabableObject Previous { get; set; }
        ITabableObject Next { get; set; }
    }
}