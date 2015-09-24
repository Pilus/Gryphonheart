
namespace GH.Menu.Objects.Page
{
    using BlizzardApi.WidgetInterfaces;
    using GH.Menu.Containers.Line;
    using GH.Menu.Objects.Line;

    public interface IPage : IMenuRegion, IContainer<ILine>
    {
        string Name { get; }

        void Show();

        void Hide();
    }
}
