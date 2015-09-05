

namespace GH.Menu.Objects
{
    using BlizzardApi.WidgetInterfaces;
    using Theme;

    public interface IMenuContainer : IMenuObject, IThemedElement
    {
        void RemoveElement(string label);
    }
}
