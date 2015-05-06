
namespace GH.Menu.Objects.Page
{
    using BlizzardApi.WidgetInterfaces;

    public interface IPage : IMenuRegion, IMenuContainer
    {
        void AddElement(int lineIndex, IObjectProfile profile);

        string Name { get; }

        void Show();

        void Hide();
    }
}
