
namespace GH.Menu.Menus
{
    using BlizzardApi.WidgetInterfaces;
    using Objects;

    public interface IMenu : IMenuContainer, IIndexer<object, object>
    {
        void AddElement(int pageIndex, int lineIndex, IObjectProfile profile);
        void UpdatePosition();

        void AnimatedShow();
        void Show();
    }
}
