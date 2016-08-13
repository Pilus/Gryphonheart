
namespace GH.Menu.Containers.Menus
{
    using GH.Menu.Containers.Page;

    public interface IMenu : IContainer<IPage>
    {
        void UpdatePosition();
        void AnimatedShow();
        void Show();
        void Hide();
    }
}
