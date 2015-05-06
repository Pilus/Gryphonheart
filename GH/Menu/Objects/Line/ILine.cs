

namespace GH.Menu.Objects.Line
{
    using BlizzardApi.WidgetInterfaces;

    public interface ILine : IMenuContainer, IMenuRegion
    {
        void AddElement(IObjectProfile profile);
    }
}
