
namespace GH.Menu
{
    using BlizzardApi.WidgetInterfaces;

    public interface IMenuRegion : IElement
    {
        void SetPosition(IFrame parent, double xOff, double yOff, double width, double height);

        double? GetPreferredWidth();
        double? GetPreferredHeight();
    }
}
