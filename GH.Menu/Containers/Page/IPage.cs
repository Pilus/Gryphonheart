
namespace GH.Menu.Containers.Page
{
    using GH.Menu.Containers.Line;

    public interface IPage : IMenuRegion, IContainer<ILine>
    {
        string Name { get; }

        void Show();

        void Hide();
    }
}
