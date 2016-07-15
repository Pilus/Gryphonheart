
namespace GH.Menu.Menus
{
    using GH.Menu.Objects.Page;
    using Objects;

    public interface IMenu : IContainer<IPage>
    {
        void UpdatePosition();
        void AnimatedShow();
        void Show();
        void Hide();
    }
}
