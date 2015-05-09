

namespace GH.Menu.Objects
{
    using BlizzardApi.WidgetInterfaces;

    public interface IMenuContainer : IMenuObject
    {
        void RemoveElement(string label);
    }
}
